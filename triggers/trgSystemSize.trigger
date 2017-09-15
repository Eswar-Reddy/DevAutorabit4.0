trigger trgSystemSize on oe_order_lines__c (before Insert, before Update)
{
    Set<String> ords = new Set<String>();
    for(oe_order_lines__c ord : Trigger.New){   
       if (String.isNotBlank(ord.ITEM_NUMBER__c))
             ords.add(ord.ITEM_NUMBER__c );
    }
  
    if(!ords.IsEmpty())
    {
        Map <String, Item__c> actt = new  Map <String, Item__c>();
        for (Item__c act : [SELECT id,Name,Item_ID__c, Product_Type__c, Item_Category_3__c FROM Item__c  WHERE Item_ID__c IN: ords])                            
                               
                              

                            
                            { 
                            system.debug('########--actt--> ' + act);
            actt.put(act.Item_ID__c, act);      
        }
 SYSTEM.DEBUG('--actt--> ' + actt);       
        for(oe_order_lines__c ord1: trigger.new)
        {
            if(String.isNotBlank(ord1.ITEM_NUMBER__c) && actt.containskey(ord1.ITEM_NUMBER__c))
            {
                ord1.Item_Number_Order_Line__c = actt.get(ord1.ITEM_NUMBER__c).Id; 
                //ord1.System_Size__c = ord1.System_Size_Formula__c;                             
                               
            }
                
            }            
        }        
    }