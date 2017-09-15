public class PriceBookdesignController {
    
    public String designId {set;get;}
    public List<SelectOption> priceBook;
    Design__c design = new Design__c();
    public Design__c getDesign() {
        return design;
    }   
    public PriceBookdesignController(){
         designId = System.currentPageReference().getParameters().get('id');
         design =[Select Id,Price_Book__c from Design__c
                 where id =:designId
                 ];
        priceBook = getPriceBookValue();
    }
    
    public PageReference init(){
         Design__c order = [Select Id  from Design__c where Id =:designId];
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
        PageReference pageRef = new PageReference('/'+designId);
        pageRef.setRedirect(true);
        return pageRef; 
        //return null;
    }


    public PageReference save() {
        
        PriceBook2 pb = null;
        if(design.Price_Book__c!=null && design.Price_Book__c!='None' ){
            pb = [Select Id,Name from PriceBook2 where id = :design.Price_Book__c];
            design.Price_Book__c = pb.Id;
        }
        
        upsert design;
        PageReference pageRef = null;
        if(design.Price_Book__c!=null && design.Price_Book__c!='None' ){
            pageRef = Page.DesignQuoteController;
            pageRef.getParameters().put('id', designId);
        }else{
            pageRef = new PageReference('/'+designId);
        }
        pageRef.setRedirect(true);
        return pageRef; 
        //return null;
    }
    
    
}