public class PriceBookController {
    
    public String estimateId {set;get;}
    public List<SelectOption> priceBook;    
    
    //Case#00065911 
    public Boolean hasProducts {get;set;}
    
    Estimate__c estimate = new Estimate__c();
    public Estimate__c getEstimate() {
        return estimate;
    }   
    public PriceBookController(){
         estimateId = System.currentPageReference().getParameters().get('id');
         estimate =[Select Id,Price_Book__c from Estimate__c
                 where id =:estimateId
                 ];
        priceBook = getPriceBookValue(); 
        
        //Case#00065911    
        checkProductAssociated();  
    }
    
    public PageReference init(){
         Estimate__c order = [Select Id  from Estimate__c where Id =:estimateId];
         PageReference pageRef = null; 
        return pageRef;
    }
    
     private List<SelectOption> getPriceBookValue() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('None','None'));
        
        PriceBook2[] pb = [Select Id,Name from PriceBook2 where IsActive =true];
      for (PriceBook2 entry : pb){
        options.add(new SelectOption(entry.Id,entry.Name));
      }
      return options;
       
   }
     public List<SelectOption> getPriceBook() {
       
      return priceBook;
       
   }
    public PageReference cancel() {
        PageReference pageRef = new PageReference('/'+estimateId);
        pageRef.setRedirect(true);
        return pageRef; 
        //return null;
    }


    public PageReference save() {  
    	//Case#00065911     	
    	deleteProductAssociated();
    		    		
        PriceBook2 pb = null;
        if(estimate.Price_Book__c!=null && estimate.Price_Book__c!='None' ){
            pb = [Select Id,Name from PriceBook2 where id = :estimate.Price_Book__c];
            estimate.Price_Book__c = pb.Id;
        }else
        	estimate.Price_Book__c = null;
        	        
        upsert estimate;
        PageReference pageRef = null;
        if(estimate.Price_Book__c!=null && estimate.Price_Book__c!='None' ){
            pageRef = Page.estimateQuoteController;
            pageRef.getParameters().put('id', estimateId);
        }else{
            pageRef = new PageReference('/'+estimateId);
        }
        pageRef.setRedirect(true);
        return pageRef; 
        //return null;
    }   
    
    //Case#00065911 start
    //check if any product associated with the estimate
    private void checkProductAssociated(){
    	hasProducts = [SELECT count() FROM QuoteLineItem WHERE Estimate__c = : estimateId ] > 0;
         if(hasProducts)
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,
        	'There are some products associated with this Estimate.'));     	
    } 
    
    //delete all associated products
    private void deleteProductAssociated(){
    	if(hasProducts){
    		List<QuoteLineItem> products = [SELECT Id FROM QuoteLineItem WHERE Estimate__c = : estimateId ];
        	delete products;
    	}
    } //Case#00065911 end
    
}