@isTest
private class TestCaseManagementController {

  static testMethod void Test_CaseManagement(){
      Test.StartTest();
        String euInspectionCaseRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('New Inspections').getRecordTypeId();
        
        Case newCase = new Case();       
        newCase.Status = 'New';
        newCase.RecordTypeId = euInspectionCaseRecTypeId;
        insert newCase;
                      
        Account acc = new Account();
        acc.Name = 'Test Account-'+ String.valueOf(DateTime.Now());
        acc.Type ='Commercial';
        acc.BillingCity = 'san mateo';
        acc.BillingState = 'CA';
        acc.BillingStreet = 'Concar drive';
        acc.BillingPostalCode ='94402';
        acc.BillingCountry = 'USA'; 
        insert acc;
        
        Contact con = new Contact();
        con.LastName = 'Test Contact-'+ String.valueOf(DateTime.Now());
        con.AccountId = acc.Id;
        insert con;
        
        Inspection__c inspection = new Inspection__c();
        inspection.Case__c = newCase.Id;
        inspection.Contact__c = UserInfo.getUserId();
        inspection.Partner_Contact__c = con.Id;
        inspection.site_type__c = 'Residential';
        insert inspection;
        
        newCase.Status = 'Assigned';
        newCase.Notification_for_Update__c=true;
        newCase.AccountId =  acc.Id;
        update newCase;
        //User testUser2 = [Select LastName, Id, FirstName, Email From User where isActive = true AND UserRole.Name='Inspector' AND Id!=:newCase.OwnerId limit 1];
        // Birlasoft - Commented the above query and used another below with new role having an active user and access to Case.
      try {
          //User testUser2 = [Select LastName, Id, FirstName, Email From User where isActive = true AND UserRole.Name='Inspector Leader' AND Id!=:newCase.OwnerId limit 1];
          User testUser2 = TestClassFactory.testUser('Inspector Leader', 'testInspector@example.com', 'testInsp');
          insert testUser2;
          
          Test.startTest();
          if(testUser2 != null)
          {
              newCase.OwnerId = testUser2.Id;
              newCase.Notification_for_Update__c=true;
              newCase.RecordTypeId = euInspectionCaseRecTypeId;
              update newCase;
              
              newCase.Status = 'Completed';
              newCase.Review_By__c = UserInfo.getUserId();
          }
          Test.StopTest();
      } catch(Exception e) {}
  }
  
  /*------------- Nathan. commenting since Feedback record type is inactivated in SM 5.2 --------------------   
  static testMethod void Test_CaseManagement1(){
      Test.StartTest();
        String FeedbackCaseRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Feedback').getRecordTypeId();
        
        List<User> testUser = new List<User>([Select Phone, LastName, Id, FirstName, Email, City From User where isActive = true and email like '%sunpower%' limit 1]);

        Account acc = new Account();
        acc.Name = 'Test Account-'+ String.valueOf(DateTime.Now());
        acc.Type ='Commercial';
        acc.BillingCity = 'san mateo';
        acc.BillingState = 'CA';
        acc.BillingStreet = 'Concar drive';
        acc.BillingPostalCode ='94402';
        acc.BillingCountry = 'USA';         
        if(testUser.size()>0){
            acc.Assigned_PSR_IDS__c = testUser[0].Id;
            acc.Primary_PSR__c = testUser[0].Id;
        }
        insert acc;
        
        Contact con = new Contact();
        con.LastName = 'Test Contact-'+ String.valueOf(DateTime.Now());
        con.AccountId = acc.Id;
        con.Email = 'testxyz@gmail.com';
        insert con;
        
        Case newCase = new Case();       
        newCase.Status = 'New';
        newCase.RecordTypeId = FeedbackCaseRecTypeId;
        newCase.Product_Category__c = 'Cells';
        newCase.RMA__c = true;
        newCase.RMA_Status__c= 'Pending';
        newCase.Warranty__c = true;
        newCase.AccountId = acc.Id;
        newCase.Notification_for_Update__c = true;
        datetime myDate = datetime.newInstance(2012, 09, 5);
        newCase.Installation_Date__c = myDate.date();
        if(testUser.size()>0){
            newCase.RSM__c = testUser[0].Id;
        }
        newCase.Region__c = 'SPDE';
        //Case 00074218
        newCase.PE__c = true;
        insert newCase;        
           
        newCase.Business_Unit__c = 'RLC';
        newCase.Type = 'Tech Support - General';
        newCase.Status = 'Closed';
        newcase.AccountId = acc.Id;
        newCase.Notification_for_Update__c=true;
        update newCase;
        
        newCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer Service Case').getRecordTypeId();
        newCase.Last_Response_Timestamp__c = datetime.now().addDays(2) ;
        newCase.Status = 'Pending User Response';
        newCase.RMA_Type__c = 'Technical Support';
        newCase.Disposition__c = 'Scrapped';
        newCase.RMA_Status__c= 'Pending';
        newCase.RMA_Quantity__c=20;
        newCase.Vendor__c = 'Xantrex';
        newCase.Product_Category__c = 'Accessories';
        newCase.Vendor_RMA_Status__c = 'Open';
        newCase.RMA_Replacement__c = 'RMA_Replacement__c';
        newCase.RMA_Return__c = 'RMA_Return__c';
        update newCase;
        
        Test.StopTest();
        
     }
  --------------------------------------------------------------------------------------------------*/
     
  static testMethod void Test_CaseManagement2(){
      Test.StartTest();
        String  CSCaseRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer Service Case').getRecordTypeId();
        
        User testUser = [select id from user where isActive = true limit 1];

        Account acc = new Account();
        acc.Name = 'Test Account-'+ String.valueOf(DateTime.Now());
        acc.Type ='Commercial';
        acc.BillingCity = 'san mateo';
        acc.BillingState = 'CA';
        acc.BillingStreet = 'Concar drive';
        acc.BillingPostalCode ='94402';
        acc.BillingCountry = 'USA'; 
        acc.Assigned_PSR_IDS__c = testUser.Id;
        insert acc;
        
        Contact con = new Contact();
        con.LastName = 'Test Contact-'+ String.valueOf(DateTime.Now());
        con.AccountId = acc.Id;
        con.Email = 'testabc@gmail.com';
        insert con;
        
        Case newCase = new Case();       
        newCase.Status = 'New';
        newCase.RecordTypeId = CSCaseRecTypeId;
        newcase.RMA__c = true;
        newcase.AccountId = acc.Id;
        newcase.Warranty__c = true;
        // Done for case # 00066557 consolidating business units IBD and Components into 'UPP Intl'.
        // newcase.Business_Unit__c ='Components';
        newcase.Business_Unit__c ='UPP Intl';
        newcase.Region__c = 'SPNA';
        newcase.Product_Category__c ='Inverters';
        newcase.Product_Sub_Category__c ='SPR-M';
        newcase.RMA_Type__c = 'Technical Support'; 
        newcase.Type_of_RMA_exchange__c = 'Not Applicable (N/A)';
         //Case 00074218
        newCase.PE__c = true;
        try{
            insert newCase;         
        }catch(DMLException ex){}
            
        newcase.Replace_with_Part__c = 'SER-235';
        try{
            insert newCase;
        }catch(DMLException ex){}
           
        newcase.Replace_with_Part__c = null;
        newcase.Type_of_RMA_exchange__c = 'Complete exchange';
        try{
            insert newCase;
        }catch(DMLException ex){}
        
        newcase.Serial_Numbers_of_Replacement__c  = '2345678';
        try{
            insert newCase;
        }catch(DMLException ex){}        
        
        newcase.Product_Sub_Category__c ='SPR-F';   
        newcase.Type_of_RMA_exchange__c = 'Part exchange';
        newcase.Replace_with_Part__c ='Power stage';
        try{
            insert newCase;
        }catch(DMLException ex){}
        
        newcase.Serial_Numbers_of_Replacement__c  = '';
        try{
            insert newCase;
            newCase.Status = 'Closed';
            newCase.Business_Unit__c = 'RLC';
            update newCase;
        }catch(DMLException ex){}
        
        Test.StopTest();
  }
  
  /*------------- Nathan. commenting since Feedback record type is inactivated in SM 5.2 --------------------   

  static testMethod void Test_CaseManagement3(){
  
  Test.StartTest();
    
    String FeedbackCaseRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Feedback').getRecordTypeId();
    User testUser = [select id from user where isActive = true limit 1];
    
    Account acc = new Account();
    acc.Name = 'Test Account-'+ String.valueOf(DateTime.Now());
    acc.Type ='Commercial';
    acc.BillingCity = 'san mateo';
    acc.BillingState = 'CA';
    acc.BillingStreet = 'Concar drive';
    acc.BillingPostalCode ='94402';
    acc.BillingCountry = 'USA'; 
    acc.Assigned_PSR_IDS__c = testUser.Id;
    insert acc;
        
        
    Set<String> regions = new Set<String>{'SPNA', 'SPAU', 'SPDE'};
    List<Case> caseList = new List<Case>();
    for(String region:regions){
        Case newCase = new Case();       
        newCase.Status = 'New';
        newCase.RecordTypeId = FeedbackCaseRecTypeId;
        newCase.Notification_for_Update__c=false;
        newCase.RSM__c = testUser.Id;
        newCase.Region__c = region;
        newCase.VAR_Dept_Owner__c='Sales';
        newCase.AccountId = acc.Id;        
        caseList.add(newCase);
    }
    insert caseList;
    
    //for update alert
    for(Case cs : caseList){
        cs.Notification_for_Update__c = true;
    }
    update caseList;
    
    Test.StopTest();
  }
  ------------------------------------------------------------------------------------------*/
  
  static testMethod void Test_CaseManagement4(){
  
      Test.StartTest();
        String crmCaseRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CRM Case').getRecordTypeId();
        
        Case newCase = new Case();       
        newCase.Status = 'Pending User Response';
        newCase.RecordTypeId = crmCaseRecTypeId;
        newCase.Last_Response_Timestamp__c = DateTime.now();
        insert newCase;
        
       Test.StopTest();
  }
  static testMethod void Test_CaseManagement5(){
      Test.StartTest();
        List<Case> caseList = new List<Case>();
        Case newCase = new Case(); 
        newCase.Type = 'Customer Complaint';
        caseList.add(newCase);
        
        Case newCase1 = new Case();
        caseList.add(newCase1);
        
        insert caseList;
        CaseManagement.chgDates(caseList);
        Test.StopTest();
  }
  static testMethod void Test_createPostCallSurvey(){
      Test.StartTest();
        List<Case> caseList = new List<Case>();
        Case newCase = new Case(); 
        newCase.Type = 'Customer Complaint';
        caseList.add(newCase);
        
        Case newCase1 = new Case();
        caseList.add(newCase1);
        
        insert caseList;
        
        CaseManagement.createPostCallSurvey(caseList);
        Test.StopTest();
  }
  
}