public class TestLeadRatingManagement{
static Map<String,String> mapRecordTypeIDName = new Map<String,String>();
static ID partnerRecordTypeId = null;
static {
    Map<Id, Schema.RecordTypeInfo> idToLeadRecordTypeInfoMap = LeadManagement.idToLeadRecordTypeInfoMap;
    for (ID recordTypeId : idToLeadRecordTypeInfoMap.keySet()) {
        mapRecordTypeIDName.put(recordTypeId, idToLeadRecordTypeInfoMap.get(recordTypeId).getName());   
        if (idToLeadRecordTypeInfoMap.get(recordTypeId).getName() == 'Partner') {
            partnerRecordTypeId = recordTypeId;
        }
    }
 }
 
  @isTest
  public static void testLeadCheck(){
      Lead lstLead = new Lead();
      lstLead.FirstName = 'Test';
      lstLead.LastName = 'Commercial';
      if(partnerRecordTypeId!=null){
        lstLead.recordtypeID = partnerRecordTypeId;
      }
      lstLead.Lead_Type__c='Partner';
      lstLead.Company = 'TEST Company A';
      lstLead.Country = 'Italy';
      lstLead.Email = 'testEmail@test123.com';
      lstLead.Phone = '09829098290';
      lstLead.LeadSource = 'Web';
      lstLead.Theater__c = 'Europe';
      
 
      insert lstLead;
      LeadRatingManagement.setItalyRating(lstLead,mapRecordTypeIDName);
  }
  @isTest
  public static void testLeadCheck1(){
      Lead lstLead = new Lead();
      lstLead.FirstName = 'Test';
      lstLead.LastName = 'Commercial';
      if(partnerRecordTypeId!=null){
        lstLead.recordtypeID = partnerRecordTypeId;
      }
      lstLead.Company = 'TEST Company A';
      lstLead.Country = 'Italy';
      lstLead.Email = 'testEmail@test123.com';
      lstLead.Phone = '09829098290';
      lstLead.LeadSource = 'Web';
      lstLead.Theater__c = 'Europe';
      lstLead.Total_Experience_in_Solar_Business__c = 'New to Solar Business';
 
      insert lstLead;
      LeadRatingManagement.setItalyRating(lstLead,mapRecordTypeIDName);
      
      Lead lstLead2 = new Lead();
      lstLead2.FirstName = 'Test';
      lstLead2.LastName = 'Commercial';
      if(partnerRecordTypeId!=null){
        lstLead.recordtypeID = partnerRecordTypeId;
      }
      lstLead2.Company = 'TEST Company A';
      lstLead2.Country = 'Italy';
      lstLead2.Email = 'testEmail@test123.com';
      lstLead2.Phone = '09829098290';
      lstLead2.LeadSource = 'Web';
      lstLead2.Theater__c = 'Europe';
      lstLead2.Size_of_Projects__c = '< 20 KW';
      lstLead2.Total_Experience_in_Solar_Business__c = '2';
 
      insert lstLead2;
      LeadRatingManagement.setItalyRating(lstLead2,mapRecordTypeIDName);
      
      
      Lead lstLead3 = new Lead();
      lstLead3.FirstName = 'Test';
      lstLead3.LastName = 'Commercial';
      if(partnerRecordTypeId!=null){
        lstLead.recordtypeID = partnerRecordTypeId;
      }
      lstLead3.Company = 'TEST Company A';
      lstLead3.Country = 'Italy';
      lstLead3.Email = 'testEmail@test123.com';
      lstLead3.Phone = '09829098290';
      lstLead3.LeadSource = 'Web';
      lstLead3.Theater__c = 'Europe';
      lstLead3.Size_of_Projects__c = '< 20 KW';
      lstLead3.Total_Experience_in_Solar_Business__c = '2';
      lstLead3.Size_of_Projects__c = '> 20 KW';
 
      insert lstLead3;
      LeadRatingManagement.setItalyRating(lstLead3,mapRecordTypeIDName);
      
      
  }
  @isTest
  public static void testLeadCheck2(){
      
      Test.startTest();    
      Lead lstLead1 = new Lead();
      lstLead1.FirstName = 'Test';
      lstLead1.LastName = 'Commercial';
      lstLead1.Lead_Type__c='Partner';
      lstLead1.Company = 'TEST Company A';
      lstLead1.Country = 'Italy';
      lstLead1.Email = 'testEmail@test123.com';
      lstLead1.Phone = '09829098290';
      lstLead1.LeadSource = 'Web';
      lstLead1.Theater__c = 'Europe';
      lstLead1.Size_of_Projects__c = '< 20 KW';
      lstLead1.Total_Experience_in_Solar_Business__c = 'New to Solar Business';
      lstLead1.Does_Company_Install_PV_Distribute__c = 'Both';
      lstLead1.Has_Engineering_and_Sales_Resources__c =true;
      if(partnerRecordTypeId!=null){
        lstLead1.recordtypeID = partnerRecordTypeId;
      }
      
      lstLead1.Cored_Business__c = 'Other';
      lstLead1.Want_to_buy_kits__c = true;
      lstLead1.Has_Engineering_and_Sales_Resources__c = true;
      lstLead1.state = 'CT';
      lstLead1.Focused_on_Ground_Mounted_Systems__c = false;
      lstLead1.Immediate_Interest_in_Pricing__c = false;
      lstLead1.Proposal_Partner_Type__c = 'Authorized'; 
      insert lstLead1;
      LeadRatingManagement.setItalyRating(lstLead1,mapRecordTypeIDName);
      
      
      Lead lstLead2 = new Lead();
      lstLead2.FirstName = 'Test';
      lstLead2.LastName = 'Commercial';
      lstLead2.Lead_Type__c='Partner';
      lstLead2.Company = 'TEST Company A';
      lstLead2.Country = 'Italy';
      lstLead2.Email = 'testEmail@test123.com';
      lstLead2.Phone = '09829098290';
      lstLead2.LeadSource = 'Web';
      lstLead2.Theater__c = 'Europe';
      lstLead2.Size_of_Projects__c = '< 20 KW';
      lstLead2.Total_Experience_in_Solar_Business__c = 'New to Solar Business';
      lstLead2.Does_Company_Install_PV_Distribute__c = 'Both';
      lstLead2.Has_Engineering_and_Sales_Resources__c =true;
      if(partnerRecordTypeId!=null){
        lstLead2.recordtypeID = partnerRecordTypeId;
      }
      
      lstLead2.Cored_Business__c = 'HVAC';
      lstLead2.Want_to_buy_kits__c = true;
      lstLead2.Has_Engineering_and_Sales_Resources__c = true;
      lstLead2.state = 'CN';
      lstLead2.Focused_on_Ground_Mounted_Systems__c = false;
      lstLead2.Immediate_Interest_in_Pricing__c = false;
      lstLead2.Proposal_Partner_Type__c = 'Authorized'; 
      insert lstLead2;
      LeadRatingManagement.setItalyRating(lstLead2,mapRecordTypeIDName);
      
      Lead lstLead3 = new Lead();
      lstLead3.FirstName = 'Test';
      lstLead3.LastName = 'Commercial';
      lstLead3.Lead_Type__c='Partner';
      lstLead3.Company = 'TEST Company A';
      lstLead3.Country = 'Italy';
      lstLead3.Email = 'testEmail@test123.com';
      lstLead3.Phone = '09829098290';
      lstLead3.LeadSource = 'Web';
      lstLead3.Theater__c = 'Europe';
      lstLead3.Total_Experience_in_Solar_Business__c = '1 - 2 years';
      lstLead3.Size_of_Projects__c = '> 20 KW';
      lstLead3.Does_Company_Install_PV_Distribute__c = 'Both';
      lstLead3.Has_Engineering_and_Sales_Resources__c =true;
      if(partnerRecordTypeId!=null){
        lstLead3.recordtypeID = partnerRecordTypeId;
      }
      lstLead3.Has_Rooftop_Experience__c = true;
      lstLead3.Has_Engineering_and_Sales_Resources__c = true;
      lstLead3.state = 'Other';
      lstLead3.Focused_on_Ground_Mounted_Systems__c = false;
      lstLead3.Immediate_Interest_in_Pricing__c = false;
      insert lstLead3;
      LeadRatingManagement.setItalyRating(lstLead3,mapRecordTypeIDName);
      
      Lead lstLead4 = new Lead();
      lstLead4.FirstName = 'Test';
      lstLead4.LastName = 'Commercial';
      lstLead4.Lead_Type__c='Partner';
      lstLead4.Company = 'TEST Company A';
      lstLead4.Country = 'Italy';
      lstLead4.Email = 'testEmail@test123.com';
      lstLead4.Phone = '09829098290';
      lstLead4.LeadSource = 'Web';
      lstLead4.Theater__c = 'Europe';
      lstLead4.Total_Experience_in_Solar_Business__c = '2';
      lstLead4.Size_of_Projects__c = '> 20 KW';
      lstLead4.Does_Company_Install_PV_Distribute__c = 'Install';
      lstLead4.Has_Engineering_and_Sales_Resources__c =true;
      if(partnerRecordTypeId!=null){
        lstLead4.recordtypeID = partnerRecordTypeId;
      }
      lstLead4.Has_Rooftop_Experience__c = true;
      lstLead4.Has_Engineering_and_Sales_Resources__c = true;
      lstLead4.state = 'Isernia';
      lstLead4.Focused_on_Ground_Mounted_Systems__c = false;
      lstLead4.Immediate_Interest_in_Pricing__c = false;
       
      insert lstLead4;
      LeadRatingManagement.setItalyRating(lstLead4,mapRecordTypeIDName);    
      
        
      Lead lstLead5 = new Lead();
      lstLead5.FirstName = 'Test';
      lstLead5.LastName = 'Commercial';
      lstLead5.Lead_Type__c='Partner';
      lstLead5.Company = 'TEST Company A';
      lstLead5.Country = 'Italy';
      lstLead5.Email = 'testEmail@test123.com';
      lstLead5.Phone = '09829098290';
      lstLead5.LeadSource = 'Web';
      lstLead5.Theater__c = 'Europe';
      lstLead5.Size_of_Projects__c = '< 20 KW';
      lstLead5.Total_Experience_in_Solar_Business__c = '1 - 2 years';
      lstLead5.Does_Company_Install_PV_Distribute__c = 'Install';
      lstLead5.Has_Engineering_and_Sales_Resources__c =true;
      if(partnerRecordTypeId!=null){
        lstLead5.recordtypeID = partnerRecordTypeId;
      }
      lstLead5.Has_Rooftop_Experience__c = true;
      lstLead5.Has_Engineering_and_Sales_Resources__c = true;
      lstLead5.state = 'CT';
      lstLead5.Focused_on_Ground_Mounted_Systems__c = false;
      lstLead5.Immediate_Interest_in_Pricing__c = false;
      lstLead5.Cored_Business__c = 'PV';
      lstLead5.Want_to_buy_kits__c = true;
      lstLead5.Immediate_Interest_in_Pricing__c = false;
            
      insert lstLead5;
      LeadRatingManagement.setItalyRating(lstLead5,mapRecordTypeIDName);
      
      Lead lstLead6 = new Lead();
      lstLead6.FirstName = 'Test';
      lstLead6.LastName = 'Commercial';
      lstLead6.Lead_Type__c='Partner';
      lstLead6.Company = 'TEST Company A';
      lstLead6.Country = 'Italy';
      lstLead6.Email = 'testEmail@test123.com';
      lstLead6.Phone = '09829098290';
      lstLead6.LeadSource = 'Web';
      lstLead6.Theater__c = 'Europe';
      lstLead6.Size_of_Projects__c = '< 20 KW';
      lstLead6.Total_Experience_in_Solar_Business__c = '2';
      lstLead6.Does_Company_Install_PV_Distribute__c = 'Install';
      lstLead6.Has_Engineering_and_Sales_Resources__c =true;
      if(partnerRecordTypeId!=null){
        lstLead6.recordtypeID = partnerRecordTypeId;
      }
      lstLead6.Has_Rooftop_Experience__c = true;
      lstLead6.Has_Engineering_and_Sales_Resources__c = true;
      lstLead6.state = 'CN';
      lstLead6.Focused_on_Ground_Mounted_Systems__c = false;
      lstLead6.Immediate_Interest_in_Pricing__c = false;
      lstLead6.Cored_Business__c = 'PV';
      lstLead6.Want_to_buy_kits__c = true;
      lstLead6.Immediate_Interest_in_Pricing__c = false;
            
      insert lstLead6;
      LeadRatingManagement.setItalyRating(lstLead6,mapRecordTypeIDName);
            
      Map<Id,Lead> leadMap = new Map<Id,Lead>([select id , LeadScore__c , Rating from Lead 
                                                    where ID =:lstLead1.Id OR ID =:lstLead2.Id
                                                        OR ID =:lstLead3.Id OR ID =:lstLead4.Id
                                                        OR ID =:lstLead5.Id OR ID =:lstLead6.Id ]);
            
      //System.assertEquals(15,leadMap.get(lstLead1.Id).LeadScore__c);
      //System.assertEquals(18,leadMap.get(lstLead2.Id).LeadScore__c);
      //System.assertEquals(17,leadMap.get(lstLead3.Id).LeadScore__c);
      //System.assertEquals(21,leadMap.get(lstLead4.Id).LeadScore__c);
      //System.assertEquals(22,leadMap.get(lstLead5.Id).LeadScore__c);
      //System.assertEquals(24,leadMap.get(lstLead6.Id).LeadScore__c);
  }
  
    testMethod public static void testLeadCheck3() {
        Lead l1 = new Lead();
        
        l1.LastName = 'Leader';
        l1.FirstName = 'Test';
        l1.Total_Experience_in_Solar_Business__c = '5+ years';
        l1.Installations_Realized_Previous_Year__c = 20;
        l1.Does_Company_Install_PV_Distribute__c = 'Install';
        l1.NumberOfEmployees = 5;
        l1.Has_Engineering_and_Sales_Resources__c = true;
        l1.Focused_on_Ground_Mounted_Systems__c = false;
        l1.leadsource = 'Web';
        l1.Email = 'test@net.moc';
        l1.phone = '0972834767';
        
        l1.Commercial_Residential_Business_Split__c = 'Residential - 10% / Commercial - 90%';
        l1.Immediate_Interest_in_Pricing__c = false;
        l1.MCS_certification__c = 'Yes';
        
        Test.startTest();
        //query available lead record types and save it in a map
        List<Recordtype> rType = [SELECT Id, Name
           FROM Recordtype
           WHERE Sobjecttype = 'Lead' AND Name = 'Partner'];
        
        Map<String, String> rTypeIDName_map = new Map<String, String>();
        
        for (RecordType rt:rType) {
            rTypeIDName_map.put(rt.Id, rt.Name);
            l1.RecordTypeId = rt.Id;
        }
        
        System.assertEquals(rTypeIDName_map.size(),1);
        
        insert(l1);
        
        LeadRatingManagement.setFrance(l1, rTypeIDName_map);       
        LeadRatingManagement.setUKRating(l1, rTypeIDName_map);
        
        l1.Has_Engineering_and_Sales_Resources__c = false;        
        
        update(l1);
        
        LeadRatingManagement.setFrance(l1, rTypeIDName_map);
        
        l1.Focused_on_Ground_Mounted_Systems__c = true;
        l1.Immediate_Interest_in_Pricing__c = true;
        l1.Total_Experience_in_Solar_Business__c = '< 1 year';
        l1.Total_Experience_in_Solar_Business__c = 'New to Solar Business';
        l1.Does_Company_Install_PV_Distribute__c = 'Distribute';
        l1.NumberOfEmployees = 1;
        l1.Installations_Realized_Previous_Year__c = 1;
        
        update(l1);
        
        LeadRatingManagement.setFrance(l1, rTypeIDName_map);
        
        l1.Has_Engineering_and_Sales_Resources__c = true;
        
        update(l1);
        
        LeadRatingManagement.setUKRating(l1, rTypeIDName_map);
        
        Test.StopTest();
    }
}