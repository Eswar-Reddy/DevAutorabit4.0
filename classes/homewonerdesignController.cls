public without sharing class homewonerdesignController {

    private final Opportunity oppty{get; set;}
    public Opportunity_Design__c opdesign{get;set;}
    public boolean crcaptured{get; set;}
    public boolean displayComments{get; set;}
    public boolean showcrPanel{get;set;}
    public boolean showStatusPanel{get;set;}
    public boolean authFailed{get;set;}
    public String response = '';
    public String opportunityStatus{get;set;}

    
    public homewonerdesignController() {
        response='Yes';
        showStatusPanel=false;
        showcrPanel=false;
        oppty=[SELECT Name,Customer_Response_Comments__c,Design_Photo__c,Opportunity_Number__c,Design_Status__c FROM Opportunity 
                   WHERE Id = :ApexPages.currentPage().getParameters().get('oid')];
                   
        List<Opportunity_Design__c> opdList = [select Opportunity__c,Design_Photo__c,Customer_Response_Comments__c from Opportunity_Design__c where Opportunity__c =:oppty.Id];
        
        if(opdList!=null && opdList.size()>0){
            opdesign=opdList[0];
            //showCRPanel=true;
            if(oppty.Design_Status__c=='' || oppty.Design_Status__c==null || oppty.Design_Status__c=='Customer Declined to Sign'){
                opportunityStatus='Waiting on Design Submission';
                showcrPanel=false;
                showStatusPanel=true;
            }
            else if(oppty.Design_Status__c=='Design Sent to Customer' || oppty.Design_Status__c=='No Customer Response'){
                showcrPanel=true;
                showStatusPanel=false;
            }
            else if(oppty.Design_Status__c=='Final Design Approved'){
                opportunityStatus='Final Design\'s already been Approved';
                showcrPanel=false;
                showStatusPanel=true;
            }
            else if(oppty.Design_Status__c=='Customer Declined Design'){
                opportunityStatus='Waiting on Resubmission';
                showcrPanel=false;
                showStatusPanel=true;
            }
        }
        else{
            showCRPanel=false;
            //ApexPages.addMessages();
        }
        
    }
    
    public Opportunity getOppty() {
        return oppty;
    }
    
    public List<SelectOption> getItems() {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('Yes','Yes'));
            options.add(new SelectOption('No','No'));
            return options;
    }

    public String getString() {
        return response;
    }
                        
    public void setString(String response) {
        this.response = response;
    }
    
    public PageReference responseToggle() {
        if(response=='No')
            displayComments=true;
        else
            displayComments=false;
        return null;
    }
    
    public pagereference saveOppty(){
        //oppty.CRPOC__c=response;
        Datetime dt = Datetime.now();
        String dateString = dt.format('MM/dd/yyyy');
        
        if(response=='No' && (opdesign.Customer_Response_Comments__c!=null && opdesign.Customer_Response_Comments__c!='')){
            if(oppty.Customer_Response_Comments__c!=null){
                oppty.Customer_Response_Comments__c=oppty.Customer_Response_Comments__c+'\r\n\r\n'+'---------- '+dateString+' ----------'+'\r\n'+opdesign.Customer_Response_Comments__c;
            }
            else
                oppty.Customer_Response_Comments__c='---------- '+dateString+' ----------'+'\r\n'+opdesign.Customer_Response_Comments__c;
        }
        
        if(response=='Yes'){
            oppty.Design_Status__c='Final Design Approved';
        }
        else if(response=='No'){
            oppty.Design_Status__c='Customer Declined Design';
        }
        
        try{
            update oppty;
            crcaptured=true;
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ''+e.getMessage()));
        }   
        
        return null;
    }
    
    
    public void authenticateOpportunityID(){
        if(oppty.Opportunity_Number__c!=ApexPages.currentPage().getParameters().get('on')){
            showcrPanel=false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Authentication Failed. Invalid Combination of Opportunity Id and Opportunity Number'));
        }
    }
}