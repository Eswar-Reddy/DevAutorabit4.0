@isTest(SeeAllData=true)
private class SPWR_partnerprogram_poc_uat_Test
{
  public static testmethod void TM1()
  {
     Integer int_currYear = Date.Today().year();
     String str_loPeriod = 'P1';
     List<Global_Dealer_Program__c> newGDP = new List<Global_Dealer_Program__c>(); //List of GDP.
     List<Metric_Template__c> newMT = new List<Metric_Template__c>(); //List of MT
     List<Account> newAcc = new List<Account>(); //List of Account
     List<Contact> newCon = new List<Contact>(); //List of Contact
     List<Metrics__c> newMetrics = new List<Metrics__c>(); //List of Metrics
     Map<Id, User> mapUsr = new Map<Id, User>([SELECT u.IsActive, u.Id, 
                                                      u.Country_Domain__c 
                                               FROM User u 
                                               WHERE u.Profile.Name IN ('Partner Executive', 'Partner Restricted', 'Partner Sales', 'Partner Operations', 'Partner Technical', 'Partner Delegated Administrator', 'EU Partner Delegated Administrator', 'EU Partner Restricted', 'EU Partner Sales', 'EU Partner Technical', 'EU Partner Executive', 'EU Partner Operations', 'EU Residential Installer') AND 
                                                     u.IsActive = true AND 
                                                     u.Country_Domain__c IN ('combo-us','combo-de','combo-it','combo-es','combo-fr')]);
     
     Id AccRecId = [SELECT id FROM RecordType WHERE sObjectType='Account' AND IsActive=true AND Name='Partner'].id;
     for(Integer i=0;i<10;i++){
        newGdp.add(new Global_Dealer_Program__c(Account_Type__c = 'Authorized-Partner-Combo, Authorized-Partner-Residential',
                                                Country_Domain__c='rvar-us, combo-us',  
                                                Performance_Year__c = int_currYear,
                                                Performance_Period__c = str_loPeriod,
                                                Countries_Supported__c = 'United States',
                                                Data_Load_Identifier__c = 'TestGDP'+Math.random()));                
     }//END FOR 
     
     if(!newGdp.isEmpty()){ 
       insert newGdp;//Insert Global Dealer Program
       for(Global_Dealer_Program__c gdr :newGdp){
            newMT.add(new Metric_Template__c(Global_Dealer_Program__c=  gdr.id,
                                             Metric_Category__c = 'Performance to Business Plan',
                                             Metric_Code__c = 'BP_AEU_006',
                                             Metric_External_ID__c =  'TestMT'+Math.random(),
                                             Metric_Name__c =  'Period Minimum Sales',
                                             Metric_Parent_Code__c=  'BP_AEU_012'));
       }
         
       if(!newMT.isEmpty()){
         insert newMT; //Insert Metric Template

          newAcc.add(new Account(RecordTypeid = AccRecId,Name = 'TestAccountXX',Type = 'Authorized-Partner-Combo',Country_Domain__c = 'combo-us',
                                       BillingCountry='United States', BillingCity= 'San Francisco',BillingPostalCode = '94139',
                                       BillingStreet = 'Po Box', BillingState = 'CA',
                                       ShippingCountry='United States', ShippingCity= 'San Francisco',ShippingPostalCode = '94139',
                                       ShippingStreet = 'Po Box', ShippingState = 'CA'));          
            
            if(!newAcc.isEmpty())
            {
              insert newAcc; ////Insert Account
              for(Account a : newAcc)
              {
                for(Metric_Template__c mt : newMT)
                {
                  newMetrics.add(new Metrics__c(Account__c = a.id,
                                        External_Id__c = 'TestEX'+Math.random(), //Generating External Id
                                        Metric_Template__c= mt.id));
                }
              }
              if(!newMetrics.isEmpty())
              {
                insert newMetrics;////Insert Insert Metrics
                Batch_Update_Parent_Metrics_v2_1 bup = new Batch_Update_Parent_Metrics_v2_1(newAcc);
                bup.prop_GetCurrentPeriod = str_loPeriod;
                bup.prop_GetCurrentYear = int_currYear; 
                ID batchprocessid = Database.executeBatch(bup,200);
              }
              
              Id conRecId = [SELECT id FROM RecordType WHERE sObjectType='Contact' AND IsActive=true AND Name='Partner'].id;
                          
              for(Integer i=0; i<newAcc.size(); i++)
              {
                if(newAcc[i].Country_Domain__c == 'combo-us')
                {
                  Contact c1 = new Contact();
                  for(Id u: mapUsr.keySet())
                    if(mapUsr.get(u).Country_Domain__c == newAcc[i].Country_Domain__c)
                      c1.Partner_Portal_User__c = u;
                  c1.LastName = 'Test' + String.valueOf(i);
                  c1.Phone = '+49941297700';
                  c1.Email = 'test.user' + String.valueOf(i) + '@test' + String.valueOf(i) + '.com';                  
                  c1.MailingCountry= 'New York';
                  c1.LMS_Job_ID__c= 'Sales';
                  c1.Country_Domain__c= 'combo-us';
                  c1.Authorized_to_Order__c = true;
                  c1.AccountId = newAcc[i].Id;
                  c1.RecordTypeId = conRecId;
                  newCon.add(c1); 

                  Contact c2 = new Contact();
                  for(Id u: mapUsr.keySet())
                    if(mapUsr.get(u).Country_Domain__c == newAcc[i].Country_Domain__c)
                      c2.Partner_Portal_User__c = u;
                  c2.LastName = 'Test' + String.valueOf(i) + String.valueOf(i);
                  c2.Phone = '+49941297777';
                  c2.Email = 'test.user' + String.valueOf(i) + String.valueOf(i) + '@test' + String.valueOf(i) + '.com';                  
                  c2.MailingCountry= 'New Wark';
                  c2.LMS_Job_ID__c= 'Sales';
                  c2.Country_Domain__c= 'combo-us';
                  c2.Authorized_to_Order__c = true;
                  c2.AccountId = newAcc[i].Id;
                  c2.RecordTypeId = conRecId;
                  newCon.add(c2);                 
                }             
              }
              insert newCon;////Insert Contact            
            }//End newAcc           
         }//End newMT        
     }//End newGDP
     
     for(Integer i=0; i<newCon.size(); i++)
     {
        System.RunAs(mapUsr.get(newCon[i].Partner_Portal_User__c))
        {
          PageReference pageRef = Page.partnerprogram_pportal_poc_uat;
          Test.setCurrentPage(pageRef);
          SPWR_partnerprogram_poc_uat controller = new SPWR_partnerprogram_poc_uat();
          
            String strAcc   = controller.getAccountName();
            String strSDt   = controller.getSinceDate();
            String strPTier = controller.getpartnerTier();
            String strPType = controller.getPartnerType();
            String strAThe  = controller.getAccTheatre();
            String strVEFD  = controller.getValidEvalFromDate();
            String strVETD  = controller.getValidEvalToDate();          
            //Contact c = controller.getContact();
            List<SelectOption> lstSelOpt = controller.Items;
            
            Decimal dec1 = controller.ConvertToDecimal('$ 234.997');
            Decimal dec2 = controller.ConvertToDecimal('234.997 €');
            
            Date d1 = controller.ChangetoDate('2012-3-29--2012-3-30', 'SD');
            Date d2 = controller.ChangetoDate('2012-3-29--2012-3-30', 'ED');
            
            String cur1 = SPWR_partnerprogram_poc_uat.DecimaltoCurrency(9999.999);           
            String cur2 = SPWR_partnerprogram_poc_uat.DecimaltoCurrency(0);
            
        }//End RunAs
     }//Loop End Run In user Context     
  }//End Test TM1

  public static testmethod void TM2() //EU
  {
     Integer int_currYear = Date.Today().year();
     String str_loPeriod = 'P1';
     List<Global_Dealer_Program__c> newGDP = new List<Global_Dealer_Program__c>(); //List of GDP.
     List<Metric_Template__c> newMT = new List<Metric_Template__c>(); //List of MT
     List<Account> newAcc = new List<Account>(); //List of Account
     List<Contact> newCon = new List<Contact>(); //List of Contact
     List<Metrics__c> newMetrics = new List<Metrics__c>(); //List of Metrics
     Map<Id, User> mapUsr = new Map<Id, User>([SELECT u.IsActive, u.Id, 
                                                      u.Country_Domain__c 
                                               FROM User u 
                                               WHERE u.Profile.Name IN ('EU Partner Delegated Administrator', 'EU Partner Restricted', 'EU Partner Sales', 'EU Partner Technical', 'EU Partner Executive', 'EU Partner Operations', 'EU Residential Installer') AND 
                                                     u.IsActive = true AND 
                                                     u.Country_Domain__c IN ('combo-de','combo-it','combo-es','combo-fr')]);
     
     Id AccRecId = [SELECT id FROM RecordType WHERE sObjectType='Account' AND IsActive=true AND Name='Partner'].id;
     for(Integer i=0;i<10;i++){
        newGdp.add(new Global_Dealer_Program__c(Account_Type__c = 'Authorized-Partner-Combo, Authorized-Partner-Residential',
                                                Country_Domain__c='<>rvar-us, combo-us, cvar-us',  
                                                Performance_Year__c = int_currYear,
                                                Performance_Period__c = str_loPeriod,
                                                Countries_Supported__c = 'France, Germany, Italy, Belgium',
                                                Data_Load_Identifier__c = 'TestGDP'+Math.random()));                                                
     }//END FOR   
     if(!newGdp.isEmpty()){ 
       insert newGdp;//Insert Global Dealer Program
       for(Global_Dealer_Program__c gdr :newGdp){
            newMT.add(new Metric_Template__c(Global_Dealer_Program__c=  gdr.id,
                                             Metric_Category__c = 'Performance to Business Plan',
                                             Metric_Code__c = 'BP_AEU_006',
                                             Metric_External_ID__c =  'TestMT'+Math.random(),
                                             Metric_Name__c =  'Period Minimum Sales',
                                             Metric_Parent_Code__c=  'BP_AEU_012'));
       }
         
       if(!newMT.isEmpty()){
         insert newMT; //Insert Metric Template
         for(Integer j=0;j<5;j++){
           if(j<1){//France
             newAcc.add(new Account(RecordTypeid = AccRecId,Name = 'TestAccount'+j, Type = 'Premier-Partner-Combo', Country_Domain__c = 'combo-fr',
                                       BillingCountry='France', BillingCity= 'Parise', BillingPostalCode = '94139',
                                       BillingStreet = 'Po Box', BillingState = 'Parise',
                                       ShippingCountry='France', ShippingCity= 'Parise', ShippingPostalCode = '94139',
                                       ShippingStreet = 'Po Box', ShippingState = 'Parise'));             
           }           
         }

         if(!newAcc.isEmpty())
         {
           insert newAcc; ////Insert Account
           for(Account a : newAcc){
             for(Metric_Template__c mt : newMT){
               newMetrics.add(new Metrics__c(Account__c = a.id,
                                        External_Id__c = 'TestEX'+Math.random(), //Generating External Id
                                        Metric_Template__c= mt.id));
             }
           }
           if(!newMetrics.isEmpty()){
             insert newMetrics;////Insert Insert Metrics
             Batch_Update_Parent_Metrics_v2_1 bup = new Batch_Update_Parent_Metrics_v2_1(newAcc);
             bup.prop_GetCurrentPeriod = str_loPeriod;
             bup.prop_GetCurrentYear = int_currYear; 
             ID batchprocessid = Database.executeBatch(bup,200);
           }
              
           Id conRecId = [SELECT id FROM RecordType WHERE sObjectType='Contact' AND IsActive=true AND Name='Partner'].id;
                          
           for(Integer i=0; i<newAcc.size(); i++)
           {
              if(newAcc[i].Country_Domain__c == 'combo-fr')
              {
                  Contact c1 = new Contact();
                  for(Id u: mapUsr.keySet())
                    if(mapUsr.get(u).Country_Domain__c == newAcc[i].Country_Domain__c)
                      c1.Partner_Portal_User__c = u;
                  c1.LastName = 'Test' + String.valueOf(i);
                  c1.Phone = '97 70 00 00 88';
                  c1.Email = 'test.user' + String.valueOf(i) + '@test' + String.valueOf(i) + '.com';                  
                  c1.MailingCountry= 'Parise';
                  c1.LMS_Job_ID__c= 'Sales';
                  c1.Country_Domain__c= newAcc[i].Country_Domain__c;
                  c1.Authorized_to_Order__c = true;
                  c1.AccountId = newAcc[i].Id;
                  c1.RecordTypeId = conRecId;                 
                  newCon.add(c1);               
              }             
            }
            insert newCon;////Insert Contact            
          }//End newAcc           
        }//End newMT        
     }//End newGDP
     
     for(Integer i=0; i<newCon.size(); i++)
     {
        System.RunAs(mapUsr.get(newCon[i].Partner_Portal_User__c))
        {
          PageReference pageRef = Page.partnerprogram_pportal_poc_uat;
          Test.setCurrentPage(pageRef);
          SPWR_partnerprogram_poc_uat controller = new SPWR_partnerprogram_poc_uat();
          
            String strAcc   = controller.getAccountName();
            String strSDt   = controller.getSinceDate();
            String strPTier = controller.getpartnerTier();
            String strPType = controller.getPartnerType();
            String strAThe  = controller.getAccTheatre();
            String strVEFD  = controller.getValidEvalFromDate();
            String strVETD  = controller.getValidEvalToDate();          
            //Contact c = controller.getContact();
            List<SelectOption> lstSelOpt = controller.Items;
            
            Decimal dec1 = controller.ConvertToDecimal('$ 234.997');
            Decimal dec2 = controller.ConvertToDecimal('234.997 €');
            
            Date d1 = controller.ChangetoDate('2012-3-29--2012-3-30', 'SD');
            Date d2 = controller.ChangetoDate('2012-3-29--2012-3-30', 'ED');
            
            String cur1 = SPWR_partnerprogram_poc_uat.DecimaltoCurrency(9999.999);           
            String cur2 = SPWR_partnerprogram_poc_uat.DecimaltoCurrency(0);
            
        }//End RunAs
     }//Loop End Run In user Context     
  }//End Test TM2  
  
  public static testmethod void TM3()
  {
     Integer int_currYear = Date.Today().year();
     String str_loPeriod = 'P1';
     List<Global_Dealer_Program__c> newGDP = new List<Global_Dealer_Program__c>(); //List of GDP.
     List<Metric_Template__c> newMT = new List<Metric_Template__c>(); //List of MT
     List<Account> newAcc = new List<Account>(); //List of Account
     List<Contact> newCon = new List<Contact>(); //List of Contact
     List<Metrics__c> newMetrics = new List<Metrics__c>(); //List of Metrics
     Map<Id, User> mapUsr = new Map<Id, User>([SELECT u.IsActive, u.Id, 
                                                      u.Country_Domain__c 
                                               FROM User u 
                                               WHERE u.Profile.Name IN ('EU Partner Delegated Administrator', 'EU Partner Restricted', 'EU Partner Sales', 'EU Partner Technical', 'EU Partner Executive', 'EU Partner Operations', 'EU Residential Installer') AND 
                                                     u.IsActive = true AND 
                                                     u.Country_Domain__c IN ('combo-de','combo-it','combo-es','combo-fr', 'cvar-es')]);
     
     Id AccRecId = [SELECT id FROM RecordType WHERE sObjectType='Account' AND IsActive=true AND Name='Partner'].id;
     for(Integer i=0;i<10;i++){
        newGdp.add(new Global_Dealer_Program__c(Account_Type__c = 'Authorized-Partner-Combo, Authorized-Partner-Residential',
                                                Country_Domain__c='<>rvar-us, combo-us, cvar-us',  
                                                Performance_Year__c = int_currYear,
                                                Performance_Period__c = str_loPeriod,
                                                Countries_Supported__c = 'France, Germany, Italy, Belgium',
                                                Data_Load_Identifier__c = 'TestGDP'+Math.random()));                                                
     }//END FOR   
     if(!newGdp.isEmpty()){ 
       insert newGdp;//Insert Global Dealer Program
       for(Global_Dealer_Program__c gdr :newGdp){
            newMT.add(new Metric_Template__c(Global_Dealer_Program__c=  gdr.id,
                                             Metric_Category__c = 'Performance to Business Plan',
                                             Metric_Code__c = 'BP_AEU_006',
                                             Metric_External_ID__c =  'TestMT'+Math.random(),
                                             Metric_Name__c =  'Period Minimum Sales',
                                             Metric_Parent_Code__c=  'BP_AEU_012'));
       }
         
       if(!newMT.isEmpty()){
         insert newMT; //Insert Metric Template
         for(Integer j=0;j<5;j++){
          if(j<1){//Spain
             newAcc.add(new Account(RecordTypeid = AccRecId,Name = 'TestAccount'+j, Type = 'Premier-Partner-Combo', Country_Domain__c = 'cvar-es',
                                       BillingCountry='Spain', BillingCity= 'Madrid', BillingPostalCode = '94139',
                                       BillingStreet = 'Po Box', BillingState = 'Madrid',
                                       ShippingCountry='Spain', ShippingCity= 'Madrid', ShippingPostalCode = '94139',
                                       ShippingStreet = 'Po Box', ShippingState = 'Madrid'));             
           }          
         }

         if(!newAcc.isEmpty())
         {
           insert newAcc; ////Insert Account
           for(Account a : newAcc){
             for(Metric_Template__c mt : newMT){
               newMetrics.add(new Metrics__c(Account__c = a.id,
                                        External_Id__c = 'TestEX'+Math.random(), //Generating External Id
                                        Metric_Template__c= mt.id));
             }
           }
           if(!newMetrics.isEmpty()){
             insert newMetrics;////Insert Insert Metrics
             Batch_Update_Parent_Metrics_v2_1 bup = new Batch_Update_Parent_Metrics_v2_1(newAcc);
             bup.prop_GetCurrentPeriod = str_loPeriod;
             bup.prop_GetCurrentYear = int_currYear; 
             ID batchprocessid = Database.executeBatch(bup,200);
           }
              
           Id conRecId = [SELECT id FROM RecordType WHERE sObjectType='Contact' AND IsActive=true AND Name='Partner'].id;
                          
           for(Integer i=0; i<newAcc.size(); i++)
           {
              if(newAcc[i].Country_Domain__c == 'cvar-es')
              {
                  Contact c1 = new Contact();
                  for(Id u: mapUsr.keySet())
                    if(mapUsr.get(u).Country_Domain__c == newAcc[i].Country_Domain__c)
                      c1.Partner_Portal_User__c = u;
                  c1.LastName = 'Test' + String.valueOf(i);
                  c1.Phone = '+3476666666';
                  c1.Email = 'test.user' + String.valueOf(i) + '@test' + String.valueOf(i) + '.com';                  
                  c1.MailingCountry= 'Madrid';
                  c1.LMS_Job_ID__c= 'Sales';
                  c1.Country_Domain__c= newAcc[i].Country_Domain__c;
                  c1.Authorized_to_Order__c = true;
                  c1.AccountId = newAcc[i].Id;
                  c1.RecordTypeId = conRecId;                 
                  newCon.add(c1);               
              }                           
            }
            insert newCon;////Insert Contact            
          }//End newAcc           
        }//End newMT        
     }//End newGDP
     
     for(Integer i=0; i<newCon.size(); i++)
     {
        System.RunAs(mapUsr.get(newCon[i].Partner_Portal_User__c))
        {
          PageReference pageRef = Page.partnerprogram_pportal_poc_uat;
          Test.setCurrentPage(pageRef);
          SPWR_partnerprogram_poc_uat controller = new SPWR_partnerprogram_poc_uat();
          
            String strAcc   = controller.getAccountName();
            String strSDt   = controller.getSinceDate();
            String strPTier = controller.getpartnerTier();
            String strPType = controller.getPartnerType();
            String strAThe  = controller.getAccTheatre();
            String strVEFD  = controller.getValidEvalFromDate();
            String strVETD  = controller.getValidEvalToDate();          
            //Contact c = controller.getContact();
            List<SelectOption> lstSelOpt = controller.Items;
            
            Decimal dec1 = controller.ConvertToDecimal('$ 234.997');
            Decimal dec2 = controller.ConvertToDecimal('234.997 €');
            
            Date d1 = controller.ChangetoDate('2012-3-29--2012-3-30', 'SD');
            Date d2 = controller.ChangetoDate('2012-3-29--2012-3-30', 'ED');
            
            String cur1 = SPWR_partnerprogram_poc_uat.DecimaltoCurrency(9999.999);           
            String cur2 = SPWR_partnerprogram_poc_uat.DecimaltoCurrency(0);
            
        }//End RunAs
     }//Loop End Run In user Context 
  }//End Test TM3

  public static testmethod void TM4()
  {
     Integer int_currYear = Date.Today().year();
     String str_loPeriod = 'P1';
     List<Global_Dealer_Program__c> newGDP = new List<Global_Dealer_Program__c>(); //List of GDP.
     List<Metric_Template__c> newMT = new List<Metric_Template__c>(); //List of MT
     List<Account> newAcc = new List<Account>(); //List of Account
     List<Contact> newCon = new List<Contact>(); //List of Contact
     List<Metrics__c> newMetrics = new List<Metrics__c>(); //List of Metrics
     Map<Id, User> mapUsr = new Map<Id, User>([SELECT u.IsActive, u.Id, 
                                                      u.Country_Domain__c 
                                               FROM User u 
                                               WHERE u.Profile.Name IN ('EU Partner Delegated Administrator', 'EU Partner Restricted', 'EU Partner Sales', 'EU Partner Technical', 'EU Partner Executive', 'EU Partner Operations', 'EU Residential Installer') AND 
                                                     u.IsActive = true AND 
                                                     u.Country_Domain__c IN ('combo-de','combo-it','combo-es','combo-fr')]);
     
     Id AccRecId = [SELECT id FROM RecordType WHERE sObjectType='Account' AND IsActive=true AND Name='Partner'].id;
     for(Integer i=0;i<10;i++){
        newGdp.add(new Global_Dealer_Program__c(Account_Type__c = 'Authorized-Partner-Combo, Authorized-Partner-Residential',
                                                Country_Domain__c='<>rvar-us, combo-us, cvar-us',  
                                                Performance_Year__c = int_currYear,
                                                Performance_Period__c = str_loPeriod,
                                                Countries_Supported__c = 'France, Germany, Italy, Belgium',
                                                Data_Load_Identifier__c = 'TestGDP'+Math.random()));                                                
     }//END FOR   
     if(!newGdp.isEmpty()){ 
       insert newGdp;//Insert Global Dealer Program
       for(Global_Dealer_Program__c gdr :newGdp){
            newMT.add(new Metric_Template__c(Global_Dealer_Program__c=  gdr.id,
                                             Metric_Category__c = 'Performance to Business Plan',
                                             Metric_Code__c = 'BP_AEU_006',
                                             Metric_External_ID__c =  'TestMT'+Math.random(),
                                             Metric_Name__c =  'Period Minimum Sales',
                                             Metric_Parent_Code__c=  'BP_AEU_012'));
       }
         
       if(!newMT.isEmpty()){
         insert newMT; //Insert Metric Template
         for(Integer j=0;j<5;j++){
          if(j<1){//German
            newAcc.add(new Account(RecordTypeid = AccRecId,Name = 'TestAccount'+j,Type = 'Premier-Partner-Combo',Country_Domain__c = 'combo-de',
                                       BillingCountry='Germany', BillingCity= 'Frankfurt', BillingPostalCode = '94139',
                                       BillingStreet = 'Po Box', BillingState = 'CA',
                                       ShippingCountry='Germany', ShippingCity= 'Frankfurt', ShippingPostalCode = '94139',
                                       ShippingStreet = 'Po Box', ShippingState = 'CA'));             
          }
          else if(j<2){//Italy
            newAcc.add(new Account(RecordTypeid = AccRecId,Name = 'TestAccount'+j, Type = 'Premier-Partner-Combo', Country_Domain__c = 'combo-it',
                                       BillingCountry='Italy', BillingCity= 'Rome', BillingPostalCode = '94139',
                                       BillingStreet = 'Po Box', BillingState = 'Rome',
                                       ShippingCountry='Italy', ShippingCity= 'Rome', ShippingPostalCode = '94139',
                                       ShippingStreet = 'Po Box', ShippingState = 'Rome'));             
          }          
         }

         if(!newAcc.isEmpty())
         {
           insert newAcc; ////Insert Account
           for(Account a : newAcc){
             for(Metric_Template__c mt : newMT){
               newMetrics.add(new Metrics__c(Account__c = a.id,
                                        External_Id__c = 'TestEX'+Math.random(), //Generating External Id
                                        Metric_Template__c= mt.id));
             }
           }
           if(!newMetrics.isEmpty()){
             insert newMetrics;////Insert Insert Metrics
             Batch_Update_Parent_Metrics_v2_1 bup = new Batch_Update_Parent_Metrics_v2_1(newAcc);
             bup.prop_GetCurrentPeriod = str_loPeriod;
             bup.prop_GetCurrentYear = int_currYear; 
             ID batchprocessid = Database.executeBatch(bup,200);
           }
              
           Id conRecId = [SELECT id FROM RecordType WHERE sObjectType='Contact' AND IsActive=true AND Name='Partner'].id;
                          
           for(Integer i=0; i<newAcc.size(); i++)
           {
              if(newAcc[i].Country_Domain__c == 'combo-de')
              {
                  Contact c1 = new Contact();
                  for(Id u: mapUsr.keySet())
                    if(mapUsr.get(u).Country_Domain__c == newAcc[i].Country_Domain__c)
                      c1.Partner_Portal_User__c = u;
                  c1.LastName = 'Test' + String.valueOf(i);
                  c1.Phone = '+013941297700';
                  c1.Email = 'test.user' + String.valueOf(i) + '@test' + String.valueOf(i) + '.com';                  
                  c1.MailingCountry= 'Frankfurt';
                  c1.LMS_Job_ID__c= 'Sales';
                  c1.Country_Domain__c= newAcc[i].Country_Domain__c;
                  c1.Authorized_to_Order__c = true;
                  c1.AccountId = newAcc[i].Id;
                  c1.RecordTypeId = conRecId;                 
                  newCon.add(c1);               
              }
              else if(newAcc[i].Country_Domain__c == 'combo-it')
              {
                  Contact c1 = new Contact();
                  for(Id u: mapUsr.keySet())
                    if(mapUsr.get(u).Country_Domain__c == newAcc[i].Country_Domain__c)
                      c1.Partner_Portal_User__c = u;
                  c1.LastName = 'Test' + String.valueOf(i);
                  c1.Phone = '3941297700';
                  c1.Email = 'test.user' + String.valueOf(i) + '@test' + String.valueOf(i) + '.com';                  
                  c1.MailingCountry= 'Rome';
                  c1.LMS_Job_ID__c= 'Sales';
                  c1.Country_Domain__c= newAcc[i].Country_Domain__c;
                  c1.Authorized_to_Order__c = true;
                  c1.AccountId = newAcc[i].Id;
                  c1.RecordTypeId = conRecId;                 
                  newCon.add(c1);               
              }                      
            }
            insert newCon;////Insert Contact            
          }//End newAcc           
        }//End newMT        
     }//End newGDP
     
     for(Integer i=0; i<newCon.size(); i++)
     {
        System.RunAs(mapUsr.get(newCon[i].Partner_Portal_User__c))
        {
          PageReference pageRef = Page.partnerprogram_pportal_poc_uat;
          Test.setCurrentPage(pageRef);
          SPWR_partnerprogram_poc_uat controller = new SPWR_partnerprogram_poc_uat();
          
            String strAcc   = controller.getAccountName();
            String strSDt   = controller.getSinceDate();
            String strPTier = controller.getpartnerTier();
            String strPType = controller.getPartnerType();
            String strAThe  = controller.getAccTheatre();
            String strVEFD  = controller.getValidEvalFromDate();
            String strVETD  = controller.getValidEvalToDate();          
            //Contact c = controller.getContact();
            List<SelectOption> lstSelOpt = controller.Items;
            
            Decimal dec1 = controller.ConvertToDecimal('$ 234.997');
            Decimal dec2 = controller.ConvertToDecimal('234.997 €');
            
            Date d1 = controller.ChangetoDate('2012-3-29--2012-3-30', 'SD');
            Date d2 = controller.ChangetoDate('2012-3-29--2012-3-30', 'ED');
            
            String cur1 = SPWR_partnerprogram_poc_uat.DecimaltoCurrency(9999.999);           
            String cur2 = SPWR_partnerprogram_poc_uat.DecimaltoCurrency(0);
            
        }//End RunAs
     }//Loop End Run In user Context         
  }//End Test TM4   
}//End Class SPWR_partnerprogram_poc_uat_Test