public class TestOpportunityManagement2{
  
  @isTest
  public static void checkOpportunityManagement2(){
      List<User> u = new List<User>();
      /* Done for case # 00050543 on 19Feb2011 */
      //u = [Select id from User where UserRole.name='Regional Sales Manager' and 
      u = [Select id from User where UserRole.name LIKE '%Regional Sales Manager%' and 
        IsActive = true limit 1];
      Account acc = new Account(Name='Test'+String.valueOf(DateTime.Now()),Theater__c='Europe',Territory__c='abc');
      acc.BillingCity = 'san mateo';
      acc.BillingStreet = 'Concar drive';
      acc.BillingPostalCode ='94402';
      acc.BillingCountry = 'USA'; 
      if(u.size()!=0){
          acc.RSM__c = u[0].id;
      }
      insert acc;
      
      Opportunity opp = new Opportunity(Name='opp'+String.valueOf(DateTime.Now()),AccountID=acc.id,stagename='50% - Value Proposition',closedate=date.today());
      opp.Probability = 50;
      insert opp;
      
      List<User> lstUser = [select Id, Name, Contact.AccountId 
        from User where ContactId != null and Contact.Account.RSM__c!=null and IsActive = true Limit 1];
      if(lstUser.size() > 0){
          opp.ownerID = lstUser[0].Id;
          update opp;
      }
      update opp;
  }
  
  @isTest
  public static void checkSharingRules(){
    //create Account
    Account testAccount = new Account();
    testAccount.Name = 'Test Account'+String.valueOf(DateTime.now());   
    testAccount.Executives_view_all_Opportunities__c = true;
    testAccount.Allow_all_to_view_Opportunities__c = true;
    testAccount.BillingCity = 'san mateo';
      testAccount.BillingStreet = 'Concar drive';
      testAccount.BillingPostalCode ='94402';
      testAccount.BillingCountry = 'USA'; 
    insert testAccount;
    
    Opportunity opp = new Opportunity(Name='opp'+String.valueOf(DateTime.Now()),AccountID=testAccount.id,stagename='50% - Value Proposition',closedate=date.today());
    opp.Probability =50;
    insert opp;
  }
  
    @isTest
    public static void checkStatus_Date(){
        String ResiRecordTypeID='';
        String namePrefix ='PR-02414_1_';
        String CommRecordTypeID='';
        //Assigning Record Types
        for(RecordType rec:[select id,Name from RecordType where sObjectType ='Opportunity']){
            if(rec.Name.indexOf('Commercial')>=0)
                CommRecordTypeID = rec.ID;
            else if(rec.Name.indexOf('Home Owner')>=0)
                ResiRecordTypeID = rec.ID;          
        }
        List<Opportunity> oppList = new List<Opportunity>(); 
        //Residential Checking
        Opportunity opp1 = new Opportunity(name = namePrefix + 'Test1',StageName='10% - Qualified Opportunity',RecordTypeID = ResiRecordTypeID,CloseDate=Date.Today());
        opp1.Probability = 10;
        oppList.add(opp1);
        Opportunity opp2 = new Opportunity(name = namePrefix + 'Test2',StageName='30% - Opportunity Contacted',RecordTypeID = ResiRecordTypeID,CloseDate=Date.Today());
        opp2.Probability = 30;
        oppList.add(opp2);
        Opportunity opp3 = new Opportunity(name = namePrefix + 'Test3',StageName='60% - Visit Completed',RecordTypeID = ResiRecordTypeID,CloseDate=Date.Today());
        opp3.Probability = 60;
        oppList.add(opp3);
        Opportunity opp4 = new Opportunity(name = namePrefix + 'Test4',StageName='100% - Won',RecordTypeID = ResiRecordTypeID,CloseDate=Date.Today());
        opp4.Reason_Won_Lost__c = 'No Response';
        opp4.Probability = 100;
        oppList.add(opp4);
        Opportunity opp5 = new Opportunity(name = namePrefix + 'Test5',StageName='0% - Lost',RecordTypeID = ResiRecordTypeID,CloseDate=Date.Today());
        opp5.Probability = 0;
        opp5.Reason_Won_Lost__c = 'Test Lost Opp';
        oppList.add(opp5);
        Opportunity opp6 = new Opportunity(name = namePrefix + 'Test6',StageName='Future Follow-up',RecordTypeID = ResiRecordTypeID,CloseDate=Date.Today());
        opp6.Probability = 10;
        oppList.add(opp6);
        //Commercial Checking
        Opportunity opp7 = new Opportunity(name = namePrefix + 'Test7',StageName='12% - Qualified Opportunity',RecordTypeID = CommRecordTypeID,CloseDate=Date.Today());
        opp7.Probability = 12;
        oppList.add(opp7);
        Opportunity opp8 = new Opportunity(name = namePrefix + 'Test8',StageName='20% Opportunity Contacted',RecordTypeID = CommRecordTypeID,CloseDate=Date.Today());
        opp8.Probability = 20;
        oppList.add(opp8);
        Opportunity opp9 = new Opportunity(name = namePrefix + 'Test9',StageName='25% - Site Audit Completed',RecordTypeID = CommRecordTypeID,CloseDate=Date.Today());
        opp9.Probability = 25;
        oppList.add(opp9);
        Opportunity opp10 = new Opportunity(name = namePrefix + 'Test10',StageName='50% - Layout Approved & BOM Generated',RecordTypeID = CommRecordTypeID,CloseDate=Date.Today());
        opp10.Probability = 50;
        oppList.add(opp10);
        Opportunity opp11 = new Opportunity(name = namePrefix + 'Test11',StageName='60% - Financing in Place',RecordTypeID = CommRecordTypeID,CloseDate=Date.Today());
        opp11.Probability = 60;
        oppList.add(opp11);
        Opportunity opp12 = new Opportunity(name = namePrefix + 'Test12',StageName='65% - Rebate Reservation Applied',RecordTypeID = CommRecordTypeID,CloseDate=Date.Today());
        opp12.Probability = 65;
        oppList.add(opp12);
        Opportunity opp13 = new Opportunity(name = namePrefix + 'Test13',StageName='70% - Rebate Reservation Granted',RecordTypeID = CommRecordTypeID,CloseDate=Date.Today());
        opp13.Probability = 70;
        oppList.add(opp13);
        Opportunity opp14 = new Opportunity(name = namePrefix + 'Test14',StageName='75% - Customer Contract in place',RecordTypeID = CommRecordTypeID,CloseDate=Date.Today());
        opp14.Probability = 75;
        oppList.add(opp14);
        Opportunity opp15 = new Opportunity(name = namePrefix + 'Test15',StageName='85% - Verbal commitment of imminent PO',RecordTypeID = CommRecordTypeID,CloseDate=Date.Today());
        opp15.Probability = 85;
        oppList.add(opp15);
        Opportunity opp16 = new Opportunity(name = namePrefix + 'Test16',StageName='95% - PO Submitted',RecordTypeID = CommRecordTypeID,CloseDate=Date.Today());
        opp16.Probability = 95;
        oppList.add(opp16);
        Opportunity opp17 = new Opportunity(name = namePrefix + 'Test17',StageName='100% - Won',RecordTypeID = CommRecordTypeID,CloseDate=Date.Today());
        opp17.Reason_Won_Lost__c = 'No Response';
        opp17.Probability = 100;
        oppList.add(opp17);
        Opportunity opp18 = new Opportunity(name = namePrefix + 'Test18',StageName='0% - Lost',RecordTypeID = CommRecordTypeID,CloseDate=Date.Today());
        opp18.Probability = 0;
        opp18.Reason_Won_Lost__c = 'Test Lost';
        oppList.add(opp18);
        Opportunity opp19 = new Opportunity(name = namePrefix + 'Test19',StageName='Future Follow-up',RecordTypeID = CommRecordTypeID,CloseDate=Date.Today());
        opp19.Probability =10;
        oppList.add(opp19);
        
        insert  oppList;
        /*System.debug('::::::::::::::::::START: Here the Results for Testing Starts for Opportunity Management:::::::::::::::::::::');
        for(Opportunity Opp: oppList){
            System.debug('Record Type::'+opp.RecordTypeId+'\tID::'+opp.ID+'\tStage::'+opp.StageName+'\tStatus::'+opp.Opportunity_Status__c+'\tContact Date::'+opp.Opportunity_Contacted_Date__c+'\tVisited Date::'+opp.Visit_Completed_Date__c+'\tFollow Up Date::'+opp.Future_Follow_up_Date__c);      
        }
        System.debug('::::::::::::::::::END: Here the Results for Testing Starts for Opportunity Management:::::::::::::::::::::');
        */
    }


}//class ends