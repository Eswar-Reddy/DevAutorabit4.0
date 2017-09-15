public with sharing class RenderAsPDf{
    
    
    public static Address billingAddress{get; set;} //show address
    Public static Account acc;
    public static String showAddress{get; set;} //show address
    public static String contactName='';
    public static String contractNumber='';
    Public static List<Contract> contract;
    
    public RenderAsPDf(){
        
    }
    
    
    static{
        
       // acc=[Select acc.Owner.Name,acc.Primary_Contact__c,acc.Name,acc.Include_in_Lease_Doc__pc,acc.BillingAddress from Account acc where acc.id=:ApexPages.currentPage().getParameters().get('Id')];
          acc=[Select acc.Owner.Name,acc.Primary_Contact__c,acc.Name,acc.Include_in_Lease_Doc__pc,acc.BillingCity,acc.BillingCountry,acc.BillingPostalCode,acc.BillingState,acc.BillingStreet from Account acc where acc.id=:ApexPages.currentPage().getParameters().get('Id')];
      //  contract=[Select ContractNumber from Contract where AccountId=:ApexPages.currentPage().getParameters().get('Id') LIMIT 1];
          List<echosign_dev1__SIGN_Agreement__c> aggList =  [select Id , echosign_dev1__Recipient__c,echosign_dev1__Recipient__r.name,
                                                                    echosign_dev1__Recipient2__c,echosign_dev1__Recipient2__r.name,
                                                                    echosign_dev1__Recipient2__r.Include_in_Lease_Doc__c ,
                                                                    Lease_Number__c 
                                                             from echosign_dev1__SIGN_Agreement__c where id=:ApexPages.currentPage().getParameters().get('aggId')];
        showAddress='';
        //if(acc !=null ){
            
            //showName=String.valueOf(acc.Name);
           // billingAddress=acc.BillingAddress; 
            //showAddress='';
            //showAddress=String.valueOf(acc.Name);
       // }
        
        
      /*  for (Contact con :[SELECT Name,Include_in_Lease_Doc__c FROM Contact WHERE Contact.AccountId =:ApexPages.currentPage().getParameters().get('Id') AND Include_in_Lease_Doc__c =TRUE limit 1]){
            
            //if(con.Include_in_Lease_Doc__c){
                
                contactName=contactName+' '+con.Name;
                     
           // }
           
        }*/
        
        echosign_dev1__SIGN_Agreement__c agreement = new echosign_dev1__SIGN_Agreement__c();
        if(aggList.size() > 0){
           agreement = aggList[0];
           
        }
        
        /*if(contactName != null && !contactName.equalsIgnoreCase('')){
            showAddress=contactName+'<br/>'+showAddress;
        }
        
        if(contract.size()>0){
            
            contractNumber=String.valueOf(contract[0].ContractNumber );
            showAddress=showAddress+'<br/>'+contractNumber;
        }*/
        
        //add contact name details
        if(agreement!= null && agreement.echosign_dev1__Recipient__c != null){
            contactName = agreement.echosign_dev1__Recipient__r.name;
           if(contactName != null && !contactName.equalsIgnoreCase('')){
            showAddress=contactName;
           } 
        }
        
        //add co lessee name information
        if(agreement!= null && agreement.echosign_dev1__Recipient2__c != null){
            contactName = agreement.echosign_dev1__Recipient2__r.name;
            if(null != agreement.echosign_dev1__Recipient2__r.Include_in_Lease_Doc__c){
               if(agreement.echosign_dev1__Recipient2__r.Include_in_Lease_Doc__c){
                   if(contactName != null && !contactName.equalsIgnoreCase('')){
                        showAddress=showAddress+'<br/>'+contactName;
                   }     
                }
            }
        }
        
        //add contract information
        if(agreement.Lease_Number__c != null ){
           contractNumber=String.valueOf(agreement.Lease_Number__c);
           showAddress=showAddress+'<br/>'+ 'Contract # ' +contractNumber;
        } 
                
      /* if(contactName != null && !contactName.equalsIgnoreCase('')){
          showAddress=contactName+'<br/>'+showAddress;
       } */
        
        if(acc !=null){
            showAddress=showAddress +'<br/>'+String.valueOf(acc.BillingStreet)+'<br/>'+String.valueOf(acc.BillingCity)+',  ' +String.valueOf(acc.BillingState)+'  '+String.valueOf(acc.BillingPostalCode)+'<br/>'+String.valueOf(acc.BillingCountry);
            
        }
        
        
    }
 
}