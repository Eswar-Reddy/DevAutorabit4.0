/* Class Added to Send Emails To All Related Email Address Whenever SPVT to Case CheckBox gets Changed */
public class sendEmailSPVTClass {
    
    public static String [] toArray= new List<String>();//Array to get All To mailaddress
    
    public static String [] ccArray= new List<String>(); //Array to get All CC mailaddress
    
    public static String [] bccArray =new List<String>(); // //Array to get All BCC mailaddress
    public static String body=''; //Empty Body 
    
    public static String subject='';//Empty Subject
    
    public static List<LeasePayment__c> financialPayment; //ObjectsList on which Email is getting fired
    public static Account acc; // Master Object of Financial Payment to get all related users email address
    public static List<SPVTBCCEMailsSend__c> bccEmailsCustomSetting= SPVTBCCEMailsSend__c.getall().values(); //Get email address from Custom Setting
    public static Map<String,List<String>> accountContactRoleEMailsCollection=new Map<String,List<String>>();
    static List <Messaging.SingleEmailMessage> mails =new List<Messaging.SingleEmailMessage>();//Object to send Emails
    static OrgWideEmailAddress orgWideEMailAddress;// Set Display Name for FROM Address
    static String emailSignatureLabel=Label.SPVT_case_to_SunPower_Signature;
    public sendEmailSPVTClass (){
   
    } 
    
    /* ******************************************************************************************************************************************************************************
Method      : sendSingleEmail
Parameters  : List<String>
Return Type : Void
Summary     : Function accept List of Financial Payment Object Ids and Send emails to corresponding users whenever there SPVT TO CASE check box is checked
******************************************************************************************************************************************************************************* */
    
    
    public static void sendSingleEmail(Set<String> financialPaymentId){
        
        financialPayment=[SELECT Partner_Account__c,Dealer_Lease_Contact_Email__c, Partner_Account__r.Area_Sales_Manager_Email__c, Partner_Account__r.RSM_Mail__c, Partner_Account__r.FSR_email__c, Lease__c, End_Customer_Account__r.Name, Partner_Account__r.FSR_NAME__c, Partner_Account__r.FSR_phone_no__c FROM LeasePayment__c  where Id IN :financialPaymentId]; 
        
        if(financialPayment !=null && financialPayment.size()>0 ){
            
            getAccountContactRoleEmails(financialPayment);//Method to get corresponding AccountContactRoleEMailAddress
            
            for (LeasePayment__c leasePayment:financialPayment){
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); //New instance of a single email message
                
                if(leasePayment.Dealer_Lease_Contact_Email__c !=null){
                    
                    toArray.add(String.valueOf(leasePayment.Dealer_Lease_Contact_Email__c));
                    
                }
                
                if(leasePayment.Partner_Account__r.Area_Sales_Manager_Email__c !=null){
                    ccArray.add(String.valueOf(leasePayment.Partner_Account__r.Area_Sales_Manager_Email__c));//Getting ASM email for newly Created formula field as 2nd level relationship is not allowed
                    
                }
                
                
                if(leasePayment.Partner_Account__r.RSM_Mail__c!=null){
                    
                    ccArray.add(String.valueOf(leasePayment.Partner_Account__r.RSM_Mail__c));//Getting RSM email for newly Created formula field as 2nd level relationship is not allowed
                    
                }
                
                if(leasePayment.Partner_Account__r.FSR_email__c!=null){
                    ccArray.add(String.valueOf(leasePayment.Partner_Account__r.FSR_email__c));//Getting FSR email for newly Created formula field as 2nd level relationship is not allowed
                    
                    
                }
                
                //Get AccountContactRole Emails
                
                if(accountContactRoleEMailsCollection !=null && accountContactRoleEMailsCollection.containsKey(String.valueOf(leasePayment.Partner_Account__c)) && accountContactRoleEMailsCollection.get(String.valueOf(leasePayment.Partner_Account__c)).size()>0){
                    toArray.addall(accountContactRoleEMailsCollection.get(String.valueOf(leasePayment.Partner_Account__c)));
                    
                }
                
                
                mail.setBccAddresses(bccArray); //Setting bcc emails for Mail Object 
                mail.setCcAddresses(ccArray);   //Setting CC emails for Mail Object 
                mail.setToAddresses(toArray);   //Setting To emails for Mail Object 
                mail.setOrgWideEmailAddressId(orgWideEMailAddress.Id); // FROM EmailAddressSetting
                
                //Preparing Body of Email as HTML 
                subject='Interconnect Invoice Forfeited: SPVT Case for Contract '+leasePayment.Lease__c;            
                body='<html><body>The unresolved SPVT case for ' + leasePayment.End_Customer_Account__r.Name + ', Contract #'+leasePayment.Lease__c+', is being reassigned. Your interconnect invoice payment is now forfeited. If the repair cost is more than your interconnect invoice we will issue a Debit Memo to recuperate the difference.<br/> <br/>'+
                emailSignatureLabel+'<body> <html>';
                               
                mail.setSubject(subject);
                mail.setHtmlBody(body); 
                mail.setSaveAsActivity(false); 
                mails.add(mail);
                
            }
            
        }
        try {
            Messaging.sendEmail(mails);//Sending Final EMails 
        }
        catch (EmailException e) {
            
            System.debug('Error '+ e.getMessage());
        }
        
    }
    
    
    /* ******************************************************************************************************************************************************************************
Method      : getAccountContactRoleEmails
Parameters  : List<LeasePayment__c>
Return Type : Void
Summary     : Function accept List of Financial Payment Object then get the related AccountContactRole Emails from it and put it in Map of<Account Id, List<String>> format
******************************************************************************************************************************************************************************* */
    
    public static void getAccountContactRoleEmails(List<LeasePayment__c> financialPaymentForContactRole){
        List<String> AccountIds=new List<String>();
        
        for(LeasePayment__c lease : financialPaymentForContactRole){
            AccountIds.add(String.valueOf(lease.Partner_Account__c));
        }
        
        for (Contact cont :[Select  Account.Id,Email from Contact where ID IN (SELECT ContactId from AccountContactRole where AccountId IN : AccountIds AND Role ='SPVT Notification')]){
            List <String> contactRoleEmails=new List<String>();
            if(accountContactRoleEMailsCollection !=null && accountContactRoleEMailsCollection.containsKey(String.valueOf(cont.Account.Id))){
                //For Multiple contact for mentioned Role
                contactRoleEmails=accountContactRoleEMailsCollection.get(String.valueOf(cont.Account.Id));
                if(contactRoleEmails !=null){
                contactRoleEmails.add(cont.EMail);
                }
            }
            
            else{
                // In case of Single Contact for mentioned Role
                contactRoleEmails.clear();
                contactRoleEmails.add(cont.Email);
                accountContactRoleEMailsCollection.put(String.valueOf(cont.Account.Id),contactRoleEmails);
                
            }
        }
    }
    
    static{
        //getting the bcc list in static block   
        for(SPVTBCCEMailsSend__c spvt : bccEmailsCustomSetting){
            bccArray.add(spvt.bccEMailsSend__c);
        }
        //Getting OrgWide EMail Address 
        orgWideEMailAddress=[select id, Address from OrgWideEmailAddress where Address =:'paymentinquiry@sunpowercorp.com'];                        
        
        
    }
}