@isTest
public class TestFactory_Ordering {

	//---------------------------- Purchase Order ------------------------------

	public static Purchase_Order__c createPurchaseOrder() {
		return (Purchase_Order__c)SmartFactory.createSObject('Purchase_Order__c');
	}

	public static Purchase_Order_Line__c createPurchaseOrderLine() {
		return (Purchase_Order_Line__c)SmartFactory.createSObject('Purchase_Order_Line__c');
	}

	//---------------------------- Bill To Site --------------------------------

	public static Bill_To_Site__c createBillToSite(Id installerId){
		if(installerId == NULL) installerId = TestFactory_StandardObjects.getPartnerAccount().Id;

		Bill_To_Site__c bts = (Bill_To_Site__c)SmartFactory.createSObject('Bill_To_Site__c',false);
		bts.Dealer_Account__c = installerId;
		return bts;
	}

	//---------------------------- Ship To Site --------------------------------

	public static Ship_To_Site__c createDealerWarehouseShipToSite(Id installerId){
		if(installerId == NULL) installerId = TestFactory_StandardObjects.getPartnerAccount().Id;

		String recTypeId = Schema.SObjectType.Ship_To_Site__c.getRecordTypeInfosByName().get('Dealer Warehouse').getRecordTypeId();

		Ship_To_Site__c sts = (Ship_To_Site__c)SmartFactory.createSObject('Ship_To_Site__c',false);
		sts.RecordTypeId = recTypeId;
		sts.Dealer_Account__c = installerId;
		sts.Status__c = 'Active';
		sts.State__c = 'CA';
		return sts;
	}

	//---------------------------- Agreement --------------------------------
    
	public static echosign_dev1__SIGN_Agreement__c createAgreement(Quote q) {
        echosign_dev1__SIGN_Agreement__c agreement = (echosign_dev1__SIGN_Agreement__c)SmartFactory.createSObject('echosign_dev1__SIGN_Agreement__c', false);
        agreement.Quote__c = q.Id;
        return agreement;
    }

	public static echosign_dev1__SIGN_Agreement__c createAgreement(Quote q, Id recordTypeId) {
		echosign_dev1__SIGN_Agreement__c agreement = (echosign_dev1__SIGN_Agreement__c)SmartFactory.createSObject('echosign_dev1__SIGN_Agreement__c', false);
		agreement.Quote__c = q.Id;
		agreement.RecordTypeId = recordTypeId;
		return agreement;
	}	
}