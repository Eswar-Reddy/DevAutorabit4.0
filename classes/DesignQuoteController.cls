/**
    *Created by: Accenture 
    * Created Date:27/4/2010
    * Last Updated Date/by:29/04/2010 Accenture
    * Purpose: This 
    *VERSION HISTORY*
    *27/4/2010 - Intial Design Framed for trigger
    *28/4/2010 - Review comment given
    *29/4/2010 - Incorporated the review comments
**/
/**
  * This class is used as a Controller for DesignQuoteController visual force page for manupulation of data or for implementing bussiness logic
**/ 
public without sharing class DesignQuoteController {
    public List<QuoteLineItem> productLists=null;
    public String designId {set;get;}
    private Design__c design;
    private Opportunity Oppcurrency;
    public String selectedFamily = '';
    List<SelectOption> family;
/**
  * Getter and setter for select family variable
**/
    Public String getSelectedFamily(){
        return selectedFamily;
    }
 
    public void setSelectedFamily(String fam){
        selectedFamily = fam;
    }
  
  /**
  * This method will return the size of quotelineitem object list
  **/
  
    public Integer getSize1(){
        if(productLists!=null)
            return productLists.size();
        else
            return 0;
    }
  
  /**
  * This method will return the list of product family value in the form of SelectObject object
  **/      

    public List<SelectOption> getFamily() {
       return Family;
    }

/**
  * This method is a constructor, used to initialization of the required field
**/
    public DesignQuoteController(){
        designId = System.currentPageReference().getParameters().get('id');
        family = getFamilyValue();  
        selectedFamily = System.currentPageReference().getParameters().get('selectedFamily');
        if(selectedFamily!=null){
            setSelectedFamily(selectedFamily);
        }
        
    }
/**
  * This method is used to fetch product details from the pricebbookentry object for the given pricebook id at design object
**/
    private List<SelectOption> getFamilyValue(){
        List<PricebookEntry> pe;
        Map<String,String> families = new Map<String,String>();
        List<SelectOption> options = new List<SelectOption>();
        design = [Select Id,Price_Book__c,Site__c,Opportunity__c from Design__c where Id =:designId];
        Oppcurrency = [Select Id, CurrencyIsoCode from Opportunity where Id =:design.Opportunity__c];
        //System.assert(false,design.Opportunity__r.CurrencyIsoCode);
        String testCall = System.currentPageReference().getParameters().get('TestCall');
        if(testCall!=null){
            pe = [Select IsActive,Product2Id, Pricebook2.Name,Product2.Family,
                                                                Product2.Name,
                                                                Product2.IsActive,Product2.Description,
                                                                UnitPrice,Product2.Quantity__c,Product2.Cost__c,Product2.Date__c
                                                                From PricebookEntry where 
                                                                Pricebook2Id =:design.Price_Book__c  
                                                                    and 
                                                                IsActive=true and CurrencyIsoCode = :Oppcurrency.CurrencyIsoCode
                                                                Order by Product2.Family desc limit 25
                                                                ];
        }else{
            pe = [Select IsActive,Product2Id, Pricebook2.Name,Product2.Family,
                                                                Product2.Name,
                                                                Product2.IsActive,
                                                                Product2.Description,UnitPrice,Product2.Quantity__c,Product2.Cost__c,Product2.Date__c
                                                                From PricebookEntry where 
                                                                Pricebook2Id =:design.Price_Book__c  
                                                                    and 
                                                                IsActive=true and CurrencyIsoCode = :Oppcurrency.CurrencyIsoCode
                                                                Order by Product2.Family desc
                                                                ];
         } 
        for(Integer i=0;i<pe.size();i++){
            if(!families.containsKey(pe[i].Product2.Family) && pe[i].Product2.Family!=null){
                families.put(pe[i].Product2.Family,pe[i].Product2.Family);
                options.add(new SelectOption(pe[i].Product2.Family,pe[i].Product2.Family));
            }
        }
        return options; 
    }  
/**
 * This method will call from visualforce page to update family
**/
    
    public PageReference updateFamily(){
        return null;
    }

/**
  * this method will call for initialization of design object for the given id
**/
    public PageReference init(){
        design = [Select Id,Price_Book__c,Site__c from Design__c where Id =:designId];
        PageReference pageRef = null;
        if(design.Price_Book__c==null || design.Price_Book__c=='' ||  design.Price_Book__c == 'None'){
            pageRef = Page.ChoosedesignPriceBook;
            pageRef.getParameters().put('id', design.id);
            pageRef.setRedirect(true);
        }
        return pageRef;
   }

/**
  * This method is used to fetch saved quoteline items from design object and initialize it with new value
**/

    private PricebookEntry[] getSearchProdsFromOpp() {
        PricebookEntry[] pricebooks = null;
        List<PricebookEntry> pricebookEntryList = new List<PricebookEntry>();  
        if((selectedFamily==null || selectedFamily.equals('')) && family!=null && family.size()>0){
            selectedFamily = family[0].getValue();  
        } 
        try{
            Design__c design = [Select Id, Price_Book__c,Site__c from Design__c where Id =:designId];
            PricebookEntry[] pe = [Select Id, IsActive,Product2Id, Pricebook2.Name,Product2.Family,
                                                            Product2.Name,
                                                            Product2.IsActive,Product2.Description,
                                                           
                                                            UnitPrice,Product2.Quantity__c,Product2.Cost__c,Product2.Date__c 
                                                            From PricebookEntry where 
                                                            Pricebook2Id =:design.Price_Book__c and 
                                                            Product2.Family = :selectedFamily 
                                                                and 
                                                            IsActive=true and CurrencyIsoCode = :Oppcurrency.CurrencyIsoCode
                                                            order by Product2.Family,Product2.Name
                                                           ];
            
            QuoteLineItem[] orderEntry = getQuoteLineItem(designId);
            for(PricebookEntry pricebook : pe){
                boolean val = false;
                for(QuoteLineItem ent : orderEntry){
                    if(ent!=null){
                        if(pricebook.Product2Id==ent.Product__c){
                            pricebook.UnitPrice = ent.UnitPrice;
                            pricebook.Product2.Quantity__c = ent.Quantity;
                            pricebook.Product2.Description=ent.Description;
                            pricebook.Product2.Cost__c=ent.Cost__c;
                            pricebook.Product2.Date__c=ent.ServiceDate;
                            val = true;
                            break;
                        }
                    }
                }
                
                if(val==false){
                    pricebook.IsActive = false;
                }else{
                    pricebook.IsActive = true;
                }
                pricebookEntryList.add(pricebook);
            }       
            pricebooks = new PricebookEntry[pricebookEntryList.size()];
            for(Integer i=0;i<pricebookEntryList.size();i++){
                pricebooks[i] = pricebookEntryList.get(i);      
                            
            }
                
        }catch(Exception e){                
               System.debug(e);
               ApexPages.addMessages(e);                    
               return null;

        }
       
        return pricebooks;
    }
    
    private  QuoteLineItem[] getQuoteLineItem(String designId) {
        QuoteLineItem[] prodOrderItem = null;
        prodOrderItem = [Select Id,Product__c,UnitPrice,Quantity,Description,IsActive__c,Cost__c,ServiceDate,Site__c
                                    from QuoteLineItem where design__c =:designId];
        return prodOrderItem;
    }   
    
/**
  * This method will add given list of quotelineitem to the productlist
**/
    public void setProductLists(List<QuoteLineItem> ls){
        this.productLists = ls;
        System.debug('New Product List'+this.productLists);
    }
          
    public List<QuoteLineItem> getProductLists(){
        PricebookEntry[] pe =  getSearchProdsFromOpp();
        if(pe!=null){                            
            productLists = new List<QuoteLineItem>();
            for(Integer i=0;i<pe.size();i++){
                QuoteLineItem prods = new QuoteLineItem();
                prods.Product__c = pe[i].Product2Id;
                prods.PricebookEntryId=pe[i].Id;
                prods.UnitPrice=pe[i].UnitPrice; 
                prods.Description=pe[i].Product2.Description;
                prods.Design__c = designId;
                prods.Site__c = design.Site__c;
                prods.IsActive__c=pe[i].IsActive;
                prods.Product_Name__c = pe[i].Product2.Name;
                prods.Cost__c = pe[i].Product2.Cost__c;
                prods.ServiceDate = pe[i].Product2.Date__c;
                prods.Quantity = ((pe[i].Product2.Quantity__c==null)?1:pe[i].Product2.Quantity__c);
                productLists.add(prods);
            }
        }
        return productLists;
    }

/**
  * This method will save and update quoteline items to the design object
**/
    public PageReference save1() {
        
            if(productLists.size()>0){
               List<QuoteLineItem> itemListSave = new List<QuoteLineItem>();
               QuoteLineItem[] oppLineItem = null;
               Quote quoteObj = null;
               try{
               oppLineItem = [Select 
                                Id,design__c,UnitPrice,Quantity,IsActive__c, Description,PricebookEntryId,Product__c,Cost__c,ServiceDate,Site__c 
                        from QuoteLineItem where design__c =:designId];
        PriceBook2 pb = null;
        String quoteName = null;
        
        try{
                  pb = [Select Id,Name from PriceBook2 where id = :design.Price_Book__c];
                  quoteName =  'DummyQuote ' + pb.Name + ' ' + Oppcurrency.CurrencyIsoCode;
                  // Done for Case # 00073764
                  // quoteObj = [Select Id,RecordType.DeveloperName from Quote where name=:quoteName];
                  quoteObj = [Select Id,RecordType.DeveloperName from Quote where name=:quoteName limit 1];
                  
        }catch (Exception e){
            
            RecordType rtypeId = null;
            try{
              rtypeId = [Select Id from RecordType where developername='Proposal_Quote' and SobjectType ='Quote'];
            }catch(Exception e1){
                System.debug('Record Type not found'+ e1);
            }   
          quoteObj = new Quote();
          quoteObj.Name = 'DummyQuote ' + pb.Name + ' ' + Oppcurrency.CurrencyIsoCode;
          
          List<Opportunity> oppList;
          List<Account> accList = [select id from Account where Name = 'DummyAccount'];
          if(accList.size()==0){
                Account testAccount = new Account();
                testAccount.Name = 'DummyAccount';
                testAccount.BillingCity = 'bangalore';
                testAccount.BillingCountry = 'India';
                testAccount.BillingStreet = 'MG Road';
                testAccount.BillingPostalCode = '126102';
                testAccount.Online_Order_Access__c = false;
                insert testAccount;
                accList.add(testAccount);
          }

          Schema.DescribeFieldResult fieldResult = Opportunity.CurrencyIsoCode.getDescribe();
          List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

          for( Schema.PicklistEntry f : ple){
                if(Oppcurrency.CurrencyIsoCode ==f.getValue()){
                    String dummyOpportunity = 'DummyOpportunity'+f.getValue();
                    oppList = [select id,CurrencyIsoCode from Opportunity where Name =:dummyOpportunity];
                    if(oppList.size()==0){
                        Opportunity opp = new Opportunity();
                        opp.AccountId = accList[0].id;
                        opp.Name = dummyOpportunity;
                        opp.CurrencyIsoCode = Oppcurrency.CurrencyIsoCode;
                        opp.CloseDate = System.today().addDays(14);
                        opp.Sales_Steps__c = 'Shortlisted';
                        opp.Contract_Type__c = 'Design';
                        opp.Financing__c = 'PPA';
                        opp.Business_Unit__c = 'Utility';
                        opp.Region__c = 'New York';
                        opp.StageName = 'Open';
                        opp.Probability = 5;
                        opp.Budgetary_Pricing_Agreed_On_Date__c = System.today();
                        insert opp;
                        oppList.add(opp);
                        
                        try{
                            
                            Group gr = [Select Id from Group where name = 'Sunpower All Internal Users'];
                            
                            OpportunityShare oppShare = new OpportunityShare();
                            oppShare.OpportunityId = opp.id;
                            oppShare.OpportunityAccessLevel='Edit';
                            oppShare.UserOrGroupId = gr.Id;
                            insert oppShare;
                        }catch(Exception exc){
                            System.debug('Sharing Failed');                         
                        }
                            
                        
                    }
                    break;
                }
          }
            
          quoteObj.RecordTypeId = rtypeId.id;   
          quoteObj.OpportunityId = oppList[0].id;
          quoteObj.Pricebook2Id = design.Price_Book__c;
          insert quoteObj;
        }   
                                       
               }catch(Exception e){                
                      System.debug('Error>>'+e);
                      ApexPages.addMessages(e);                    
                      return null;
               }
               
                for(QuoteLineItem prod:productLists){
                if(prod.isActive__c){
                    boolean added=false;
                     for(QuoteLineItem item :oppLineItem ){
                        if(item.design__c == prod.design__c && item.product__c == prod.Product__c){
                            added = true;
                            item.UnitPrice = prod.UnitPrice;
                            item.Quantity = prod.Quantity;
                            item.Description = prod.Description;
                            item.Product__c = prod.Product__c;
                            item.Cost__c = prod.Cost__c;
                            item.ServiceDate = prod.ServiceDate;
                            item.Site__c = prod.Site__c;   
                        }
                     }
                         if(!added){
                         	system.debug('-----added--------');
                            prod.quoteId=quoteObj.Id;
                            prod.design__c = designId;
                            itemListSave.add(prod);
                         }
                    }
                }
                             
                if(itemListSave.size()>0){
                    try{
                        insert itemListSave;
                    }catch(Exception e){
                        System.debug('insert>>>'+e);
                       // System.assert(false,'insert>>>'+e + ' SObject>>>'+itemListSave);
                        ApexPages.addMessages(e);
                        return null;

                    }
                }
                if(oppLineItem !=null && oppLineItem.size()>0){
                    try{
                        update oppLineItem;
                    }catch(Exception e){
                        System.debug('update>>>'+e);
                        ApexPages.addMessages(e);
                        return null;
                        //System.assert(false,'update>>>'+e);
                    }
                }
                    
            }
            
            PageReference pageRef = new PageReference('/'+designId);
            pageRef.setRedirect(true);
            return pageRef;   
    }

/**
  * This method will call from cancel button of VisualForce page. So the design view page will display
**/
    public PageReference cancel() {
        PageReference pageRef = new PageReference('/'+designId);
        pageRef.setRedirect(true);
        return pageRef;
    }

}