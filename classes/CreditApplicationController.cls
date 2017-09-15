public class CreditApplicationController{
    //begin
    public static Map<String, Schema.RecordTypeInfo> nameToCARecordTypeInfoMap;    
    static {
      nameToCARecordTypeInfoMap = Schema.SObjectType.Credit_Application__c.getRecordTypeInfosByName();        
    }
    //end
    public Credit_Application__c creditApp{get;set;} 
    public String accountId {get;set;} 
    public String creditAppId {get;set;} 
    private List<Attachment> attachments;    
    
    public List<Attachment> getAttachments(){
        if(attachments == null){
            attachments = new List<Attachment>
                ([Select Id, Name , ContentType, LastModifiedBy.Name, CreatedBy.Name from Attachment where ParentId=:creditAppId]);
        }
        return attachments;
    }
    
    public void setAttachments(List<Attachment> attachments){
        this.attachments = attachments;
    }
    public CreditAppAttachment__c notesattach {get;set;}
    public String parentId{get;set;}
    public String idToRemove{get;set;}
    private Boolean renderAttachedFiles;
    public Boolean getRenderAttachedFiles(){
        if(attachments != null && attachments.Size()>0)
           return true;
        else
            return false;  
    }
    public String getParentId(){
        return parentId;
    }
   
    //constructor    
    public CreditApplicationController(ApexPages.StandardController controller) {
        creditApp = (Credit_Application__c)controller.getRecord();
        
        accountId = ApexPages.currentPage().getParameters().get('aid');
        List<Account> lstAccount = null;
        if (accountId != null && accountId != ''){
            //handling invalid id error
           try{ 
                  creditApp.Account__c = accountId;
                  lstAccount = [select id, name, BillingStreet, BillingState, BillingPostalCode,BillingCountry, BillingCity,
                              ShippingStreet, ShippingState, ShippingPostalCode, ShippingCountry, ShippingCity, NumberOfEmployees, Phone,Theater__c
                              FROM Account WHERE id=:accountId];
            }
            catch(Exception ex){
                    //ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.WARNING ,ex.getMessage());
                    //ApexPages.addMessage(msg);
            }                         
            if(lstAccount != null && lstAccount.size() > 0){                
                Account accountObj = lstAccount.get(0);

                creditApp.Legal_Company_Name__c = accountObj.Name;             
                creditApp.Number_of_Employees__c = accountObj.NumberOfEmployees;
                 
                creditApp.Bill_To_Phone__c = accountObj.Phone;
                creditApp.Bill_To_Zip__c = accountObj.BillingPostalCode;
                creditApp.Bill_To_State__c = accountObj.BillingState;
                creditApp.Bill_To_Country__c = accountObj.BillingCountry;
                creditApp.Bill_To_City__c = accountObj.BillingCity;
                creditApp.Bill_To_Address__c = accountObj.BillingStreet;
                 
                creditApp.Ship_To_Zip__c = accountObj.ShippingPostalCode;
                creditApp.Ship_To_State__c = accountObj.ShippingState;
                creditApp.Ship_To_Country__c = accountObj.ShippingCountry;
                creditApp.Ship_To_City__c = accountObj.ShippingCity;
                creditApp.Ship_To_Address__c = accountObj.ShippingStreet;
                creditApp.Account__c = accountObj.id;  
                
                 if(accountObj.Theater__c == 'Europe') {
                    
                    creditApp.RecordTypeId = nameToCARecordTypeInfoMap.get('EU Credit Application').getRecordTypeId();
                }
                else{
                    
                    creditApp.RecordTypeId = nameToCARecordTypeInfoMap.get('NA Credit Application').getRecordTypeId();
                    
                } 
                
               
               
                
                
                             
            }
        }              
    }
    
    //on each step data will be saved by this function
    public Boolean saveCreditApplication(){
        try{
            if (creditApp.Id == null) {
                List<Group> creAppQueue = [Select Id From Group where Name = 'Credit Application Queue' and Type ='Queue'];
                if (creAppQueue.size() > 0) {
                    creditApp.OwnerId = creAppQueue[0].Id;
                }
                /**************************************/ 
                
                
                               
                insert creditApp;
            } else { 
                update creditApp;
            }
        }
        catch(Exception ex){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage());
            ApexPages.addMessage(msg);
            return false;
        }
         
        creditAppId=creditApp.Id;        
        return true;
    }
 
 
  
    //Function to save all attachments in list & to show on page
    public PageReference showAttachedFiles() {
      List<Attachment> listAttachment = new List<Attachment>([Select Id, Name , ContentType,  LastModifiedBy.Name, CreatedBy.Name from Attachment where ParentId=:creditAppId]);
      if(listAttachment.Size()>0) {
          attachments = listAttachment;
      } 
      return null;
    }
    //to remove attched files in attachements
    public PageReference remove(){
        if(idToRemove != null){
            List<Attachment> listAtt = new List<Attachment>([Select Id, Name from Attachment where ParentId=:creditAppId  and Id=:idToRemove limit 1]);
            if(listAtt.Size()>0) {
                delete listAtt;
                attachments = new List<Attachment>();
                List<Attachment> listAttachment = new List<Attachment>([Select Id, Name , ContentType,  LastModifiedBy.Name, CreatedBy.Name from Attachment where ParentId=:creditAppId]);
                if(listAttachment.Size()>0) {
                    attachments = listAttachment;
                }   
            }
        }
         return null;
    } 
    
     /***** steps for English version *****/
     
    public PageReference cancel(){        
        creditApp=new Credit_Application__c(); 
        creditAppId=null; 
        attachments=null;        
        return Page.CreditApp_1;
    }      
     
    public PageReference step1(){        
        return Page.CreditApp_1;
    } 

    public PageReference step2(){
        // nothing to save yet.        
        return Page.CreditApp_2;
    } 
   
    public PageReference step3(){
        //Validation added against the validation rule created on credit application object
        if(creditApp.VAT_Number__c == null && creditApp.Federal_Tax_ID__c == null){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.ERROR, 'Please enter either a Federal Tax ID or VAT Number.');
            ApexPages.addMessage(msg);
            return null;
        }          
        return Page.CreditApp_3;
    } 
    
     //save data of English version
     //submit button
    public PageReference step4(){
        creditApp.status__c = 'New';     
        PageReference pr;
        if(saveCreditApplication()){
            pr = Page.CreditApp_4;
        }
        return pr;    
    }    
    
    /******For EU ************/
    
     public PageReference cancel_EU(){
        creditApp=new Credit_Application__c(); 
        creditAppId=null; 
        attachments=null;        
        return Page.EU_CreditApp_1;
    }    
        
     public PageReference step1_EU(){        
        return Page.EU_CreditApp_1;
    } 

    public PageReference step2_EU(){
        // nothing to save yet.
        return Page.EU_CreditApp_2;
    } 
    public PageReference step3_EU(){
        //Validation added against the validation rule created on credit application object
        if(creditApp.VAT_Number__c == null && creditApp.Federal_Tax_ID__c == null){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.ERROR, 'Please enter either a Federal Tax ID or VAT Number.');
            ApexPages.addMessage(msg);
            return null;
        }
        return Page.EU_CreditApp_3;
    } 

    //save data of EU Version
     public PageReference step4_EU(){
        creditApp.status__c = 'New';
        PageReference pr;
        if(saveCreditApplication()){
            pr = Page.EU_CreditApp_4;
        }    
        return pr; 
     }      
}