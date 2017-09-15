public class GenerateWarranty_CLS {

    public List<WarRegnWrapper> lstWrap {get; set;}   
    
    public GenerateWarranty_CLS (ApexPages.StandardController controller) {
        viewDetails();
    }
 
     
    public void viewDetails() {
        List<WR_Line_Item__c> lstWRLineItem = [SELECT Id, Name, Warranty_Registration__c, WR_FDS_Product__r.Serial_Number__c,Product_Type__c,Product_Name__c FROM WR_Line_Item__c
                                              where Product_Type__c like '%Module%' and Product_Name__c like '%SPR%' and Warranty_Registration__c=:ApexPages.currentPage().getParameters().get('Id') order by WR_FDS_Product__r.Serial_Number__c ASC];       
                                            //   where Product_Type__c like '%Module%' and WR_FDS_Product__r.Item__r.Description__c like '%SPR%' and Warranty_Registration__c=:ApexPages.currentPage().getParameters().get('Id') order by WR_FDS_Product__r.Serial_Number__c ASC];        
                                           //   where  Warranty_Registration__c='a1U80000000LcPm' ];        
        WarRegnWrapper wrWrap;
        
                   
        lstWrap = new List<WarRegnWrapper>();
        for(Integer i=0; i<lstWRLineItem.size(); i++) {
            if((i-5*Integer.valueOf(i/5) == 0)) {
                wrWrap = new WarRegnWrapper();
                wrWrap.Col0 = lstWRLineItem[i].WR_FDS_Product__r.Serial_Number__c;
            }
            else if((i-5*Integer.valueOf(i/5) == 1)) {
                wrWrap.Col1 = lstWRLineItem[i].WR_FDS_Product__r.Serial_Number__c;
            }          
            else if((i-5*Integer.valueOf(i/5) == 2)) {
                wrWrap.Col2 = lstWRLineItem[i].WR_FDS_Product__r.Serial_Number__c;
            }
            else if((i-5*Integer.valueOf(i/5) == 3)) {
                wrWrap.Col3 = lstWRLineItem[i].WR_FDS_Product__r.Serial_Number__c;
            }
            else if((i-5*Integer.valueOf(i/5) == 4)) {
                wrWrap.Col4 = lstWRLineItem[i].WR_FDS_Product__r.Serial_Number__c;
                lstWrap.add(wrWrap);
            }  
        }

        if( lstWRLineItem.size() - 5*Integer.valueOf(lstWRLineItem.size()/5) < 5 &&
            lstWRLineItem.size()- 5*Integer.valueOf(lstWRLineItem.size()/5) != 0 ) {
            lstWrap.add(wrWrap);
        }        
    } 
    
 
 
// Wrapper Class
    public class WarRegnWrapper {
        public string Col0 {get; set;}
        public string Col1 {get; set;}
        public string Col2 {get; set;}
        public string Col3 {get; set;}
        public string Col4 {get; set;}
    }   
 
 
 
/*    List<WR_Line_Item__c> wrli=new List<WR_Line_Item__c>();
    
        
    public List<WR_Line_Item__c> getSerialNumbers() {
        String value = ApexPages.currentPage().getParameters().get('id');
        System.debug('----------'+value);  

        string wrsoql='SELECT  WR_Line_Item__c.WR_FDS_Product__r.Serial_Number__c FROM WR_Line_Item__c where Warranty_Registration__c=\'' +value+'\' '; 
        System.debug('--------'+wrsoql); 

        //wrli = [SELECT  WR_Line_Item__c.WR_FDS_Product__r.Serial_Number__c FROM WR_Line_Item__c where Warranty_Registration__c=+'wid'] ; 
        wrli=Database.query(wrsoql); 
        SerialNumberCount=String.ValueOf(wrli.size());
        System.debug('---size'+SerialNumberCount);
        return wrli;
    }    
*/
}