/* **************************************************************************************
* Class Name     : PrepPOLineItems 
* Version        : 1.0 
* Created Date   : 13 Aug 2015
* Function       : Class to prep PO Line Items based on Financial Offering

* Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Chaitanya Devarapalli       13 Aug 2015          Original Version
*************************************************************************************/
public class PrepPOLineItems{
    public static Integer runningPOLNumber;
    
	//Prepare PO Line Items
	public static List<Purchase_Order_Line__c> preparePOLines(Map<Id, Quote> mapQot, Purchase_Order__c po, Integer runningPOLNum) {
		List<Purchase_Order_Line__c> polList = new List<Purchase_Order_Line__c>();
		try {
			List<POLineFeeSetup__c> polFSList = new List<POLineFeeSetup__c>();
			Map<String, Id> rolePartnerIdMap = new Map<String, Id>();
			Map<String, Decimal> partnerRoleFeeMap = new Map<String, Decimal>();
			Map<String,Id> temprolePartnerIdMap = Dealerfee_cal_Utility_ModelBased.mPartnerRoleWithAccId;
			boolean bMaxFit = false;
			Boolean isTPSCashOrder = false;

			// TPS Cash order check
			if(po.Sales_Type__c == 'Cash' && String.isNotBlank(po.Dealer_Account__r.NH_SSE_Type__c) && po.Dealer_Account__r.NH_SSE_Type__c.contains('TPS')) {
				isTPSCashOrder = true;
			}

			for(String pRole : temprolePartnerIdMap.keySet()){
				if(pRole == 'Opportunity Owner'){
					rolePartnerIdMap.put('TPS', temprolePartnerIdMap.get(pRole));
					partnerRoleFeeMap.put('TPS', (Decimal)mapQot.get(po.Quote__c).get(Quote_Fees_Fields_API__c.getInstance(pRole).Field_API_Name__c));
				}
				else{
					rolePartnerIdMap.put(pRole, temprolePartnerIdMap.get(pRole));
					partnerRoleFeeMap.put(pRole, (Decimal)mapQot.get(po.Quote__c).get(Quote_Fees_Fields_API__c.getInstance(pRole).Field_API_Name__c));
				}
			}

			runningPOLNumber = runningPOLNum;
			Fee_Distribution__c tpsFD = new Fee_Distribution__c();
			Quote q = mapQot.get(po.Quote__c);

			if(q != null && q.Installation_Model__c != null) {
				polFSList = [SELECT Financial_Offering__c, MileStone__c, Partner_Role__c, Percentage__c, Item__c, Item__r.Name, Item__r.Item_ID__c, Item__r.Description__c, Value_From__c, MaxFit__c FROM POLineFeeSetup__c WHERE Model__c = :q.Installation_Model__c AND Item__c != null AND (MileStone__c != 'ORIGINATION' OR (MileStone__c='ORIGINATION' AND MaxFit__c = :bMaxFit))];

				// list for Alliance Partners on Residential Project
				List<Alliance_Partner__c> alliancePartners;
				if(isTPSCashOrder) {
					// get Alliance Partners
					for(Residential_Project__c rp : [SELECT Id FROM Residential_Project__c WHERE Quote__c IN :mapQot.keySet() ORDER BY CreatedDate DESC LIMIT 1]) {
						alliancePartners = [SELECT Partner_Account__c, Role__c FROM Alliance_Partner__c WHERE Residential_Project__c = :rp.Id AND Role__c != null];
					}
				}

				for(POLineFeeSetup__c polfs : polFSList){
					Double unitPrice;
					Integer quantity;
					Id vendorName;

					if(q.Installation_Model__r.Type__c == 'Auto'){
						if(q.Installation_Model__r.Partner__c == 'New Homes'){
							unitPrice = 0.00;
							quantity = 1;
						} else {
							if(q.get(polfs.Value_From__c) != null && polfs.Percentage__c != null) {
								unitPrice = Double.valueOf((Decimal)q.get(polfs.Value_From__c)) * polfs.Percentage__c / 100;
							} else unitPrice = 0;

							quantity = Integer.valueOf(unitPrice) != 0 ? Integer.valueOf(unitPrice) : 1;
							vendorName = q.Opportunity.Account.Partner_Account__c;
						}
					} else if(q.Installation_Model__r.Type__c == 'Manual'){
						tpsFD = Dealerfee_cal_Utility_ModelBased.fdTPS;

						if(tpsFD.MaxFit_Reduction__c > 0.00){
							bMaxFit = true;
						}

						if(polfs.Partner_Role__c == 'TPS'){
							Double tpsFee = PartnerRoleFeeMap.get(polfs.Partner_Role__c) + tpsFD.MaxFit_Reduction__c;

							if(polfs.MaxFit__c) {
								unitPrice = (tpsFee * polfs.Percentage__c / 100) - tpsFD.MaxFit_Reduction__c;
								quantity = Integer.valueOf((tpsFee * polfs.Percentage__c / 100) - tpsFD.MaxFit_Reduction__c) != 0 ? Integer.valueOf((tpsFee * polfs.Percentage__c / 100) - tpsFD.MaxFit_Reduction__c) : 1;
							} else {
								unitPrice = tpsFee * polfs.Percentage__c / 100;
								quantity = Integer.valueOf(tpsFee*polfs.Percentage__c / 100) != 0 ? Integer.valueOf(tpsFee*polfs.Percentage__c / 100) :1;
							}
						} else if(polfs.Partner_Role__c != null) {
							if(PartnerRoleFeeMap.get(polfs.Partner_Role__c) != null && polfs.Percentage__c != null) {
								unitPrice = PartnerRoleFeeMap.get(polfs.Partner_Role__c) * polfs.Percentage__c / 100;
							} else unitPrice = 0;

							quantity = Integer.valueOf(PartnerRoleFeeMap.get(polfs.Partner_Role__c) * polfs.Percentage__c / 100) != 0 ? Integer.valueOf(PartnerRoleFeeMap.get(polfs.Partner_Role__c) * polfs.Percentage__c / 100) : 1;

							vendorName = rolePartnerIdMap.get(polfs.Partner_Role__c);
						} else {
							if(q.get(polfs.Value_From__c) != null && polfs.Percentage__c != null) {
								unitPrice = Double.valueOf((Decimal)q.get(polfs.Value_From__c)) * polfs.Percentage__c / 100;
							} else unitPrice = 0;

							quantity = Integer.valueOf(unitPrice) != 0 ? Integer.valueOf(unitPrice) : 1;
							vendorName = q.Opportunity.Account.Partner_Account__c;
						}
					}
					if(isTPSCashOrder) {
						for(Alliance_Partner__c ap : alliancePartners) {
							if(ap.Role__c == polfs.Partner_Role__c) {
								vendorName = ap.Partner_Account__c;
							}
						}
					}

					polList.add(new Purchase_Order_Line__c(Order_Line_Number__c = String.valueOf(runningPOLNum ++),
														   Unit_Price__c = unitPrice,
														   Quantity__c = quantity,
														   Purchase_Order__c = po.Id,
														   Price__c = 100,
														   currencyisocode = po.currencyisocode,
														   Item_Number__c = polfs.Item__r.Name,
														   Item_ID__c = polfs.Item__r.Item_ID__c,
														   Item_Description__c = polfs.Item__r.Description__c,
														   Oracle_Item_ID__c = polfs.Item__c,
														   Oracle_Warehouse__c = q.QuoteType__c == 'Lease' ? q.Opportunity.Account.Oracle_Warehouse_Derived__c : '',
														   Vendor_Name__c = vendorName,
														   Partner_Role__c = polfs.Partner_Role__c
														  ));
					runningPOLNumber++;
				}
			}
		} catch(Exception e) {
			Exlog.Log(e);
		}
		return polList;
	}
    
    //Method to find missing roles in Opportunity Team based on the Installation Model selected
    public static String findMissingRoles(List<OpportunityTeamMember> otmList,Installation_Model__c iModel){
        String nP=null;
        Set<String> teamMemRoleSet = new Set<String>();
        for(OpportunityTeamMember otm:otmList){
            teamMemRoleSet.add(otm.TeamMemberRole);
        }
        if(iModel.Type__c=='Manual'){
            List<String> imList = iModel.Roles__c.split(';');
            if(!teamMemRoleSet.isEmpty()){
                for(String im:imList){
                    if(!teamMemRoleSet.contains(im)){
                        if(nP!=null)
                            nP = nP+','+im;
                        else
                            nP = im;
                    }
                }
            }
            return nP;
        }
        else
            return nP;
    }
    
}