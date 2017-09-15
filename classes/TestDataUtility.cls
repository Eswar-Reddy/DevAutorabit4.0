@isTest 
public class TestDataUtility {

    public static Account setUpAccount(Id RSMID , String recordTypeName, Boolean isInsert){
       //Test.StartTest();
       Account acct = new Account(Name=String.valueOf(System.now()));
       
       if(recordTypeName != null && recordTypeName != ''){
           //RecordType recType = Database.query('select id from RecordType where name like \'' + recordTypeName + '%\' and SobjectType=\'Account\'');
           
           acct.RecordTypeId = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Account.sobjectType).get('Home_Owner');
               //recType.Id;
       }
       acct.Type ='Commercial';
       acct.BillingCity = 'banga';
       acct.BillingCountry = 'France';
       acct.BillingStreet = 'btm';
       acct.BillingPostalCode = '12311';
       acct.Sic = '0111';
       acct.Theater__c = 'Europe';
       acct.Territory__c = 'France';
       acct.RSM__c = RSMID;
       acct.Lease__c = false;
       acct.Executives_view_all_Opportunities__c = true;
       acct.Allow_all_to_view_Opportunities__c = true;
       if(isInsert){
           insert acct;    
           system.assertNotEquals(acct.Id , null);
       }
       return acct;
    }
    
    public static Contact setUpContact(Id accountID, Boolean isInsert){
      // Test.StartTest();
       Contact contactObj = new Contact();
       contactObj.FirstName = 'Test' + String.valueOf(DateTime.Now()) ;
       contactObj.LastName = 'Test' + String.valueOf(DateTime.Now());
       contactObj.AccountId = accountID;
       contactObj.RecordTypeID = util.GetRecordTypeIdsByDeveloperName(Contact.SObjectType).get('Partner'); //MAM 19.MAY.2015 Get Contact Partner RecordTypeId
        
       if(isInsert){
        insert contactObj;       
        system.assertNotEquals(contactObj.Id , null);
       } 
       return contactObj;
    }
    
    public static User setUpPortalUser(String profileName , Contact cont){
        //Test.StartTest();
        User user = new User();
        List<User> userList = new List<User>([SELECT Id,LastName, FirstName, ContactId, Username, Alias, CommunityNickname, TimeZoneSidKey, EmailEncodingKey, LanguageLocaleKey, Email, LocaleSidKey, Profile.Name  from User where Profile.Name =: profileName and IsActive = true limit 1]);
        if(userList.size()>0){
          user = userList.get(0);
        }else{
          user = setUpPartnerPortalUserByContact(profileName , cont);
        } 
        // Test.stopTest();
        system.assertNotEquals(user.Id , null);
        return user;
    }
    
    public static Opportunity  setUpOpportunity(Id accountId , Date closeDate, Boolean isInsert){
        //Test.StartTest();
        Opportunity opp = new Opportunity();
        opp.AccountId = accountId;
        opp.Name = 'testOpp';
        opp.CloseDate = closeDate;
        opp.Sales_Steps__c = 'Shortlisted';
        opp.Contract_Type__c = 'Design';
        opp.Financing__c = 'PPA';
        opp.Business_Unit__c = 'Utility';
        opp.Region__c = 'New York';
        opp.StageName = 'Open';
        opp.Probability = 5;
        opp.Budgetary_Pricing_Agreed_On_Date__c = System.today();
        if(isInsert){
            insert opp;
            system.assertNotEquals(opp.Id , null);
        }
        return opp;
    }
    
    public static User setUpUserForRoleAndProfile(String roleName  , String profileName  ){
      //Test.StartTest();
      List<User> userList = new List<User>();
      userList = Database.query('select id from User where UserRole.Name LIKE \'%'+roleName+'%\' Limit 1');
      User user;
      if(userList == null || userList.size() ==0){
        String username ='hello@world.com';
        user = new User(LastName = 'Hello222'+String.ValueOf(DateTime.Now()) ,FirstName = 'W'+ String.ValueOf(DateTime.Now()));
        user.Username = username;        
        user.Alias = 'yoo';       
        user.CommunityNickname = username.subString(0,7);
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.LanguageLocaleKey = 'en_US';
        user.Email = 'testRSMPopulate@test.com';
        user.LocaleSidKey = 'en_US';
        user.Edit_Partner_Users__c = true;
        List<Profile> lstProfile = [select Id from Profile where Name =: profileName  LIMIT 1];
        /* Done for case # 00050543 on 19Feb2011 */
        List<UserRole> lstRole = Database.query('select Id from UserRole where Name LIKE \'%'+roleName+'%\' LIMIT 1');
        if(lstProfile.Size()>0 && lstRole.size()>0){
            user.ProfileId = lstProfile[0].Id;
            user.UserRoleId = lstRole[0].Id;
            insert user;
        }
        else if(lstProfile.Size()>0){
            user.ProfileId = lstProfile[0].Id;
            insert user;
        }
      }
      else{
        user = userList[0];
      }
      system.assertNotEquals(user.Id , null);
    return user;
    }
    
    public static User setUpUserForUserTypeAndProfile(String userType , String profileName  , contact cc){
     // Test.StartTest();
      User  user = null;
      List<User> userList = new List<User>();
      if(userType  != null && userType != ''){
          userList = Database.query('select id from User where UserType = \''+ userType + '\' and isActive = true and Profile.Name != \'SunPower Credit\' Limit 1');
      }
      if(userList == null || userList.size() ==0){
        String username ='hellooo@world.com';
        user = new User(LastName = 'Hello222'+String.ValueOf(DateTime.Now()) ,FirstName = 'W'+ String.ValueOf(DateTime.Now()));
        user.Username = username;        
        user.Alias = 'yoo';  
        if(cc!=null){
            user.ContactID = cc.id;
        }     
        user.CommunityNickname = username.subString(0,7);
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.LanguageLocaleKey = 'en_US';
        user.Email = 'testSharePartnerAccount@test.com';
        user.LocaleSidKey = 'en_US';
        user.isActive = true;
        user.Division= 'test';
        user.Country = 'test';
        user.Edit_Partner_Users__c = true;
        List<Profile> lstProfile = [select Id from Profile where Name =: profileName LIMIT 1];
        if(cc != null && cc.Account != null){
            String roleName = cc.Account.Name + 'Partner Executive';
            List<UserRole> lstRole = [select Id from UserRole where Name = :roleName LIMIT 1];
            if(lstProfile.Size()>0 && lstRole.size()>0){
                user.ProfileId = lstProfile[0].Id;
                user.UserRoleId = lstRole[0].Id;           
                insert user;
            }            
        }
        else{
            user.ProfileId = lstProfile[0].Id;
            insert user;
        }        
      }
      else{
        user = userList[0];
      }
      system.AssertNotEquals(user.Id , null);
      return user;         
    }
    
    public static Task setUpTask(String status , String subject , ID ownerID , ID whatID){
      Task ts  = new Task();
      ts.status = status ;
      ts.subject = subject ;
      if(ownerID != null)
      ts.OwnerId = ownerID ;
      ts.WhatId = whatID;
      insert ts;
      system.assertNotEquals(ts.Id , null);
      return ts;
    }
    
    public static Certification__c setUpCertification(Id accountID){
        Certification__c certificationObj = new Certification__c();
        certificationObj.Account__c = accountID;
        //certificationObj.Contact__c = contactObj.Id;
        insert certificationObj;   
        system.assertNotEquals(certificationObj.Id , null);
        return certificationObj; 
    }
    
    public static AccountContactRole  setUpAccountContactRole(Id accountId , ID contactID , String roleName){
        AccountContactRole accContact = new AccountContactRole();
        accContact.accountId=accountId;
        accContact.contactId=contactId;
        accContact.role= roleName;
        insert accContact;
        system.assertNotEquals(accContact.Id , null);
        return accContact;
    }
    
    public static Case setUpCase(String recordTypeName ,ID AccountId ,ID RSMID, String statusVal, Boolean isInsert){
        Case newCase = new Case();
        if(recordTypeName != null && recordTypeName != ''){
            String recTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
            newCase.RecordTypeId = recTypeId ;
        }               
        newCase.Status = statusVal;        
        newCase.RMA__c = true;
        newCase.Warranty__c = true;
        newCase.AccountId = AccountId ;
        newCase.Notification_for_Update__c=true;
        newCase.RSM__c = RSMID;
        newCase.Region__c = 'SPDE';
        newCase.RMA_Quantity__c = 1.0;
        newCase.Vendor__c = 'Fronius';
        newCase.RMA_Status__c = 'Open';
        newCase.Vendor_RMA_Status__c ='Open';
        newCase.RMA_Type__c ='Technical Support';
        newCase.Disposition__c = 'Scrapped';
        //Case 00074218
        newCase.PE__c = true;
        //Start 00108512
        if(recordTypeName == 'Customer Service Case'){
            newCase.VAR_Dept_Owner__c = 'Training';
            newCase.Category__c = 'Invoices';
            newCase.sub_Category__c = 'Financing';
        }
        //End 00108512
        if(isInsert){
            insert newCase;       
            system.assertNotEquals(newCase.Id , null);
        }  
        return newCase;
    }
    
    public static Inspection__c setUpInspection(ID caseID , ID contactID , String siteType){
        Inspection__c inspection = new Inspection__c();
        inspection.Case__c = caseID;
        inspection.Contact__c = UserInfo.getUserId();
        inspection.Partner_Contact__c = contactID;
        inspection.site_type__c = siteType;
        insert inspection;
        system.assertNotEquals(inspection.Id , null);
        return inspection;
    }
    
    public static Lead setUpLead(String recordTypeName, Boolean isInsert){
        Lead ld = new Lead();    
        if(recordTypeName != null && recordTypeName != ''){
            RecordType rtype = [select id,name from recordType where name Like : recordTypeName and SobjectType='Lead' limit 1];
            ld.RecordTypeID  = rtype.Id;
        }
        //Check for Lead insert
        ld.FirstName = 'Test';
        ld.LastName = 'Commercial';
        ld.Lead_Type__c='Commercial';
        ld.Company = 'TEST Company A';
        ld.Country = 'North America';
        ld.Email = 'testEmail@test123.com';
        ld.Phone = '09829098290';
        ld.LeadSource = 'Web';
        if(isInsert){
            insert ld;
            system.assertNotEquals(ld.Id , null);
        }
        return ld;
    }
    
    public static Site_Information_Form__c setUpSiteInformationForm(Id leadID , String recordTypeName){
         Site_Information_Form__c site = new Site_Information_Form__c();
         if(recordTypeName != null && recordTypeName != ''){
            site.RecordTypeID = [Select id from recordType where name =: recordTypeName].id;
         }        
         
         site.Lead__c = leadID;
         site.Site_Address__c='123-link road';
         site.Site_City__c='london';
         site.Site_Zip_Postal_Code__c='12345';
         site.Site_State__c='London';
         insert site;
         system.assertNotEquals(site.Id , null);
         return site;
    }
    
    public static Opportunity setUpOpportunity(String stageName , String status, Date closeDate , ID accountID, Boolean isInsert){
        Opportunity oppObj = new Opportunity();
        oppObj.Name = 'testOpp';
        if(stageName != ''){
            oppObj.StageName = stageName ;
        }
        if(closeDate != null){
            oppObj.CloseDate = closeDate;    
        }
        if(status != ''){
            oppObj.Opportunity_Status__c = status;
        }
        oppObj.Probability = 25; 
        oppObj.RSM_Email__c = 'a@b.com';
        if(accountID != null){
            oppObj.AccountID = accountID;
        }
        if(isInsert){
            insert oppObj;
            system.assertNotEquals(oppObj.Id , null);
        }
        return oppObj;
    }
    
    public static Credit_Application__c  setUpCreditApplication(ID accountID , Boolean isPartner){
        Credit_Application__c creditAppObj = new Credit_Application__c(); 
        if(!isPartner){
            creditAppObj.Account__c = accountID;
        }
        creditAppObj.Credit_Limit_Requested__c = 1000;
        creditAppObj.Bank_Reference_Name__c = 'TestReference';
        creditAppObj.Trade_Reference_1_Company__c = 'Trade Reference1';
        creditAppObj.Trade_Reference_1_Phone__c = '12345' ;
        creditAppObj.Trade_Reference_2_Company__c = 'Trade Reference1';
        creditAppObj.Trade_Reference_2_Phone__c = '6789';
        creditAppObj.Federal_Tax_ID__c = '123456';
        creditAppObj.VAT_Number__c = '123456789';  
        creditAppObj.Legal_Company_Name__c = accountID ;    
        insert creditAppObj;
        system.assertNotEquals(creditAppObj.Id , null);
        return creditAppObj;
    }
    public static List<Credit_Application__c>  setUpCreditApplications(ID accountID , Boolean isPartner , Integer counter){
        List<Credit_Application__c> creditApps = new List<Credit_Application__c>();
        for(Integer index=1;index<=counter;index++){
            Credit_Application__c creditAppObj = new Credit_Application__c(); 
            if(!isPartner){
                creditAppObj.Account__c = accountID;
            }
            creditAppObj.Credit_Limit_Requested__c = 1000;
            creditAppObj.Bank_Reference_Name__c = 'TestReference';
            creditAppObj.Trade_Reference_1_Company__c = 'Trade Reference1';
            creditAppObj.Trade_Reference_1_Phone__c = '12345' ;
            creditAppObj.Trade_Reference_2_Company__c = 'Trade Reference1';
            creditAppObj.Trade_Reference_2_Phone__c = '6789';
            creditAppObj.Federal_Tax_ID__c = '123456';
            creditAppObj.VAT_Number__c = '123456789';  
            creditAppObj.Legal_Company_Name__c = accountID ;  
            creditApps.Add(creditAppObj);
        }
        insert creditApps;
        for(Credit_Application__c  ca : creditApps){
            system.assertNotEquals(ca.Id , null);    
        }        
        return creditApps;
    }
    public static Post_Visit_Follow_Up_Survey__c  setUpPostVisitFollowUpSurvey(ID accountID , ID opportunityId , ID contactId){
        Post_Visit_Follow_Up_Survey__c postVisitFollowUpSurveyObj = new Post_Visit_Follow_Up_Survey__c(); 
        postVisitFollowUpSurveyObj.Opportunity_ID__c = opportunityId;
        postVisitFollowUpSurveyObj.Partner_Account__c = accountID;
        postVisitFollowUpSurveyObj.Customer_Contact__c = contactId;
        insert postVisitFollowUpSurveyObj;
        system.assertNotEquals(postVisitFollowUpSurveyObj.Id , null);
        return postVisitFollowUpSurveyObj;
    }
    
    public static Partner_Application__c  setUpPartnerApplication (String territoryName){
        Partner_Application__c partner = new Partner_Application__c();
        partner.Zip__c = '12345';
        partner.Company_Name__c = 'Test Company'+string.valueOf(DateTime.now());
        partner.Partner_Application_Type__c = 'Commercial';
        partner.territory__c = territoryName;
        partner.Country__c = 'USA';
        partner.CRSM__c = userInfo.getUserID();
        insert partner;
        system.assertNotEquals(partner.Id , null);
        return partner;
    }
    
    //Create Partner Portal user
     public static User setUpPartnerPortalUserByContact(String profileName , Contact cont){
        User user = new User();
        String username =cont.Email;
        user = new User(LastName = 'Hello222'+String.ValueOf(DateTime.Now()) ,FirstName = 'W'+ String.ValueOf(DateTime.Now()));
        user.ContactId = cont.Id;
        user.Username = 'lolcatz'+Math.random()+'@noemail.com';
        user.IsActive = true;
        user.Alias = 'zxc';
        user.CommunityNickname = username.subString(0,7);
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.LanguageLocaleKey = 'en_US';
        user.Email = cont.Email;
        user.LocaleSidKey = 'en_US';
        user.Edit_Partner_Users__c = true;
        List<Profile> lstProfile = [select Id from Profile where Name =: profileName];
           
        if(lstProfile.Size()>0){
          user.ProfileId = lstProfile[0].Id;            
          insert user;                    
        }
        system.assertNotEquals(user.Id , null);
        return user;
    }
    
    //Create Campaign
    public static Campaign setUpCampaign(){
        Campaign campaignObj = new Campaign(); 
        campaignObj.Name = 'Test Campaign';
        insert campaignObj;
        system.assertNotEquals(campaignObj.Id , null);
        return campaignObj;
    }
    
    //Create PSR
    public static PSR__c setUpPSR(Boolean isInsert){
        PSR__c p = new PSR__c(); 
        p.Site_Survey_Completed__c =Date.Today();
        if(isInsert){
            insert p;
            system.assertNotEquals(p.Id , null);
        }
        return p;
    }
    public static Issues__c setUpIssue(Id CaseId, Boolean isInsert){
        Issues__c issue = new Issues__c(Name = 'Test Issue Jitendra', Location__c = 'Inverter', Serial__c ='6566555'); 
        issue.Case__c = CaseId;
        issue.Product_Category__c ='Inverter';
        issue.b_Product_Sub_Category__c ='Other Inverter';
        issue.Other_Product_Sub_Category__c = 'Other valiue';
        if(isInsert){
            insert issue;
            system.assertNotEquals(issue.Id , null);
        }
        return issue;
    }
}