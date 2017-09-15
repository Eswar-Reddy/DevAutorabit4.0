@isTest
public class AlaCarteController_Test {
    
    
	public static TestMethod void testAlaCarteController() {
        
        Account testPartner = TestClassFactory.CreateDealer('dealerName', 'North America');

        Contact partnerContact = TestClassFactory.testContact('lastName', 'testcontactpartner@noemail.com', TestClassFactory.retrieveRecordTypeID('Contact', 'Partner'));
        partnerContact.AccountId = testPartner.Id;
        partnerContact.Authorized_To_Order__c = TRUE;
        insert partnerContact;

        UserRole role = [SELECT Id FROM UserRole WHERE Name LIKE '%Partner Executive' LIMIT 1];

        Id execProfileId = SFDCSpecialUtilities.getProfileIdByName('Partner Executive');

        User currentUser = new User(alias = 'cashman1', email = partnerContact.Email, 
                          emailencodingkey='UTF-8', lastname='Testing', 
                          languagelocalekey='en_US', localesidkey='en_US', 
                          profileid = execProfileId,  country='United States', 
                          communityNickName = 'cashman1', timezonesidkey='America/Los_Angeles', 
                          username=string.valueOf(math.random())+'u1@testorg.com',
                          contactId=partnerContact.Id, UserRole = role);
        Price_List__c priceList = TestClassFactory.createPriceList();
        
        Price_List_Item__c pli = new Price_List_Item__c();
        pli.Type_1__c = 'Ala Carte';
        pli.Category__c = 'Monitoring';
        pli.Item_ID__c = [SELECT Id FROM Item__c WHERE Line_Type__c = 'Ala Carte' LIMIT 1].Id;
        pli.Price_List__c = priceList.Id;
        pli.Effective_Start_Date__c = Date.today() - 1;
        pli.Effective_End_Date__c = Date.today().addDays(30);
        insert pli; 
        
        Order_Discount__c o = new Order_Discount__c();
        o.Minimum_Quantity__c = 4;
        o.Maximum_Quantity__c = 100;
        o.Oracle_Item_ID__c = [SELECT Item_ID__c FROM Price_List_Item__c LIMIT 1].Item_ID__c;
        o.Effective_Date__c = Date.today() - 1;
        o.Discontinue_Date__c = Date.today().addDays(30);
        o.Bundle_Quantity__c = 4;
        o.Theatre__c = 'North America';
        o.Country__c = 'United States';
        insert o;
        
        System.runAs(currentUser)  {

            Test.startTest();
            PageReference pageRef = Page.OrderAlaCarteConfiguration;
            Test.setCurrentPage(pageRef);
            
            AlaCarteController controller = new AlaCarteController();

			controller.updateProductLineItemList();            
            
            controller.hdnDelProdLineId = pli.id;
            controller.singleAddedprodId = pli.id;
            controller.addItemToList();
            controller.addItemToList();
            
            controller.changedQty = '4';
            controller.updateQuantity();
            
            controller.changedQty = '8';
            controller.updateQuantity();
            
            controller.setJSON();
            
            controller.delItemFromList();
            
            controller.getQunatityMessage();
            
            string testString = controller.selProductItemsJSON;
            
            Boolean b = controller.hasNext;
            b = controller.hasPrevious;
            integer i = controller.pageNumber;
            controller.first();
            controller.last();
            controller.previous();
            controller.next();
            controller.cancel();
            controller.selectedCategoryKey = null;
            controller.moveAccordingToFilter();
            controller.selectedCategoryKey = 'Module';
            controller.moveAccordingToFilter();
            controller.prodDescFilter = 'RESI';
            controller.moveAccordingToFilter();
            
            //checkChangedQuantity(AlaCarteController.PriceItemWrapper wrapper, String newVal)
            AlaCarteController.PriceItemWrapper w = new AlaCarteController.PriceItemWrapper();
            w.Id = pli.Id;
            w.oracleItemIDRef = pli.Item_ID__c;
            w.Qty = '1';
            Boolean try1 = controller.checkChangedQuantity(w,'2');
            Boolean try2 = controller.checkChangedQuantity(w,'4');
            controller.showQuantityMessage = true;
            controller.getQunatityMessage();
            controller.getCategoryKeys();
            //controller.initilizeSetCon();
            controller.addItemToList();
            
            controller.first();
            controller.next();
            controller.last();
            controller.previous();
            controller.cancel();
            
            Test.stopTest();
        }
    }
}