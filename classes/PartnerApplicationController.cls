public class PartnerApplicationController{
    
     
    public Partner_Application__c partnerApp{get;set;} 
    public String partnerAppId{get;set;}
    public String leadId{get;set;}
    public boolean isCVARApplication{get;set;}
    public List<SelectOption> Proj_Comp_Last_Year_Options {get; private set;}
    public string partnerAppType{get;set;}  
    public Boolean isCommercial{get;set;}

    public string naPartnerAppRecTypeId{get;set;} 
    public string naPartnerAppResRecTypeId{get;set;}  
    public string euPartnerAppRecTypeId{get;set;}
    //for case 00039606 - record type for Aus
    public string auPartnerAppRecTypeId{get;set;}
    public string eca{get;set;}
    public string ecc{get;set;}
    public string econt{get;set;}
    //for case 00039606
    private boolean isOwnerSetFromLead = false;          
    public PartnerApplicationController(ApexPages.StandardController stdController) {   
            partnerApp = (Partner_Application__c)stdController.getRecord();
            //for case 00039606    
            eca='No';
            ecc='No';
            econt='No';
            //for case 00039606
            isCVARApplication = false;
            String sTmp = ApexPages.CurrentPage().getURL();
            if (sTmp != null) {
                if (sTmp.toLowerCase().contains('_cvar')) {
                    isCVARApplication = isCommercial = true;
                    
                    List<RecordType> recordTypeList = [SELECT Id FROM RecordType
                            WHERE SobjectType = 'Partner_Application__c'
                            AND Name = 'NA Commercial Partner Application'];
                    
                    if (recordTypeList.size() > 0) {
                        partnerApp.RecordTypeId = recordTypeList[0].Id;
                    }
                }
            }
            
            partnerAppType = ApexPages.CurrentPage().getParameters().get('Type');
            //System.debug('::::::::::::'+partnerAppType);
            
            leadId = ApexPages.CurrentPage().getParameters().get('LId');
            List<Lead> partnerLeads = new List<Lead>();

            if (leadId != null && leadId != ''){
                //handeling for invalid id error
                try{ 
                     partnerApp.lead__c=leadId;
                    
                     partnerLeads = [Select Company, City, Country, State,  WebSite, Email, 
                     Phone, FirstName, LastName, Fax, MobilePhone ,NumberOfEmployees,Cored_Business__c, 
                     PostalCode, Street, Theater__c, OwnerId,owner.Email,owner.Name from Lead where Id =:leadId limit 1];
                 }//try end
                 catch(Exception ex){
                        //ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.WARNING,ex.getMessage());
                        //ApexPages.addMessage(msg);
                  }
                                 
                   if(partnerLeads.Size()>0){
        
                       partnerApp.Company_Name__c = partnerLeads.get(0).Company;
                       partnerApp.City__c = partnerLeads.get(0).City;
                       partnerApp.Country__c = partnerLeads.get(0).Country;
                       partnerApp.State__c = partnerLeads.get(0).State;
                       partnerApp.Zip__c = partnerLeads.get(0).PostalCode;
                       partnerApp.Website__c = partnerLeads.get(0).WebSite;
                       partnerApp.Email__c = partnerLeads.get(0).Email;
                       partnerApp.Phone__c = partnerLeads.get(0).Phone;
                       partnerApp.First_Name__c = partnerLeads.get(0).FirstName;
                       partnerApp.Last_Name__c = partnerLeads.get(0).LastName;
                       partnerApp.Fax__c = partnerLeads.get(0).Fax;
                       partnerApp.Mobile__c = partnerLeads.get(0).MobilePhone;
                       partnerApp.Employees__c = partnerLeads.get(0).NumberOfEmployees; 
                       partnerApp.Address__c= partnerLeads.get(0).Street;
                       partnerApp.Theater__c= partnerLeads.get(0).Theater__c;
                       partnerApp.Current_Industry__c = partnerLeads.get(0).Cored_Business__c;//for case 00039606
                       
                       //Set Partner Application owner as the Lead owner if Lead owner is not a queue or Group
                       //Done for the case-00011979
                       if(partnerLeads.get(0).OwnerId!=null){
                           if(!(String.valueOf(partnerLeads.get(0).OwnerId).startsWith('00G'))){
                                partnerApp.Lead_Owner__c= partnerLeads.get(0).OwnerId;
                                partnerApp.ownerID = partnerLeads.get(0).OwnerId;
                                //partnerApp.owner__c = partnerLeads.get(0).Owner.name;   
                                isOwnerSetFromLead = true;                          
                           }
                       }                       
                   }            
            }                       
            
            if (partnerAppType != null){
                partnerApp.partner_application_type__c = partnerAppType;
                if(partnerAppType == 'commercial' || isCVARApplication == true){
                  isCommercial = true;
                }
                else{
                  isCommercial = false;
                }
                
            }
            naPartnerAppRecTypeId=null;
            naPartnerAppResRecTypeId=null;
            euPartnerAppRecTypeId=null;
            auPartnerAppRecTypeId=null;//for case 00039606
                
            for(RecordType recType : 
                [Select r.Id, r.Name 
                    From RecordType r 
                    where r.SobjectType = 'Partner_Application__c']){
                        
                if(recType.Name=='NA Partner Application'){
                    naPartnerAppResRecTypeId = recType.Id; 
                }
                
                if ((recType.Name=='NA Partner Application' && isCVARApplication == false)
                        || (recType.Name=='NA Commercial Partner Application' && isCVARApplication == true)) {
                    naPartnerAppRecTypeId = recType.Id;       
                }       
                else if (recType.Name=='EU Partner Application'){
     
                    euPartnerAppRecTypeId = recType.Id;           
                }
                //for case 00039606
                else if (recType.Name=='AUS Partner Application'){
                    auPartnerAppRecTypeId = recType.Id;           
                }//for case 00039606                      
            }//for end
        
        Proj_Comp_Last_Year_Options = new List<SelectOption>();
        Proj_Comp_Last_Year_Options.add(new SelectOption('', '--None--'));
        if (isCVARApplication == true) {
            Proj_Comp_Last_Year_Options.add(new SelectOption('Less than 10 projects', 'Less than 10 projects'));
            Proj_Comp_Last_Year_Options.add(new SelectOption('11 - 25 projects', '11 - 25 projects'));
            Proj_Comp_Last_Year_Options.add(new SelectOption('25 - 49 projects', '25 - 49 projects'));
            Proj_Comp_Last_Year_Options.add(new SelectOption('50+ projects', '50+ projects'));
        } else {
            Proj_Comp_Last_Year_Options.add(new SelectOption('<100 projects', '<100 projects'));
            Proj_Comp_Last_Year_Options.add(new SelectOption('101 - 249 projects', '101 - 249 projects'));
            Proj_Comp_Last_Year_Options.add(new SelectOption('250 - 499 projects', '250 - 499 projects'));
            Proj_Comp_Last_Year_Options.add(new SelectOption('500+ projects', '500+ projects'));
        }
    }

    public Boolean savePartnerApplication(){
        try{                    
            if (partnerApp.Id==null)
                insert partnerApp;
            else 
                update partnerApp;           
        }
        catch(Exception ex){
            System.debug('savePartnerApplication Error');
            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.ERROR,ex.getMessage());
            ApexPages.addMessage(msg);
            return false;
        }
        partnerAppId=partnerApp.Id;
        System.debug('savePartnerApplication- successful');
        return true;    
        
    }

    public PageReference step1(){
        PageReference pr;        
        //case 12024
        if(isCVARApplication){
            pr=Page.PartnerApp_CVAR_1;
        }
        else{
            pr = Page.PartnerApp_1; 
        }            
        return pr;    
    }

    
    public PageReference step2(){        
        partnerApp.language__c='English';    
        PageReference pr;     
        List<Partner_Application__c> partnerApplicationList = [select Id ,name,Company_Name__c from Partner_Application__c where Company_Name__c =: partnerApp.Company_Name__c limit 1];
        // validations
        if(partnerApplicationList.size()>0){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.ERROR,'Partner Application has already been submitted for the Company '+ partnerApp.Company_Name__c);
            ApexPages.addMessage(msg);
            
        }
        // case 00424687
        // If any of the Owner fields are populated then the respective DOB and % ownership fields must also be populated
        // Owner 2 field validations
        else if(partnerApp.Owner_2__c != null && (partnerApp.Owner_2_DOB__c == null || partnerApp.Owner_2_of_Ownership__c == null)){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.ERROR,'Owner 2 DOB and % Ownership cannot be blank.');
            ApexPages.addMessage(msg);
        }
        // Owner 3 field validations
        else if(partnerApp.Owner_3__c != null && (partnerApp.Owner_3_DOB__c == null || partnerApp.Owner_3_of_Ownership__c == null)){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.ERROR,'Owner 3 DOB and % Ownership cannot be blank.');
            ApexPages.addMessage(msg);
        }
        // Owner 4 field validations
        else if(partnerApp.Owner_4__c != null && (partnerApp.Owner_4_DOB__c == null || partnerApp.Owner_4_of_Ownership__c == null)){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.ERROR,'Owner 4 DOB and % Ownership cannot be blank.');
            ApexPages.addMessage(msg);
        }
        // Owner 5 field validations
        else if(partnerApp.Owner_5__c != null && (partnerApp.Owner_5_DOB__c == null || partnerApp.Owner_5_of_Ownership__c == null)){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.ERROR,'Owner 5 DOB and % Ownership cannot be blank.');
            ApexPages.addMessage(msg);
        }
        else{
            
            if(naPartnerAppRecTypeId!=null){
                partnerApp.recordtypeId=naPartnerAppRecTypeId;          
            }
        
            //case 12024
            if(isCVARApplication){
                pr=Page.PartnerApp_CVAR_2;
            }
            else{
                pr = Page.PartnerApp_2; 
            }
        }       
        return pr;        
    }
    
    public PageReference step3(){       
        
        partnerApp.status__c='Submitted';  
        PageReference pr;
           
        if(savePartnerApplication()){
            //case 12024
            if(isCVARApplication){
                pr=Page.PartnerApp_CVAR_3;
            }
            else{
                pr = Page.PartnerApp_3; 
            }  
            
            //Send email notification for leadowner --Case-#00011378
            //sendEmailToLeadOwner();//for case#00065563
                       
        }
        return pr;
    }        


    public void sendEmailToLeadOwner(){
        try{ 
            //System.debug(partnerApp.Lead__c+'111111111');
            //if partner application associated with a lead then send a mail to lead owner
            if(partnerApp.Lead__c != null){ 
                List<Lead> lstLead = new List<Lead>([Select Id, OwnerId,  Owner.Email From Lead where Id =:partnerApp.Lead__c limit 1]);
                
                
                List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] str = new List<String>();
                
                if(lstLead.Size()>0) {
                    //check production & sandbox
                    string UrlPartner = ApexPages.currentPage().getHeaders().get('Host');                    
                    if(partnerApp.OwnerID==lstLead.get(0).OwnerID && lstLead.get(0).Owner.Email != null){
                        //for case # 00039606
                        if(partnerApp.RecordTypeId == auPartnerAppRecTypeId){
                            List<User> userList = [Select Name, Id, Email From User where UserRole.Name = 'Partner Ambassador'];
                            if(userList.size()>0){
                                str = new List<String>();
                                for(User u:userList){
                                    str.add(u.Email);
                                }
                                str.add(lstLead.get(0).Owner.Email);
                                str.add(partnerApp.Owner.Email);
                                mail.setToAddresses(str);
                            }                            
                        }else{  
                        //for case # 00039606
                            //start for case # 00058164 
                            str = new List<String>();
                            str.add(lstLead.get(0).Owner.Email);
                            //URL Partner condition is used so that these users receive mails only from production
                            if(UrlPartner != 'sunpower.gbl.cs3.force.com' && partnerApp.RecordTypeId == naPartnerAppRecTypeId ){
                                str.add('bernie.chir@sunpowercorp.com'); //for case 00065563
                                str.add('dave.depuy@sunpowercorp.com');
                                str.add('peter.franetovich@sunpowercorp.com');                         
                            }
                           
                            //start for case # 00058164 
                        }        
                    }
                    //Added for case 00058461
                    //URL Partner condition is used so that these users receive mails only from production
                    else if(!isOwnerSetFromLead && (partnerApp.RecordTypeId == naPartnerAppRecTypeId) && UrlPartner != 'sunpower.gbl.cs3.force.com'){
                        str = new List<String>();    
                        str.add('bernie.chir@sunpowercorp.com'); //for case 00065563
                        str.add('dave.depuy@sunpowercorp.com');
                        str.add('peter.franetovich@sunpowercorp.com');                
                    }
                    
                    //mail.setToAddresses(new String[] {lstLead.get(0).Owner.Email});
                    mail.setToAddresses(str);
                    //mail.setToAddresses(new String[] {partnerApp.Owner.Email});
                    mail.setSubject('New partner application has been received');
                    string newUrlPartner = '';
                    Boolean needUpdate  = false;
                   
                    //case 00039606
                    if(UrlPartner == 'sunpower.gbl.cs3.force.com'){//sandbox site
                        newUrlPartner = 'https://test.salesforce.com/' + partnerAppId;
                    }
                    else if(UrlPartner == 'sunpower.force.com'){ //production site
                        newUrlPartner = 'https://login.salesforce.com/' + partnerAppId;
                    }
                    else{
                        newUrlPartner = 'https://' + UrlPartner + '/' + partnerAppId;
                    }
                    
                    //Changed for case 00065563
                    
                    Double score = null;
                    if (partnerApp.RecordTypeId == naPartnerAppRecTypeId){
                        Partner_Application__c pApp = [select Calculated_Application_Score__c from Partner_Application__c where id= :partnerApp.id limit 1].get(0);
                        if (pApp.Calculated_Application_Score__c == null)
                            score = 0.0;
                        else
                            score = pApp.Calculated_Application_Score__c;
                    }
                    string mailHTMLBody = 'Partner Application :  ' + partnerApp.Company_Name__c +
                                     '<br/>City :  ' + partnerApp.City__c +
                                     '<br/>State :  ' + partnerApp.State__c +
                                     '<br/>Zip Code:  ' + partnerApp.Zip__c ;//for case # 00058164 
                    
                    if (score != null){
                        mailHTMLBody += '<br/>Application Score:   '+score +
                                     '<br/><br/>Click the link to view: <br/>' +  newUrlPartner;
                    }else{
                        mailHTMLBody += '<br/><br/>Click the link to view: <br/>' +  newUrlPartner;
                    }
                    
                    //End of change for Case 00065563            
                                     
                    mail.setHTMLBody(mailHTMLBody);              
                                                         
                    mailList.add(mail);
                    Messaging.sendEmail(mailList);
                }
                
                
                    
                
            }
        }
        catch(Exception ex){
        
        }      
    }
     
    /****************For Belgium*********************/
      
    public PageReference step1_bg(){
        PageReference pr;
        pr = Page.PartnerApp_bg_1;
        return pr;                
    } 
    public PageReference step2_bg(){
        partnerApp.language__c='French';   
        PageReference pr;   
        if(euPartnerAppRecTypeId!=null){        
            partnerApp.recordtypeId=euPartnerAppRecTypeId;          
        }
        pr = Page.PartnerApp_bg_2;
        return pr;
    }
    
    public PageReference step3_bg(){
        PageReference pr;       
        pr = Page.PartnerApp_bg_3; 
        return pr;
    }
    
    public PageReference step4_bg(){
        partnerApp.status__c='Submitted';
        PageReference pr;
        if(savePartnerApplication()){
            pr = Page.PartnerApp_bg_4;
            //Send mail to lead owner Case-#00011378    
            //sendEmailToLeadOwner();//for case#00065563
                              
        }                              
        return pr;
    }
       public PageReference CancelPartner_bg(){
    
        PageReference pr = null;
    
        try{
            partnerAppId = null;
            partnerApp = new Partner_Application__c();
            pr = Page.partnerapp_bg_1;
            
        }catch(Exception ex){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.ERROR,ex.getMessage());
            ApexPages.addMessage(msg);
        }   
        return pr;
    } 
    /*******for french*************/
    public PageReference step1_fr(){
        PageReference pr;
        pr = Page.PartnerApp_fr_1;
        return pr;                
    }
    public PageReference step2_fr(){
        partnerApp.language__c='French';   
        PageReference pr;   
        if(euPartnerAppRecTypeId!=null){        
            partnerApp.recordtypeId=euPartnerAppRecTypeId;          
        }
        pr = Page.PartnerApp_fr_2;
        return pr;
    }
    
    public PageReference step3_fr(){
        PageReference pr;
        pr = Page.PartnerApp_fr_3;
        return pr;
    }
    
    public PageReference step4_fr(){
        partnerApp.status__c='Submitted';
        PageReference pr;
        if(savePartnerApplication()){
            pr = Page.PartnerApp_fr_4;
            //Send mail to lead owner Case-#00011378    
            //sendEmailToLeadOwner();//for case#00065563
                              
        }                              
        return pr;
    }
        
    /*******for italian*************/
    public PageReference step1_it(){

        PageReference pr;
        pr = Page.PartnerApp_it_1;
        return pr;
    }
    
    public PageReference step2_it(){
        partnerApp.language__c='Italian';       
        if(euPartnerAppRecTypeId!=null){
            partnerApp.recordtypeId=euPartnerAppRecTypeId;          
        }       
        PageReference pr;
        pr = Page.PartnerApp_it_2;
        return pr;
    }
    
    public PageReference step3_it(){
        
        partnerApp.Insurance_Type_1__c = 'Responsabilità Civile verso terzi';
        partnerApp.Insurance_Type_2__c = 'Assicurazione sul personale';
        partnerApp.Insurance_Type_3__c = 'Veicoli';
        PageReference pr;
        pr = Page.PartnerApp_it_3;
        return pr;        
    }

    public PageReference step4_it(){
        partnerApp.status__c='Submitted';
        PageReference pr;
        if(savePartnerApplication()){
            pr = Page.PartnerApp_it_4;
            //Send mail to lead owner Case-#00011378 
            //sendEmailToLeadOwner();//for case#00065563
            
        }   
        return pr;        
    }

    
    /*******for German*************/
    public PageReference step1_de(){
        PageReference pr;
        pr = Page.PartnerApp_de_1;
        return pr;        
    }
    
    public PageReference step2_de(){
        partnerApp.language__c='German';        
        if(euPartnerAppRecTypeId!=null){
            partnerApp.recordtypeId=euPartnerAppRecTypeId;          
        }           
        PageReference pr;
        pr = Page.PartnerApp_de_2;
        return pr;        
    }
    
    public PageReference step3_de(){
        PageReference pr;
        pr = Page.PartnerApp_de_3;
        return pr;        
    }   

    public PageReference step4_de(){
        partnerApp.status__c='Submitted';
        PageReference pr;
        if(savePartnerApplication()){
            pr = Page.PartnerApp_de_4;     
            //Send mail to lead owner Case-#00011378 
            //sendEmailToLeadOwner();//for case#00065563
        }
        
        return pr;        
    }   

    
    /*******for spanish************/
    public PageReference step1_es(){  
        PageReference pr;
        pr = Page.PartnerApp_es_1;
        return pr;        
    }
    
    public PageReference step2_es(){
        
        partnerApp.language__c='Spanish';       
        if(euPartnerAppRecTypeId!=null){
            partnerApp.recordtypeId=euPartnerAppRecTypeId;          
        }           
        PageReference pr;
        pr = Page.PartnerApp_es_2;
        return pr;        
    }
    
    public PageReference step3_es(){
        PageReference pr;
        pr = Page.PartnerApp_es_3;
        return pr;        
    }   

    public PageReference step4_es(){
        partnerApp.status__c='Submitted';
        PageReference pr;
        if(savePartnerApplication()){
            pr = Page.PartnerApp_es_4;    
            //Send mail to lead owner Case-#00011378 
            //sendEmailToLeadOwner();//for case#00065563
                                  
        }
        return pr;        
    }   

     public PageReference CancelPartner_de(){
    
        PageReference pr = null;
    
        try{
            partnerAppId = null;
            partnerApp = new Partner_Application__c();
            pr = Page.partnerapp_de_1;
            
        }catch(Exception ex){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.ERROR,ex.getMessage());
            ApexPages.addMessage(msg);
        }   
        return pr;
    } 
    
     public PageReference CancelPartner_es(){
    
        PageReference pr = null;
    
        try{
            partnerAppId = null;
            partnerApp = new Partner_Application__c();
            pr = Page.partnerapp_es_1;
            
        }catch(Exception ex){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.ERROR,ex.getMessage());
            ApexPages.addMessage(msg);
        }   
        return pr;
    }       
 
     public PageReference CancelPartner_it(){
    
        PageReference pr = null;
    
        try{
            partnerAppId = null;
            partnerApp = new Partner_Application__c();
            pr = Page.partnerapp_it_1;
            
        }catch(Exception ex){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.ERROR,ex.getMessage());
            ApexPages.addMessage(msg);
        }   
        return pr;
    }   
 
 
    public PageReference CancelPartner_fr(){
    
        PageReference pr = null;
    
        try{
            partnerAppId = null;
            partnerApp = new Partner_Application__c();
            pr = Page.partnerapp_fr_1;
            
        }catch(Exception ex){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.ERROR,ex.getMessage());
            ApexPages.addMessage(msg);
        }   
        return pr;
    }   
    
    public PageReference CancelPartner(){
    
        PageReference pr = null;
    
        try{
            partnerAppId = null;
            partnerApp = new Partner_Application__c();
            
            //case 12024
            if(isCVARApplication){
            pr=Page.PartnerApp_CVAR_1;
            }
            else{
                pr = Page.PartnerApp_1; 
            }
            
        }catch(Exception ex){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.ERROR,ex.getMessage());
            ApexPages.addMessage(msg);
        }   
        return pr;
    }     
    /*******for Australia************Case # 00039606*/ 
    public PageReference step1_au(){
        PageReference pr;
        pr = Page.PartnerApp_au_1;
        return pr;        
    }
    
    public PageReference step2_au(){
        partnerApp.language__c='English';    
        PageReference pr;     
        List<Partner_Application__c> partnerApplicationList = [select Id ,name,Company_Name__c from Partner_Application__c where Company_Name__c =: partnerApp.Company_Name__c limit 1];
        if(partnerApplicationList.size()>0){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.ERROR,'Partner Application has already been submitted for the Company '+ partnerApp.Company_Name__c);
            ApexPages.addMessage(msg);
        }else{ 
            partnerApp.Insurance_Type_1__c = 'Public Liability';            
            partnerApp.Insurance_Type_2__c = 'Product Liability';
            partnerApp.Insurance_Type_3__c = 'Indemnity';           
            partnerApp.Insurance_Type_4__c = 'Workers';
            partnerApp.Insurance_Type_5__c = 'Other – give details';
            partnerApp.PV_Experience_years__c = partnerApp.Years_in_Business__c;
            if(auPartnerAppRecTypeId!=null){
                partnerApp.recordtypeId=auPartnerAppRecTypeId;          
            }
                pr = Page.PartnerApp_au_2; 
        }       
        return pr;
    }
    
    public PageReference step3_au(){
        PageReference pr;
        pr = Page.PartnerApp_au_3;
        return pr;
    }
    
    public PageReference step4_au(){
        partnerApp.status__c='Submitted';  
        PageReference pr;
        if(eca=='Yes'){
            partnerApp.Electrical_Class_A__c = true;
        }else{
            partnerApp.Electrical_Class_A__c = false;
        }
        if(ecc=='Yes'){
            partnerApp.Electrical_Class_A__c = true;
        }else{
            partnerApp.Electrical_Class_A__c = false;
        } 
        if(econt=='Yes'){
            partnerApp.Electrical_Class_A__c = true;
        }else{
            partnerApp.Electrical_Class_A__c = false;
        }            
        if(savePartnerApplication()){
                pr = Page.PartnerApp_au_4;
            //sendEmailToLeadOwner();//for case#00065563                       
        }
        return pr;
    }
    
    public PageReference CancelPartner_au(){
        PageReference pr = null;    
        try{
            partnerAppId = null;
            partnerApp = new Partner_Application__c();
            pr = Page.PartnerApp_au_1;
        }catch(Exception ex){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.ERROR,ex.getMessage());
            ApexPages.addMessage(msg);
        }
        return pr;
    }
    /*******for Australia************Case # 00039606*/ 
    public List<SelectOption> getYesNo() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Yes','Yes'));
        options.add(new SelectOption('No','No'));
        return options;
    }
     //Start Case # 72314
   public PageReference step1_uk(){
        PageReference pr;
        //if(savePartnerApplication()){
            pr = Page.PartnerApp_uk_1;  
        //}  
        return pr;                
    }
   
   public PageReference step2_uk(){
        partnerApp.language__c='English';   
        PageReference pr;   
        if(euPartnerAppRecTypeId!=null){        
            partnerApp.recordtypeId=euPartnerAppRecTypeId;          
        }       
        //if(savePartnerApplication()){
             pr = Page.PartnerApp_uk_2;
       // } 
        return pr;
    }
    
  /*  public PageReference step3_uk(){
        PageReference pr;
       // if(savePartnerApplication()){
            pr = Page.PartnerApp_fr_3;  
       // }
        return pr;
    }*/
    
    public PageReference step3_uk(){
        partnerApp.status__c='Submitted';
        PageReference pr;
        if(savePartnerApplication()){
            pr = Page.PartnerApp_uk_3;
            //Send mail to lead owner Case-#00011378    
            //sendEmailToLeadOwner();
                              
        }                              
        return pr;
    }
    public PageReference CancelPartner_uk(){
    
        PageReference pr = null;
    
        try{
            partnerAppId = null;
            partnerApp = new Partner_Application__c();
            pr = Page.partnerapp_uk_1;
            
        }catch(Exception ex){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.ERROR,ex.getMessage());
            ApexPages.addMessage(msg);
        }   
        return pr;
    } 
}