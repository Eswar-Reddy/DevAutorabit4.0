/*******************************
//Created By- Kapil Goutam
//Created On- May 01 2009
//Last Modified on-
//Last Modified By-
//Description- Test Class For CreatePartnerApplication page
//Version - 1.0
********************************/
@isTest
public class TestCreatePartnerApplication{
 
   
    static TestMethod void TestCreatePartnerApplication(){
        DealerUtility.bulkLeadTest = TRUE;
        ApexTrigger t2 = new ApexTrigger(name = 'Lead');
        //TriggerDispatcher.setFrameworkTestParameters(t2,true);
        List<Lead> leadList = new List<Lead>();
        Lead leadObj = new Lead(LastName = 'Test Last Name' +String.valueOf(DateTime.Now()), Company = 'Test Company' +String.valueOf(DateTime.Now()),
        	Status = 'Open', LeadSource = 'Web',Ground_Roof_Space__c ='10');
               
        leadObj.Email = 'abcTest@test.com';
        leadObj.Theater__c = 'North America';
        leadObj.Partner_Type__c ='Residential';
        leadList.add(leadObj);
        
        Lead leadObj1 = new Lead(LastName = 'Test Last Name' +String.valueOf(DateTime.Now()), Company = 'Test Company1' +String.valueOf(DateTime.Now()),
        	Status = 'Open', LeadSource = 'Web',Ground_Roof_Space__c ='10');
        leadObj1.Email = 'abcTest1@test.com';
        leadObj1.Theater__c = 'North America';
        leadObj1.Partner_Type__c ='Commercial';
        leadList.add(leadObj1);
        
        Lead leadObj2 = new Lead(LastName = 'Test Last Name' +String.valueOf(DateTime.Now()), Company = 'Test Company3' +String.valueOf(DateTime.Now()),
        	Status = 'Open', LeadSource = 'Web',Ground_Roof_Space__c ='10');
        leadObj2.Email = 'abcTest2@test.com';
        leadObj2.Theater__c = 'Europe';
        leadList.add(leadObj2);
        
        Lead leadObj3 = new Lead(LastName = 'Test Last Name' +String.valueOf(DateTime.Now()), Company = 'Test Company4' +String.valueOf(DateTime.Now()),
        	Status = 'Open', LeadSource = 'Web',Ground_Roof_Space__c ='10');
        leadObj3.Email = 'abcTest3@test.com';
        leadObj3.Theater__c = 'Australia';
        leadList.add(leadObj3);
        
        insert leadList;
        
        System.currentPageReference().getParameters().put('LId', leadObj.Id);
        System.currentPageReference().getParameters().put('Lang', 'English');
        
        Test.startTest();
        //Test for NA Residential Lead
        CreatePartnerApplication obj = new CreatePartnerApplication();
        obj.saveAndMove();
        List<Partner_Application__c> pa = [Select Id, RecordType.Name from Partner_Application__c where Lead__c =:leadObj.Id limit 1];
        System.assertEquals(pa.size(), 1);
        System.assertEquals(pa.get(0).RecordType.Name, 'NA Partner Application');
        Lead newLead = [Select Partner_Application__c from Lead where Id =:leadObj.Id limit 1]; 
        System.assertEquals(newLead.Partner_Application__c, pa.get(0).Id);
        System.assertEquals(obj.errorMessage, null);
        //Test for Exception
        
        //obj = new CreatePartnerApplication();        
        obj.saveAndMove();
        System.assertNotEquals(obj.errorMessage, null);
        
        //Test for NA Commercial Lead
        System.currentPageReference().getParameters().put('LId', leadObj1.Id);
        obj = new CreatePartnerApplication();
        obj.saveAndMove();
        pa = [Select Id, RecordType.Name from Partner_Application__c where Lead__c =:leadObj1.Id limit 1];
        System.assertEquals(pa.size(), 1);
        System.assertEquals(pa.get(0).RecordType.Name, 'NA Commercial Partner Application');        
        newLead = [Select Partner_Application__c from Lead where Id =:leadObj1.Id limit 1]; 
        System.assertEquals(newLead.Partner_Application__c, pa.get(0).Id);
        System.assertEquals(obj.errorMessage, null);
        
        //Test for EU Lead
        System.currentPageReference().getParameters().put('LId', leadObj2.Id);
        obj = new CreatePartnerApplication();
        obj.saveAndMove();
        pa = [Select Id, RecordType.Name from Partner_Application__c where Lead__c =:leadObj2.Id limit 1];
        System.assertEquals(pa.size(), 1);
        System.assertEquals(pa.get(0).RecordType.Name, 'EU Partner Application');        
        newLead = [Select Partner_Application__c from Lead where Id =:leadObj2.Id limit 1]; 
        System.assertEquals(newLead.Partner_Application__c, pa.get(0).Id);
        System.assertEquals(obj.errorMessage, null);
        
        //Test for AUS Lead
        System.currentPageReference().getParameters().put('LId', leadObj3.Id);
        System.currentPageReference().getParameters().put('Type', 'Residential');
        obj = new CreatePartnerApplication();
        obj.saveAndMove();
        pa = [Select Id, RecordType.Name from Partner_Application__c where Lead__c =:leadObj3.Id limit 1];
        System.assertEquals(pa.size(), 1);
        System.assertEquals(pa.get(0).RecordType.Name, 'AUS Partner Application');
        newLead = [Select Partner_Application__c from Lead where Id =:leadObj3.Id limit 1]; 
        System.assertEquals(newLead.Partner_Application__c, pa.get(0).Id);        
        System.assertEquals(obj.errorMessage, null);
        
        Test.stopTest();
   }
   
}