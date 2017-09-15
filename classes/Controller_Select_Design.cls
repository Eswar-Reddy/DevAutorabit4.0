/***************************************************************************
Class                   :   Controller_Select_Design
Related Page            :   Select_Design
Created By              :   Appirio Offshore
Created On              :   Feb 24, 2010
Desciption              :   Controller apex class for vf page Select_Design.
****************************************************************************/
public class Controller_Select_Design {
    
    //current PSR record
    PSR__c currentPSR{get;set;} 
    
    //list of site wrapper objects
    public List<DesignWrapper> listDesignWrapper{get;set;}
    
    //variable to hold selected design id from the page
    public String selectedDesignOnPage{get;set;}
    
    // Done for Case # 00071200
    public List<PSR__c> currentPSRList{get;set;}
    
    //variable to decide whether the table on page should be displayed or not
    //if listDesignWrapper is not null or its size > 0 then return true otherwise false
    public Boolean renderTable{
        get{
            if(listDesignWrapper != null && listDesignWrapper.size() > 0)
                return true;
            else
                return false;   
        }
    }
    
    /** Constructor Controller_Select_Site.
     *  @param ApexPages.standardController
     */
    public Controller_Select_Design(ApexPages.StandardController controller){
        
        //current psr record
        currentPSR = (PSR__c)controller.getRecord();
        
        // Done for Case # 00071200
        //query more fields of current psr record
        /* currentPSR = [select name, Single_Line_based_on_Design__c,PM_Cost__c,PSR_Sent__c,Quote__c, Site__c, Design__c 
                       ,Array_Layout_Revision__c,Array_Layout__c
                      from PSR__c where ID =: currentPSR.ID];*/
		currentPSRList = new List<PSR__c>([select name, Single_Line_based_on_Design__c,PM_Cost__c,PSR_Sent__c,Quote__c, Site__c, Design__c 
                       		,Array_Layout_Revision__c,Array_Layout__c
                      		from PSR__c where ID =: currentPSR.ID]);
		if(currentPSRList!= null && currentPSRList.size() > 0){                      		                      
			currentPSR = currentPSRList[0];
		}else{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'PSR does not found.'));
            return;
		}
		// End Case # 00071200.

        //if the current PSR does not have Quote__c then display a page error message
        if(currentPSR.site__c == null){
            ApexPages.addMessage(new ApexPages.Message(
                    ApexPages.Severity.ERROR, 
                    'Please select a Site.'));
            return;                      
        }
        
        //Done for case #00049099
        if(currentPSR.Array_Layout_Revision__c ){
            ApexPages.addMessage(new ApexPages.Message(
                        ApexPages.Severity.ERROR, 
                        'You have requested the design revision for the PSR, so please do not select the design.'));
            return; 
         }else if(currentPSR.Array_Layout__c ){
             ApexPages.addMessage(new ApexPages.Message(
                        ApexPages.Severity.ERROR, 
                        'You have requested new design layout for the PSR, so please do not select the design.'));
             return; 
          }   
        
          if(!(currentPSR.PM_Cost__c || currentPSR.Single_Line_based_on_Design__c) ){
              ApexPages.addMessage(new ApexPages.Message(
                         ApexPages.Severity.ERROR, 
                         'You should only select a design if you are asking for an Estimate or Single Line based on an existing design.'));
              return; 
          }
          
        //list of Site_Information_Form__c
        List<Site_Information_Form__c> lstSites;
        
        //querying related design records
        if(currentPSR.Site__c != null){
            lstSites = [select id, name,  
                (Select Id, Name, RecordTypeId, Revision_Letter__c,
                        Date_Design_Completed__c, Status__c, Opportunity__c, 
                        Proposal_Designer__c,
                        Product_Type__c, Module_Type__c, Actual_System_Size__c, 
                        RecordType.Name 
                        From Designs__r 
                        where RecordType.Name = 'Proposal Design')       
            from Site_Information_Form__c 
            where id =: currentPSR.site__c];        
        }
        

        
        //wrapper reference
        DesignWrapper wrapper;
        
        //filling the list of wrapper
        if(lstSites != null && lstSites.size() > 0){


            //if the associated site does not have any designs then display a page error message
            if(lstSites.get(0).Designs__r == null || lstSites.get(0).Designs__r.size() == 0){
                ApexPages.addMessage(new ApexPages.Message(
                        ApexPages.Severity.ERROR, 
                        'The Site does not have any designs.'));
                return;
            }        




            for(Design__c design :lstSites.get(0).Designs__r){
                
                //instantiating listDesignWrapper
                if(listDesignWrapper == null)
                    listDesignWrapper = new List<DesignWrapper>();
                
                //if displaying selected design CHECKED on page
                if(currentPSR.Design__c != null && design.id == currentPSR.Design__c) 
                    wrapper = new DesignWrapper(true, design);
                else
                    wrapper = new DesignWrapper(false, design);
            
                listDesignWrapper.add(wrapper);       
            
            }//end of for-loop
            
        }//end of if
        
    }//end of constructor
    
     
    /** Action function called from button 'return to PSR' on page 'Select_Site'. 
     *  @return PageReference
     */     
    public PageReference returnToPSR(){
        
        //boolean variable to decide whether current psr record should be updated or not
        //if the design__c is changed then update current psr record
        Boolean updatePSR = false;
        System.debug('*******value '+selectedDesignOnPage);
        
        if(listDesignWrapper != null && listDesignWrapper.size() > 0 
            && selectedDesignOnPage != null && selectedDesignOnPage != ''){
                
            //iterating through listDesignWrapper
            for(DesignWrapper wrapper:listDesignWrapper){
                //if wrapper.design.id == selectedDesignOnPage means this design is selected by user from the page
                if(String.valueof(wrapper.design.id) == selectedDesignOnPage){
                    currentPSR.Design__c = wrapper.design.Id;                   
                    updatePSR = true;
                    break;
                }
            }//end of for-loop
        }//end of if
        
        //Done under the case-00038856
        List<Design__c> d = new List<Design__c>([Select id from Design__c where PSR__c = :currentPSR.ID and Primary_PSR_Design__c = true limit 1]);        
        if(d.size()>0 && d[0].ID!=currentPSR.Design__c){
             ApexPages.addMessage(new ApexPages.Message(
                        ApexPages.Severity.ERROR, 
                        'Design can not be changed for the PSR.'));
             return null;
        }                                
        
        //updating the currentPSR record
        if(updatePSR){
        try{
               //Done under the case-00038856
               if(currentPSR.PSR_Sent__c!=null && (currentPSR.PM_Cost__c || currentPSR.Single_Line_based_on_Design__c) ){
                   ApexPages.addMessage(new ApexPages.Message(
                        ApexPages.Severity.ERROR, 
                        'Design can not be changed because Estimate or SingleLine of PSR is created based on existing Design.'));
                   return null; 
               }

               

               update currentPSR;
           }
           catch(Exception ex){              
               ApexPages.addMessage(new ApexPages.Message(
                    ApexPages.Severity.ERROR, 
                    ex.getMessage()));

               return null; 
               
           }
        }
            
        //initializing selectedDesignOnPage to blank after updating psr
        selectedDesignOnPage = '';
        
        //return to current psr record        
        return new PageReference('/' + currentPSR.Id);
    }
    
    /** Action function called from button 'cancel' on page 'Select_Design'. 
     *  @return PageReference
     */ 
    public PageReference Cancel(){
        return new PageReference('/' + currentPSR.Id);      
    } 
    
    public PageReference removeDesign(){
       //Done under the case-00038856
       if(currentPSR.PSR_Sent__c!=null){
           ApexPages.addMessage(new ApexPages.Message(
                ApexPages.Severity.ERROR, 
                'Design can not be removed once the PSR is sent.'));
           return null; 
       }
       
       currentPSR.Design__c=null;
       update currentPSR;
       return new PageReference('/' + currentPSR.Id);      
    } 
    //Inner wrapper class around Design__c
    public class DesignWrapper{
        
        //variable to display the selected design checked on the page
        public Boolean isSelected{get;set;}
        //Design__c object
        public Design__c design{get;set;}
        
        //constructor
        public DesignWrapper(Boolean isSelected, Design__c design){
            this.isSelected = isSelected;
            this.design = design;
        }
    }
}