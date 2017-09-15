/**
This class is test by a Test Class: - PartnerApplicationControllerNewTest
**/
public class PartnerApplicationControllerNew{
    
     
    public Partner_Application__c partnerApp{get;set;} 
    public String partnerAppId{get;set;}
    public String leadId{get;set;}
    public boolean isCVARApplication{get;set;}
    public List<SelectOption> Proj_Comp_Last_Year_Options {get; private set;}
    public string partnerAppType{get;set;}  
    public Boolean isCommercial{get;set;}

    public string naPartnerAppRecTypeId{get;set;} 
    public string naPartnerAppResRecTypeId{get;set;}  
    
    public string eca{get;set;}
    public string ecc{get;set;}
    public string econt{get;set;}
    
   
    //for case 00039606
    private boolean isOwnerSetFromLead = false;          
    public PartnerApplicationControllerNew(ApexPages.StandardController stdController) {   
            partnerApp = (Partner_Application__c)stdController.getRecord();
               
                      
            //for case 00039606
            isCVARApplication = false;
            String sTmp = ApexPages.CurrentPage().getURL();
            if (sTmp != null) {
                if (sTmp.toLowerCase().contains('_comm')) {
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
    System.debug('>>>>>>>>>>>>>>>>>> '+ partnerApp);
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
            pr=Page.PartnerApplication_CommNew;
        }
        else{
            pr = Page.PartnerApplication_ResNew; 
        }            
        return pr;    
    }

   
       
       @RemoteAction
       public static integer newstep2(String CompanyName){        
        
        PageReference pr; 
        ApexPages.Message msg;    
        List<Partner_Application__c> partnerApplicationList = [select Id ,name,Company_Name__c from Partner_Application__c where Company_Name__c =: CompanyName limit 1];
       /* if(partnerApplicationList.size()>0){
           msg = new ApexPages.Message(ApexPages.severity.ERROR,'Partner Application has already been submitted for the Company '+ CompanyName);
            ApexPages.addMessage(msg);
            
        }  */
       
        return partnerApplicationList.size();        
    }
    
    public PageReference step3(){       
        System.debug('>##############'+partnerApp.Company_name__c);
        partnerApp.status__c='Submitted';  
        PageReference pr;
           
        if(savePartnerApplication()){
            //case 12024
            if(isCVARApplication){
                pr=Page.PartnerApplication_CommNew1;
            }
            else{
                pr = Page.PartnerApplication_ResNew1; 
            }  
            
            //Send email notification for leadowner --Case-#00011378
            //sendEmailToLeadOwner();//for case#00065563
                       
        }
        return pr;
    }        

  
   
}