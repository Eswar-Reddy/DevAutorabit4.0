@isTest
private class TestAssignPartner  {
    static testMethod void Test_AssignPartner (){
    
    
    SFDCSpecialUtilities.isRunningTest = True; 
    
    Map<String,Id> accRTs = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Account.SObjectType); //Get Account RecordTypes
    Map<String,Id> leadRTs = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Lead.SObjectType); //Get Lead RecordTypes
    Map<String,Id> cmpRTs = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Campaign.SObjectType); //Get Campaign RecordTypes
    
    String recType2 = accRTs.get('Home_Owner');
    Id recordResidentId = leadRTs.get('Residential');
    Id recordPartnerId = accRTs.get('Partner');
    String recCampA =  cmpRTs.get('Alliance');
    String recCampS =  cmpRTs.get('Standard');
    
    LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];     
    List<Lead> insertLead = new List<Lead>();
 
    Lead l= new Lead();
     l.Status='new';
     l.LeadSource='Affilate';
     l.Street ='Adriatic Way';
     l.City='Santa Clara'; 
     l.State='CA';
     l.PostalCode='95051';
     l.Country='United States';
     l.Phone='1234567895'; 
     l.LastName = 'Test1';
     l.Email='a@gmail.com';
     l.Lead_Manufacturer__c='SunPower';
     l.recordtypeid=recordResidentId;
     l.Company='ABC';
     l.Theater__c = 'Europe';
     insert l;
        
     Database.LeadConvert lc = new database.LeadConvert();
        test.startTest();
     lc.setLeadId(l.id);
     system.debug('>>>>>>>abhi'+lc);
     lc.setConvertedStatus(convertStatus.MasterLabel); 
     
     //Database.LeadConvertResult lcr = Database.convertLead(lc);
     //system.debug('>>>>>>>lcr>>>'+lcr);
     test.stopTest();
  }
   static testMethod void Test_AutoOpportunityRoute1 (){
  
   
    // put test setup code in here

        //Account RecordType
        
        SFDCSpecialUtilities.isRunningTest = True; 
        
        Map<String,Id> accRTs = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Account.SObjectType); //Get Account RecordTypes
        Map<String,Id> leadRTs = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Lead.SObjectType); //Get Lead RecordTypes
        Map<String,Id> cmpRTs = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Campaign.SObjectType); //Get Campaign RecordTypes
        Map<String,Id> oppRTs = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Opportunity.SObjectType); //Get Opportunity RecordTypes
        
        //Account RecordType
        String recType1 = accRTs.get('Partner');
        String recType2 = accRTs.get('Home_Owner');
        //Campaign RecordtType
        String recCampA =  cmpRTs.get('Alliance');
        String recCampS =  cmpRTs.get('Standard');
        //Opportunity RecordType
        String recOpp =  oppRTs.get('Home_Owner');
        List<Account> objAccList = new List<Account>();
        // Residencial customer EU
        for(integer a=0; a<1; a++)
        {
        Account objC = new Account();
        objC.recordtypeId=recType2;
        objC.Geo__Latitude__s=37.349462;
        objC.Geo__Longitude__s=-121.9985126;
        objC.BillingStreet='Adriatic Way';
        objC.BillingCity='Santa Clara';
        objC.BillingPostalCode='95051';
        objC.BillingCountry='United States';
        objC.Phone='1234567895';
        //objC.Type='Elite-Partner-Combo';
        //objC.IsPortalEnabled = true;
            if(a==0)
            {
                objC.BillingState=null;
                objC.Name = 'test11';
                objC.Theater__c ='North America';
            }
           /*  else if(a==1)
            {
                objC.BillingState='CA';
                objC.Name = 'test12';
                objC.Theater__c ='North America';
            } */
            objAccList.add(objC);
        }
        if(objAccList.size()>0)
        {
            insert objAccList;
        }
        
        test.startTest();
        
        // Campaign Alliance
        
        Campaign  objalliance =  new Campaign(Name='TestAllianceCampNA',recordtypeId=recCampA ,IsActive=true,AssignRandomPartner__c=true);
        insert objalliance;
        
        
        Campaign  objalliancelead =  new Campaign(Name='TestAllianceCampNA',recordtypeId=recCampA ,IsActive=true,AssignRandomPartner__c=true);
        insert objalliancelead;
        //objalliance.AssignRandomPartner__c=true;
       // update objalliance;
        
         Campaign  objcamp =  new Campaign(Name='TestCampNA',recordtypeId=recCampS ,IsActive=true,AssignRandomPartner__c=true);
        insert objcamp ;
       // objcamp.AssignRandomPartner__c=true;
       // update objcamp ;
         Profile lstProfile = [select Id from Profile where Name = 'Partner Executive' limit 1];
        //user
         user thisUser1 = [ select Id from User where isactive=true AND ProfileId=:lstProfile.Id limit 1];
        
        //Partner Account
         List<Account> insertAcc = new List<Account>();
         for(integer i=0; i<5; i++){
            Account objp = new Account();
            objp.Name = 'test114' + i;
            objp.recordtypeId=recType1;
            objp.Geo__Latitude__s=37.349462;
            objp.Geo__Longitude__s=-121.9985126;
            objp.BillingStreet='Adriatic Way';
            objp.BillingCity='Santa Clara';
            objp.BillingState='CA';
            objp.BillingPostalCode='95051';
            objp.BillingCountry='United States';
            objp.Theater__c ='North America';
            objp.Phone='1234567895';
            objp.Type='ELITE-Partner-Combo';
            objp.Opportunity_Close__c=1;
            objp.Partner_Class__c='Develop';
            objp.Status__c='Active';
           // objp.Opportunity_Recipient__c = thisUser1.id;
            //objp.Owner.IsActive = true;
            
            insertAcc.add(objp);
         }
         if(insertAcc.size()>0)
         {
              Insert insertAcc;
         }
       
        // create Contact for every Account
        //user thisUser = [ select Id,isactive from User where Id = :UserInfo.getUserId() AND isactive=true];
        List<AccountContactRole> accCon = new List<AccountContactRole>();
        for(integer i=0;i<insertAcc.size();i++){
            Contact cont = new Contact(LastName ='abhi'+i,Partner_Portal_User__c=thisUser1.id , AccountId=insertAcc[i].id);
            cont.Email = System.now().getTime()+i+'te@test.com';
            cont.Phone = '999-888-6677';
            cont.MailingCity = 'San Francisco';
            cont.MailingStreet = '100 Spear St';
            cont.MailingCountry = 'USA';
            cont.MailingState='CA';
            cont.MailingPostalCode ='94105';
             insert Cont;
             //AccountContactrole
              AccountContactRole accConRole = new AccountContactRole(AccountId=insertAcc[i].id,ContactId=cont.id,Role='Opportunity Recipient');
              accCon.add(accConRole);
              
        }
        if(accCon.size()>0)
        {
            insert accCon;
        }
       
        // Campaing Partner
        Campaign_Partner__c objAllianePartner = new Campaign_Partner__c(Name='test1',Campaign__c=objalliance.Id, Partner__c=insertAcc[0].Id, Enabled__c=true);
        insert objAllianePartner;
        
        Campaign_Partner__c objAllianePartner1 = new Campaign_Partner__c(Name='test11',Campaign__c=objalliance.Id, Partner__c=insertAcc[1].Id, Enabled__c=true);
        insert objAllianePartner1;
        
        
        Campaign_Partner__c objAllianePartner2 = new Campaign_Partner__c(Name='test1',Campaign__c=objalliance.Id, Partner__c=insertAcc[2].Id, Enabled__c=true);
        insert objAllianePartner2;
        
        Campaign_Partner__c objAllianePartner3 = new Campaign_Partner__c(Name='test11',Campaign__c=objcamp.Id, Partner__c=insertAcc[0].Id, Enabled__c=true);
        insert objAllianePartner3;
        
        
        Campaign_Partner__c objAllianePartner4 = new Campaign_Partner__c(Name='test112',Campaign__c=objcamp.Id, Partner__c=insertAcc[1].Id, Enabled__c=true);
        insert objAllianePartner4;
        
        Campaign_Partner__c objAllianePartner5 = new Campaign_Partner__c(Name='test113',Campaign__c=objcamp.Id, Partner__c=insertAcc[2].Id, Enabled__c=true);
        insert objAllianePartner5;
        //Alr metadata
        List<ALR_Metadata__c> insertAlr = new List<ALR_Metadata__c>();
        for(integer i=0; i<1; i++)
        {
        ALR_Metadata__c objAlrMetaEU = new ALR_Metadata__c();
        objAlrMetaEU.Precedence1__c='Alliance Lead Random';
        objAlrMetaEU.Precedence2__c='Campaign Lead Random';
        objAlrMetaEU.Precedence3__c='Campaign Lead';
        objAlrMetaEU.Precedence4__c='Alliance Lead';
        objAlrMetaEU.Precedence5__c='Alliance Lead by Distance';
        objAlrMetaEU.Precedence6__c='Exclusivity';
        objAlrMetaEU.Precedence7__c='Distance';
        
        objAlrMetaEU.Distance_Radius__c=4000.000;
        objAlrMetaEU.Country__c='United States';
        objAlrMetaEU.Type__c = 'Home Owner';
       
                objAlrMetaEU.State__c = null;
                objAlrMetaEU.Theatre__c='North America';
                objAlrMetaEU.Distance_Unit__c='mi';
        
            /*if(i==0)
            {
                objAlrMetaEU.Precedence3__c='Exclusivity';
                objAlrMetaEU.State__c = null;
                objAlrMetaEU.Theatre__c='Europe';
                objAlrMetaEU.Distance_Unit__c='km';
            }*/
           /*  else if(i==1)
            {
                objAlrMetaEU.Precedence3__c='Dealer Locator';
                objAlrMetaEU.State__c = null;
                objAlrMetaEU.Theatre__c='North America';
                objAlrMetaEU.Distance_Unit__c='km';
            } */
             insertAlr.add(objAlrMetaEU);
        }
        if(insertAlr.size()>0)
        {
            insert insertAlr; 
        }
       
        //Exclusivity
         Exclusive_Zip_codes__c objZipCode = new Exclusive_Zip_codes__c();
         objZipCode.Partner__c =insertAcc[0].Id;
         objZipCode.Country__c = 'United States';
         objZipCode.Zip_code__c = '95051';
         insert objZipCode;
        
         PartnerTier__c Ptier = new PartnerTier__c();
         Ptier.Name = 'lower';
         Ptier.Tier1__c = 'Elite';
         Ptier.Tier2__c = 'Premier'; 
         Ptier.Tier3__c = 'Authorized';
         insert Ptier;
         
       
     
       // opportunity
        Date dt = Date.today();
        List<Opportunity> insertOpp = new List<Opportunity>();
        List<Opportunity> insertOpp1 = new List<Opportunity>();
        for(integer i=0;i<5;i++)
        {
        Opportunity objOpp = new Opportunity();
        objOpp.Name='test1';
        objOpp.recordtypeId=recOpp;
        objOpp.CloseDate=dt;
        objOpp.StageName='New Opportunity';
        objOpp.AccountId=objAccList[0].Id; 
        objOpp.Partner_Account_Id__c = insertAcc[0].id;
        //objOpp.OwnerId = objUser.id;
            if(i==0)
            {
                 
                objOpp.CampaignId=objalliance.Id;
                 
            }
            else if(i==1)
            {
                
                objOpp.CampaignId=objcamp.Id;
            }
            else if(i==2)
            {
                objOpp.Dealer_Selection__c=insertAcc[0].id;
            }
            else if(i==3)
            {
                objOpp.CampaignId=objalliancelead.id;
            }
            else if(i==4)
            {
                objOpp.CampaignId=null;
            }
            insertOpp.add(objOpp);
        } 
        if(insertOpp.size() > 0){
          insert insertOpp;
        }
        //call Method
        for(integer i=0; i<insertOpp.size(); i++)
        {
            
          AutoOpportunityRoute.Checkprecedence(insertOpp[i].id);   
        }
        test.stopTest();
       
  } 
  
   static testMethod void Test_AutoOpportunityRoute12 (){
  
    
    // put test setup code in here
        SFDCSpecialUtilities.isRunningTest = True; 
        
        Map<String,Id> accRTs = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Account.SObjectType); //Get Account RecordTypes
        Map<String,Id> leadRTs = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Lead.SObjectType); //Get Lead RecordTypes
        Map<String,Id> cmpRTs = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Campaign.SObjectType); //Get Campaign RecordTypes
        Map<String,Id> oppRTs = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Opportunity.SObjectType); //Get Opportunity RecordTypes
        
        //Account RecordType
        String recType1 = accRTs.get('Partner');
        String recType2 = accRTs.get('Home_Owner');
        //Campaign RecordtType
        String recCampA =  cmpRTs.get('Alliance');
        String recCampS =  cmpRTs.get('Standard');
        //Opportunity RecordType
        String recOpp =  oppRTs.get('Home_Owner');
        
        List<Account> objAccList = new List<Account>();
        // Residencial customer EU
        for(integer a=0; a<1; a++)
        {
        Account objC = new Account();
        objC.recordtypeId=recType2;
        objC.Geo__Latitude__s=37.349462;
        objC.Geo__Longitude__s=-121.9985126;
        objC.BillingStreet='Adriatic Way';
        objC.BillingCity='Santa Clara';
        objC.BillingPostalCode='95051';
        objC.BillingCountry='United States';
        objC.Phone='1234567895';
        //objC.Type='Elite-Partner-Combo';
        //objC.IsPortalEnabled = true;
            if(a==0)
            {
                objC.BillingState=null;
                objC.Name = 'test11';
                objC.Theater__c ='North America';
            }
           /*  else if(a==1)
            {
                objC.BillingState='CA';
                objC.Name = 'test12';
                objC.Theater__c ='North America';
            } */
            objAccList.add(objC);
        }
        if(objAccList.size()>0)
        {
            insert objAccList;
        }
        
        test.startTest();
        
        // Campaign Alliance
        
        Campaign  objalliance =  new Campaign(Name='TestAllianceCampNA',recordtypeId=recCampA ,IsActive=true,AssignRandomPartner__c=false);
        insert objalliance;
        //objalliance.AssignRandomPartner__c=true;
       // update objalliance;
        
         Campaign  objcamp =  new Campaign(Name='TestCampNA',recordtypeId=recCampS ,IsActive=true,AssignRandomPartner__c=false);
        insert objcamp ;
       // objcamp.AssignRandomPartner__c=true;
       // update objcamp ;
        //user
          user thisUser2 = [ select Id from User where Id = :UserInfo.getUserId() AND isactive=true];
        //Partner Account
         List<Account> insertAcc = new List<Account>();
         for(integer i=0; i<5; i++){
            Account objp = new Account();
            objp.Name = 'test114' + i;
            objp.recordtypeId=recType1;
            objp.Geo__Latitude__s=37.349462;
            objp.Geo__Longitude__s=-121.9985126;
            objp.BillingStreet='Adriatic Way';
            objp.BillingCity='Santa Clara';
            objp.BillingState='CA';
            objp.BillingPostalCode='95051';
            objp.BillingCountry='United States';
            objp.Theater__c ='North America';
            objp.Phone='1234567895';
            objp.Type='Premier-Partner-Combo';
            objp.Opportunity_Close__c=1;
            objp.Partner_Class__c='Develop';
            objp.Status__c='Active';
            objp.Opportunity_Recipient__c = thisUser2.id;
          
            insertAcc.add(objp);
         }
         if(insertAcc.size()>0)
         {
              Insert insertAcc;
         }
       List<AccountContactRole> accCon = new List<AccountContactRole>();
        // create Contact for every Account
        user thisUser = [ select Id from User where Id = :UserInfo.getUserId() AND isactive=true];
        for(integer i=0;i<insertAcc.size();i++){
            Contact cont = new Contact(LastName ='abhi'+i,Partner_Portal_User__c=thisUser.id , AccountId=insertAcc[i].id);
            cont.Email = System.now().getTime()+i+'te@test.com';
            cont.Phone = '999-888-6677';
            cont.MailingCity = 'San Francisco';
            cont.MailingStreet = '100 Spear St';
            cont.MailingCountry = 'USA';
            cont.MailingState='CA';
            cont.MailingPostalCode ='94105';
             insert Cont;
             //AccountContactrole
              AccountContactRole accConRole = new AccountContactRole(AccountId=insertAcc[i].id,ContactId=cont.id,Role='Opportunity Recipient');
              accCon.add(accConRole);
             
        }
        if(accCon.size()>0)
        {
            insert accCon;
        }
       
        //Profile
        
        
        // Campaing Partner
        Campaign_Partner__c objAllianePartner = new Campaign_Partner__c(Name='test1',Campaign__c=objalliance.Id, Partner__c=insertAcc[0].Id, Enabled__c=true);
        insert objAllianePartner;
        
        Campaign_Partner__c objAllianePartner1 = new Campaign_Partner__c(Name='test11',Campaign__c=objalliance.Id, Partner__c=insertAcc[1].Id, Enabled__c=true);
        insert objAllianePartner1;
        
        
        Campaign_Partner__c objAllianePartner2 = new Campaign_Partner__c(Name='test1',Campaign__c=objalliance.Id, Partner__c=insertAcc[2].Id, Enabled__c=true);
        insert objAllianePartner2;
        
        Campaign_Partner__c objAllianePartner3 = new Campaign_Partner__c(Name='test11',Campaign__c=objcamp.Id, Partner__c=insertAcc[0].Id, Enabled__c=true);
        insert objAllianePartner3;
        
        
        Campaign_Partner__c objAllianePartner4 = new Campaign_Partner__c(Name='test112',Campaign__c=objcamp.Id, Partner__c=insertAcc[1].Id, Enabled__c=true);
        insert objAllianePartner4;
        
        Campaign_Partner__c objAllianePartner5 = new Campaign_Partner__c(Name='test113',Campaign__c=objcamp.Id, Partner__c=insertAcc[2].Id, Enabled__c=true);
        insert objAllianePartner5;
        //Alr metadata
        List<ALR_Metadata__c> insertAlr = new List<ALR_Metadata__c>();
        for(integer i=0; i<1; i++)
        {
        ALR_Metadata__c objAlrMetaEU = new ALR_Metadata__c();
        objAlrMetaEU.Precedence1__c='Alliance Lead Random';
        objAlrMetaEU.Precedence2__c='Campaign Lead Random';
        objAlrMetaEU.Precedence3__c='Campaign Lead';
        objAlrMetaEU.Precedence4__c='Alliance Lead';
        objAlrMetaEU.Precedence5__c='Alliance Lead by Distance';
        objAlrMetaEU.Precedence6__c='Dealer Locator';
        objAlrMetaEU.Precedence7__c='Distance';
        
        objAlrMetaEU.Distance_Radius__c=4000.000;
        objAlrMetaEU.Country__c='United States';
        objAlrMetaEU.Type__c = 'Home Owner';
       
                objAlrMetaEU.State__c = null;
                objAlrMetaEU.Theatre__c='North America';
                objAlrMetaEU.Distance_Unit__c='mi';
        
            /*if(i==0)
            {
                objAlrMetaEU.Precedence3__c='Exclusivity';
                objAlrMetaEU.State__c = null;
                objAlrMetaEU.Theatre__c='Europe';
                objAlrMetaEU.Distance_Unit__c='km';
            }*/
           /*  else if(i==1)
            {
                objAlrMetaEU.Precedence3__c='Dealer Locator';
                objAlrMetaEU.State__c = null;
                objAlrMetaEU.Theatre__c='North America';
                objAlrMetaEU.Distance_Unit__c='km';
            } */
             insertAlr.add(objAlrMetaEU);
        }
        if(insertAlr.size()>0)
        {
            insert insertAlr; 
        }
       
        //Exclusivity
         Exclusive_Zip_codes__c objZipCode = new Exclusive_Zip_codes__c();
         objZipCode.Partner__c =insertAcc[0].Id;
         objZipCode.Country__c = 'United States';
         objZipCode.Zip_code__c = '95051';
         insert objZipCode;
        
         PartnerTier__c Ptier = new PartnerTier__c();
         Ptier.Name = 'lower';
         Ptier.Tier1__c = 'Elite';
         Ptier.Tier2__c = 'Premier'; 
         Ptier.Tier3__c = 'Authorized';
         insert Ptier;
       
     
       // opportunity
        Date dt = Date.today();
        List<Opportunity> insertOpp = new List<Opportunity>();
        List<Opportunity> insertOpp1 = new List<Opportunity>();
        for(integer i=0;i<5;i++)
        {
        Opportunity objOpp = new Opportunity();
        objOpp.Name='test1';
        objOpp.recordtypeId=recOpp;
        objOpp.CloseDate=dt;
        objOpp.StageName='New Opportunity';
        objOpp.AccountId=objAccList[0].Id; 
        //objOpp.OwnerId = objUser.id;
            if(i==0)
            {
                 
                objOpp.CampaignId=objalliance.Id;
                 
            }
            else if(i==1)
            {
                
                objOpp.CampaignId=objcamp.Id;
            }
            else if(i==2)
            {
                objOpp.Dealer_Selection__c=insertAcc[0].id;
            }
            else if(i==3)
            {
                objOpp.CampaignId=null;
            }
            else if(i==4)
            {
                objOpp.CampaignId=null;
            }
            insertOpp.add(objOpp);
        } 
        if(insertOpp.size() > 0){
          insert insertOpp;
        }
        //call Method
        for(integer i=0; i<insertOpp.size(); i++)
        {
            
          AutoOpportunityRoute.Checkprecedence(insertOpp[i].id);   
        }
        test.stopTest();
  } 
  
   static testMethod void Test_AutoOpportunityRoute22 (){
     
   
    // put test setup code in here

        //Account RecordType
        String recType1 = [SELECT id FROM recordtype WHERE name='Partner' and Sobjecttype = 'Account' limit 1].id;
        String recType2 = [SELECT id FROM recordtype WHERE name='Residential Customer' and Sobjecttype = 'Account' limit 1].id;
        //Campaign RecordtType
        String recCampA =  [SELECT id FROM recordtype WHERE name='Alliance' and Sobjecttype = 'Campaign' limit 1].id;
        String recCampS =  [SELECT id FROM recordtype WHERE name='Standard' and Sobjecttype = 'Campaign' limit 1].id;
        //Opportunity RecordType
        String recOpp =  [SELECT id FROM recordtype WHERE name='Home Owner' and Sobjecttype = 'Opportunity' limit 1].id;
        List<Account> objAccList = new List<Account>();
        // Residencial customer EU
        for(integer a=0; a<1; a++)
        {
        Account objC = new Account();
        objC.recordtypeId=recType2;
        objC.Geo__Latitude__s=41.9294861;
        objC.Geo__Longitude__s=12.4656169;
        objC.BillingStreet='Largo Girolamo Rainaldi';
        objC.BillingCity='Roma';
        objC.BillingPostalCode='00196';
        objC.BillingCountry='Italy';
        objC.Phone='1234567895';
            if(a==0)
            {
                objC.BillingState=null;
                objC.Name = 'test11';
                objC.Theater__c ='Europe';
            }
            objAccList.add(objC);
        }
        if(objAccList.size()>0)
        {
            insert objAccList;
        }
        
        test.startTest();
        
        // Campaign Alliance
        
        Campaign  objalliance =  new Campaign(Name='TestAllianceCampNA',recordtypeId=recCampA ,IsActive=true,AssignRandomPartner__c=false);
        insert objalliance;
        //objalliance.AssignRandomPartner__c=true;
       // update objalliance;
        
         Campaign  objcamp =  new Campaign(Name='TestCampNA',recordtypeId=recCampS ,IsActive=true,AssignRandomPartner__c=false);
        insert objcamp ;
       // objcamp.AssignRandomPartner__c=true;
       // update objcamp ;
        //user
          user thisUser2 = [ select Id from User where Id = :UserInfo.getUserId() AND isactive=true];
        //Partner Account
         List<Account> insertAcc = new List<Account>();
         for(integer i=0; i<5; i++){
            Account objp = new Account();
            objp.Name = 'test114' + i;
            objp.recordtypeId=recType1;
            objp.Geo__Latitude__s=41.9294861;
            objp.Geo__Longitude__s=12.4656169;
            objp.BillingStreet='Largo Girolamo Rainaldi';
            objp.BillingCity='Roma';
            objp.BillingState='Roma';
            objp.BillingPostalCode='00196';
            objp.BillingCountry='Italy';
            objp.Theater__c ='Europe';
            objp.Phone='1234567895';
            objp.Type='Premier-Partner-Combo';
            objp.Opportunity_Close__c=1;
             objp.Status__c='Active';
            if(i==0 && i==1)
            objp.Partner_Class__c='Develop';
            if(i==2)
            objp.Partner_Class__c='Retain';
            if(i==3)
            objp.Partner_Class__c='Acquire';
            if(i==4)
            objp.Partner_Class__c='Terminate';
  
            insertAcc.add(objp);
         }
         if(insertAcc.size()>0)
         {
              Insert insertAcc;
         }
        List<AccountContactRole> accCon = new List<AccountContactRole>();
        // create Contact for every Account
        user thisUser = [ select Id from User where Id = :UserInfo.getUserId() AND isactive=true];
        for(integer i=0;i<insertAcc.size();i++){
            Contact cont = new Contact(LastName ='abhi'+i,Partner_Portal_User__c=thisUser.id , AccountId=insertAcc[i].id);
            cont.Email = System.now().getTime()+i+'te@test.com';
            cont.Phone = '999-888-6677';
            cont.MailingCity = 'San Francisco';
            cont.MailingStreet = '100 Spear St';
            cont.MailingCountry = 'USA';
            cont.MailingState='CA';
            cont.MailingPostalCode ='94105';
             insert Cont;
             //AccountContactrole
              AccountContactRole accConRole = new AccountContactRole(AccountId=insertAcc[i].id,ContactId=cont.id,Role='Opportunity Recipient');
              accCon.add(accConRole);
              
        }
        if(accCon.size()>0)
        {
            insert accCon;
        }
       
        //Profile
        
        
        // Campaing Partner
        Campaign_Partner__c objAllianePartner = new Campaign_Partner__c(Name='test1',Campaign__c=objalliance.Id, Partner__c=insertAcc[0].Id, Enabled__c=true);
        insert objAllianePartner;
        
        Campaign_Partner__c objAllianePartner1 = new Campaign_Partner__c(Name='test11',Campaign__c=objalliance.Id, Partner__c=insertAcc[1].Id, Enabled__c=true);
        insert objAllianePartner1;
        
        
        Campaign_Partner__c objAllianePartner2 = new Campaign_Partner__c(Name='test1',Campaign__c=objalliance.Id, Partner__c=insertAcc[2].Id, Enabled__c=true);
        insert objAllianePartner2;
        
        Campaign_Partner__c objAllianePartner3 = new Campaign_Partner__c(Name='test11',Campaign__c=objcamp.Id, Partner__c=insertAcc[0].Id, Enabled__c=true);
        insert objAllianePartner3;
        
        
        Campaign_Partner__c objAllianePartner4 = new Campaign_Partner__c(Name='test112',Campaign__c=objcamp.Id, Partner__c=insertAcc[1].Id, Enabled__c=true);
        insert objAllianePartner4;
        
        Campaign_Partner__c objAllianePartner5 = new Campaign_Partner__c(Name='test113',Campaign__c=objcamp.Id, Partner__c=insertAcc[2].Id, Enabled__c=true);
        insert objAllianePartner5;
        //Alr metadata
        List<ALR_Metadata__c> insertAlr = new List<ALR_Metadata__c>();
        for(integer i=0; i<1; i++)
        {
        ALR_Metadata__c objAlrMetaEU = new ALR_Metadata__c();
        objAlrMetaEU.Precedence1__c='Alliance Lead Random';
        objAlrMetaEU.Precedence2__c='Campaign Lead Random';
        objAlrMetaEU.Precedence3__c='Campaign Lead';
        objAlrMetaEU.Precedence4__c='Alliance Lead';
        objAlrMetaEU.Precedence5__c='Exclusivity';
        objAlrMetaEU.Precedence6__c='Alliance Lead by Distance';
        objAlrMetaEU.Precedence7__c='Distance';
        
        objAlrMetaEU.Distance_Radius__c=4000.000;
        objAlrMetaEU.Country__c='Italy';
        objAlrMetaEU.Type__c = 'Home Owner';
       
                objAlrMetaEU.State__c = null;
                objAlrMetaEU.Theatre__c='Europe';
                objAlrMetaEU.Distance_Unit__c='mi';
        
            if(i==0)
            {
                objAlrMetaEU.State__c = null;
                objAlrMetaEU.Theatre__c='Europe';
                objAlrMetaEU.Distance_Unit__c='km';
            }
           /*  else if(i==1)
            {
                objAlrMetaEU.Precedence3__c='Dealer Locator';
                objAlrMetaEU.State__c = null;
                objAlrMetaEU.Theatre__c='North America';
                objAlrMetaEU.Distance_Unit__c='km';
            } */
             insertAlr.add(objAlrMetaEU);
        }
        if(insertAlr.size()>0)
        {
            insert insertAlr; 
        }
       
        //Exclusivity
         Exclusive_Zip_codes__c objZipCode = new Exclusive_Zip_codes__c();
         objZipCode.Partner__c =insertAcc[0].Id;
         objZipCode.Country__c = 'Italy';
         objZipCode.Zip_code__c = '00196';
         insert objZipCode;
        
         PartnerTier__c Ptier = new PartnerTier__c();
         Ptier.Name = 'lower';
         Ptier.Tier1__c = 'Elite';
         Ptier.Tier2__c = 'Premier'; 
         Ptier.Tier3__c = 'Authorized';
         insert Ptier;
       
     
       // opportunity
        Date dt = Date.today();
        List<Opportunity> insertOpp = new List<Opportunity>();
        List<Opportunity> insertOpp1 = new List<Opportunity>();
        for(integer i=0;i<5;i++)
        {
        Opportunity objOpp = new Opportunity();
        objOpp.Name='test1';
        objOpp.recordtypeId=recOpp;
        objOpp.CloseDate=dt;
        objOpp.StageName='New Opportunity';
        objOpp.AccountId=objAccList[0].Id; 
        //objOpp.OwnerId = objUser.id;
            if(i==0)
            {
                 
                objOpp.CampaignId=objalliance.Id;
                 
            }
            else if(i==1)
            {
                
                objOpp.CampaignId=objcamp.Id;
            }
            else if(i==2)
            {
                objOpp.Dealer_Selection__c=insertAcc[0].id;
            }
            else if(i==3)
            {
                objOpp.CampaignId=null;
            }
            else if(i==4)
            {
                objOpp.CampaignId=null;
            }
            insertOpp.add(objOpp);
        } 
        if(insertOpp.size() > 0){
          insert insertOpp;
        }
        //call Method
        for(integer i=0; i<insertOpp.size(); i++)
        {
            
          AutoOpportunityRoute.Checkprecedence(insertOpp[i].id);   
        }
        test.stopTest();
  } 
  
  
  static testMethod void Test_AutoOpportunityRoute123 (){
     test.startTest();
   
    // put test setup code in here

        //Account RecordType
        String recType1 = [SELECT id FROM recordtype WHERE name='Partner' and Sobjecttype = 'Account' limit 1].id;
        String recType2 = [SELECT id FROM recordtype WHERE name='Residential Customer' and Sobjecttype = 'Account' limit 1].id;
        //Campaign RecordtType
        String recCampA =  [SELECT id FROM recordtype WHERE name='Alliance' and Sobjecttype = 'Campaign' limit 1].id;
        String recCampS =  [SELECT id FROM recordtype WHERE name='Standard' and Sobjecttype = 'Campaign' limit 1].id;
        //Opportunity RecordType
        String recOpp =  [SELECT id FROM recordtype WHERE name='Home Owner' and Sobjecttype = 'Opportunity' limit 1].id;
        List<Account> objAccList = new List<Account>();
        // Residencial customer EU
        for(integer a=0; a<1; a++)
        {
        Account objC = new Account();
        objC.recordtypeId=recType2;
        objC.Geo__Latitude__s=37.349462;
        objC.Geo__Longitude__s=-121.9985126;
        objC.BillingStreet='Adriatic Way';
        objC.BillingCity='Santa Clara';
        objC.BillingPostalCode='95051';
        objC.BillingCountry='United States';
        objC.Phone='1234567895';
        //objC.Type='Elite-Partner-Combo';
        //objC.IsPortalEnabled = true;
            if(a==0)
            {
                objC.BillingState=null;
                objC.Name = 'test11';
                objC.Theater__c ='North America';
            }
           /*  else if(a==1)
            {
                objC.BillingState='CA';
                objC.Name = 'test12';
                objC.Theater__c ='North America';
            } */
            objAccList.add(objC);
        }
        if(objAccList.size()>0)
        {
            insert objAccList;
        }
        
        // Campaign Alliance
        
        Campaign  objalliance =  new Campaign(Name='TestAllianceCampNA',recordtypeId=recCampA ,IsActive=true,AssignRandomPartner__c=false);
        insert objalliance;
        //objalliance.AssignRandomPartner__c=true;
       // update objalliance;
        
         Campaign  objcamp =  new Campaign(Name='TestCampNA',recordtypeId=recCampS ,IsActive=true,AssignRandomPartner__c=false);
        insert objcamp ;
       // objcamp.AssignRandomPartner__c=true;
       // update objcamp ;
        //user
          user thisUser2 = [ select Id from User where Id = :UserInfo.getUserId() AND isactive=true];
        //Partner Account
         List<Account> insertAcc = new List<Account>();
         for(integer i=0; i<5; i++){
            Account objp = new Account();
            objp.Name = 'test114' + i;
            objp.recordtypeId=recType1;
            objp.Geo__Latitude__s=37.349462;
            objp.Geo__Longitude__s=-121.9985126;
            objp.BillingStreet='Adriatic Way';
            objp.BillingCity='Santa Clara';
            objp.BillingState='CA';
            objp.BillingPostalCode='95051';
            objp.BillingCountry='United States';
            objp.Theater__c ='North America';
            objp.Phone='1234567895';
            objp.Type='Authorized-Partner-Combo';
            objp.Opportunity_Close__c=1;
            objp.Partner_Class__c='Aquire';
            objp.Status__c='Active';
          
            insertAcc.add(objp);
         }
         if(insertAcc.size()>0)
         {
              Insert insertAcc;
         }
       
        
        
        
        // Campaing Partner
        Campaign_Partner__c objAllianePartner = new Campaign_Partner__c(Name='test1',Campaign__c=objalliance.Id, Partner__c=insertAcc[0].Id, Enabled__c=true);
        insert objAllianePartner;
        
        Campaign_Partner__c objAllianePartner1 = new Campaign_Partner__c(Name='test11',Campaign__c=objalliance.Id, Partner__c=insertAcc[1].Id, Enabled__c=true);
        insert objAllianePartner1;
        
        
        Campaign_Partner__c objAllianePartner2 = new Campaign_Partner__c(Name='test1',Campaign__c=objalliance.Id, Partner__c=insertAcc[2].Id, Enabled__c=true);
        insert objAllianePartner2;
        
        Campaign_Partner__c objAllianePartner3 = new Campaign_Partner__c(Name='test11',Campaign__c=objcamp.Id, Partner__c=insertAcc[0].Id, Enabled__c=true);
        insert objAllianePartner3;
        
        
        Campaign_Partner__c objAllianePartner4 = new Campaign_Partner__c(Name='test112',Campaign__c=objcamp.Id, Partner__c=insertAcc[1].Id, Enabled__c=true);
        insert objAllianePartner4;
        
        Campaign_Partner__c objAllianePartner5 = new Campaign_Partner__c(Name='test113',Campaign__c=objcamp.Id, Partner__c=insertAcc[2].Id, Enabled__c=true);
        insert objAllianePartner5;
        //Alr metadata
        List<ALR_Metadata__c> insertAlr = new List<ALR_Metadata__c>();
        for(integer i=0; i<1; i++)
        {
        ALR_Metadata__c objAlrMetaEU = new ALR_Metadata__c();
        objAlrMetaEU.Precedence1__c='Alliance Lead Random';
        objAlrMetaEU.Precedence2__c='Campaign Lead Random';
        objAlrMetaEU.Precedence3__c='Campaign Lead';
        objAlrMetaEU.Precedence4__c='Alliance Lead';
        objAlrMetaEU.Precedence5__c='Dealer Locator';
        objAlrMetaEU.Precedence6__c='Distance';
        
        objAlrMetaEU.Distance_Radius__c=4000.000;
        objAlrMetaEU.Country__c='United States';
        objAlrMetaEU.Type__c = 'Home Owner';
       
                objAlrMetaEU.State__c = null;
                objAlrMetaEU.Theatre__c='North America';
                objAlrMetaEU.Distance_Unit__c='mi';
        
            /*if(i==0)
            {
                objAlrMetaEU.Precedence3__c='Exclusivity';
                objAlrMetaEU.State__c = null;
                objAlrMetaEU.Theatre__c='Europe';
                objAlrMetaEU.Distance_Unit__c='km';
            }*/
           /*  else if(i==1)
            {
                objAlrMetaEU.Precedence3__c='Dealer Locator';
                objAlrMetaEU.State__c = null;
                objAlrMetaEU.Theatre__c='North America';
                objAlrMetaEU.Distance_Unit__c='km';
            } */
             insertAlr.add(objAlrMetaEU);
        }
        if(insertAlr.size()>0)
        {
            insert insertAlr; 
        }
       
        //Exclusivity
         Exclusive_Zip_codes__c objZipCode = new Exclusive_Zip_codes__c();
         objZipCode.Partner__c =insertAcc[0].Id;
         objZipCode.Country__c = 'United States';
         objZipCode.Zip_code__c = '95051';
         insert objZipCode;
        
         PartnerTier__c Ptier = new PartnerTier__c();
         Ptier.Name = 'lower';
         Ptier.Tier1__c = 'Elite';
         Ptier.Tier2__c = 'Premier'; 
         Ptier.Tier3__c = 'Authorized';
         insert Ptier;
       
     
       // opportunity
        Date dt = Date.today();
        List<Opportunity> insertOpp = new List<Opportunity>();
        List<Opportunity> insertOpp1 = new List<Opportunity>();
        for(integer i=0;i<5;i++)
        {
        Opportunity objOpp = new Opportunity();
        objOpp.Name='test1';
        objOpp.recordtypeId=recOpp;
        objOpp.CloseDate=dt;
        objOpp.StageName='New Opportunity';
        objOpp.AccountId=objAccList[0].Id; 
        //objOpp.OwnerId = objUser.id;
            if(i==0)
            {
                 
                objOpp.CampaignId=objalliance.Id;
                 
            }
            else if(i==1)
            {
                
                objOpp.CampaignId=objcamp.Id;
            }
            else if(i==2)
            {
                objOpp.Dealer_Selection__c=insertAcc[0].id;
            }
            else if(i==3)
            {
                objOpp.CampaignId=null;
            }
            else if(i==4)
            {
                objOpp.CampaignId=null;
            }
            insertOpp.add(objOpp);
        } 
        if(insertOpp.size() > 0){
          insert insertOpp;
        }
        //call Method
        for(integer i=0; i<insertOpp.size(); i++)
        {
            
          AutoOpportunityRoute.Checkprecedence(insertOpp[i].id);   
        }
        test.stopTest();
  } 
 
 static testMethod void Test_AutoOpportunityRoute1234 (){
     test.startTest();
   
    // put test setup code in here

        //Account RecordType
        String recType1 = [SELECT id FROM recordtype WHERE name='Partner' and Sobjecttype = 'Account' limit 1].id;
        String recType2 = [SELECT id FROM recordtype WHERE name='Residential Customer' and Sobjecttype = 'Account' limit 1].id;
        //Campaign RecordtType
        String recCampA =  [SELECT id FROM recordtype WHERE name='Alliance' and Sobjecttype = 'Campaign' limit 1].id;
        String recCampS =  [SELECT id FROM recordtype WHERE name='Standard' and Sobjecttype = 'Campaign' limit 1].id;
        //Opportunity RecordType
        String recOpp =  [SELECT id FROM recordtype WHERE name='Home Owner' and Sobjecttype = 'Opportunity' limit 1].id;
        List<Account> objAccList = new List<Account>();
        // Residencial customer EU
        for(integer a=0; a<1; a++)
        {
        Account objC = new Account();
        objC.recordtypeId=recType2;
        objC.Geo__Latitude__s=37.349462;
        objC.Geo__Longitude__s=-121.9985126;
        objC.BillingStreet='Adriatic Way';
        objC.BillingCity='Santa Clara';
        objC.BillingPostalCode='95051';
        objC.BillingCountry='United States';
        objC.Phone='1234567895';
        //objC.Type='Elite-Partner-Combo';
        //objC.IsPortalEnabled = true;
            if(a==0)
            {
                objC.BillingState=null;
                objC.Name = 'test11';
                objC.Theater__c ='North America';
            }
           /*  else if(a==1)
            {
                objC.BillingState='CA';
                objC.Name = 'test12';
                objC.Theater__c ='North America';
            } */
            objAccList.add(objC);
        }
        if(objAccList.size()>0)
        {
            insert objAccList;
        }
        
        // Campaign Alliance
        
        Campaign  objalliance =  new Campaign(Name='TestAllianceCampNA',recordtypeId=recCampA ,IsActive=true,AssignRandomPartner__c=true);
        insert objalliance;
        //objalliance.AssignRandomPartner__c=true;
       // update objalliance;
        
         Campaign  objcamp =  new Campaign(Name='TestCampNA',recordtypeId=recCampS ,IsActive=true,AssignRandomPartner__c=true);
        insert objcamp ;
       // objcamp.AssignRandomPartner__c=true;
       // update objcamp ;
        //user
          user thisUser3 = [ select Id from User where Id = :UserInfo.getUserId() AND isactive=true];
        //Partner Account
         List<Account> insertAcc = new List<Account>();
         for(integer i=0; i<5; i++){
            Account objp = new Account();
            objp.Name = 'test114' + i;
            objp.recordtypeId=recType1;
            objp.Geo__Latitude__s=37.349462;
            objp.Geo__Longitude__s=-121.9985126;
            objp.BillingStreet='Adriatic Way';
            objp.BillingCity='Santa Clara';
            objp.BillingState='CA';
            objp.BillingPostalCode='95051';
            objp.BillingCountry='United States';
            objp.Theater__c ='North America';
            objp.Phone='1234567895';
            objp.Type='ELITE-Partner-Combo';
            objp.Opportunity_Close__c=1;
            objp.Partner_Class__c='Develop';
            objp.Status__c='Active';
            objp.Opportunity_Recipient__c = thisUser3.id;
            insertAcc.add(objp);
         }
         if(insertAcc.size()>0)
         {
              Insert insertAcc;
         }
       
        
        
        
        // Campaing Partner
        Campaign_Partner__c objAllianePartner = new Campaign_Partner__c(Name='test1',Campaign__c=objalliance.Id, Partner__c=insertAcc[0].Id, Enabled__c=true);
        insert objAllianePartner;
        
        Campaign_Partner__c objAllianePartner1 = new Campaign_Partner__c(Name='test11',Campaign__c=objalliance.Id, Partner__c=insertAcc[1].Id, Enabled__c=true);
        insert objAllianePartner1;
        
        
        Campaign_Partner__c objAllianePartner2 = new Campaign_Partner__c(Name='test1',Campaign__c=objalliance.Id, Partner__c=insertAcc[2].Id, Enabled__c=true);
        insert objAllianePartner2;
        
        Campaign_Partner__c objAllianePartner3 = new Campaign_Partner__c(Name='test11',Campaign__c=objcamp.Id, Partner__c=insertAcc[0].Id, Enabled__c=true);
        insert objAllianePartner3;
        
        
        Campaign_Partner__c objAllianePartner4 = new Campaign_Partner__c(Name='test112',Campaign__c=objcamp.Id, Partner__c=insertAcc[1].Id, Enabled__c=true);
        insert objAllianePartner4;
        
        Campaign_Partner__c objAllianePartner5 = new Campaign_Partner__c(Name='test113',Campaign__c=objcamp.Id, Partner__c=insertAcc[2].Id, Enabled__c=true);
        insert objAllianePartner5;
        //Alr metadata
        List<ALR_Metadata__c> insertAlr = new List<ALR_Metadata__c>();
        for(integer i=0; i<1; i++)
        {
        ALR_Metadata__c objAlrMetaEU = new ALR_Metadata__c();
        objAlrMetaEU.Precedence1__c='Alliance Lead Random';
        objAlrMetaEU.Precedence2__c='Campaign Lead Random';
        objAlrMetaEU.Precedence3__c='Campaign Lead';
        objAlrMetaEU.Precedence4__c='Alliance Lead';
        objAlrMetaEU.Precedence5__c='Dealer Locator';
        objAlrMetaEU.Precedence6__c='Distance';
        
        objAlrMetaEU.Distance_Radius__c=4000.000;
        objAlrMetaEU.Country__c='United States';
        objAlrMetaEU.Type__c = 'Home Owner';
       
                objAlrMetaEU.State__c = null;
                objAlrMetaEU.Theatre__c='North America';
                objAlrMetaEU.Distance_Unit__c='mi';
        
            /*if(i==0)
            {
                objAlrMetaEU.Precedence3__c='Exclusivity';
                objAlrMetaEU.State__c = null;
                objAlrMetaEU.Theatre__c='Europe';
                objAlrMetaEU.Distance_Unit__c='km';
            }*/
           /*  else if(i==1)
            {
                objAlrMetaEU.Precedence3__c='Dealer Locator';
                objAlrMetaEU.State__c = null;
                objAlrMetaEU.Theatre__c='North America';
                objAlrMetaEU.Distance_Unit__c='km';
            } */
             insertAlr.add(objAlrMetaEU);
        }
        if(insertAlr.size()>0)
        {
            insert insertAlr; 
        }
       
        //Exclusivity
         Exclusive_Zip_codes__c objZipCode = new Exclusive_Zip_codes__c();
         objZipCode.Partner__c =insertAcc[0].Id;
         objZipCode.Country__c = 'United States';
         objZipCode.Zip_code__c = '95051';
         insert objZipCode;
        
         PartnerTier__c Ptier = new PartnerTier__c();
         Ptier.Name = 'lower';
         Ptier.Tier1__c = 'Elite';
         Ptier.Tier2__c = 'Premier'; 
         Ptier.Tier3__c = 'Authorized';
         insert Ptier;
       
     
       // opportunity
        Date dt = Date.today();
        List<Opportunity> insertOpp = new List<Opportunity>();
        List<Opportunity> insertOpp1 = new List<Opportunity>();
        for(integer i=0;i<4;i++)
        {
        Opportunity objOpp = new Opportunity();
        objOpp.Name='test1';
        objOpp.recordtypeId=recOpp;
        objOpp.CloseDate=dt;
        objOpp.StageName='New Opportunity';
        objOpp.AccountId=objAccList[0].Id; 
        //objOpp.OwnerId = objUser.id;
            if(i==0)
            {
                 
                objOpp.CampaignId=objalliance.Id;
                 
            }
            else if(i==1)
            {
                
                objOpp.CampaignId=objcamp.Id;
            }
            else if(i==2)
            {
                objOpp.Dealer_Selection__c=insertAcc[0].id;
            }
            else if(i==3)
            {
                objOpp.CampaignId=null;
            }
           
            insertOpp.add(objOpp);
        } 
        if(insertOpp.size() > 0){
          insert insertOpp;
        }
        //call Method
        for(integer i=0; i<insertOpp.size(); i++)
        {
            
          AutoOpportunityRoute.Checkprecedence(insertOpp[i].id);   
        }
        test.stopTest();
  }  
}