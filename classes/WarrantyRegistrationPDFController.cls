public class WarrantyRegistrationPDFController{
    
    public static Warranty_Registration__c warranty{get;set;}    
    //public static List<WR_Line_Item__c> wProducts{get;set;}
    public static List<List<pdfWrapper>> wProductsWrapper{get;set;}
    public static Integer sNum{get;set;}
    
    public WarrantyRegistrationPDFController(){
       try{ 
       /* warranty = [SELECT Customer_SFDC_ID__r.Name,Customer_SFDC_ID__r.FirstName,Customer_SFDC_ID__r.PersonDepartment,Customer_SFDC_ID__r.Contact_Name__c, Customer_SFDC_ID__r.PersonMobilePhone,Customer_SFDC_ID__r.Email__c, Customer_SFDC_ID__r.Phone, Customer_SFDC_ID__r.BillingStreet, Customer_SFDC_ID__r.BillingCity, Customer_SFDC_ID__r.BillingState,Customer_SFDC_ID__r.BillingCountry, Customer_SFDC_ID__r.BillingPostalCode,
        Partner_SFDC_ID__r.Country_Domain__c,Partner_SFDC_ID__r.Name, Partner_SFDC_ID__r.PersonMobilePhone,Partner_SFDC_ID__r.Email__c, Partner_SFDC_ID__r.Phone, Partner_SFDC_ID__r.BillingStreet, Partner_SFDC_ID__r.BillingCity, Partner_SFDC_ID__r.BillingState, Partner_SFDC_ID__r.BillingPostalCode,
        Delivery_Date__c,
        (Select Id, WR_FDS_Product__r.Product_Name__c,WR_FDS_Product__r.Product_Type__c, WR_FDS_Product__r.Serial_Number__c From WR_Line_Items__r ORDER BY WR_FDS_Product__r.Product_Type__c DESC  limit 999)
        FROM Warranty_Registration__c WHERE Id =: apexpages.currentpage().getParameters().get('warrantyId')].get(0); 
           */  
           //sNo = 0;
           sNum = 0;
        warranty = [SELECT Warranty_Number__c, Customer_SFDC_ID__r.Name,Customer_SFDC_ID__r.FirstName,Customer_SFDC_ID__r.PersonDepartment,Customer_SFDC_ID__r.Contact_Name__c, Customer_SFDC_ID__r.PersonMobilePhone,Customer_SFDC_ID__r.Email__c, Customer_SFDC_ID__r.Phone, Customer_SFDC_ID__r.BillingStreet, Customer_SFDC_ID__r.BillingCity, Customer_SFDC_ID__r.BillingState,Customer_SFDC_ID__r.BillingCountry, Customer_SFDC_ID__r.BillingPostalCode,
                    Partner_SFDC_ID__r.Country_Domain__c,Partner_SFDC_ID__r.Name, Partner_SFDC_ID__r.PersonMobilePhone,Partner_SFDC_ID__r.Email__c, Partner_SFDC_ID__r.Phone, Partner_SFDC_ID__r.BillingStreet, Partner_SFDC_ID__r.BillingCity, Partner_SFDC_ID__r.BillingState, Partner_SFDC_ID__r.BillingPostalCode, Partner_SFDC_ID__r.BillingCountry, Partner_SFDC_ID__r.Website,
                    Delivery_Date__c 
                    FROM Warranty_Registration__c WHERE Id =: apexpages.currentpage().getParameters().get('warrantyId')].get(0);  
        //wProducts = warranty.WR_Line_Items__r; 
        //wProducts = [Select Id, WR_FDS_Product__r.Product_Name__c,WR_FDS_Product__r.Product_Type__c, WR_FDS_Product__r.Serial_Number__c From WR_Line_Item__c where Warranty_Registration__c =: warranty.Id ORDER BY WR_FDS_Product__r.Product_Type__c DESC ];
       // wProducts = [Select Id, WR_FDS_Product__r.Product_Name__c,WR_FDS_Product__r.Product_Type__c, WR_FDS_Product__r.Serial_Number__c From WR_Line_Item__c ORDER BY WR_FDS_Product__r.Product_Type__c DESC  limit 10000];
        //integer cnt = 0;
        //Uncomment below line for View State size error
        //wProducts = [Select Id, WR_FDS_Product__r.Product_Name__c,WR_FDS_Product__r.Product_Type__c, WR_FDS_Product__r.Serial_Number__c From WR_Line_Item__c where Warranty_Registration__r.Partner_SFDC_ID__c =:Warranty.Partner_SFDC_ID__c ORDER BY WR_FDS_Product__r.Product_Type__c DESC limit 1200];
        wProductsWrapper = new List<List<pdfWrapper>>();
        List<pdfWrapper> wProductsInnerList = new List<pdfWrapper>();
        //wProducts = new List<WR_Line_Item__c>();
        pdfWrapper lastRec = null;
        for(WR_Line_Item__c wrLineItem :[Select Id, WR_FDS_Product__r.Product_Name__c,WR_FDS_Product__r.Product_Type__c, WR_FDS_Product__r.Serial_Number__c From WR_Line_Item__c where Warranty_Registration__c =: warranty.Id ORDER BY WR_FDS_Product__r.Product_Type__c DESC /*limit 8000*/]){
            sNum++; //cnt++;
            if(sNum == 25){ 
                wProductsInnerList.add(new pdfWrapper(sNum,wrLineItem,true));
                //cnt = 0;
            }
            else if(sNum > 25 && Math.mod((sNum - 25),38) == 0){
                    lastRec = new pdfWrapper(sNum,wrLineItem,true);
                    wProductsInnerList.add(lastRec);
                    //cnt = 0;
            }
            else{
                wProductsInnerList.add(new pdfWrapper(sNum,wrLineItem,false));
            }
            if(wProductsInnerList.size()>=1000){
               wProductsWrapper.add(wProductsInnerList);
               wProductsInnerList = new List<pdfWrapper>();
            }    
            
            //wProducts.add(wrLineItem);
            
        }
        
          if(sNum > 25 && Math.mod((sNum - 25),38) == 0){
                lastRec.isPageBrk = false;
            }
            
            if(wProductsInnerList.size() > 0){
                wProductsWrapper.add(wProductsInnerList);
            }
        //system.debug('===== ' + wProducts.size());   
        
    
      }catch(Exception ex){
        System.debug('------ Unexpected error ----'+ex.getMessage());
      } 
    } 
    
    public class pdfWrapper{
        public integer sNo{get;set;}
        public WR_Line_Item__c wrLineItem{get;set;}
        public boolean isPageBrk{get;set;}
        public pdfWrapper(integer sNo, WR_Line_Item__c wrLineItem,boolean isPageBrk){
            this.sNo = sNo;
            this.wrLineItem = wrLineItem;
            this.isPageBrk = isPageBrk;
        }
    }
}