public with sharing class RenderACHformAsPdf{
    
    public static String contactName{get; set;} //Display Contact Name on Cover Letter
    public static String contractNumber{get; set;} //Display Contract Number on Agreement
    public String displayTodaysDate{get; set;}//Display date in MONTH DD,YYYY format
    
    public RenderACHformAsPdf(){
        
        //Query to get all required details from Agreement Object 
        List<echosign_dev1__SIGN_Agreement__c> aggList =  [select Id,Name, echosign_dev1__Recipient__c,echosign_dev1__Recipient__r.name,
                                                           echosign_dev1__Recipient2__c,echosign_dev1__Recipient2__r.name,
                                                           echosign_dev1__Recipient2__r.Include_in_Lease_Doc__c ,
                                                           Lease_Number__c 
                                                           from echosign_dev1__SIGN_Agreement__c where id=:ApexPages.currentPage().getParameters().get('aggId')];
        
        
        echosign_dev1__SIGN_Agreement__c agreement = new echosign_dev1__SIGN_Agreement__c();
        if(aggList.size() > 0){
            agreement = aggList[0]; //Assigning Object
        }
        
        //add contact name details
        if(agreement!= null && agreement.echosign_dev1__Recipient__c != null){
            contactName = String.valueOf(agreement.echosign_dev1__Recipient__r.name);  // Recipient (Contact) Name
            
        }
        
        //add contract information
        if(agreement.Lease_Number__c != null ){
            contractNumber=String.valueOf(agreement.Lease_Number__c); // Contract Number
            
        } 
        
        Datetime myDatetime = Datetime.now();
        displayTodaysDate= myDatetime.format('MMMM d,  yyyy');
    }
}