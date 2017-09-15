public class Test_Controller_Activate_Design
 {         
  public static TestMethod void Test001()
   {    
    Date dt = date.newinstance(2010,1,4);
     Account acc = new Account(Name = 'testaccc',CurrencyIsoCode = 'USD', Account_Status__c = 'Active',SPWR_Relationship_Type__c = 'Off-Taker',BillingStreet = 'West Mare',BillingCity = 'SanFrancisco',BillingPostalCode = '2345', BillingCountry = 'United States of America',Phone = '1234');
      insert acc;
       // Done for case # 00066557 consolidating business units IBD and Components into 'UPP Intl'.
       // Opportunity o = new Opportunity(Name = 'Tesrt',StageName= 'Budgetary Pricing',Business_Unit__c='IBD',CloseDate=dt,AccountId = acc.ID);
       Opportunity o = new Opportunity(Name = 'Tesrt',StageName= 'Budgetary Pricing',Business_Unit__c='UPP Intl',CloseDate=dt,AccountId = acc.ID);
        Insert o;
         Pricebook2 pb = [select Id from Pricebook2 where Name='Systems Price Book'];
          Design__c design = new Design__c(Opportunity__c=o.Id,Price_Book__c=pb.Id);
           insert design;
            /*List<Design__c> dsgn= new List<Design__c>([select id , Site__c,Primary__c from Design__c where Primary__c=true  limit 2 ]);
               List<Design__c> dsgn1 = new List<Design__c>();
                for(Design__c nxdsgn1:dsgn )
                 {
                  dsgn1.add(nxdsgn1.clone(false));
                   }
                    Insert dsgn1;*/
                      list<Design__c> dlist = new list<Design__c>();
                     dlist.add(design);
                    ApexPages.currentPage().getParameters().put('id',design.Id); 
                   ApexPages.StandardSetController assc= new ApexPages.StandardSetController(dlist);
                  Controller_Activate_Design cad=new Controller_Activate_Design(assc);
                 cad.updateDesign();
               cad.ActivateDesign();
              ApexPages.StandardSetController assc1= new ApexPages.StandardSetController(dlist);
            Controller_Activate_Design cad1=new Controller_Activate_Design(assc1); 
          //cad1.updateDesign();
         Delete design;
       cad1.ActivateDesign();
      }
    }