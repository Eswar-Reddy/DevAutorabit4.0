@isTest
public class TestCHomeController {

	public static void Test_HeadlineData(){
        RecordType recType = Database.query('select id from RecordType where name = \'Multi Line\' AND SobjectType = \'APPR_PUB__Headline__c\'');
   
        APPR_PUB__Headline__c h1 = new APPR_PUB__Headline__c(Name='Headline1');
           	h1.APPR_PUB__Active__c = TRUE;
            h1.Display_Name__c = 'display name 1';
        	h1.Section__c = 'Banner';
            h1.APPR_PUB__Long_Description__c = 'Long_Description 11';
            h1.APPR_PUB__Sort_Order__c = 0;
            h1.RecordTypeId = recType.id;
            insert h1;   	
        h1 = new APPR_PUB__Headline__c(Name='Headline1');
           	h1.APPR_PUB__Active__c = TRUE;
            h1.Display_Name__c = 'display name 1';
        	h1.APPR_PUB__Long_Description__c = 'Long_Description 11';
            h1.APPR_PUB__Sort_Order__c = 1;
            h1.RecordTypeId = recType.id;
            insert h1;
        	h1 = new APPR_PUB__Headline__c(Name='Headline2', APPR_PUB__Tab__c='CHome' );
           	h1.APPR_PUB__Active__c = TRUE;
            h1.Display_Name__c = 'display name 1';
            h1.APPR_PUB__Long_Description__c = 'Long_Description 11';
            h1.APPR_PUB__Sort_Order__c = 2;
            h1.RecordTypeId = recType.id;
            insert h1;
        	h1 = new APPR_PUB__Headline__c(Name='Headline2', APPR_PUB__Tab__c='CHome' );
           	h1.APPR_PUB__Active__c = TRUE;
            h1.Display_Name__c = 'display name 1';
            h1.APPR_PUB__Long_Description__c = 'Long_Description 11';
            h1.APPR_PUB__Sort_Order__c = 3;
            h1.RecordTypeId = recType.id;
            insert h1;
        	h1 = new APPR_PUB__Headline__c(Name='Headline2', APPR_PUB__Tab__c='CHome' );
           	h1.APPR_PUB__Active__c = TRUE;
            h1.Display_Name__c = 'display name 1';
            h1.APPR_PUB__Long_Description__c = 'Long_Description 11';
            h1.APPR_PUB__Sort_Order__c = 3;
            h1.RecordTypeId = recType.id;
            insert h1;
        	h1 = new APPR_PUB__Headline__c(Name='Headline2', APPR_PUB__Tab__c='CHome' );
           	h1.APPR_PUB__Active__c = TRUE;
            h1.Display_Name__c = 'display name 1';
            h1.APPR_PUB__Long_Description__c = 'Long_Description 11';
            h1.APPR_PUB__Sort_Order__c = 4;
            h1.RecordTypeId = recType.id;
            insert h1;
    }
    public static testMethod void testMyController() {
        RecordType recType = Database.query('select id from RecordType where name = \'Multi Line\' AND SobjectType = \'APPR_PUB__Headline__c\'');
   			APPR_PUB__Headline_Link__c hl1;
           	APPR_PUB__Headline__c h1 = new APPR_PUB__Headline__c(Name='Headline1');
           	h1.APPR_PUB__Active__c = TRUE;
            h1.Display_Name__c = 'display name 1';
        	h1.Section__c = 'Banner';
            h1.APPR_PUB__Long_Description__c = 'Long_Description 11';
            h1.APPR_PUB__Sort_Order__c = 1;
            h1.RecordTypeId = recType.id;
            insert h1;
        	h1 = new APPR_PUB__Headline__c(Name='Headline2', APPR_PUB__Tab__c='CHome' );
           	h1.APPR_PUB__Active__c = TRUE;
            h1.Display_Name__c = 'display name 1';
            h1.APPR_PUB__Long_Description__c = 'Long_Description 11';
            h1.APPR_PUB__Sort_Order__c = 2;
            h1.RecordTypeId = recType.id;
            insert h1;
        	h1 = new APPR_PUB__Headline__c(Name='Headline2', APPR_PUB__Tab__c='CHome' );
           	h1.APPR_PUB__Active__c = TRUE;
            h1.Display_Name__c = 'display name 1';
            h1.APPR_PUB__Long_Description__c = 'Long_Description 11';
            h1.APPR_PUB__Sort_Order__c = 3;
            h1.RecordTypeId = recType.id;
            insert h1;
        	h1 = new APPR_PUB__Headline__c(Name='Headline2', APPR_PUB__Tab__c='CHome' );
           	h1.APPR_PUB__Active__c = TRUE;
            h1.Display_Name__c = 'display name 1';
            h1.APPR_PUB__Long_Description__c = 'Long_Description 11';
            h1.APPR_PUB__Sort_Order__c = 3;
            h1.RecordTypeId = recType.id;
            insert h1;
        	h1 = new APPR_PUB__Headline__c(Name='Headline2', APPR_PUB__Tab__c='CHome' );
           	h1.APPR_PUB__Active__c = TRUE;
            h1.Display_Name__c = 'display name 1';
            h1.APPR_PUB__Long_Description__c = 'Long_Description 11';
            h1.APPR_PUB__Sort_Order__c = 4;
            h1.RecordTypeId = recType.id;
            insert h1;
        h1 = new APPR_PUB__Headline__c(Name='Headline2', APPR_PUB__Tab__c='CHome',APPR_PUB__Active__c = TRUE, Display_Name__c = 'display name 1',APPR_PUB__Long_Description__c = 'Long_Description 11');
        h1.APPR_PUB__Sort_Order__c = 6;
        h1.RecordTypeId = recType.id;
        insert h1;
        h1 = new APPR_PUB__Headline__c(Name='Headline2', APPR_PUB__Tab__c='CHome',APPR_PUB__Active__c = TRUE, Display_Name__c = 'display name 1',APPR_PUB__Long_Description__c = 'Long_Description 11');
        h1.APPR_PUB__Sort_Order__c = 7;
        h1.RecordTypeId = recType.id;
        insert h1;
        h1 = new APPR_PUB__Headline__c(Name='Headline2', APPR_PUB__Tab__c='CHome',APPR_PUB__Active__c = TRUE, Display_Name__c = 'display name 1',APPR_PUB__Long_Description__c = 'Long_Description 11');
        h1.APPR_PUB__Sort_Order__c = 8;
        h1.RecordTypeId = recType.id;
        insert h1;
        h1 = new APPR_PUB__Headline__c(Name='Headline2', APPR_PUB__Tab__c='CHome',APPR_PUB__Active__c = TRUE, Display_Name__c = 'display name 1',APPR_PUB__Long_Description__c = 'Long_Description 11');
        h1.APPR_PUB__Sort_Order__c = 9;
        h1.RecordTypeId = recType.id;
        insert h1;
        h1 = new APPR_PUB__Headline__c(Name='Headline2', APPR_PUB__Tab__c='CHome',APPR_PUB__Active__c = TRUE, Display_Name__c = 'display name 1',APPR_PUB__Long_Description__c = 'Long_Description 11');
        h1.APPR_PUB__Sort_Order__c = 10;
        h1.RecordTypeId = recType.id;
        insert h1;
        h1 = new APPR_PUB__Headline__c(Name='Headline2', APPR_PUB__Tab__c='CHome',APPR_PUB__Active__c = TRUE, Display_Name__c = 'display name 1',APPR_PUB__Long_Description__c = 'Long_Description 11');
        h1.APPR_PUB__Sort_Order__c = 11;
        h1.RecordTypeId = recType.id;
        insert h1;
        h1 = new APPR_PUB__Headline__c(Name='Headline2', APPR_PUB__Tab__c='CHome',APPR_PUB__Active__c = TRUE, Display_Name__c = 'display name 1',APPR_PUB__Long_Description__c = 'Long_Description 11');
        h1.APPR_PUB__Sort_Order__c = 12;
        h1.RecordTypeId = recType.id;
        insert h1;
        h1 = new APPR_PUB__Headline__c(Name='Headline2', APPR_PUB__Tab__c='CHome',APPR_PUB__Active__c = TRUE, Display_Name__c = 'display name 1',APPR_PUB__Long_Description__c = 'Long_Description 11');
        h1.APPR_PUB__Sort_Order__c = 13;
        h1.RecordTypeId = recType.id;
        insert h1;
        h1 = new APPR_PUB__Headline__c(Name='Headline2', APPR_PUB__Tab__c='CHome',APPR_PUB__Active__c = TRUE, Display_Name__c = 'display name 1',APPR_PUB__Long_Description__c = 'Long_Description 11');
        h1.APPR_PUB__Sort_Order__c = 14;
        h1.RecordTypeId = recType.id;
        insert h1;
        
        //sorting order 5
        h1 = new APPR_PUB__Headline__c(Name='Headline2', APPR_PUB__Tab__c='CHome' );
           	h1.APPR_PUB__Active__c = TRUE;
            h1.Display_Name__c = 'display name 1';
            h1.APPR_PUB__Long_Description__c = 'Long_Description 11';
            h1.APPR_PUB__Sort_Order__c = 5;
            h1.RecordTypeId = recType.id;
            insert h1;
        hl1 = new APPR_PUB__Headline_Link__c(Name ='Headline link 1',APPR_PUB__Active__c = TRUE);
           	hl1.APPR_PUB__Active__c = TRUE;
            hl1.APPR_PUB__Display_Name__c = 'display name 1';
            hl1.APPR_PUB__URL__c = 'http://sunpower.com/';
            hl1.APPR_PUB__Sort_Order__c = 1;
       		hl1.APPR_PUB__Headline__c = h1.id;
            insert hl1;
        hl1 = new APPR_PUB__Headline_Link__c(Name ='Headline link 2',APPR_PUB__Active__c = TRUE);
           	hl1.APPR_PUB__Active__c = TRUE;
            hl1.APPR_PUB__Display_Name__c = 'link display name 2';
            hl1.APPR_PUB__URL__c = 'http://sunpower.com/';
            hl1.APPR_PUB__Sort_Order__c = 2;
       		hl1.APPR_PUB__Headline__c = h1.id;
            insert hl1;
        
        //sorting order 6
        h1 = new APPR_PUB__Headline__c(Name='Headline2', APPR_PUB__Tab__c='CHome' );
           	h1.APPR_PUB__Active__c = TRUE;
            h1.Display_Name__c = 'display name 1';
            h1.APPR_PUB__Long_Description__c = 'Long_Description 11';
            h1.APPR_PUB__Sort_Order__c = 16;
            h1.RecordTypeId = recType.id;
            insert h1;
        hl1 = new APPR_PUB__Headline_Link__c(Name ='Headline link 1',APPR_PUB__Active__c = TRUE);
           	hl1.APPR_PUB__Active__c = TRUE;
            hl1.APPR_PUB__Display_Name__c = 'display name 1';
            hl1.APPR_PUB__URL__c = 'http://sunpower.com/';
            hl1.APPR_PUB__Sort_Order__c = 1;
       		hl1.APPR_PUB__Headline__c = h1.id;
            insert hl1;
        hl1 = new APPR_PUB__Headline_Link__c(Name ='Headline link 2',APPR_PUB__Active__c = TRUE);
           	hl1.APPR_PUB__Active__c = TRUE;
            hl1.APPR_PUB__Display_Name__c = 'link display name 2';
            hl1.APPR_PUB__URL__c = 'http://sunpower.com/';
            hl1.APPR_PUB__Sort_Order__c = 2;
       		hl1.APPR_PUB__Headline__c = h1.id;
            insert hl1;
        
        
        //sorting order 6
        h1 = new APPR_PUB__Headline__c(Name='Headline2', APPR_PUB__Tab__c='CHome' );
           	h1.APPR_PUB__Active__c = TRUE;
            h1.Display_Name__c = 'display name 1';
            h1.APPR_PUB__Long_Description__c = 'Long_Description 11';
            h1.APPR_PUB__Sort_Order__c = 15;
            h1.RecordTypeId = recType.id;
            insert h1;
        hl1 = new APPR_PUB__Headline_Link__c(Name ='Headline link 1',APPR_PUB__Active__c = TRUE);
           	hl1.APPR_PUB__Active__c = TRUE;
            hl1.APPR_PUB__Display_Name__c = 'display name 1';
            hl1.APPR_PUB__URL__c = 'http://sunpower.com/';
            hl1.APPR_PUB__Sort_Order__c = 1;
       		hl1.APPR_PUB__Headline__c = h1.id;
            insert hl1;
        hl1 = new APPR_PUB__Headline_Link__c(Name ='Headline link 2',APPR_PUB__Active__c = TRUE);
           	hl1.APPR_PUB__Active__c = TRUE;
            hl1.APPR_PUB__Display_Name__c = 'link display name 2';
            hl1.APPR_PUB__URL__c = 'http://sunpower.com/';
            hl1.APPR_PUB__Sort_Order__c = 2;
       		hl1.APPR_PUB__Headline__c = h1.id;
            insert hl1;
        
        //sorting order 9
        h1 = new APPR_PUB__Headline__c(Name='Headline2', APPR_PUB__Tab__c='CHome' );
           	h1.APPR_PUB__Active__c = TRUE;
            h1.Display_Name__c = 'display name 1';
            h1.APPR_PUB__Long_Description__c = 'Long_Description 11';
            h1.APPR_PUB__Sort_Order__c = 15;
            h1.RecordTypeId = recType.id;
            insert h1;
        hl1 = new APPR_PUB__Headline_Link__c(Name ='Lead Performance Score',APPR_PUB__Active__c = TRUE, SSO_Active__c = TRUE);
           	hl1.APPR_PUB__Active__c = TRUE;
            hl1.APPR_PUB__Display_Name__c = 'Lead Performance Score';
            hl1.APPR_PUB__URL__c = 'http://sunpower.com/';
            hl1.APPR_PUB__Sort_Order__c = 1;
       		hl1.APPR_PUB__Headline__c = h1.id;
            insert hl1;
        hl1 = new APPR_PUB__Headline_Link__c(Name ='Dealer Program Fund', APPR_PUB__Active__c = TRUE, SSO_Active__c = TRUE);
           	hl1.APPR_PUB__Active__c = TRUE;
            hl1.APPR_PUB__Display_Name__c = 'Dealer Program Fund';
            hl1.APPR_PUB__URL__c = 'http://sunpower.com/';
            hl1.APPR_PUB__Sort_Order__c = 2;
       		hl1.APPR_PUB__Headline__c = h1.id;
            insert hl1;
        hl1 = new APPR_PUB__Headline_Link__c(Name ='Marketing Resource Center', APPR_PUB__Active__c = TRUE, SSO_Active__c = TRUE);
           	hl1.APPR_PUB__Active__c = TRUE;
            hl1.APPR_PUB__Display_Name__c = 'Marketing Resource Center';
            hl1.APPR_PUB__URL__c = 'http://sunpower.com/';
            hl1.APPR_PUB__Sort_Order__c = 2;
       		hl1.APPR_PUB__Headline__c = h1.id;
            insert hl1;
        hl1 = new APPR_PUB__Headline_Link__c(Name ='My Account', APPR_PUB__Active__c = TRUE,  SSO_Active__c = TRUE);
           	hl1.APPR_PUB__Active__c = TRUE;
            hl1.APPR_PUB__Display_Name__c = 'My Account';
            hl1.APPR_PUB__URL__c = 'http://sunpower.com/';
            hl1.APPR_PUB__Sort_Order__c = 2;
       		hl1.APPR_PUB__Headline__c = h1.id;
            insert hl1;
        RecordType accRecType = Database.query('select id from RecordType where name like \'Partner%\' and SobjectType=\'Account\'');
    Account accountObj = new Account();
    accountObj .RecordTypeId = accRecType.Id;    
    accountObj .Name = 'TestDuplicate';
    accountObj .Type ='Partner'; 
    accountObj .billingCity = 'TestCity';
    accountObj .BillingCountry = 'TestCountry';
    accountObj .BillingPostalCode = '12345';
    accountObj .BillingState = 'TestState';
    accountObj .BillingStreet = 'TestStreet';
    accountObj .ShippingCountry  = 'TestShippingCountry'; 
    accountObj .ShippingStreet = 'TestShippingStreet';
    accountObj .ShippingCity = 'TestShippingcity';
    accountObj .ShippingPostalCode = '45345';
    insert accountObj ;

        
        PageReference pageRef = Page.CHome;
        Test.setCurrentPage(pageRef);
      
        CHomeController controller = new CHomeController();
        controller.userAccountId = accountObj.id;
        //String nextPage = controller.save().getUrl();

        // Verify that page fails without parameters
        //System.assertEquals('/apex/failure?error=noParam', nextPage);

        // Add parameters to page URL
        //ApexPages.currentPage().getParameters().put('qp', 'yyyy');
      
        // Instantiate a new controller with all parameters in the page
        /*controller = new thecontroller(); 
        controller.setLastName('lastname');
        controller.setFirstName('firstname');
        controller.setCompany('acme');
        controller.setEmail('firstlast@acme.com');
        nextPage = controller.save().getUrl();

        // Verify that the success page displays
        System.assertEquals('/apex/success', nextPage);
        Lead[] leads = [select id, email from lead where Company = 'acme'];
        System.assertEquals('firstlast@acme.com', leads[0].email);*/
    }
}