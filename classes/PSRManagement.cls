public class PSRManagement {

    
    static public string PSR_STEP_KICKOFF_MEETING   = '1. Kick-off meeting';   
    static public string PSR_STEP_SITE_SURVEY       = '2. Site Audit';   
    static public string PSR_STEP_ARRAY_LAYOUT      = '3. Array Layout';
    static public string PSR_STEP_SINGLE_LINE       = '4. Electrical Support';
    static public string PSR_STEP_COST_ESTIMATE     = '5. Cost Estimate';
    static public string PSR_STEP_PSR_COMPLETE      = '6. PSR Complete';
    static public string PSR_STEP_PSR_REJECTED      = '7. PSR Rejected';

    static public integer DEFAULT_DAYS_SITE_SURVEY_STANDARD = 2;
    static public integer DEFAULT_DAYS_SITE_SURVEY_SUBCONTRACTOR = 2;    
    static public integer DEFAULT_DAYS_ARRAY_LAYOUT = 4;
    static public integer DEFAULT_DAYS_ARRAY_LAYOUT_REVISION = 3;
    static public integer DEFAULT_DAYS_ELECTRICAL_SUPPORT = 1;
    static public integer DEFAULT_DAYS_COST_ESTIMATE = 5;

    static public integer MINIMUM_DAYS_SITE_SURVEY_STANDARD = 1;
    static public integer MINIMUM_DAYS_SITE_SURVEY_SUBCONTRACTOR = 2; 
    static public integer MINIMUM_DAYS_ARRAY_LAYOUT = 1;
    static public integer MINIMUM_DAYS_ARRAY_LAYOUT_REVISION = 1;
    static public integer MINIMUM_DAYS_ELECTRICAL_SUPPORT = 1;
    static public integer MINIMUM_DAYS_COST_ESTIMATE = 1;
         
    static public Set<String> weekendDaysSet = new Set<String>{'saturday','sunday'} ;
    
    public static void beforePSRUpdate(List<PSR__c> psrList, List<PSR__c> oldPSRList, Map<ID,PSR__c> mapPSRold){      
        populateFields(psrList,mapPSRold);
        
        //Added under case-00038856
        //Allow to create related object even after sending the PSR
        sendPSRFunction(psrList, mapPSRold); 
    }

    public static void beforePSRInsert(List<PSR__c> psrList){
        populateFields(psrList,null);
    }

    public static void afterPSRUpdate(List<PSR__c> psrList, List<PSR__c> oldPSRList){
        populateRelatedObjects(psrList);      
    }
    

    public static void afterPSRInsert(List<PSR__c> psrList){

        populateRelatedObjects(psrList);
    }
    //Get max Date
    private static Date getMaxDate(Date dt1, Date dt2){
        Date dt = null;
        if(dt1==null && dt2==null){
            return null;
        }
        else if(dt1==null && dt2!=null){
            return dt2;
        }
        else if(dt1!=null && dt2==null){
            return dt1;
        }
        else{
            dt = (dt1 > dt2)?dt1:dt2;
        }
        return dt;
    }
    
    private static integer getNumberOfWorkingDays(Date startDate, Date endDate){
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
    private static Date addWorkingDays(Date startDate, Integer days) {

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
    
    //Added under case-00038856
    //Allow to create related object even after sending the PSR
    public static void sendPSRFunction(List<PSR__c> psrList, Map<ID,PSR__c> mapPSRold){
        try{        
        Set<ID> psrIds = new Set<ID>();
        Set<ID> setSite = new Set<ID>();
        List<PSR__c> newPsrList = new List<PSR__c>();
        for(PSR__c currentPSR : psrList){   
            //Go for send PSR function only if PSR is already sent
            if(currentPSR.PSR_Sent__c == null){
                continue; 
            }
            
            //Request uncheck should not be allowed
            if((!currentPSR.Site_Survey_SubContractor__c && mapPSRold.get(currentPSR.ID).Site_Survey_SubContractor__c) || (!currentPSR.Site_Survey_Standard__c && mapPSRold.get(currentPSR.ID).Site_Survey_Standard__c)
            || (!currentPSR.Array_Layout__c && mapPSRold.get(currentPSR.ID).Array_Layout__c) || (!currentPSR.Array_Layout_Revision__c && mapPSRold.get(currentPSR.ID).Array_Layout_Revision__c) 
            || (!currentPSR.Single_Line_based_on_Design__c && mapPSRold.get(currentPSR.ID).Single_Line_based_on_Design__c) || (!currentPSR.Single_Line_without_Design__c && mapPSRold.get(currentPSR.ID).Single_Line_without_Design__c) 
            || (!currentPSR.PM_Cost__c && mapPSRold.get(currentPSR.ID).PM_Cost__c) || (!currentPSR.PM_Cost_without_Design__c && mapPSRold.get(currentPSR.ID).PM_Cost_without_Design__c)){
                currentPSR.AddError('No Request can be canceled once PSR is sent.');
                return;
            }
            
            //Due date should not be set if any activity is not requested
            if(!currentPSR.Site_Survey_Standard__c && !currentPSR.Site_Survey_SubContractor__c && currentPSR.Site_Survey_Due__c!=null){
                currentPSR.AddError('You have a requested due date for Site Survey but have not requested Site Survey on the PSR request list.');
                return;
            }
            if(!currentPSR.Array_Layout_Revision__c && !currentPSR.Array_Layout__c && currentPSR.Array_Layout_Due__c!=null){
                currentPSR.AddError('You have a requested due date for Design but have not requested Design on the PSR request list.');
                return;
            }
            if(!currentPSR.Single_Line_based_on_Design__c && !currentPSR.Single_Line_without_Design__c && currentPSR.Electrical_Support_Due__c!=null){
                currentPSR.AddError('You have a requested due date for Single Line but have not requested Single Line on the PSR request list.');
                return;
            }
            if(!currentPSR.PM_Cost__c && !currentPSR.PM_Cost_without_Design__c && currentPSR.Cost_Estimate_Due__c!=null){
                currentPSR.AddError('You have a requested due date for Estimate but have not requested Estimate on the PSR request list.');
                return;
            }                        
            
            //Design      
            if((currentPSR.Array_Layout__c==true && mapPSRold.get(currentPSR.ID).Array_Layout__c==false) || (currentPSR.Array_Layout_Revision__c==true && mapPSRold.get(currentPSR.ID).Array_Layout_Revision__c==false)){                                                                
                if(currentPSR.Array_Layout_Revision__c && currentPSR.Site__c!=null){
                    setSite.add(currentPSR.Site__c);
                }
            }//End If
            
            //Validate Single Line
            if((currentPSR.Single_Line_based_on_Design__c && !mapPSRold.get(currentPSR.ID).Single_Line_based_on_Design__c) || (currentPSR.Single_Line_without_Design__c && !mapPSRold.get(currentPSR.ID).Single_Line_without_Design__c)){           
                //Validate
                if(!currentPSR.Array_Layout__c && !currentPSR.Array_Layout_Revision__c && currentPSR.Design__c == null && currentPSR.Single_Line_based_on_Design__c){
                    currentPSR.addError('A design is required for a Single Line based on Design.  Please select New Design or Design Revision or enter an existing design.');                
                    return;
                }               
            }//End If  
            
            //Validate Estimate
            if((currentPSR.PM_Cost__c && !mapPSRold.get(currentPSR.ID).PM_Cost__c) || (currentPSR.PM_Cost_without_Design__c && !mapPSRold.get(currentPSR.ID).PM_Cost_without_Design__c)){           
                //Validate
                if(!currentPSR.Array_Layout__c && !currentPSR.Array_Layout_Revision__c && currentPSR.Design__c == null && currentPSR.PM_Cost__c){
                    currentPSR.addError('A design is required for an estimate.  Please select New Design or Design Revision or enter an existing design.');                
                    return;
                }
                
                if (currentPSR.Opportunity__c!=null){
                    psrIds.add(currentPSR.Id);
                }                                                                   
            }//End If  
            
            newPsrList.add(currentPSR);
        }//End for loop    
        
        //List to Insert record
        List<Design__c> lstDesign = new List<Design__c>();
        List<Single_Line__c> lstSingleLine = new List<Single_Line__c>();
        List<Estimate__c> lstEstimate = new List<Estimate__c>();
        List<Task> lstTask = new List<Task>();
        
        //Get PSR reference Data
        Map<ID,PSR__c> mapPSR = new Map<ID,PSR__c>();
        if (psrIds.size() > 0) {
            mapPSR = new Map<ID,PSR__c>([Select id,Opportunity__r.name,site__r.Site_Name__c from PSR__c where id in :psrIds]);
        }
        
        //Get Design record type
        Schema.DescribeSObjectResult d = Schema.SObjectType.Design__c; 
        Map<ID,Schema.RecordTypeInfo> rtMapByID = d.getRecordTypeInfosById();           
        ID proposalDesignRecordTypeId = null;
        for(ID recID : rtMapByID.keySet()){
            if(rtMapByID.get(recID).name == 'Proposal Design'){
                proposalDesignRecordTypeId = recID;
                break;
            }           
        }
        
        //Get Task record type
        Schema.DescribeSObjectResult dt = Schema.SObjectType.Task; 
        Map<ID,Schema.RecordTypeInfo> rtTaskMapByID = dt.getRecordTypeInfosById();           
        ID taskRecordTypeID = null;
        for(ID recID : rtTaskMapByID.keySet()){         
            if(rtTaskMapByID.get(recID).Name == 'Engineering Task'){
                taskRecordTypeID = recID;
                break;
            }           
        }
        
        map<String,Design__c> mapSiteDesign = new map<String,Design__c>();
        if (setSite.size() > 0) {
            for(Design__c de : [Select id,Site__c from Design__c where RecordType.SobjectType = 'Design__c'
                                and RecordType.DeveloperName = 'Proposal_Design'
                                and Site__c in :setSite]){
                mapSiteDesign.put(de.Site__c,de);
            }
        }
        
        Design__c design = null;
        
        for(PSR__c currentPSR : newPsrList){   
            if(currentPSR.isFirstRun__c){
                currentPSR.isFirstRun__c = false;
                continue;
            }
            boolean isPSRChanged = false;
            
            integer totalDuration = 0;
            integer totalRequiredDuration = 0;
            
            integer siteSurveyDuration = 0;         
            integer arrayLayoutDuration = 0;            
            integer electricalSupportDuration = 0;          
            integer costEstimateDuration = 0;  
            
            boolean siteSurveyRequest = false;
            boolean designRequest = false;
            boolean singleLineRequest = false;
            boolean estimateRequest = false;
            
            Date startDate = null;
            //Get the start date 
            //Get max due Date of already created related records
            Date maxDueDate = getMaxDate(getMaxDate(getMaxDate(currentPSR.Site_Survey_Due__c , currentPSR.Array_Layout_Due__c),currentPSR.Electrical_Support_Due__c),currentPSR.Cost_Estimate_Due__c);
            if(maxDueDate != null){
                if(maxDueDate > Date.Today()){
                    startDate = maxDueDate;
                }
                else{
                    startDate = Date.Today();
                }               
            }
            else if (currentPSR.Kickoff_Meeting_Date__c==null){
               startDate = date.today();                                                                   
            }
            else{                
                if (currentPSR.Kickoff_Meeting_Date__c>date.today())
                    startDate = currentPSR.Kickoff_Meeting_Date__c;
                else
                    startDate = date.today();                                    
            } 
            
            //Create Task
            if((currentPSR.Site_Survey_SubContractor__c && !mapPSRold.get(currentPSR.ID).Site_Survey_SubContractor__c) || (currentPSR.Site_Survey_Standard__c && !mapPSRold.get(currentPSR.ID).Site_Survey_Standard__c)){                          
                siteSurveyRequest = true;
                //Set due date and duration                
                if(currentPSR.Site_Survey_Due__c == null){
                    if(currentPSR.Site_Survey_SubContractor__c && !mapPSRold.get(currentPSR.ID).Site_Survey_SubContractor__c)
                        currentPSR.Site_Survey_Due__c = addWorkingDays(startDate,PSRManagement.DEFAULT_DAYS_SITE_SURVEY_SUBCONTRACTOR);
                    else
                        currentPSR.Site_Survey_Due__c = addWorkingDays(startDate,PSRManagement.DEFAULT_DAYS_SITE_SURVEY_STANDARD);
                }
                siteSurveyDuration =  getNumberOfWorkingDays(startDate, currentPSR.Site_Survey_Due__c);                         
                currentPSR.Site_Survey_Duration__c = siteSurveyDuration;
                
                //Update total duration and total required duration                
                totalDuration = totalDuration + siteSurveyDuration;
                if (currentPSR.Site_Survey_Standard__c){                
                    if (currentPSR.Site_Survey_Urgent_Request__c)
                        totalRequiredDuration = totalRequiredDuration + PSRManagement.MINIMUM_DAYS_SITE_SURVEY_STANDARD;
                    else
                        totalRequiredDuration = totalRequiredDuration + PSRManagement.DEFAULT_DAYS_SITE_SURVEY_STANDARD;                
                }
                else if (currentPSR.Site_Survey_SubContractor__c){
                    if (currentPSR.Site_Survey_Urgent_Request__c)
                        totalRequiredDuration = totalRequiredDuration + PSRManagement.MINIMUM_DAYS_SITE_SURVEY_SUBCONTRACTOR;
                    else
                        totalRequiredDuration = totalRequiredDuration + PSRManagement.DEFAULT_DAYS_SITE_SURVEY_SUBCONTRACTOR;
                }
                
                //Validate
                if(currentPSR.Site_Survey_SubContractor__c && siteSurveyDuration<PSRManagement.DEFAULT_DAYS_SITE_SURVEY_SUBCONTRACTOR && !currentPSR.Site_Survey_Urgent_Request__c){                    
                    currentPSR.AddError('Please select Urgent Request if you require a Site Survey in fewer than ' 
                        + String.valueOf(PSRManagement.DEFAULT_DAYS_SITE_SURVEY_SUBCONTRACTOR)+ 
                        ' working days.  You have specified '
                        + String.valueOf(siteSurveyDuration)
                        + ' working day(s).');  
                    return;                 
                }
                else if(currentPSR.Site_Survey_Standard__c && siteSurveyDuration<PSRManagement.DEFAULT_DAYS_SITE_SURVEY_STANDARD 
                    && !currentPSR.Site_Survey_Urgent_Request__c){
                    currentPSR.AddError('Please select Urgent Request if you require a Site Survey in fewer than ' 
                            + String.valueOf(PSRManagement.DEFAULT_DAYS_SITE_SURVEY_STANDARD)+ 
                            ' working days.  You have specified '
                            + String.valueOf(siteSurveyDuration)
                            + ' working day(s).');
                     return; 
                }
                system.debug('----taskRecordTypeID-----'+taskRecordTypeID);
                if(taskRecordTypeID != null){                    
                    Task task = new Task();
                    task.RecordTypeId = taskRecordTypeID;
                    task.Task_Type__c = 'Site Audit';
                    task.PSR_ID__c = currentPSR.id;
                    task.Subject = 'Site Survey Request - ' + currentPSR.Site__r.Site_Name__c;      
                    task.PSR_Comments__c = currentPSR.Survey_Comments__c;
                    
                    //Commented for Case#00068745
                    //task.ActivityDate = currentPSR.Site_Survey_Due__c;
                    task.WhatID = currentPSR.Site__c;
                    task.Urgent_Request__c=currentPSR.Site_Survey_Urgent_Request__c;
                    task.Request_Category__c = currentPSR.Request_Category__c;
                    task.Request_sub_Category__c = currentPSR.Request_sub_Category__c;
                    
                    //added for Case#00063303 
                    task.Tracking_Date__c = currentPSR.Site_Audit_Tracking__c;
                    
                    if (currentPSR.Site_Surveyor__c!=null)                  
                        task.OwnerId = currentPSR.Site_Surveyor__c; 
                    
                    currentPSR.isFirstRun__c = true;
                    isPSRChanged = true;
                    lstTask.Add(task);                                      
                }
            }//End If
            
            //set arrayLayoutStartDate
            Date arrayLayoutStartDate = null;
            if (siteSurveyRequest)
                arrayLayoutStartDate = currentPSR.Site_Survey_Due__c;               
            else
                arrayLayoutStartDate = startDate;  
                
            //Create Design      
            if((currentPSR.Array_Layout__c==true && mapPSRold.get(currentPSR.ID).Array_Layout__c==false) || (currentPSR.Array_Layout_Revision__c==true && mapPSRold.get(currentPSR.ID).Array_Layout_Revision__c==false)){                                                                
                designRequest = true; 
                
                //Validate
                if(currentPSR.Array_Layout_Revision__c && (currentPSR.Site__c==null || (currentPSR.Site__c!=null && mapSiteDesign.get(currentPSR.Site__c)==null))){
                    currentPSR.addError('Design Revision requires at least 1 proposal design for the site.');
                    return;
                }
                if ((currentPSR.Array_Layout__c || currentPSR.Array_Layout_Revision__c) && currentPSR.Design__c!=null){
                    currentPSR.addError('You cannot select New Design/Design Revision and enter an existing design.'+currentPSR.Array_Layout__c+'---'+mapPSRold.get(currentPSR.ID).Array_Layout__c+'---'+mapPSRold.get(currentPSR.ID).Design__c+'---'+currentPSR.Design__c);
                    return; 
                }
                
                
                //Set due date and duration                
                if (currentPSR.Array_Layout_Due__c==null){  
                    if(currentPSR.Array_Layout__c && !mapPSRold.get(currentPSR.ID).Array_Layout__c)                
                        currentPSR.Array_Layout_Due__c = addWorkingDays(arrayLayoutStartDate,PSRManagement.DEFAULT_DAYS_ARRAY_LAYOUT);
                    else
                        currentPSR.Array_Layout_Due__c = addWorkingDays(arrayLayoutStartDate,PSRManagement.DEFAULT_DAYS_ARRAY_LAYOUT_REVISION);                       
                }

                arrayLayoutDuration = getNumberOfWorkingDays(arrayLayoutStartDate, currentPSR.Array_Layout_Due__c);                
                currentPSR.Array_Layout_Duration__c = arrayLayoutDuration;
                
                //Update total duration and total required duration                
                totalDuration = totalDuration + arrayLayoutDuration;
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
                
                //Validate
                if(currentPSR.Array_Layout__c && arrayLayoutDuration<PSRManagement.DEFAULT_DAYS_ARRAY_LAYOUT && !currentPSR.Design_Urgent_Request__c){
                    currentPSR.addError('Please select Urgent Request if you require a design fewer than ' 
                            + String.valueOf(PSRManagement.DEFAULT_DAYS_ARRAY_LAYOUT)+ 
                            ' working days.  You have specified '
                            + String.valueOf(arrayLayoutDuration)
                            + ' working day(s).');
                    return;
                }
                else if(currentPSR.Array_Layout_Revision__c && arrayLayoutDuration<PSRManagement.DEFAULT_DAYS_ARRAY_LAYOUT_REVISION && !currentPSR.Design_Urgent_Request__c){
                    currentPSR.addError('Please select Urgent Request if you require a design in fewer ' 
                            + String.valueOf(PSRManagement.DEFAULT_DAYS_ARRAY_LAYOUT_REVISION)+ 
                            ' working days.  You have specified '
                            + String.valueOf(arrayLayoutDuration)
                            + ' working day(s).');
                    return;
                }
                               
                design = new Design__c();
                design.RecordTypeId = proposalDesignRecordTypeId;
                design.Site__c = currentPSR.Site__c;
                design.Opportunity__c = currentPSR.Opportunity__c;                        
                design.Requested_System_Size__c = currentPSR.Requested_System_Size__c;                
                design.Product_Type__c=currentPSR.Product_Type__c;
                //design.Module_Type__c=currentPSR.Module_Type__c;  
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
                
                currentPSR.isFirstRun__c = true;
                isPSRChanged = true;
                lstDesign.Add(design);                                               
            }//End If
            
            //Set single line start date
            Date electricalSupportStartDate = null;
            if (designRequest)               
                electricalSupportStartDate = currentPSR.Array_Layout_Due__c;                
            else if (siteSurveyRequest)
                electricalSupportStartDate = currentPSR.Site_Survey_Due__c; 
            else
                electricalSupportStartDate = startDate; 
                
            //Create Single Line
            if((currentPSR.Single_Line_based_on_Design__c && !mapPSRold.get(currentPSR.ID).Single_Line_based_on_Design__c) || (currentPSR.Single_Line_without_Design__c && !mapPSRold.get(currentPSR.ID).Single_Line_without_Design__c)){           
                singleLineRequest = true;
                
                //Set due date and duration                
                if (currentPSR.Electrical_Support_Due__c==null){                                 
                    currentPSR.Electrical_Support_Due__c = addWorkingDays(electricalSupportStartDate,PSRManagement.DEFAULT_DAYS_ELECTRICAL_SUPPORT);                   
                }
                electricalSupportDuration = getNumberOfWorkingDays(electricalSupportStartDate, currentPSR.Electrical_Support_Due__c);                       
                currentPSR.Electrical_Support_Duration__c = electricalSupportDuration;                      
                
                //Update total duration and total required duration                
                totalDuration = totalDuration + electricalSupportDuration;                
                if (currentPSR.Single_Line_Urgent_Request__c)
                    totalRequiredDuration = totalRequiredDuration + PSRManagement.MINIMUM_DAYS_ELECTRICAL_SUPPORT;
                else 
                    totalRequiredDuration = totalRequiredDuration + PSRManagement.DEFAULT_DAYS_ELECTRICAL_SUPPORT;
                    
                //Validate
                if (electricalSupportDuration<PSRManagement.DEFAULT_DAYS_ELECTRICAL_SUPPORT && !currentPSR.Single_Line_Urgent_Request__c){
                    currentPSR.addError('Please select Urgent Request if you require a Single Line in fewer than ' 
                            + String.valueOf(PSRManagement.DEFAULT_DAYS_ELECTRICAL_SUPPORT)+ 
                            ' days.  You have specified '
                            + String.valueOf(electricalSupportDuration)
                            + ' working day(s).');                
                    return;                            
                }
                
                Single_Line__c singleLine = new Single_Line__c();
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
                
                currentPSR.isFirstRun__c = true;
                isPSRChanged = true;
                lstSingleLine.Add(singleLine);                                                                   
            }//End If  
            
            //Get cost Estimate start date
            Date costEstimateStartDate = null;
            if (singleLineRequest)             
                costEstimateStartDate = currentPSR.Electrical_Support_Due__c;               
            else if (designRequest)              
                costEstimateStartDate = currentPSR.Array_Layout_Due__c;             
            else if (siteSurveyRequest)
                costEstimateStartDate = currentPSR.Site_Survey_Due__c;  
            else
                costEstimateStartDate = startDate;
                
            //Create Estimate
            if((currentPSR.PM_Cost__c && !mapPSRold.get(currentPSR.ID).PM_Cost__c) || (currentPSR.PM_Cost_without_Design__c && !mapPSRold.get(currentPSR.ID).PM_Cost_without_Design__c)){           
                EstimateRequest = true;
                
                //Set due date and duration                
                if (currentPSR.Cost_Estimate_Due__c==null){                                  
                    currentPSR.Cost_Estimate_Due__c = addWorkingDays(costEstimateStartDate,PSRManagement.DEFAULT_DAYS_COST_ESTIMATE);                   
                }
                costEstimateDuration = getNumberOfWorkingDays(costEstimateStartDate, currentPSR.Cost_Estimate_Due__c);                                             
                currentPSR.cost_estimate_duration__c = costEstimateDuration;  
                
                //Update total duration and total required duration                
                totalDuration = totalDuration + costEstimateDuration;
                if (currentPSR.Estimate_Urgent_Request__c)
                    totalRequiredDuration = totalRequiredDuration + PSRManagement.MINIMUM_DAYS_COST_ESTIMATE;
                else
                    totalRequiredDuration = totalRequiredDuration + PSRManagement.DEFAULT_DAYS_COST_ESTIMATE;
                
                //Validate
                if (costEstimateDuration<PSRManagement.DEFAULT_DAYS_COST_ESTIMATE && !currentPSR.Estimate_Urgent_Request__c){
                    currentPSR.addError('Please select Urgent Request if you require a Cost Estimate in fewer than ' 
                            + String.valueOf(PSRManagement.DEFAULT_DAYS_COST_ESTIMATE)+ 
                            ' days.  You have specified '
                            + String.valueOf(costEstimateDuration)
                            + ' working day(s).');                
                    return;                            
                }  
                
                Estimate__c estimate = new Estimate__c();
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
                    estimate.name=mapPSR.get(currentPSR.ID).Opportunity__r.Name;               
                }                               
                
                currentPSR.isFirstRun__c = true;
                isPSRChanged = true;
                lstEstimate.Add(estimate);                                                                     
            }//End If  
            
            if (totalDuration<totalRequiredDuration){
                currentPSR.addError('The minimum required duration is ' 
                            + String.valueOf(totalRequiredDuration) 
                            + ' working days.  You have specified a duration of  ' 
                            + String.valueOf(totalDuration) 
                            + ' working days.');   
                return;                          
            } 
            
            if(isPSRChanged && currentPSR.Total_Required_Duration__c != null){
                Decimal existingRDuration = currentPSR.Total_Required_Duration__c;
                currentPSR.Total_Required_Duration__c = existingRDuration + Decimal.valueof(totalRequiredDuration);               
            }                                             
        }//End for loop    
        
        //Insert Design
        
        system.debug('Bharti ==' + lstDesign);
        if(lstDesign.size()>0){
            insert lstDesign;
        }  
        //Insert Single Line
        if(lstSingleLine.size()>0){
            insert lstSingleLine;
        } 
        //Insert Estimate
        if(lstEstimate.size()>0){
            insert lstEstimate;
        } 
        //Insert Task
        system.debug('----lstTask-----'+lstTask);
        if(lstTask.size()>0){           
            Database.DMLOptions dmlo = new Database.DMLOptions();
            dmlo.EmailHeader.triggerUserEmail = true;
            database.insert(lstTask, dmlo);    
        } 
        //Prepare map of Design
        map<ID,Design__c> mapPSRDesign = new map<ID,Design__c>();
        for(Design__c d1 : lstDesign){
            mapPSRDesign.put(d1.PSR__c,d1); 
        }
        //Prepare map of SingleLine
        map<ID,Single_Line__c> mapPSRSingleLine = new map<ID,Single_Line__c>();
        for(Single_Line__c s : lstSingleLine){
            mapPSRSingleLine.put(s.PSR__c,s);   
        }
        //Prepare map of Estimate
        map<ID,Estimate__c> mapPSREstimate = new map<ID,Estimate__c>();
        for(Estimate__c e : lstEstimate){
            mapPSREstimate.put(e.PSR__c,e); 
        }
        //Prepare map of SiteSurvey
        map<ID,Task> mapPSRSiteSurvey = new map<ID,Task>();
        for(Task t : lstTask){
            mapPSRSiteSurvey.put(t.PSR_ID__c,t);    
        }
        
        //Set Design,SingleLine,Estimate and SiteSurvey on PSR            
        for(PSR__c currentPSR : psrList){
            if(mapPSRDesign.get(currentPSR.ID)!=null){
                currentPSR.Design__c = mapPSRDesign.get(currentPSR.ID).ID;
            }               
            if(mapPSRSingleLine.get(currentPSR.ID)!=null){               
                currentPSR.Single_Line__c = mapPSRSingleLine.get(currentPSR.ID).ID;
            } 
            if(mapPSREstimate.get(currentPSR.ID)!=null){
                currentPSR.Estimate__c = mapPSREstimate.get(currentPSR.ID).ID;
            }
            if(mapPSRSiteSurvey.get(currentPSR.ID)!=null){
                currentPSR.Site_Survey_ID__c = mapPSRSiteSurvey.get(currentPSR.ID).ID;
            }
        }         
        }//End Try
        catch (Exception e) {
            psrList[0].addError(e.getMessage());                       
        }
        
        System.debug('At the end of sendPSRFunction method...'); //kcm
        for(PSR__c p:psrList) {//kcm
            System.debug('...PSR Step of PSR ' + p.Id + ' is ' + p.PSR_Step__c);
        } //kcm
    }
    
    public static void populateRelatedObjects(List<PSR__c> psrList){

    /* update Quote Steps to PSR in Progress or PSR Complete */

      List<Id> quoteIds = new List<Id>();
      Map<Id,Quote> quotes = new Map<Id,Quote>();
      List<Quote> updatedQuotes = new List<Quote>();

      // get all quote Ids
      for(PSR__c psr : psrList){        

        if (psr.Quote__c != null){
            quoteIds.add(psr.Quote__c); 
        }   

      }//end-for
        
      // get all quote records and PSRs that have been sent
      // non-sent PSRs are irrelevant
      // if a quote is awaiting psr approval, then its step should not be changed. 
      
      if (quoteIds.size()>0){
        
        quotes = new Map<Id,Quote> 
            ([Select q.Quote_Steps__c, q.Id, 
                (Select Id, PSR_Step__c, PSR_Sent__c 
                    From PSR__r
                    where PSR_Sent__c != null) 
                From Quote q 
                where q.id in :quoteIds 
                    and q.Quote_Steps__c != :QuoteManagement.QUOTE_STEP_AWAITING_APPROVAL]);        
      }//end-if

                 
      Quote quote = null;
      
      
      PSR__c[] childPSRs=null;

      if (quotes.size()>0){     
      
        for(Id quoteId : quoteIds){         

            if(quotes.containsKey(quoteId)
                && quotes.get(quoteId).PSR__r!=null){
      
                  
            //quote=quotes.get(quoteId);
            // Start code: SFDC
            quote = new Quote(id = quoteId);
            quote.Quote_Steps__c = quotes.get(quoteId).Quote_Steps__c;
            
            System.debug('**************** quoteId: ' + quoteId);
            System.debug('**************** Quote: ' + quote);

            // End code : SFDC
            childPSRs=quotes.get(quoteId).PSR__r;
            
            boolean completed = true;
            
            
            if (childPSRs!=null && childPSRs.size()>0){

                for (PSR__c psr : childPSRs){
                    
                    if (psr.PSR_Step__c!=PSR_STEP_PSR_COMPLETE){
                        completed=false;
                        break;
                    }                           
                }
    
                boolean updateQuote = false;

                System.debug('***SFDC **** ' + updateQuote);
                System.debug('***SFDC **** ' + completed);
                
                
                if (completed){
                     
                    if(quote.quote_steps__c!=QuoteManagement.QUOTE_STEP_PSR_COMPLETE){
                        quote.quote_steps__c=QuoteManagement.QUOTE_STEP_PSR_COMPLETE;
                        updateQuote=true;
                        System.debug('***SFDC ****  In conditon One');                    }               
                }
                else
                {
                    if(quote.quote_steps__c==QuoteManagement.QUOTE_STEP_PSR_COMPLETE){
                        quote.quote_steps__c=QuoteManagement.QUOTE_STEP_PSR_IN_PROGRESS;
                        updateQuote=true;    
                        System.debug('***SFDC ****  In conditon Two');            
                    }                           
                }
                
                System.debug('***SFDC **** ' + updateQuote);
                if (updateQuote){
                    System.debug('***SFDC **** QUote:' + quote);
                    updatedQuotes.add(quote);           
                }
                
            }//end-if               
        }//end-if   

        }//end-for
      }//end-if
      if (updatedQuotes.size()>0) {
        System.debug('***SFDC **** UpdateQuotes begin:' + updatedQuotes);
        update updatedQuotes;
        System.debug('***SFDC **** UpdateQuotes ends:');
      }

    }//end-method


    public static void populateFields(List<PSR__c> psrList, Map<ID,PSR__c> mapPSRold){ 
        //Case-00037321-UAT - Limit the Products available when using the lookup  
        //setPSRProduct(psrList,mapPSRold);
        
        //set of Ids of Quote to be queried
        Set<Id> quoteIDS = new set<ID>();
        
        //getting quote ids from psr's getting inserted/updated      
        for(PSR__c psr : psrList){
            if(psr.Opportunity__c == null && psr.Quote__c != null)
                quoteIDS.add(psr.Quote__c);
                
            // Done for Case # 00073004 
            /* If PSR is sent with a site audit request and a Design request, set 'Received Information to Design date' default to Site Audit Completed Date.*/
            if( mapPSRold != null
                && psr.Received_Information_to_Design_date__c == null
                && psr.PSR_Sent__c != null 
                && psr.Site_Survey_Completed__c != mapPSRold.get(psr.Id).Site_Survey_Completed__c
                && (psr.Array_Layout__c || psr.Array_Layout_Revision__c) 
                && (psr.Site_Survey_Standard__c || psr.Site_Survey_SubContractor__c)){
                    psr.Received_Information_to_Design_date__c = psr.Site_Survey_Completed__c;
            }
            // End Case # 00073004.
                           
        }
   
        //query opportunity from respective quotes
        Map<ID, Quote> mapQuotes = new Map<ID, Quote>();
        
        if (quoteIDS.size()>0){
            
            mapQuotes = new Map<ID, Quote>(
            [select Id,opportunity.id from Quote where ID IN : quoteIDS]);
        }

        System.debug('>>>>>>populateFields START');
                    
        //populating opportunity field of PSR
        for(PSR__c psr : psrList){
            
            if(psr.Opportunity__c == null){
                if(mapQuotes.containsKey(psr.Quote__c))
                    psr.Opportunity__c = mapQuotes.get(psr.Quote__c).opportunity.id;
            }     
            updateStep(psr);
        }   
        
        System.debug('At the end of populateFields method...'); //kcm
        for(PSR__c p:psrList) {//kcm
            System.debug('...PSR Step of PSR ' + p.Id + ' is ' + p.PSR_Step__c);
        } //kcm             
    }
    
    

    private static void updateStep(PSR__c psr) {
        System.debug('Just entered updateStep method...'); //kcm
        System.debug('...PSR Step of PSR ' + psr.Id + ' is ' + psr.PSR_Step__c); //kcm

        boolean kickOffMeetingCompleted =  psr.KickOff_Meeting_Completed__c;    
        boolean siteSurveyCompleted = (psr.Site_Survey_Completed__c)==null? false : true;
        boolean arrayLayoutCompleted = (psr.Array_Layout_Completed__c)==null? false : true;
        boolean electricalSupportCompleted = (psr.Electrical_Support_Completed__c)==null? false : true;
        boolean costEstimateCompleted = (psr.Cost_Estimate_Completed__c)==null? false : true;             
        boolean pmCost = psr.PM_Cost__c || psr.PM_Cost_without_Design__c;
        boolean singleLine = psr.Single_Line_based_on_Design__c || psr.Single_Line_without_Design__c;
        boolean arrayLayout = psr.Array_Layout__c || psr.Array_Layout_Revision__c;
        boolean siteSurvey = psr.Site_Survey_Standard__c || psr.Site_Survey_SubContractor__c;

        System.debug('>>>>>>siteSurveyCompleted='+siteSurveyCompleted);
        System.debug('>>>>>>siteSurvey='+siteSurvey);
        System.debug('>>>>>>arrayLayoutCompleted='+arrayLayoutCompleted);        
        System.debug('>>>>>>arrayLayout='+arrayLayout);
        System.debug('>>>>>>electricalSupportCompleted='+electricalSupportCompleted);
        System.debug('>>>>>>singleLine='+singleLine);
        System.debug('>>>>>>costEstimateCompleted='+costEstimateCompleted);
        System.debug('>>>>>>pmCost='+pmCost);
        System.debug('>>>>>>kickOffMeetingCompleted='+kickOffMeetingCompleted);
        //START 11_26_2012 - NEW METHOD CALLED FOR CHECKING WHAT IS THE STEP - Code Before this change in Case # 00172869
        checkStep(psr);
        /** START 11_26_2012 - COMMENTED BY BIRLASOFT FOR OPTIMIZING THE LOGIC - Code Before this change in Case # 00172869      
        //first condition is added under case-00038856
        //PSR step should remain on '1.Kickoff Meeting' step until PSR is sent even if Kickoff Meeting Date is passed.
        if(psr.PSR_Sent__c==null && !kickOffMeetingCompleted){
             psr.psr_step__c=PSR_STEP_KICKOFF_MEETING;      
        }                   
        else if (pmCost && costEstimateCompleted){
            
            psr.psr_step__c=PSR_STEP_PSR_COMPLETE;
            System.debug('>>>>>> 111111111111111111');
            checkStep(psr);
             
        }           
        else if (singleLine && electricalSupportCompleted){

            if (pmCost) 
                psr.PSR_Step__c = PSR_STEP_COST_ESTIMATE;
            else{ // no next step, go to complete
                psr.psr_step__c=PSR_STEP_PSR_COMPLETE; 
                 System.debug('>>>>>> 2222222222222222222');
                checkStep(psr);
            }          
        }        
        else if (arrayLayout && arrayLayoutCompleted){
            
            if (singleLine)
                psr.psr_step__c=PSR_STEP_SINGLE_LINE;
            else if (pmCost)
                psr.psr_step__c=PSR_STEP_COST_ESTIMATE; 
            else{ // no next step, go to complete
                psr.psr_step__c=PSR_STEP_PSR_COMPLETE;
                System.debug('>>>>>> 3333333333333333333333');                              
                checkStep(psr);
            }    
        }        
        else if (siteSurvey && siteSurveyCompleted){
                
            if (arrayLayout)    
                psr.psr_step__c=PSR_STEP_ARRAY_LAYOUT;
            else if (singleLine)
                psr.psr_step__c=PSR_STEP_SINGLE_LINE;
            else if (pmCost)
                psr.psr_step__c=PSR_STEP_COST_ESTIMATE; 
            else{ // no next step, go to complete
                psr.psr_step__c=PSR_STEP_PSR_COMPLETE;
                System.debug('>>>>>> 4444444444444444444');
                checkStep(psr); 
            }                             
        }
        else if (kickOffMeetingCompleted){    
            //first condition is added under case-00038856
            //PSR step should remain on '1.Kickoff Meeting' step until PSR is sent even if Kickoff Meeting Date is passed.
            if(psr.PSR_Sent__c==null){
                 psr.psr_step__c=PSR_STEP_KICKOFF_MEETING;      
            }       
            else if (siteSurvey)
                psr.psr_step__c=PSR_STEP_SITE_SURVEY;   
            else if (arrayLayout)
                psr.psr_step__c=PSR_STEP_ARRAY_LAYOUT;
            else if (singleLine)
                psr.psr_step__c=PSR_STEP_SINGLE_LINE;
            else if (pmCost)
                psr.psr_step__c=PSR_STEP_COST_ESTIMATE; 
            else{ // no next step, go to complete
                psr.psr_step__c=PSR_STEP_PSR_COMPLETE;
                System.debug('>>>>>> 555555555555555555555555');          
                checkStep(psr);
            }    
        }
        else if (psr.PSR_Sent__c!=null){
            // PSR Sent

        System.debug('>>>>>>PSR Sent, Nothing completed');
            
            if (siteSurvey){
                psr.PSR_Step__c = PSR_STEP_SITE_SURVEY;
            }
            else if(arrayLayout){
                psr.PSR_Step__c = PSR_STEP_ARRAY_LAYOUT;
            }else if (singleLine){
                psr.PSR_Step__c = PSR_STEP_SINGLE_LINE;
            }else if (pmCost){
                psr.PSR_Step__c = PSR_STEP_COST_ESTIMATE;
            }
            
            checkStep(psr);
        }
        //END-  11_26_2012 - COMMENTED BY BIRLASOFT FOR OPTIMIZING THE LOGIC - Code Before this change in Case # 00172869        
          **/          
        
        return;
    } 

 //START - 11_26_2012 - NEW CODE BY BIRLASOFT FOR OPTIMIZING THE LOGIC - Code Before this change in Case # 00172869
    public static PSR__c checkStep (PSR__c psr) {
        System.debug('Just entered the checkStep method...'); //kcm
        System.debug('...PSR Step of PSR ' + psr.Id + ' is ' + psr.PSR_Step__c); //kcm 
    
        // STEP : 7. PSR Rejected
        // This is evaluated first so that the user can reject the PSR at any point in the process
        if( psr.PSR_Rejected_Reason__c != null){
            psr.PSR_Step__c = PSR_STEP_PSR_REJECTED;
            return psr;
        }
    
        //  STEP: 1. Kick-off meeting
        // if(psr.Kickoff_Meeting_Completed__c == FALSE && psr.PSR_Sent__c==null)
        //Added by bharti for case#00191940
        else if(psr.PSR_Sent__c==null)
        {
            psr.PSR_Step__c = PSR_STEP_KICKOFF_MEETING;
            return psr;
        }
        //Ended here.
        
        //  STEP: 2. Site Audit
        else if(psr.Site_Survey_Completed__c == null && (psr.Site_Survey_Standard__c || psr.Site_Survey_SubContractor__c)) {
                psr.PSR_Step__c = PSR_STEP_SITE_SURVEY;
                return psr;
        }
        
        //  STEP:   3. Array Layout
        else if( psr.Array_Layout_Completed__c == null && (psr.Array_Layout__c || psr.Array_Layout_Revision__c)) {
                psr.PSR_Step__c = PSR_STEP_ARRAY_LAYOUT;
                return psr;
        }
    
        //  STEP:   4. Electrical Support
        else if( psr.Electrical_Support_Completed__c == null && (psr.Single_Line_based_on_Design__c || psr.Single_Line_without_Design__c)) {
                psr.PSR_Step__c = PSR_STEP_SINGLE_LINE;
                System.debug('psr.Electrical_Support_Completed__c == null && (psr.Single_Line_based_on_Design__c || psr.Single_Line_without_Design__c)'); //kcm
                System.debug(psr.Single_Line_based_on_Design__c + ' || ' + psr.Single_Line_without_Design__c + ')'); //kcm
                return psr;
        }
        
        
        // STEP:    5. Cost Estimate
        else if( psr.Cost_Estimate_Completed__c == null && (psr.PM_Cost__c || psr.PM_Cost_without_Design__c) ) {
                psr.PSR_Step__c = PSR_STEP_COST_ESTIMATE;
                return psr;
        }
        
        //  STEP:   6. PSR Complete
        else {
            psr.PSR_Step__c = PSR_STEP_PSR_COMPLETE;
            return psr;
        }
        
    }
 //END 11_26_2012 - NEW CODE BY BIRLASOFT FOR OPTIMIZING THE LOGIC - Code Before this change in Case # 00172869    
    
        
    //Method to calculate weekend days
    public static Integer calculateWeekendDays(Date startDate, Date endDate) {

        //returns 0 if startDate or endDate is null
        if( endDate == null || startDate == null ){
            return 0;
        }
        
        //returns 0 if endDate < startDate
        if( endDate < startDate){
            return 0;
        }
        
        
        String dayCalculated;
        Date startdateCalculated;
        startdateCalculated = startDate;
        Integer counter = 0;
        //number of weekend days are calculated between startDate and endDate
        while(startdateCalculated <= endDate) {
            dayCalculated = startdateCalculated.year() + '-' + startdateCalculated.month() + '-' + startdateCalculated.day() + ' ' + '00:00:00';
            dayCalculated = Datetime.valueOf(dayCalculated).formatGmt('EEEE');
            if(weekendDaysSet.contains(dayCalculated.toLowerCase() )){
                counter++;
            }
            startdateCalculated = startdateCalculated.addDays(1);
        }

        
        return counter;
    }
    
    // Done for case # 00066565
    // This Method is NOT called by the PSR Management. It is called by the PSR Related Objects(Design,Estimate,SingleLine)
    /* Whenever any of the related objects on a PSR go to 'Completed' or 'Cancelled' status,
       It send a notification to all owners of related objects on the PSR and user 'Sunpower Archive'.*/
    public static void sendEmailOnCompletedOrCancelledStatusOfRelatedObjects(List<ID> psrIDsList ,String PSRrelatedObjectName){
    
        if(psrIDsList == null || psrIDsList.isEmpty()) return; 
        // Preparing the PSR Map
        // Done for Case # 00070130 Adding PSR owner and the 'Estimator' on the Estimate object in Reciever List.                
        Map<Id,PSR__c> PSRMap = new Map<Id,PSR__c>([select id,OwnerId,Owner.Email,
                                                    Design__c,Design__r.ownerId,Design__r.owner.Email,
                                                    Estimate__c,Estimate__r.ownerId,Estimate__r.owner.Email,Estimate__r.Estimator__c,Estimate__r.Estimator__r.Email,
                                                    Estimate__r.Project_Manager__c,Estimate__r.Project_Manager__r.Email,
                                                    Single_Line__c,Single_Line__r.ownerId,Single_Line__r.owner.Email,
                                                    Opportunity__c, Opportunity__r.Owner.Email, Design__r.Opportunity__c, Design__r.Opportunity__r.Owner.Email from PSR__c where id in :psrIDsList]); 
        
        if(PSRMap.isEmpty()) return;
                    
        String DESIGN_TEMPLATE = 'Design_Completed_Cancelled_VF_Template';
        String ESTIMATE_TEMPLATE = 'Estimate_Completed_Cancelled_VF_Template';
        String SINGLE_LINE_TEMPLATE = 'SL_Completed_Cancelled_VF_Template';
  
        // Fetching email address of 'SunPower Email Archives'
        ReminderEmailAddress__c reminder = ReminderEmailAddress__c.getOrgDefaults();
        List<Contact> contacts = new List<Contact>();
        if (reminder != null) {
            contacts = new List<Contact>([Select id, Email from Contact where Email =: reminder.Email__c]); 
        }
        if (contacts.isEmpty()){
            Contact cont = new Contact();
            cont.LastName = 'Dummy Contact';
            cont.Email = reminder.Email__c;
            insert cont;
            contacts.Add(cont);
        }
        
        // Preparing the map of email templates
        Map<String,Id> mapEmailTemplateByName = new Map<String,Id>();
        for(EmailTemplate et : [select Id, DeveloperName from EmailTemplate where DeveloperName in (:DESIGN_TEMPLATE,:ESTIMATE_TEMPLATE,:SINGLE_LINE_TEMPLATE) and isActive = true]){ 
            mapEmailTemplateByName.put(et.DeveloperName , et.Id);                               
        }
        List<Messaging.Email> emailMessages = new List<Messaging.Email>();
        for(PSR__c psr : PSRMap.values()){
            
            List<String> recieversList = new List<String>();
            if(PSRMap.get(psr.ID).Design__c != null && PSRMap.get(psr.ID).Design__r.Owner != null && PSRMap.get(psr.ID).Design__r.Owner.Email != null)
                recieversList.add(PSRMap.get(psr.ID).Design__r.Owner.Email);
            if(PSRMap.get(psr.ID).Estimate__c != null && PSRMap.get(psr.ID).Estimate__r.Owner != null && PSRMap.get(psr.ID).Estimate__r.Owner.Email != null)
                recieversList.add(PSRMap.get(psr.ID).Estimate__r.Owner.Email);
            if(PSRMap.get(psr.ID).Single_Line__c != null && PSRMap.get(psr.ID).Single_Line__r.Owner != null && PSRMap.get(psr.ID).Single_Line__r.Owner.Email != null)
                recieversList.add(PSRMap.get(psr.ID).Single_Line__r.Owner.Email);
            // Done for Case # 00070130 Adding PSR owner and the 'Estimator' on the Estimate object in Reciever List.
            // Adding PSR Owner
            if(PSRMap.get(psr.ID).Owner != null && PSRMap.get(psr.ID).Owner.Email != null)
                recieversList.add(PSRMap.get(psr.ID).Owner.Email);
            // Adding the 'Estimator' on the Estimate object
            if(PSRMap.get(psr.ID).Estimate__c != null && PSRMap.get(psr.ID).Estimate__r.Estimator__c != null && PSRMap.get(psr.ID).Estimate__r.Estimator__r.Email != null)
                recieversList.add(PSRMap.get(psr.ID).Estimate__r.Estimator__r.Email);

            //R.Alega - Include Opportunity Owner as recipient on email alert - Case 00702905  - 
            //27.APR.2016
            /***START***/
            if((PSRMap.get(psr.ID).Opportunity__c != null) && (PSRMap.get(psr.ID).Opportunity__r.Owner.Email != null))  
                recieversList.add(PSRMap.get(psr.ID).Opportunity__r.Owner.Email);
            /***END***/ 

            // Setting the template Id for related objects of PSR
            Id templateId = null;               
            if(PSRrelatedObjectName == 'Design'){   
                //Added recipient to comment method sendEmailOnDesignComplete of DesignManagement
                if(PSRMap.get(psr.ID).Estimate__c != null && PSRMap.get(psr.ID).Estimate__r.Project_Manager__c != null && PSRMap.get(psr.ID).Estimate__r.Project_Manager__r.Email != null)
                    recieversList.add(PSRMap.get(psr.ID).Estimate__r.Project_Manager__r.Email);        
                templateId = mapEmailTemplateByName.get(DESIGN_TEMPLATE);               
            }else if(PSRrelatedObjectName == 'Single Line'){
                templateId = mapEmailTemplateByName.get(SINGLE_LINE_TEMPLATE);
            }else if(PSRrelatedObjectName == 'Estimate'){           
                templateId = mapEmailTemplateByName.get(ESTIMATE_TEMPLATE);
            }
            
            // Preparing the email content
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTemplateId(templateId);
            mail.setToAddresses(recieversList);
            mail.targetObjectID = contacts.get(0).ID;
            mail.setWhatId(psr.Id);
            mail.saveAsActivity=false;
            if(mail.getTemplateId()!=null)
                emailMessages.add(mail); 
        }
        // Sending the email notification
        if(emailMessages.size()>0){
            List<Messaging.SendEmailResult> sendEmailResults = new List<Messaging.SendEmailResult>();
            if (Util.byPassValidation() == false) {
                sendEmailResults = Messaging.sendEmail(emailMessages);
            }
        }    
    } // End Method    
}