trigger BeforeInsertUpdateProcessing_OOH on oe_order_headers__c (before Insert, before Update)
{
    Set<String> ords = new Set<String>();
    Set<Id>partnerAccountIdSet = new Set<Id>();
    Map<Id,Account> partnerMap;
    
    for(oe_order_headers__c ord : Trigger.New){   
       if (String.isNotBlank(ord.CUST_ACCT_NUMBER__c))
             ords.add(ord.CUST_ACCT_NUMBER__c );
       partnerAccountIdSet.add(ord.Parent_Account__c);
    }
    
    if(!partnerAccountIdSet.isEmpty())
        partnerMap=new Map<Id,Account>([select Country_Domain__c from Account where Id in :partnerAccountIdSet]);
    
    if(!ords.IsEmpty())
    {
        Map <String, Account> actt = new  Map <String, Account>();
        for (Account act : [SELECT id, Parentid, 
                                   RecordType.Name, RecordTypeId,
                                   Account_Record_Type__c, Oracle_Account_Number__c,
                                   Partner_Account__c 
                            FROM Account 
                            WHERE Oracle_Account_Number__c IN: ords])
        { 
system.debug('########--actt--> ' + act);
           
            actt.put(act.Oracle_Account_Number__c, act);      
        }
        
 SYSTEM.DEBUG('--actt--> ' + actt);
 
        for(oe_order_headers__c ord1: trigger.new)
        {
        
            if(Label.Ok_To_Ship_Switch=='ON'){
                if(ord1.REQUESTED_DELIVERY_DATE__c!=null && partnerMap.containsKey(ord1.Parent_Account__c) && (partnerMap.get(ord1.Parent_Account__c).Country_Domain__c=='rvar-us')|| (partnerMap.get(ord1.Parent_Account__c).Country_Domain__c=='combo-us' && ord1.Order_Type__c.contains('RVAR'))){
                
                    DateTime dt = ord1.REQUESTED_DELIVERY_DATE__c;
                    System.debug('dt -----'+dt);
                    if(dt!=null){
                        String dayOfTheWeek=dt.format('EEEE');
                        System.debug('dayOfTheWeek -----'+dayOfTheWeek);
                        if(dayOfTheWeek=='Saturday' || dayOfTheWeek=='Sunday' || dayOfTheWeek=='Monday'||dayOfTheWeek=='Tuesday'||dayOfTheWeek=='Wednesday'){
                           ord1.X4_days_before_SSD__c=ord1.REQUESTED_DELIVERY_DATE__c.addDays(-6);
                        }
                        else if(dayOfTheWeek=='Thursday'){
                           ord1.X4_days_before_SSD__c=ord1.REQUESTED_DELIVERY_DATE__c.addDays(-4);
                        }
                        else if(dayOfTheWeek=='Friday'){
                           ord1.X4_days_before_SSD__c=ord1.REQUESTED_DELIVERY_DATE__c.addDays(-5);
                        }
                        
                        System.debug('X4_days_before_SSD__c -----'+ord1.X4_days_before_SSD__c);
                    }
                }
           }
        
SYSTEM.DEBUG('--Record Type--> ' + ord1.RecordType__c);

            if(String.isNotBlank(ord1.CUST_ACCT_NUMBER__c) && actt.containskey(ord1.CUST_ACCT_NUMBER__c))
            {    
                if (ord1.RecordType__c == 'CASH BOOKED' || ord1.RecordType__c == 'CASH SHIPPED' || ord1.RecordType__c == 'CASH CANCELLED')
                {

                    ord1.Oracle_Account_Number__c = actt.get(ord1.CUST_ACCT_NUMBER__c).Id;

SYSTEM.DEBUG('--ord1.CUST_ACCT_NUMBER__c--> ' + ord1.CUST_ACCT_NUMBER__c);               
SYSTEM.DEBUG('--actt.get(ord1.CUST_ACCT_NUMBER__c).Id--> ' + actt.get(ord1.CUST_ACCT_NUMBER__c).Id);   


                    if(actt.get(ord1.CUST_ACCT_NUMBER__c).RecordType.Name == 'Partner' && actt.get(ord1.CUST_ACCT_NUMBER__c).Partner_Account__c == null)
                    {
                        ord1.Parent_Account__c = actt.get(ord1.CUST_ACCT_NUMBER__c).Id;

SYSTEM.DEBUG('--1--> ');        

                    }
                    else if((actt.get(ord1.CUST_ACCT_NUMBER__c).RecordType.Name == 'Partner' || actt.get(ord1.CUST_ACCT_NUMBER__c).RecordType.Name != 'Partner') && actt.get(ord1.CUST_ACCT_NUMBER__c).Partner_Account__c != null)
                    {
                        ord1.Parent_Account__c = actt.get(ord1.CUST_ACCT_NUMBER__c).Id;
SYSTEM.DEBUG('--2--> '+ord1.Parent_Account__c);                                 
                    }


                }
                else if(ord1.RecordType__c == 'LEASE BOOKED' || ord1.RecordType__c == 'LEASE SHIPPED' || ord1.RecordType__c == 'LEASE CANCELLED')
                {

                    ord1.Oracle_Account_Number__c = actt.get(ord1.CUST_ACCT_NUMBER__c).Id;

SYSTEM.DEBUG('--ord1.CUST_ACCT_NUMBER__c--> ' + ord1.CUST_ACCT_NUMBER__c);               
SYSTEM.DEBUG('--actt.get(ord1.CUST_ACCT_NUMBER__c).Id--> ' + actt.get(ord1.CUST_ACCT_NUMBER__c).Id);                

                    if(actt.get(ord1.CUST_ACCT_NUMBER__c).RecordType.Name == 'Partner' && actt.get(ord1.CUST_ACCT_NUMBER__c).Partner_Account__c == null)
                    {
                        ord1.Parent_Account__c = actt.get(ord1.CUST_ACCT_NUMBER__c).Id;

SYSTEM.DEBUG('--1--> ');                   

                    }
                    else if(actt.get(ord1.CUST_ACCT_NUMBER__c).RecordType.Name != 'Partner' && actt.get(ord1.CUST_ACCT_NUMBER__c).Partner_Account__c != null)
                    {

                        ord1.Parent_Account__c = actt.get(ord1.CUST_ACCT_NUMBER__c).Partner_Account__c;

SYSTEM.DEBUG('--Else2--> '+ord1.Parent_Account__c);                                 

                    }
                }           
            } 
        }        
    }  
}