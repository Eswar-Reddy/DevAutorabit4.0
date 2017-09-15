trigger SetOrderForMonth on Electric_Bill_Detail__c (before Insert)
{
   if(util.isSkipTrigger())
    {
            return;
    } 

  for(Electric_Bill_Detail__c ebd : Trigger.new)
  {
     if(ebd.Month__c.contains('January'))
       {
         ebd.orderofmonth__c = 1;
       }
     else if(ebd.Month__c.contains('February')) 
       {
         ebd.orderofmonth__c = 2;
       }   
     else if(ebd.Month__c.contains('March')) 
       {
         ebd.orderofmonth__c = 3;
       }
     else if(ebd.Month__c.contains('April')) 
       {
         ebd.orderofmonth__c = 4;
       }
     else if(ebd.Month__c.contains('May')) 
       {
         ebd.orderofmonth__c = 5;
       }
     else if(ebd.Month__c.contains('June')) 
       {
         ebd.orderofmonth__c = 6;
       }
     else if(ebd.Month__c.contains('July')) 
       {
         ebd.orderofmonth__c = 7;
       }
     else if(ebd.Month__c.contains('August')) 
       {
         ebd.orderofmonth__c = 8;
       }
     else if(ebd.Month__c.contains('September')) 
       {
         ebd.orderofmonth__c= 9;
       }
     else if(ebd.Month__c.contains('October')) 
       {
         ebd.orderofmonth__c = 10;
       }
     else if(ebd.Month__c.contains('November')) 
       {
         ebd.orderofmonth__c = 11;
       }
     else if(ebd.Month__c.contains('December')) 
       {
         ebd.orderofmonth__c = 12;
       }                                                                         
  }

}