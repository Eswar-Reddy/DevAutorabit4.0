public class AddProductFromPsr_Extension 
{
  public List<QuoteLineItem> selectedLineitems = new List<QuoteLineItem>();
  public List<PSRLineItems> psrLIlst {get;set;}
  public Boolean status {get;set;}

  public Quote quoteObj {get;set;}
  Set<PSR__c> psrid = new Set<PSR__c>();
  Set<ID> lineitemids = new Set<ID>();
  Set<ID> lineitemids1 = new Set<ID>();
  public ID quoteid = ApexPages.currentPage().getParameters().get('id');
 // Public String hostAddress = ApexPages.currentpage().getHeaders().get('host');
  
  public AddProductFromPsr_Extension(ApexPages.StandardController stdController)     
  {        
    this.quoteObj = (Quote)stdController.getRecord();

    psrLIlst = new  List<PSRLineItems>();
    lstPSR = [Select id,Name,Quote__c,Product_Type__c,Site_Name__c,Site__r.Name ,Site__r.Site_Name__c  from PSR__c where Quote__c =: quoteid ];
    System.debug('Ashok' + lstPSR);
    Integer RecSize = 0;
    RecSize = lstPSR.size();
    psrid.addALL(lstPSR);
    status = false;
    
    
    for(integer i=0; i < lstPSR.size(); i++)
     { 

                   
          Design__c[]  des = [Select Id, Name,PSR__c FROM Design__c WHERE PSR__c =:lstPSR[i].id ];
        
          Estimate__c[]  estimate =[Select Id,Name,PSR__c From Estimate__c WHERE PSR__c =: lstPSR[i].id];
                
          QuoteLineItem[] lineitemDesign;
          QuoteLineItem[] lineitemEstimate;
          
          for(integer j=0; j < des.size(); j++)
          {
          If(des.size() != 0)
           { 
            lineitemDesign = [Select Id,currencyIsoCode,QuoteId,Quote.PriceBook2Id,PricebookEntryId, 
                             Product__c,Site__r.Name,Quantity,UnitPrice,ServiceDate,TotalPrice,PriceBookEntry.Product2.name,
                             Cost__c,Estimate__c,Design__c,Site__c,Design__r.PSR__c,Estimate__r.PSR__c,Design__r.Name,
                              Total_Cost__c,Estimate__r.Name,Product__r.Name,Product__r.Family 
                             FROM QuoteLineItem where Design__c =: des[0].id and PriceBookEntry.Product2.name !='Total Price' ];     
           }
          }
          for(integer k=0; k < estimate.size(); k++)
          {
              If(estimate.size() != 0 )
               {
                lineitemEstimate = [Select Id,currencyIsoCode,QuoteId,Quote.PriceBook2Id,PricebookEntryId, Quantity, UnitPrice, Product__c,Site__r.Name,
                                   ServiceDate,TotalPrice,Cost__c,Estimate__c,Design__c,PriceBookEntry.Product2.name,
                                   Site__c,Design__r.PSR__c,Estimate__r.PSR__c,Design__r.Name,Total_Cost__c,
                                   Estimate__r.Name,Product__r.Name,Product__r.Family  FROM QuoteLineItem 
                                   where Estimate__c =: estimate[0].id and PriceBookEntry.Product2.name !='Total Price'  ];
               }
          }
          
      List<QuoteLineItem> psrLineitems = new List<QuoteLineItem>();
	   Set<String> setQuoteLineID = new Set<String>();
       If(estimate.size() != 0 )
         {
             for(QuoteLineItem objc : lineitemEstimate)            
             {                   	       
          		psrLineitems.add(objc); 
          		setQuoteLineID.Add(objc.ID);                 	
             }
         }
       If(des.size() != 0)
         {
             for(QuoteLineItem objc1 : lineitemDesign)
             {            
             	if(!setQuoteLineID.contains(objc1.ID)){     
                 	psrLineitems.add(objc1);
             	}
             }
         }
        

        psrLIlst.add(new PSRLineItems(lstPSR[i],psrLineitems));

         
    }
     
 }
 
 public Class PSRLineItems{
     public  PSR__c  psrObj {get;set;}
     public  List<cQuoteLineItem>cQuoteLTLst {get;set;}

    public PSRLineItems(PSR__c refpsrObj ,List<QuoteLineItem> QLItemsLst){
        cQuoteLTLst = new List<cQuoteLineItem>();
        this.psrObj =refpsrObj ;
        if(QLItemsLst.size()>0){
            for(QuoteLineItem nextLI :QLItemsLst){
                cQuoteLTLst.add(new cQuoteLineItem(nextLI));
            }
        }
    }
 }

   
  /* This is our wrapper/container class. A container class is a class, a data     
  structure, or an abstract data type whose instances are collections of other     
  objects. */ 
     
      public class cQuoteLineItem    
      {        
      public QuoteLineItem item {get; set;}        
      public Boolean selected {get; set;}   
                  
       
          public cQuoteLineItem()        
          {        
           item = new QuoteLineItem(); 
                  
           selected = false;        
          }                
          public cQuoteLineItem(QuoteLineItem c)
          {            
          //item.currencyIsoCode =c.currencyIsoCode ;
          item = c.clone(false);            
          
          selected = false;        
          }    
      }
      
      //****-------------------------------****//
      



  
  public List<PSR__c> lstPSR{get; set;}
  public List<PSR__c> getlstPSR()
   {   
    return lstPSR;   
   }
  
  public List<QuoteLineItem> LineItems;    
  public List<QuoteLineItem> getLineItems() 
  {
    return LineItems;
  }
  
 
      
       Public PageReference updatelineitem()
       { 
         //QLineItem.clear();
         for(PSRLineItems nextPLT :psrLIlst){
            for(cQuoteLineItem cCon : nextPLT.cQuoteLTLst)           
            {            
                if(cCon.selected == true)            
                {                
                selectedLineitems.add(cCon.item);            
                }  
                               
            }
         }
            
           
                
            List<Estimate__c> estList;
            List<Design__c> designList;    
            String pricebookId;    
            List<QuoteLineItem> estQLineItem = new List<QuoteLineItem>();
            List<QuoteLineItem> insertQLineItem = new List<QuoteLineItem>(); 

           
            if(selectedLineitems.size()>0){
            
                 for(QuoteLineItem lineItem : selectedLineitems){
                       QuoteLineItem item = lineItem.clone(false);

                       // if(item.UnitPrice >0)
                       //   item.UnitPrice =0;

                        item.quoteId=quoteId; 
                         
                         if(item.Design__c !=null){
                          
                            item.Design_Link__c = item.Design__c ; // 'https://' + hostAddress +'/' + item.Design__c;
                            item.Design_Name__c = item.Design__r.name ;
                            item.Design__c =null ;

             }
                         
                         if(item.Estimate__c !=null){
                            item.Estimate_Link__c = item.Estimate__c ;
                            item.Estimate_Name__c = item.Estimate__r.name ; // 'https://' + hostAddress +'/' + item.Estimate__c;
                            item.Estimate__c =null ;
             }

                      insertQLineItem.add( item);
                       
                    }
              
            
        }

          Savepoint sp = Database.setSavepoint();
         try{    

             
           
            //remove exist quote line items , not to total price product
           List<QuoteLineItem> delQLI = new List<QuoteLineItem>();
           List<QuoteLineItem> allQLI = [Select Id,UnitPrice,quantity,PriceBookEntry.Product2.name,PriceBookEntry.Product2.Product_Type__c from QuoteLineItem where QuoteId =:quoteid ];
           if(allQLI.size()>0){
               for(QuoteLineItem nextQLT: allQLI){
                    if(nextQLT.PriceBookEntry.Product2.name =='Total Price' && nextQLT.PriceBookEntry.Product2.Product_Type__c =='Total Price'){
                        nextQLT.UnitPrice = 0;
                       // nextQLT.quantity =0;
                        //nextQLT.totalPrice=0;
                        update nextQLT ;
                    }
                    else {
                        delQLI.add(nextQLT);
                    }
               }
           }


           if(delQLI.size()>0 && insertQLineItem.size()>0)
                delete delQLI ;

            //set price book entry if not set already 
            
            if(pricebookId==null && selectedLineitems.size()>0){
                Quote quotes = new Quote(Id=quoteId,PriceBook2Id=selectedLineitems[0].Quote.PriceBook2Id);
                //quotes.PriceBook2Id = designQLineItem[0].Quote.PriceBook2Id;
                update quotes;
            } 

            if(insertQLineItem.size()>0){
                insert insertQLineItem;
                status = true ;               
            // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Products Added Successfully'));
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Please select record and try again.'));
            }



           


        }

      catch(Exception ex){
             Database.rollback(sp);
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getDmlMessage(0)));
     }
     
     
     return null;
     
       
   }  


   public PageReference goToQuoteView(){
        Quote otObj =[select id from Quote where Id=:quoteid];
        PageReference pageRef = new ApexPages.StandardController(otObj).View();        
        pageRef.setRedirect(true);
        return pageRef;
        //return null;

   }
      
   

}