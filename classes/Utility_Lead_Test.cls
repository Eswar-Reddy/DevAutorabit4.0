@isTest
public class Utility_Lead_Test {
    
    static TestMethod void testSPDEloquaMatrix() {
		//setAutoConvertLeadFieldsSPD(Lead l
		Lead l = TestClassFactory.testLead('TestLead', 'Test Lead', 'test' + Math.random() + '@noemail123.com');
        l.Source_System__c = 'Eloqua';
        l.Lead_Data_Quality__c = 'Qualified';
        
        Test.startTest();
        Utility_Lead.setAutoConvertLeadFieldsSPD(l);
        System.assertEquals(l.Status, 'Marketing Qualified');
        
        l.Lead_Data_Quality__c = 'Undetermined';
        Utility_Lead.setAutoConvertLeadFieldsSPD(l);
        System.assertEquals(l.Status, 'Disqualified');
        
        l.Lead_Data_Quality__c = null;
        Utility_Lead.setAutoConvertLeadFieldsSPD(l);
        System.assertEquals(l.Status, 'Disqualified');
        Test.stopTest();
    }
    
    static TestMethod void testStandardEloquaMatrix() {
        //setAutoConvertLeadFields(Lead l
        
		Lead l = TestClassFactory.testLead('TestLead', 'Test Lead', 'test' + Math.random() + '@noemail123.com');
        l.Source_System__c = 'Eloqua';
        l.Lead_Inferred_Quality__c = 'Reject';
        
        
        Utility_Lead.setAutoConvertLeadFields(l);
        System.assertEquals(l.Status, 'SPAM');
        
        l.Lead_Inferred_Quality__c = 'Accept';
        l.Lead_Data_Quality__c = 'Qualified';
        Utility_Lead.setAutoConvertLeadFields(l);
        System.assertEquals(l.Status, 'Marketing Qualified');
         
        l.Lead_Inferred_Quality__c = 'Review';
        l.Lead_Data_Quality__c = 'Undetermined';
        
        Utility_Lead.setAutoConvertLeadFields(l);
        System.assertEquals(l.Status, 'Awaiting Qualification Review');
        
        Test.startTest();
        
        l.Lead_Data_Quality__c = 'Qualified';
        l.Lead_Inferred_Quality__c = 'Accept';
        l.Street = '77 Rio Robles';
        l.City = 'San Jose';
        l.State = 'CA';
        l.Country = 'United States of America';
        
        insert l;
        
        Test.stopTest();
        
        Lead result = [SELECT Id, Status, Country FROM Lead WHERE Id =: l.Id];
        
        System.assertEquals(result.Status, 'Marketing Qualified');
        System.assertEquals(result.Country, 'United States');
         
    }
    
    static TestMethod void testLeadInsertUpdateFields() {
        //setFieldsBasedOnLeadValues(lead l, Lead oldLead)
        Lead l = TestClassFactory.testLead('TestlastName', 'Test Lead Company', 'TestLeadUtil@noemail.com');
        l.LeadSource = 'Jigsaw';
        
        Test.startTest();
        insert l;

        Lead result1 = [SELECT RecordTypeId, Status, LeadSource FROM Lead WHERE Id =: l.Id];
		System.assertEquals(result1.RecordTypeId, Utility_Lead.ResidentialRecordTypeId);
        System.assertEquals(result1.Status, 'Marketing Qualified');
        System.assertEquals(result1.LeadSource, 'Data.Com - Sales');
        
        l.LeadSource = 'Jigsaw';
        l.Country = null;
        l.State = 'AZ';
        l.SPWR_Industry_Type__c = 'Other';
        l.Theater__c = 'NA';
        l.First_follow_up__c = true;
        l.Second_follow_up__c = true;
        l.Third_follow_up__c = true;
        l.Fourth_follow_up__c = true;
        l.Fifth_follow_up__c = true;
        
        update l;
        Test.stopTest();
        
        Lead result2 = [SELECT Id, LeadSource, RecordTypeId, SPWR_Industry_Type_Hidden__c, Theater__c,
                       		Date_Time_First_follow_up__c, Date_Time_Second_Follow_Up__c, Date_Time_Third_Follow_Up__c,
                       		Date_Time_Fourth_Follow_Up__c, Date_Time_Fifth_Follow_Up__c
                       FROM Lead WHERE Id =: l.Id];
        
        System.assert(result2.LeadSource == 'Data.Com - Sales');
        System.assert(result2.RecordTypeId == Utility_Lead.ResidentialRecordTypeId);
        System.assert(result2.Theater__c == null);
        System.assert(result2.SPWR_Industry_Type_Hidden__c == 'Other');
        System.assert(result2.Date_Time_First_follow_up__c != null);
        System.assert(result2.Date_Time_Second_follow_up__c != null);
        System.assert(result2.Date_Time_Third_follow_up__c != null);
        System.assert(result2.Date_Time_Fourth_follow_up__c != null);
        System.assert(result2.Date_Time_Fifth_follow_up__c != null);
        
    }
    
    static TestMethod void testLeadDupeCheck() {
        //findDuplicateLeads(Map<String, Id> dupCheckMap)
        Map<String, Id> dupeCheckMap = new Map<String, Id>();
        
        Lead l = TestClassFactory.testLead('TestlastName', 'Testcompany', 'test@noemail.com');
        
        insert l;
        
        dupeCheckMap.put(l.Email, l.Id);
        
        Test.startTest();
        Utility_Lead.findDuplicateLeads(dupeCheckMap);
        Test.stopTest();
    }
    
    static TestMethod void testSiteInfoForm() {

        Account affiliateAcc = TestClassFactory.testAccount('TestAffiliatename', TestClassFactory.retrieveRecordTypeID('Account', 'Partner'));
        insert affiliateAcc;
        
        Lead l = TestClassFactory.testLead('testlastName', 'Testcompany', 'testlead@noemail.test');
        l.RecordTypeId = TestClassFactory.retrieveRecordTypeID('Lead', 'Systems');
        l.Street = '77 Rio Robles';
        l.City = 'San Jose';
        l.State = 'CA';
        l.Country = 'United States';
        l.PostalCode = '95134';
        l.Facility_Address__c = '77 Rio Robles';
        l.Facility_Address_2__c = 'Suite 1';
        l.Facility_City__c = 'San Jose';
        l.Facility_State__c = 'CA';
        l.Facility_Zip__c = '95134';
        l.Affiliate_Account__c = affiliateAcc.Id;
        
        insert l;
        
        Site_Information_Form__c sf = new Site_Information_Form__c();
        sf.Lead__c = l.Id;
        sf.RecordTypeId = TestClassFactory.retrieveRecordTypeID('Site_Information_Form__c', 'Lead Sites');
        sf.Site_Address__c = 'test';
        sf.Site_City__c = 'San Francisco';
        sf.Site_Country__c = 'test';
        sf.Site_Zip_Postal_Code__c = '123';
        insert sf;
        
        l.Status = 'Qualified';
        
        Test.startTest();
        update l;
        
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(l.Id);
        lc.setConvertedStatus(convertStatus.MasterLabel);
        
        Database.LeadConvertResult lr = Database.convertLead(lc);
        
        
        Test.stopTest();
        
    
    }

}