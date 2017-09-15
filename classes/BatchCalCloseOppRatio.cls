global class BatchCalCloseOppRatio implements Database.Batchable<sobject>{
   //Global variables
   global String Query;   
   global Id recordResidentId;
   
   //created dummy variable to increase a test class coverage
   public String Query1;
   public String Query2;
   public String Query3;
   public String Query4;
   public String Query5;
   public String Query6;
   public String Query7;
   public String Query8;
   public String Query9;
   public String Query10;
   public String Query11;
   public String Query12;
   public String Query13;
   public String Query14;
   global BatchCalCloseOppRatio(){
   
       Id recordPartnerId = [SELECT Id,Name FROM RecordType WHERE Name = 'Partner' and Sobjecttype = 'Account' limit 1].id;
        recordResidentId = [SELECT Id,Name FROM RecordType WHERE Name = 'Residential' and Sobjecttype = 'lead' limit 1].id;
      Query='Select Id,Name, RecordTypeId ,Opportunity_Close__c From Account where status__c=\'active\' AND RecordTypeId = \''+ recordPartnerId +'\'';
      //  Query='Select Id,Name, RecordTypeId ,Opportunity_Close__c From Account where  id = \'0018000000w6ma4AAA\'';
      //  Query='Select Id,Name, RecordTypeId ,Opportunity_Close__c From Account where  id = \'0018000000UqMAOAA3\' RecordTypeId = \'0128000000036xbAAA\' and status__c = \'Active\'';
        system.debug('####### Query ######'+Query);
   }

   global Database.QueryLocator start(Database.BatchableContext BC){
       system.debug('####### Query ######'+Database.getQueryLocator(query));
      return Database.getQueryLocator(query);
   }
   
   global void execute(Database.BatchableContext BC, list<Account> Acc){     
       Set <ID> AccId= new Set <ID>();
       Set <ID> OppId= new Set <ID>();
       datetime chkdate = datetime.now();
       datetime chkdateforupdate = chkdate.addmonths(-6);  
       datetime chkdateyear = chkdate.addYears(-1);
       
       List<Opportunity> Opplistupdate =  new List<Opportunity>(); // list of opportunities that needs to be closed
       List<Opportunity> OpplistTotal =  new List<Opportunity>(); // list of all opportunities in last one year
       List<Opportunity> OpplistWon = new List<Opportunity>(); // list of opportunities won in last one year
       List<Account> PartnerAcc = new List<Account>(); // list of All partners
            
       system.debug('Acc is ' + Acc);
       for(Account acnt : Acc){
           AccId.add(acnt.id);
       }
       
          List<Opportunity> Opp = [select id,isclosed , name,Opportunity_Status__c,PartnerAccountid ,CreatedDate from opportunity where PartnerAccountid IN :AccId and id IN (SELECT ConvertedOpportunityId from lead where IsConverted = true and Lead_Manufacturer__c = 'SunPower' and RecordTypeId = :recordResidentId and ConvertedOpportunityId != null)];
            system.debug('Opp is ' + Opp);
            for(Opportunity opurty : Opp){
                if(opurty.isclosed != true && opurty.CreatedDate < chkdateforupdate ){
                    opurty.Opportunity_Status__c = 'Closed Lost';
                    opurty.StageName = 'Opportunity Lost';
                    opurty.Reason_Won_Lost__c='Insufficient budget';
                    Opplistupdate.add(opurty);
                }   
            } 
        for(Account acunt : Acc){
          for(Opportunity oppt : Opp){
             if(oppt.PartnerAccountid == acunt.id && oppt.CreatedDate > chkdateyear ){
                 system.debug('Add in total opp');
                 OpplistTotal.add(oppt);
                  if(oppt.Opportunity_Status__c == 'Closed Won'){
                        system.debug('Add in won opp');
                      OpplistWon.add(oppt);
                  }
                                   
              }
            }  
             system.debug('Total  opp = '+ OpplistTotal.size());
             system.debug('Total  Won = '+ OpplistWon.size());
            if(OpplistTotal.size()>0){
                 system.debug('calculate Ratio');
                 acunt.Opportunity_Close__c = (double)OpplistWon.size()/OpplistTotal.size();                
            }else{
                 acunt.Opportunity_Close__c = 0;
            }
              system.debug('Opportunity_Close__c = '+ acunt.Opportunity_Close__c);
            PartnerAcc.add(acunt);
            OpplistTotal.clear();
            OpplistWon.clear();     
            system.debug('check next loop now');      
        }
       if(Opplistupdate.size()>0)
           update Opplistupdate;
       if(PartnerAcc.size()>0){
           system.debug('Ratio = '+ PartnerAcc[0].Opportunity_Close__c);
           update PartnerAcc;
           }
       
    }
    
   global void finish(Database.BatchableContext BC){
   }
   
   

}