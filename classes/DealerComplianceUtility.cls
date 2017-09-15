/**
 * @name DealerComplianceUtility 
 * @description Utitlity Class for Dealer Compliance activities
 * @author Michelle Magsarili
 * @company: Cloud Sherpas
 * @date 07.FEB.2014
 *
 * HISTORY
 * - 07.FEB.2014    Michelle Magsarili      Created.
 * - 11.FEB.2014    Michelle Magsarili      Refactor Trigger code to check for the validations on a trigger level.
 */
public class DealerComplianceUtility{

    //isValidForDealerCompliance Method that returns TRUE if Opportunity is North America AND Residential
    public static boolean isValidForDealerCompliance(Opportunity Opp, Id accountRtId, Id oppRtId){
        return (opp.RecordTypeId == oppRtId && ( String.ValueOf(opp.Theater__c).equals('North America')  || String.ValueOf(opp.Theater__c).equals('Australia')) && opp.Account.RecordTypeId == accountRtId);
    }
    
    //isOppAssignedToNewDealer that returns TRUE if oldOpp.Owner != newOpp.Owner && newOpp.Owner.isPartnerUser
    public static boolean isOppAssignedToNewDealer(Opportunity oldOpp, Opportunity newOpp){
        //Owner.isPartnerUser = IsPortalEnabled in the code
        if(oldOpp != null)
            return  oldOpp.OwnerId != newOpp.OwnerId && newOpp.Owner.IsPortalEnabled;
        else
            return  newOpp.Owner.IsPortalEnabled;
    }
    
    //createDealerComplianceRecords - code to create Compliance Requirements Records
    public static void createDealerComplianceRecords(Opportunity Opp){
        //Dealer Compliance Requirement records to Insert
        List<Dealer_Compliance_Requirement__c> dealerComplianceToInsert = new List<Dealer_Compliance_Requirement__c>(); 
        
        //Get Description Values from Custom Setting
        String dCompDescriptionIdVerificationVal = '';
        String dCompDescriptionRightToCancelVal = '';
        
        if(DealerComplianceRequirement__c.getValues('ID Verification') != null && Opp.Theater__c != 'Australia'){
            DealerComplianceRequirement__c dCompDescriptionIdVerification = DealerComplianceRequirement__c.getValues('ID Verification');
            dCompDescriptionIdVerificationVal = dCompDescriptionIdVerification.Description__c;
        }
        
        if(DealerComplianceRequirement__c.getValues('ID Verification Australia') != null && Opp.Theater__c == 'Australia'){
            DealerComplianceRequirement__c dCompDescriptionIdVerification = DealerComplianceRequirement__c.getValues('ID Verification Australia');
            dCompDescriptionIdVerificationVal = dCompDescriptionIdVerification.Description__c;
        }
        
        
        
        if(DealerComplianceRequirement__c.getValues('Right to Cancel') != null){
            DealerComplianceRequirement__c dCompDescriptionRightToCancel = DealerComplianceRequirement__c.getValues('Right to Cancel');
            dCompDescriptionRightToCancelVal = dCompDescriptionRightToCancel.Description__c;
        }
        
        //Insert Dealer_Compliance_Requirement__c record with record Name 'Verified Customer’s ID'
        Dealer_Compliance_Requirement__c dealerComplianceVerifiedCustId = new Dealer_Compliance_Requirement__c();
        dealerComplianceVerifiedCustId.Name = 'Verified Customer’s ID';
        dealerComplianceVerifiedCustId.Opportunity__c = opp.Id;
        dealerComplianceVerifiedCustId.Account__c = opp.AccountId;  //R.A. 26.SEPT.2014 - Added AccountId on DealerCompliance "Verified Customer’s ID" record creation - Case  00353484
        dealerComplianceVerifiedCustId.Compliance_Description__c = dCompDescriptionIdVerificationVal;
        dealerComplianceToInsert.add(dealerComplianceVerifiedCustId);
        
        if(Opp.Theater__c != 'Australia'){
            //Insert Dealer_Compliance_Requirement__c record with record Name 'Verbally Notified Customer of Right to Cancel'
            Dealer_Compliance_Requirement__c dealerComplianceVerballyNotifiedCust = new Dealer_Compliance_Requirement__c();
            dealerComplianceVerballyNotifiedCust.Name = 'Verbally Notified Customer of Right to Cancel';
            dealerComplianceVerballyNotifiedCust.Opportunity__c = opp.Id;
            dealerComplianceVerballyNotifiedCust.Account__c = opp.AccountId;    //R.A. 26.SEPT.2014 - Added AccountId on DealerCompliance "Verbally Notified Customer of Right to Cancel" record creation - Case  00353484
            dealerComplianceVerballyNotifiedCust.Compliance_Description__c = dCompDescriptionRightToCancelVal;
            dealerComplianceToInsert.add(dealerComplianceVerballyNotifiedCust);
        }
        if(dealerComplianceToInsert.size() > 0)
            insert dealerComplianceToInsert;
    }    
}