/**********************************************************************
Class                   :   Controller_Select_Site
Related Page            :   Select_Site
Created By              :   Appirio Offshore
Created On              :   Jan 07, 2010
Desciption              :   Controller apex class for vf page Select_Site.
************************************************************************/
//Site_Information_Form__c
public class Controller_Select_Site {
    
    //current PSR record
    PSR__c currentPSR{get;set;}  
    
    //list of site wrapper objects
    public List<SiteWrapper> listSiteWrapper{get;set;}
    //variable binded with hidden input field in vf page
    
    public String selectedSiteOnPage {get;set;}
    
    //variable to decide whether the table on page should be displayed or not
    //if listSiteWrapper is not null or its size > 0 then return true otherwise false
    public Boolean renderTable{
        get{
            if(listSiteWrapper != null && listSiteWrapper.size() > 0)
                return true;
            else
                return false;   
        }
    }
    
    /** Constructor Controller_Select_Site.
     *  @param ApexPages.standardController
     */
    public Controller_Select_Site(ApexPages.StandardController controller){
        //initializing selectedSiteOnPage to blank
        selectedSiteOnPage = '';
        //instantiating listSiteWrapper
        listSiteWrapper = new List<SiteWrapper>();
        //reference of wrapper object
        SiteWrapper wrapper;
        //current psr record
        currentPSR = (PSR__c)controller.getRecord();
        
        //added Business_Unit__c in query for Case#00066255
        currentPSR = [select name, Quote__c, Opportunity__c,site__c,Business_Unit__c 
            from PSR__c where ID =: currentPSR.ID limit 1];
        
        //Case#00108044 - Removing Quote's mandatory check
        /*//modified condition for Case#00066255
        //if the current PSR does not have Quote__c then display a page error message
        if((currentPSR.Business_Unit__c == null || !Controller_Send_PSR.BUsToBypassQuoteCheck.contains(currentPSR.Business_Unit__c.toUpperCase())) 
           && currentPSR.Quote__c == null){
            ApexPages.addMessage(new ApexPages.Message(
                    ApexPages.Severity.ERROR, 
                    'The Quote field must be populated.'));
            return;                      
        }*/
         
        //querying child Site_Information_Form__c records of the opportunity
        List<Site_Information_Form__c> listSites = [Select s.id, s.Site_State__c, 
            s.Site_Name__c, s.Site_Status__c, 
            s.Site_Country__c, s.Site_City__c, s.Name 
            From Site_Information_Form__c s 
            where s.Site_Status__c!='Inactive' 
                and s.opportunity_del__c =: currentPSR.Opportunity__c ];
        
        
        //if the associated Opportunity does not have any sites then display a page error message
        if(listSites == null || listSites.size() == 0){
            ApexPages.addMessage(new ApexPages.Message(
                    ApexPages.Severity.ERROR, 
                    'The Opportunity does not have any active sites.'));
            return;
        }
        
        //iterating through child site_information_form__c records of Quote__r.Opportunity__c
        for(Site_Information_Form__c site:listSites){           
            //if site.id == currentPSR.site__c means it is to be displayed checked on the vf page 
            if(currentPSR.site__c != null && site.id == currentPSR.site__c) {
                wrapper = new SiteWrapper(true,site);
                selectedSiteOnPage = currentPSR.site__c;
            }
            else
                wrapper = new SiteWrapper(false,site);
                
            listSiteWrapper.add(wrapper);       
        }
    }
    
    /** Action function called from button 'return to PSR' on page 'Select_Site'. 
     *  @return PageReference
     */     
    public PageReference returnToPSR(){
        //boolean variable to decide whether current psr record should be updated or not
        //if the site__c is changed then update current psr record
        Boolean updatePSR = false;
        System.debug('*******value '+selectedSiteOnPage);
        System.debug('*******Size of ListSiteWrapper '+listSiteWrapper.size());
        if(listSiteWrapper != null && listSiteWrapper.size() > 0 
            && selectedSiteOnPage != null && selectedSiteOnPage != ''){
            //iterating through listSiteWrapper
            for(SiteWrapper wrapper:listSiteWrapper){
                //if wrapper.site.id == selectedSiteOnPage means this site is selected by user from the page
                if(String.valueof(wrapper.site.id) == selectedSiteOnPage){
                    currentPSR.site__c = wrapper.site.Id;                   
                    updatePSR = true;
                    break;
                }
            }//end of for-loop
        }//end of if
        
        //updating the currentPSR record
        if(updatePSR)
            update currentPSR;
            
        //initializing selectedSiteOnPage to blank after updating psr
        selectedSiteOnPage = '';
        //return to current psr record  
        return new PageReference('/' + currentPSR.Id);
    }
    
    public PageReference Cancel(){
        return new PageReference('/' + currentPSR.Id);      
    }   
    
    //Inner wrapper class around Site_Information_Form__c
    public class SiteWrapper{
        //variable to display the selected site checked on the page
        public Boolean isSelected{get;set;}
        //Site_Information_Form__c object
        public Site_Information_Form__c site{get;set;}
        
        //constructor
        public SiteWrapper(Boolean isSelected, Site_Information_Form__c site){
            this.isSelected = isSelected;
            this.site = site;
        }
    }
}