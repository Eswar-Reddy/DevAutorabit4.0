/**********************************************************************
Class                   :   Controller_Send_PSR
Related Page            :   Send_PSR
Created By              :   Appirio Offshore
Created On              :   December 17, 2009
Desciption              :   Controller apex class for vf page Send_PSR.
************************************************************************/
public class Controller_Send_PSR {
    
    //added for Case#00066255
    public static Set<String> BUsToBypassQuoteCheck;    
    static{
        BUsToBypassQuoteCheck = new Set<String>();
        for(String businessUnit : Label.BUsToBypassQuoteCheckOnSendPSR.split(',')){
            BUsToBypassQuoteCheck.add(businessUnit.toUpperCase());
        }       
    }
    
    //Current PSR record
    PSR__c currentPSR{get;set;}
    Id proposalDesignRecordTypeId{get;set;}
    
    /** Constructor Controller_Send_PSR.
     *  @param ApexPages.standardController
        * Added by Venkat Ramesh
        * Added Kickoff_Meeting_Date__c & p.Quote__r.QuoteNumber in the query
     */
    public Controller_Send_PSR(ApexPages.StandardController controller){
        
        currentPSR = (PSR__c)controller.getRecord();
        currentPSR = [Select p.Array_Layout__c, PM_Cost_without_Design__c,
            p.Design__c, p.PM_Cost__c,
            p.PSR_Step__c, p.Site__c, p.Quote__c, 
            p.Opportunity__c,  
            PSR_Sent__c, Array_Layout_Due__c, VDC__c,  
            Estimate_Urgent_Request__c,Design_Urgent_Request__c,
            Survey_Comments__c,
            Requested_System_Size__c,Kickoff_Meeting_Date__c,              
            Product_Type__c, Module_Type__c,
            Cost_Estimate_Due__c,Request_Category__c,Request_sub_Category__c,
            Site_Survey_SubContractor__c, Site_Survey_Standard__c,
            Site_Survey_Due__c, 
            Single_Line_based_on_Design__c, 
            Single_Line_without_Design__c,
            Single_Line__c,         
            Electrical_Support_Due__c,
            Maximize_Array_Size__c, Commercial_Operation_Date__c, 
            O_M_Duration_Years__c, O_M_Service_Level__c, PV_Cost_Wp__c,
            Array_Layout_Revision__c, Electrical_Engineer__c, Proposal_Designer__c,
            Estimator__c, Site_Surveyor__c, Site_Survey_Urgent_Request__c,
            Single_Line_Urgent_Request__c, Project_Manager__c,
            DC_AC_Ratio__c, GCR__c,
            Estimate_Reviewer__c,
            p.Opportunity__r.Name,
            p.Site__r.Site_Name__c,
            p.Quote__r.Quote_Steps__c,
            p.Quote__r.QuoteNumber,
            p.Quote__r.Status,p.Quote__r.RecordType.Name,
            //added for Case#00063303
            Site_Audit_Tracking__c,   
            //added for Case#00066255
            p.Business_Unit__c,
            // added for case # 00073004
            p.Received_Information_to_Design_date__c,
            // added for case # 00201084
            p.Approved_to_Send_PSR__c,p.Opportunity__r.Business_Unit__c 
            from PSR__c p where p.ID =:currentPSR.ID limit 1];              

        for (RecordType recType : 
            [Select r.SobjectType, r.Id, r.DeveloperName From RecordType r 
                where SobjectType = 'Design__c' and DeveloperName = 'Proposal_Design'
                limit 1]){
                    
            proposalDesignRecordTypeID = recType.Id;
                                
        }                   



    }
 
    public integer getNumberOfDays(Date startDate, Date endDate){

        if (startDate==null || endDate==null)
            return 0;           
        else if (startDate.isSameDay(endDate))
            return 0;
                
        integer numberOfDays = 
             startDate.daysBetween(endDate);


        return numberOfDays;        
    } 
        
    private integer getNumberOfWorkingDays(Date startDate, Date endDate){

        if (startDate==null || endDate==null)
            return 0;           
        else if (startDate.isSameDay(endDate))
            return 0;

        integer numberOfWeekendDays = 
            PSRManagement.calculateWeekendDays(startDate, endDate);

        integer numberOfDays = 
             startDate.daysBetween(endDate);

        return numberOfDays-numberOfWeekendDays;        
    } 

    // add days, weekend days are excluded
    private Date addWorkingDays(Date startDate, Integer days) {

        Date endDate = null;
        integer weekendDays = 0;
                
        if (startDate==null)
            return endDate;
            
        if (days==0 || days<0)
            return startDate;

        endDate = startDate.addDays(days);
        weekendDays = PSRManagement.calculateWeekendDays(startDate, endDate);                           
        endDate = endDate.addDays(weekendDays);
        
        integer additionalDays = days - getNumberOfWorkingDays(startDate, endDate);

        endDate = endDate.addDays(additionalDays);
    
        return endDate;     

    }
    
    /** Action function called on page load of 'Send_PSR'. 
     *  @return PageReference
     */ 
    public PageReference sendPSRAction(){
        
        try{

            integer totalDuration = 0;
            integer totalRequiredDuration = 0;

            integer siteSurveyDuration = 0;         
            integer arrayLayoutDuration = 0;            
            integer electricalSupportDuration = 0;          
            integer costEstimateDuration = 0;           


            Estimate__c estimate = null;
            Single_Line__c singleLine = null;
            Design__c design = null;
            Task task = null; 
            Quote quote = null;
            OpportunityTeamMember oppTeam=null;
            list<OpportunityTeamMember> lstOppteam = new list<OpportunityTeamMember>(); 
                         
                        
            Date startDate = null;
            Date arrayLayoutStartDate = null;
            Date electricalSupportStartDate = null;
            Date costEstimateStartDate = null;
            
        /** Requirement    : Restricted Send_PSR VF Button. 
          * Condition      : "Send PSR" button will not work if following is true: Approved to Send PSR = "No" or "Null" AND Business Unit = "UPP Americas" or "NA Commercial" 
          * Case #         : 00201084
          * Modified by    : Vinay Pathak
          * Modified Date  : March 21, 2013
          */
          
Set<String> businessUnitsSet = new Set<String>();
            
            for(Business_Unit__c bu:Business_Unit__c.getall().values()){
                if(bu.Active__c==true)
                    businessUnitsSet.add(bu.Name);
            }
            
            //if ((currentPSR.Approved_to_Send_PSR__c=='No' || String.IsBlank(currentPSR.Approved_to_Send_PSR__c))&&(currentPSR.Opportunity__r.Business_Unit__c=='UPP Americas' || currentPSR.Opportunity__r.Business_Unit__c=='NA Commercial')){
            if ((currentPSR.Approved_to_Send_PSR__c=='No' || String.IsBlank(currentPSR.Approved_to_Send_PSR__c))&&(businessUnitsSet.contains(currentPSR.Opportunity__r.Business_Unit__c))){
                ApexPages.addMessage(new ApexPages.Message( ApexPages.Severity.ERROR,'Please Obtain Sales Ops Approval to Send PSR'));   
                }
                        
            /* validation rules */           

            else {
            if (currentPSR==null){
            
                ApexPages.addMessage(new ApexPages.Message(
                    ApexPages.Severity.ERROR, 
                    'PSR is not valid.'));          

                return null;

            }   
            
                        
            if (currentPSR.PSR_Sent__c!=null){
            
                ApexPages.addMessage(new ApexPages.Message(
                    ApexPages.Severity.ERROR, 
                    'The PSR has already been sent on '
                    + currentPSR.PSR_Sent__c.format()
                    + '.'
                    + '  Please create a new PSR.'));           

                return null;

            }               

            if (currentPSR.Site__c==null){
            
                ApexPages.addMessage(new ApexPages.Message(
                    ApexPages.Severity.ERROR, 
                    'Please select a site.'));          
            }

            
           if (currentPSR.Quote__c!=null 
                && currentPSR.Quote__r.Quote_Steps__c==QuoteManagement.QUOTE_STEP_AWAITING_APPROVAL){
            
                ApexPages.addMessage(new ApexPages.Message(
                    ApexPages.Severity.ERROR, 
                    'The right to quote has not been approved.'));          
            }
                   
            //Case#00108044 - Removing Quote approval check
            /*//Added Business_Unit__c check for Case#00066255
            if(currentPSR.Business_Unit__c == null || !BUsToBypassQuoteCheck.contains(currentPSR.Business_Unit__c.toUpperCase())){
                //Case-00037455 - Check if Quote has been Approved
                //Get the latest approval process of the Quote
                List<ProcessInstance> lstProcess = new List<ProcessInstance>([Select id, TargetObjectId, Status From ProcessInstance where TargetObjectId=:currentPSR.Quote__c order by createddate desc limit 1]);
                if(lstProcess.size()==0 || (lstProcess.size()>0 && lstProcess[0].status != 'Approved')){
                     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                      'Quote is not approved. Quote should be Approved to send the PSR.'));
                    return null;
                }
            }*/
            
            if (currentPSR.Array_Layout_Revision__c && currentPSR.Site__c!=null){

                integer proposalDesignCount = 0;
                
                proposalDesignCount = 
                    [Select count() from Design__c d  
                        where d.RecordType.SobjectType = 'Design__c'
                            and d.RecordType.DeveloperName = 'Proposal_Design'
                            and d.Site__c =: currentPSR.Site__c];
                        
                        
            
                if (proposalDesignCount==0){
            
                    ApexPages.addMessage(new ApexPages.Message(
                        ApexPages.Severity.ERROR, 
                        'Design Revision requires at least 1 proposal design for the site.'));
                    
                }           
            }
            
            
            if(!currentPSR.Site_Survey_Standard__c && !currentPSR.Site_Survey_SubContractor__c && currentPSR.Site_Survey_Due__c!=null){
                ApexPages.addMessage(new ApexPages.Message(
                        ApexPages.Severity.ERROR, 
                        'You have a requested due date for Site Survey but have not requested Site Survey on the PSR request list.'));
            }
            if(!currentPSR.Array_Layout_Revision__c && !currentPSR.Array_Layout__c && currentPSR.Array_Layout_Due__c!=null){
                ApexPages.addMessage(new ApexPages.Message(
                        ApexPages.Severity.ERROR, 
                        'You have a requested due date for Design but have not requested Design on the PSR request list.'));
            }
            if(!currentPSR.Single_Line_based_on_Design__c && !currentPSR.Single_Line_without_Design__c && currentPSR.Electrical_Support_Due__c!=null){
                ApexPages.addMessage(new ApexPages.Message(
                        ApexPages.Severity.ERROR, 
                        'You have a requested due date for Single Line but have not requested Single Line on the PSR request list.'));
            }
            if(!currentPSR.PM_Cost__c && !currentPSR.PM_Cost_without_Design__c && currentPSR.Cost_Estimate_Due__c!=null){
                ApexPages.addMessage(new ApexPages.Message(
                        ApexPages.Severity.ERROR, 
                        'You have a requested due date for Estimate but have not requested Estimate on the PSR request list.'));
            }
            
            if (ApexPages.hasMessages()){
                return null;    
            }
            
            // If Array_Layout__c = false and Design__c is blank and PM_Cost__c = true
            // then display an error message  "A design is required for an estimate."       
            
            if(currentPSR.Array_Layout__c == false 
                && currentPSR.Array_Layout_Revision__c == false
                && currentPSR.Design__c == null 
                && currentPSR.PM_Cost__c == true){
                 
                ApexPages.addMessage(new ApexPages.Message(
                    ApexPages.Severity.ERROR, 
                    'A design is required for an estimate.  Please select New Design or Design Revision or enter an existing design.'));                 

                 return null;
            }


            if(currentPSR.Array_Layout__c == false 
                && currentPSR.Array_Layout_Revision__c == false
                && currentPSR.Design__c == null 
                && currentPSR.Single_Line_based_on_Design__c == true){
                 
                ApexPages.addMessage(new ApexPages.Message(
                    ApexPages.Severity.ERROR, 
                    'A design is required for a Single Line based on Design.  Please select New Design or Design Revision or enter an existing design.'));               

                 return null;
            }


            if ((currentPSR.Array_Layout__c || currentPSR.Array_Layout_Revision__c) 
                && currentPSR.Design__c!=null){

                    ApexPages.addMessage(new ApexPages.Message(
                        ApexPages.Severity.ERROR, 
                        'You cannot select New Design/Design Revision and enter an existing design.'));
                                    
            }



            /* CALCULATE Durations */

            if (currentPSR.Kickoff_Meeting_Date__c==null){
               startDate = date.today();                                                                   
            }
            else{
                
                if (currentPSR.Kickoff_Meeting_Date__c>date.today())
                    startDate = currentPSR.Kickoff_Meeting_Date__c;
                else
                    startDate = date.today();
                                    
            } 


            /* ----------------------------------------------------------------------------- */


            boolean siteSurveySelected =            
                (currentPSR.Site_Survey_Standard__c || currentPSR.Site_Survey_SubContractor__c)? true : false;
            
            boolean arrayLayoutSelected = 
                (currentPSR.Array_Layout__c || currentPSR.Array_Layout_Revision__c)? true : false;
            
            boolean electricalSupportSelected = 
                (currentPSR.Single_Line_based_on_Design__c || currentPSR.Single_Line_without_Design__c)? true : false;
            
            boolean costEstimateSelected = currentPSR.PM_Cost__c || currentPSR.PM_Cost_without_Design__c; 

            /* ----------------------------------------------------------------------------- */

            /* Site Survey is selected */
            /* Default Due Date if it's blank */
            if (currentPSR.Site_Survey_Standard__c){
                
                if (currentPSR.Site_Survey_Due__c==null){
                    currentPSR.Site_Survey_Due__c=
                        addWorkingDays(startDate,PSRManagement.DEFAULT_DAYS_SITE_SURVEY_STANDARD);
                } 
                
                siteSurveyDuration =  getNumberOfWorkingDays(startDate, currentPSR.Site_Survey_Due__c);         
                totalDuration = totalDuration + siteSurveyDuration;
                currentPSR.Site_Survey_Duration__c = siteSurveyDuration;
                
                /* Check if this is an urgent request */                                                        
                if (siteSurveyDuration<PSRManagement.DEFAULT_DAYS_SITE_SURVEY_STANDARD 
                    && !currentPSR.Site_Survey_Urgent_Request__c){
                    ApexPages.addMessage(new ApexPages.Message(
                        ApexPages.Severity.ERROR, 
                        'Please select Urgent Request if you require a Site Survey in fewer than ' 
                            + String.valueOf(PSRManagement.DEFAULT_DAYS_SITE_SURVEY_STANDARD)+ 
                            ' working days.  You have specified '
                            + String.valueOf(siteSurveyDuration)
                            + ' working day(s).'));         
                }       
                
                
            }
            else if (currentPSR.Site_Survey_SubContractor__c){
                
                if (currentPSR.Site_Survey_Due__c==null){
                    currentPSR.Site_Survey_Due__c=
                        addWorkingDays(startDate,PSRManagement.DEFAULT_DAYS_SITE_SURVEY_SUBCONTRACTOR);
                }                   
                                
                siteSurveyDuration = getNumberOfWorkingDays(startDate, currentPSR.Site_Survey_Due__c);          
                totalDuration = totalDuration + siteSurveyDuration;
                currentPSR.Site_Survey_Duration__c = siteSurveyDuration;

                /* Check if this is an urgent request */                                                        
                if (siteSurveyDuration<PSRManagement.DEFAULT_DAYS_SITE_SURVEY_SUBCONTRACTOR 
                    && !currentPSR.Site_Survey_Urgent_Request__c){
                    ApexPages.addMessage(new ApexPages.Message(
                        ApexPages.Severity.ERROR, 
                        'Please select Urgent Request if you require a Site Survey in fewer than ' 
                            + String.valueOf(PSRManagement.DEFAULT_DAYS_SITE_SURVEY_SUBCONTRACTOR)+ 
                            ' working days.  You have specified '
                            + String.valueOf(siteSurveyDuration)
                            + ' working day(s).'));         
                }       
                
            }


            /* ----------------------------------------------------------------------------- */

            /* Array Layout is selected */
            /* Default Due Date if it's blank */
            
            if (currentPSR.Site_Survey_Due__c!=null)
                arrayLayoutStartDate = currentPSR.Site_Survey_Due__c;               
            else
                arrayLayoutStartDate = startDate;                                   



            if (currentPSR.Array_Layout__c){
                 
                if (currentPSR.Array_Layout_Due__c==null){                  
                    currentPSR.Array_Layout_Due__c = 
                        addWorkingDays(arrayLayoutStartDate,PSRManagement.DEFAULT_DAYS_ARRAY_LAYOUT);                       
                }

                arrayLayoutDuration = getNumberOfWorkingDays(arrayLayoutStartDate, currentPSR.Array_Layout_Due__c);
                totalDuration = totalDuration + arrayLayoutDuration;
                currentPSR.Array_Layout_Duration__c = arrayLayoutDuration;
                                            
                

                /* Check if this is an urgent request */                                                        
                if (arrayLayoutDuration<PSRManagement.DEFAULT_DAYS_ARRAY_LAYOUT 
                    && !currentPSR.Design_Urgent_Request__c){
                    ApexPages.addMessage(new ApexPages.Message(
                        ApexPages.Severity.ERROR, 
                        'Please select Urgent Request if you require a design fewer than ' 
                            + String.valueOf(PSRManagement.DEFAULT_DAYS_ARRAY_LAYOUT)+ 
                            ' working days.  You have specified '
                            + String.valueOf(arrayLayoutDuration)
                            + ' working day(s).'));         
                }                           
                
            }
            else if (currentPSR.Array_Layout_Revision__c){

                if (currentPSR.Array_Layout_Due__c==null){                  
                    currentPSR.Array_Layout_Due__c = 
                        addWorkingDays(arrayLayoutStartDate,PSRManagement.DEFAULT_DAYS_ARRAY_LAYOUT_REVISION);
                }

                arrayLayoutDuration = getNumberOfWorkingDays(arrayLayoutStartDate, currentPSR.Array_Layout_Due__c);                     
                totalDuration = totalDuration + arrayLayoutDuration;
                currentPSR.Array_Layout_Duration__c = arrayLayoutDuration;

                /* Check if this is an urgent request */                                                        
                if (arrayLayoutDuration<PSRManagement.DEFAULT_DAYS_ARRAY_LAYOUT_REVISION 
                    && !currentPSR.Design_Urgent_Request__c){
                    ApexPages.addMessage(new ApexPages.Message(
                        ApexPages.Severity.ERROR, 
                        'Please select Urgent Request if you require a design in fewer ' 
                            + String.valueOf(PSRManagement.DEFAULT_DAYS_ARRAY_LAYOUT_REVISION)+ 
                            ' working days.  You have specified '
                            + String.valueOf(arrayLayoutDuration)
                            + ' working day(s).'));         
                }                           


            }


            /* ----------------------------------------------------------------------------- */


            if (currentPSR.Array_Layout_Due__c!=null)               
                electricalSupportStartDate = currentPSR.Array_Layout_Due__c;                
            else if (currentPSR.Site_Survey_Due__c!=null)
                electricalSupportStartDate = currentPSR.Site_Survey_Due__c; 
            else
                electricalSupportStartDate = startDate; 

            
            /*  Single Line (Electrical Support) Selected */
            if (currentPSR.Single_Line_based_on_Design__c ||
                currentPSR.Single_Line_without_Design__c
                ){
                 
                if (currentPSR.Electrical_Support_Due__c==null){                
                    currentPSR.Electrical_Support_Due__c = 
                        addWorkingDays(electricalSupportStartDate,PSRManagement.DEFAULT_DAYS_ELECTRICAL_SUPPORT);
                }

                electricalSupportDuration = getNumberOfWorkingDays(electricalSupportStartDate, currentPSR.Electrical_Support_Due__c);                       
                currentPSR.Electrical_Support_Duration__c = electricalSupportDuration;                      
                totalDuration = totalDuration + electricalSupportDuration;

                /* Check if this is an urgent request */                                                        
                if (electricalSupportDuration<PSRManagement.DEFAULT_DAYS_ELECTRICAL_SUPPORT
                    && !currentPSR.Single_Line_Urgent_Request__c){

                    ApexPages.addMessage(new ApexPages.Message(
                        ApexPages.Severity.ERROR, 
                        'Please select Urgent Request if you require a Single Line in fewer than ' 
                            + String.valueOf(PSRManagement.DEFAULT_DAYS_ELECTRICAL_SUPPORT)+ 
                            ' days.  You have specified '
                            + String.valueOf(electricalSupportDuration)
                            + ' working day(s).'));         
                }   

            }           

            /* ----------------------------------------------------------------------------- */         
        

            /* PM Cost is selected */   
            /* Default Due Date if it's blank */                    
            /* Check if this is an urgent request */


            if (currentPSR.Electrical_Support_Due__c!=null)             
                costEstimateStartDate = currentPSR.Electrical_Support_Due__c;               
            else if (currentPSR.Array_Layout_Due__c!=null)              
                costEstimateStartDate = currentPSR.Array_Layout_Due__c;             
            else if (currentPSR.Site_Survey_Due__c!=null)
                costEstimateStartDate = currentPSR.Site_Survey_Due__c;  
            else
                costEstimateStartDate = startDate;  

            
            if (currentPSR.PM_Cost__c || currentPSR.PM_Cost_without_Design__c){ 

                // there's no due date           
                if (currentPSR.Cost_Estimate_Due__c==null){ 

                    currentPSR.Cost_Estimate_Due__c=
                        addWorkingDays(costEstimateStartDate,PSRManagement.DEFAULT_DAYS_COST_ESTIMATE);

                }
                
                costEstimateDuration = 
                    getNumberOfWorkingDays(costEstimateStartDate, currentPSR.Cost_Estimate_Due__c);                                             
                currentPSR.cost_estimate_duration__c = costEstimateDuration;                                                
 
                totalDuration = totalDuration + costEstimateDuration;
                
                /* Check if this is an urgent request */                                                        
                if (costEstimateDuration<PSRManagement.DEFAULT_DAYS_COST_ESTIMATE
                    && !currentPSR.Estimate_Urgent_Request__c){

                    ApexPages.addMessage(new ApexPages.Message(
                        ApexPages.Severity.ERROR, 
                        'Please select Urgent Request if you require a Cost Estimate in fewer than ' 
                            + String.valueOf(PSRManagement.DEFAULT_DAYS_COST_ESTIMATE)+ 
                            ' days.  You have specified '
                            + String.valueOf(costEstimateDuration)
                            + ' working day(s).'));         
                }                               
            }           
            
            /* ----------------------------------------------------------------------------- */         
        

            /* Check if total duration is valid */

            if (currentPSR.Site_Survey_Standard__c){
                
                if (currentPSR.Design_Urgent_Request__c)
                    totalRequiredDuration = totalRequiredDuration + PSRManagement.MINIMUM_DAYS_SITE_SURVEY_STANDARD;
                else
                    totalRequiredDuration = totalRequiredDuration + PSRManagement.DEFAULT_DAYS_SITE_SURVEY_STANDARD;                
            }
            else if (currentPSR.Site_Survey_SubContractor__c){
                if (currentPSR.Design_Urgent_Request__c)
                    totalRequiredDuration = totalRequiredDuration + PSRManagement.MINIMUM_DAYS_SITE_SURVEY_SUBCONTRACTOR;
                else
                    totalRequiredDuration = totalRequiredDuration + PSRManagement.DEFAULT_DAYS_SITE_SURVEY_SUBCONTRACTOR;
            }


            if (currentPSR.Array_Layout__c){
            
                if (currentPSR.Design_Urgent_Request__c)
                    totalRequiredDuration = totalRequiredDuration + PSRManagement.MINIMUM_DAYS_ARRAY_LAYOUT;
                else
                    totalRequiredDuration = totalRequiredDuration + PSRManagement.DEFAULT_DAYS_ARRAY_LAYOUT;    
            }           
            else if (currentPSR.Array_Layout_Revision__c){
            
                if (currentPSR.Design_Urgent_Request__c)
                    totalRequiredDuration = totalRequiredDuration + PSRManagement.MINIMUM_DAYS_ARRAY_LAYOUT_REVISION;
                else
                    totalRequiredDuration = totalRequiredDuration + PSRManagement.DEFAULT_DAYS_ARRAY_LAYOUT_REVISION;   
            }

            if (currentPSR.Single_Line_based_on_Design__c || 
                currentPSR.Single_Line_without_Design__c){
                if (currentPSR.Single_Line_Urgent_Request__c)
                    totalRequiredDuration = totalRequiredDuration + PSRManagement.MINIMUM_DAYS_ELECTRICAL_SUPPORT;
                else 
                    totalRequiredDuration = totalRequiredDuration + PSRManagement.DEFAULT_DAYS_ELECTRICAL_SUPPORT;
            }


            if (currentPSR.PM_Cost__c || currentPSR.PM_Cost_without_Design__c){
            
                if (currentPSR.Estimate_Urgent_Request__c)
                    totalRequiredDuration = totalRequiredDuration + PSRManagement.MINIMUM_DAYS_COST_ESTIMATE;
                else
                    totalRequiredDuration = totalRequiredDuration + PSRManagement.DEFAULT_DAYS_COST_ESTIMATE;   
                
            }
            
            currentPSR.Total_Required_Duration__c=totalRequiredDuration;


            if (totalDuration<totalRequiredDuration){

                    ApexPages.addMessage(new ApexPages.Message(
                        ApexPages.Severity.ERROR, 
                        'The minimum required duration is ' 
                            + String.valueOf(totalRequiredDuration) 
                            + ' working days.  You have specified a duration of  ' 
                            + String.valueOf(totalDuration) 
                            + ' working days.'));           
            }   


            if(currentPSR.Array_Layout_Due__c!=null){           
                if(currentPSR.Cost_Estimate_Due__c!=null && currentPSR.PM_Cost__c && currentPSR.Array_Layout_Due__c.daysBetween(currentPSR.Cost_Estimate_Due__c)<1){
                     ApexPages.addMessage(new ApexPages.Message(
                        ApexPages.Severity.ERROR, 
                        'Cost Estimate Due date must be at least 1 day after Design Due date.'));
                }
                        
                if(currentPSR.Electrical_Support_Due__c!=null && currentPSR.Single_Line_based_on_Design__c && currentPSR.Array_Layout_Due__c.daysBetween(currentPSR.Electrical_Support_Due__c)<1){
                     ApexPages.addMessage(new ApexPages.Message(
                        ApexPages.Severity.ERROR, 
                        'Electrical Support Due date must be at least 1 day after Design Due date.'));
                }           
            }
            
            /* ----------------------------------------------------------------------------- */
                        


            if (ApexPages.hasMessages()){
                return null;    
            }
            
            /* Commented below for Sunpower Case # 00037855
            // update due dates
            currentPSR.PSR_Sent__c=datetime.now();
            update currentPSR;          
            **************************************/

            //If Array_Layout__c = true and Design__c is null
            //then create new design record
            if(currentPSR.Array_Layout__c || currentPSR.Array_Layout_Revision__c){
                design = new Design__c();
                design.RecordTypeId = proposalDesignRecordTypeId;
                design.Site__c = currentPSR.Site__c;
                design.Opportunity__c = currentPSR.Opportunity__c;
                        
                design.Requested_System_Size__c=
                    currentPSR.Requested_System_Size__c;
                
                design.Product_Type__c=currentPSR.Product_Type__c;
                design.Module_Type__c=currentPSR.Module_Type__c;  
                design.Urgent_Request__c=currentPSR.Design_Urgent_Request__c;
                design.PSR__c=currentPSR.Id;
                design.Commercial_Operation_Date__c = currentPSR.Commercial_Operation_Date__c;                          
                design.VDC__c = currentPSR.VDC__c;
                design.DC_AC_Ratio__c = currentPSR.DC_AC_Ratio__c;
                design.GCR__c = currentPSR.GCR__c;
                // Done for Case # 00067528
                // Setting "Negotiated Due Date" field default to "Original Due Date" (PSR:Array Layout Due)
                design.Date_of_Agreed_Delivery__c = currentPSR.Array_Layout_Due__c;
                                                                                
                if (currentPSR.Proposal_Designer__c!=null){
                    design.Proposal_Designer__c  = currentPSR.Proposal_Designer__c;     
                    design.OwnerId = currentPSR.Proposal_Designer__c;
                }    
                
                insert design;
                /*-----adding the team to opportunity-----Case#00052010-----------------*/
                if(design.OwnerId!=null){
                    oppteam = new OpportunityTeamMember(); 
                    oppteam.OpportunityId = currentPSR.Opportunity__c;
                    oppteam.UserId = design.OwnerId;
                    oppteam.TeamMemberRole = 'Proposal Designer';
                    //Case#00066255
                    lstOppteam.add(oppteam);                    
                }                
                
                ApexPages.Message designCreatedMsg = 
                    new ApexPages.Message(ApexPages.Severity.INFO, 
                        'A design has been successfully created.');
                ApexPages.addMessage(designCreatedMsg);
                                                
                currentPSR.Design__c = design.ID;
 
            }   



            //If Single_Line_based_on_Design__c = true then create new single line record
 
 
            if(currentPSR.Single_Line_based_on_Design__c ||
                currentPSR.Single_Line_without_Design__c){

                singleLine = new Single_Line__c();
                singleLine.Opportunity__c = currentPSR.Opportunity__c;
                singleLine.Site__c = currentPSR.Site__c;
                singleLine.PSR__c = currentPSR.Id;
                //Added by Anuradha for case # 00074956
                singleLine.Negotiated_Due_Date__c = currentPSR.Electrical_Support_Due__c;
                
                if(currentPSR.Design__c != null)
                    singleLine.Design__c = currentPSR.Design__c;    
                else if(design!=null && design.ID != null)
                    singleLine.Design__c = design.ID;   

                
                if (currentPSR.Electrical_Engineer__c!=null){       
                    singleLine.OwnerId = currentPSR.Electrical_Engineer__c;
                }   

                insert singleLine;
                    
                ApexPages.Message singleLineCreatedMsg = 
                    new ApexPages.Message(ApexPages.Severity.INFO, 
                        'A single line has been successfully created.');
                ApexPages.addMessage(singleLineCreatedMsg); 
                
                currentPSR.Single_Line__c = singleLine.ID;
            }


                    
            //If PM_Cost__c = true then create new Estimate record
            if(currentPSR.PM_Cost__c || currentPSR.PM_Cost_without_Design__c){

                estimate = new Estimate__c();
                estimate.Site__c = currentPSR.Site__c;
                estimate.Opportunity__c = currentPSR.Opportunity__c;
                estimate.PSR__c = currentPSR.Id;
                estimate.PV_Wp__c = currentPSR.PV_Cost_Wp__c;
                estimate.Commercial_Operation_Date__c = currentPSR.Commercial_Operation_Date__c;
                estimate.GCR__c = currentPSR.GCR__c;
                estimate.VDC__c = currentPSR.VDC__c;                
                estimate.DC_AC_Ratio__c = currentPSR.DC_AC_Ratio__c;
                estimate.Product_Type__c=currentPSR.Product_Type__c;
                estimate.Module_Type__c=currentPSR.Module_Type__c;  
                estimate.System_Size_kWp__c=
                    currentPSR.Requested_System_Size__c;
                estimate.Quote_Number__c=currentPSR.Quote__r.QuoteNumber;  
                estimate.Quote__c=currentPSR.Quote__c;   
                estimate.Urgent_Request__c=currentPSR.Estimate_Urgent_Request__c;

                                                                                                
                if(currentPSR.Design__c != null)
                    estimate.Design__c = currentPSR.Design__c;  
                else if(design!=null && design.ID != null)
                    estimate.Design__c = design.ID; 
                    
                if (currentPSR.Estimator__c!=null){
                    estimate.Estimator__c = currentPSR.Estimator__c;        

                }   

                if (currentPSR.Project_Manager__c!=null){
                    estimate.Project_Manager__c = currentPSR.Project_Manager__c;        
                    estimate.OwnerId = currentPSR.Project_Manager__c;
                }   

                if (currentPSR.Project_Manager__c!=null){
                    estimate.Project_Manager__c = currentPSR.Project_Manager__c;        
                }   
                
                if (currentPSR.Estimate_Reviewer__c!=null){
                    estimate.Estimate_Reviewer__c = currentPSR.Estimate_Reviewer__c;        
                }                   



                if (currentPSR.Opportunity__c!=null){
                    estimate.name=currentPSR.Opportunity__r.Name;               
                }
                
                // Commented below as per Case 00039908
                /*
                if (currentPSR.Site__c!=null){

                    estimate.name=estimate.name+' '+currentPSR.Site__r.Site_Name__c;    
                }
                */
                
                insert estimate;
                /*-----adding the team to opportunity-----Case#00052010-----------------*/
                if(estimate.OwnerId!=null){
                    oppteam = new OpportunityTeamMember(); 
                    oppteam.OpportunityId = currentPSR.Opportunity__c;
                    oppteam.UserId = estimate.OwnerId;
                    oppteam.TeamMemberRole = 'Estimator';
                    lstOppteam.add(oppteam);
                }    
                
                if(lstOppteam.size()>0){
                    insert lstOppteam;
                }
                system.debug('----------------------Abhay-----------'+lstOppteam); 
                ApexPages.Message estimateCreatedMsg = 
                    new ApexPages.Message(ApexPages.Severity.INFO, 
                        'An estimate has been successfully created.');
                ApexPages.addMessage(estimateCreatedMsg);   
                
                currentPSR.Estimate__c = estimate.ID;
            }
            
            //If Site_Survey_Standard__c(Site Survey - SPWR Personnel) = true OR
            //Site_Survey_SubContractor__c(Site Survey - SPWR & SubContractor) = true 
            //create a Task record
            if(currentPSR.Site_Survey_SubContractor__c || currentPSR.Site_Survey_Standard__c){

                List<RecordType> taskRecordTypeList = [SELECT Id FROM RecordType 
                                                        WHERE SObjectType = 'Task'
                                                        AND Name = 'Engineering Task'];
                
                if(taskRecordTypeList.size() > 0){
                    task = new Task();
                    task.RecordTypeId = taskRecordTypeList.get(0).id;
                    task.Task_Type__c = 'Site Audit';
                    task.PSR_ID__c = currentPSR.id;
                    task.Subject = 'Site Survey Request - ' + currentPSR.Site__r.Site_Name__c;      
                    task.PSR_Comments__c = currentPSR.Survey_Comments__c;
                    
                    //Commented for Case#00068745
                    //task.ActivityDate = currentPSR.Site_Survey_Due__c;
                    task.WhatID = currentPSR.Site__c;
                    task.Request_Category__c = currentPSR.Request_Category__c;
                    task.Request_sub_Category__c = currentPSR.Request_sub_Category__c;

                    task.Urgent_Request__c=currentPSR.Site_Survey_Urgent_Request__c;
                    
                     //added for Case#00063303 
                    task.Tracking_Date__c = currentPSR.Site_Audit_Tracking__c;
                    
                    if (currentPSR.Site_Surveyor__c!=null)                  
                        task.OwnerId = currentPSR.Site_Surveyor__c; 
            
                    //Create task and send Notification Email to task owner.
                    Database.DMLOptions dmlo = new Database.DMLOptions();
                    dmlo.EmailHeader.triggerUserEmail = true;
                    try{                        
                        database.insert(task, dmlo);
                        
                        //Update Site Survey ID with the new Task ID.
                        currentPSR.Site_Survey_ID__c = task.id;
                        
                        ApexPages.Message taskCreatedMsg = new ApexPages.Message(ApexPages.Severity.INFO, 
                                                    'A Site Survey task has been successfully created.');
                                                    
                        ApexPages.addMessage(taskCreatedMsg);

                    }catch (Exception e) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
                        return null;
                    }                    
                   
                }
            }
            
            // update PSR Sent Date
            currentPSR.PSR_Sent__c=datetime.now();
            
            // Done for Case # 00073004 Setting Default value for field "Received Information to Design date"
            /* If PSR is sent without a site audit request but with a Design request, set 'Received Information to Design date' default to PSR sent date. */
            if(arrayLayoutSelected && !siteSurveySelected && currentPSR.Received_Information_to_Design_date__c == null){
                currentPSR.Received_Information_to_Design_date__c = currentPSR.PSR_Sent__c.date();          
            }
            // End Case # 00073004.
            
            update currentPSR;

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 
                'The PSR has been sent.'));                     


            // update Quote Step

            //if (currentPSR.Quote__c!=null){
            //    quote = new Quote (Id=currentPSR.Quote__c);
            //    quote.quote_steps__c = '2. PSR In Progress';        
            //    update quote;
           // }           

            }   // End of else block for Case # 00201084 
        
        }catch(Exception ex){
            System.debug('*****Exception********');
            System.debug('**'+ex);
            System.debug('*************');

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
        }
        return null;
            
    } 


    
    
    /** Action function called from button 'return to PSR' on page 'Send_PSR'. 
     *  @return PageReference
     */     
    public PageReference returnToPSR(){
        
        return new PageReference('/' + currentPSR.Id);
 
    }
}