public class PartnerApplicationManagement {
    

    static String strAreaSalesManager = 'Area Sales Manager';    
    static String strRegionalSalesManager = 'Regional Sales Manager';
    /* Done for the case # 00050543 on 19Feb2011 */
    //static String strDirectorofSales = 'Director of Sales';
    static String strDirectorofSales = 'National Sales Director';
    
    //for case 00039606
    static String naPartnerAppRecTypeId;
    static String naComPartnerAppRecTypeId;
    static String auPartnerAppRecTypeId;
    static String euPartnerAppRecTypeId;
    static String jpPartnerAppRecTypeId;
    //for case 00039606
    
    private static User currentUser;
    public static Map<Id, Schema.RecordTypeInfo> idToPartnerApplicationRecordTypeInfoMap;
    public static Map<String, Schema.RecordTypeInfo> nameToPartnerApplicationRecordTypeInfoMap;
    Map<String,String> mapRecordTypeIDName = new Map<String,String>();
    static {
        currentUser = Util.currentUser;
        idToPartnerApplicationRecordTypeInfoMap = Schema.SObjectType.Partner_Application__c.getRecordTypeInfosById();
        nameToPartnerApplicationRecordTypeInfoMap = Schema.SObjectType.Partner_Application__c.getRecordTypeInfosByName();
    }
    
    public static void beforePartnerApplicationInsert (List<Partner_Application__c> partnerApplicationList) {
        setRecordTypeId();//for case 00039606
        setApplicationScore(partnerApplicationList);
        setFields(partnerApplicationList);
        checkDuplicateCompanyName(partnerApplicationList);
        setPartnerApplicationType(partnerApplicationList);
        fillTerritoryManager(partnerApplicationList);
    }        

    public static void beforePartnerApplicationUpdate (List<Partner_Application__c> partnerApplicationList,  
        List<Partner_Application__c> oldPartnerApplicationList){
            setRecordTypeId();//for case 00039606
        setApplicationScore(partnerApplicationList);
        setFields(partnerApplicationList);
        checkDuplicateCompanyName(partnerApplicationList);
        setPartnerApplicationType(partnerApplicationList);
        fillTerritoryManager(partnerApplicationList);
    }

    public static void afterPartnerApplicationInsert (List<Partner_Application__c> partnerApplicationList) {

        updateLead(partnerApplicationList);
    } 

    public static void afterPartnerApplicationUpdate (List<Partner_Application__c> partnerApplicationList,  
        List<Partner_Application__c> oldPartnerApplicationList){        
        updateLead(partnerApplicationList); 
        
        List<Task> task = new List<Task>();
        
        List<User> taskUser = [select id from user where name ='Tom Dowley'];    
       // List<User> taskUser = [select id from user where name ='Abhay Appirio'];
       if(taskUser!=null && taskUser.size() > 0) {
        String userId = taskUser.get(0).Id;
        for(Partner_Application__c partnerApp :partnerApplicationList){
         if(partnerApp.statusSetFromApprovalProcess__c == true && partnerApp.Status__c=='Approved'){
                        
                 task.add(new Task(
                    whatid=partnerApp.Id,
                    ActivityDate= Date.today(),
                    OwnerId=userId,
                    Subject= 'Create Partner Account;  '+ partnerApp.Company_Name__c +'',
                    Description= 'The NA Partner Application for '+ partnerApp.Company_Name__c +' has been approved. Create an account and route a contract for signature.'
                    ));
                                    
            partnerApp.statusSetFromApprovalProcess__c = false;                 
         }
         
        }
       insert task; 
       }
    }

    public static void updateLead(List<Partner_Application__c> partnerApplicationList){
     
        List<Id> leadIds = new List<Id>();
        Map<String,String> nonConvertedleadIds = new Map<String,String>();
        List<Lead> updateLeadList = new List<Lead>();           
        
        for(Partner_Application__c partnerApp : partnerApplicationList){
            if (partnerApp.lead__c!=null){
                leadIds.add(partnerApp.lead__c);           
            } 
            
        }

        if (leadIds.size()==0)
            return;
            
        /* get unconverted leads with no partner application */
        for(Lead partnerLead:
                [select id 
                    from Lead
                    where id in :leadIds
                        and partner_application__c = null 
                        and isConverted = false]){
                        
            nonConvertedleadIds.put(partnerLead.Id, partnerLead.Id);
                                                                    
        }
            
        if (nonConvertedleadIds.size()==0)
            return;
            
        for(Partner_Application__c partnerApp : partnerApplicationList){

            if (partnerApp.lead__c!=null 
                && nonConvertedleadIds.containsKey(partnerApp.lead__c)){
                System.Debug('Partner Application Id'+partnerApp.Id);
                Lead existingLead = new Lead(Id=partnerApp.lead__c);
                existingLead.partner_application__c = partnerApp.Id;
                updateLeadList.add(existingLead);     
                      
            }                               
        }
        if (updateLeadList.size()>0)
            update updateLeadList;
    }       

 
    
    public static void setFields(List<Partner_Application__c> lstPartnerApplication){

        List<String> countries = new List<String> ();

        for(Partner_Application__c partnerAppObj : lstPartnerApplication){
        
            /* Get all countries */
            if(partnerAppObj.Theater__c == null && partnerAppObj.Country__c != null){               
                countries.add(partnerAppObj.Country__c);                    
            }
            
        }           

        Map<String,String> countryTheaterMap = new Map<String,String> ();
        
        if(countries.size()>0){
            
            for(Country_Reference__c countryRef : [select Country__c, Theater__c 
                from Country_Reference__c where Country__c in : countries])
            {
                    
                countryTheaterMap.put(countryRef.country__c, countryRef.theater__c);        
            }              

        }
        
        for(Partner_Application__c partnerAppObj : lstPartnerApplication){
        
            /* Theater */
            if(partnerAppObj.Theater__c == null 
                && partnerAppObj.Country__c != null){
                
                partnerAppObj.Theater__c = 
                    countryTheaterMap.get(partnerAppObj.Country__c);    
                
            }
            
            
            /* Customer Base */
            if(partnerAppObj.Partner_Application_Type__c == 'Commercial' 
                && partnerAppObj.Commercial_Customer_Base__c!=null){
                
                partnerAppObj.Customer_Base__c = partnerAppObj.Commercial_Customer_Base__c;
                             
            }
            else if(partnerAppObj.Partner_Application_Type__c == 'Residential'
                && partnerAppObj.Residential_Customer_Base__c!=null){
                partnerAppObj.Customer_Base__c = partnerAppObj.Residential_Customer_Base__c;             
            } 
        }       
 
    }

    /** new added for case - 12059**/
   public static void setPartnerApplicationType(List<Partner_Application__c> partnerApplicationList){
       Set<Id> leadIdsSet = new Set<Id>();
       Map<Id,String> leadPartnerTypeMap = new Map<Id,String>();       
       for(Partner_Application__c partnerApp :partnerApplicationList){
           if(partnerApp.lead__c !=null){
               leadIdsSet.add(partnerApp.lead__c);
           }
       }
       
       for(Lead lead : [Select Id, Partner_Type__c from Lead where Id in :leadIdsSet]){
           leadPartnerTypeMap.put(lead.Id,lead.Partner_Type__c);
       }
       System.Debug('Lead Partner Type '+leadPartnerTypeMap);
       for(Partner_application__c partnerApp : partnerApplicationList){
           if(partnerApp.Partner_Application_Type__c == null || partnerApp.Partner_Application_Type__c==''){
               if(leadPartnerTypeMap.containsKey(partnerApp.Lead__c)){
                   partnerApp.Partner_Application_Type__c = leadPartnerTypeMap.get(partnerApp.Lead__c);
               }
           }
       }
   }
   //for case 00039606
   public static void setRecordTypeId(){
          naPartnerAppRecTypeId = nameToPartnerApplicationRecordTypeInfoMap.get('NA Partner Application').getRecordTypeId(); 
          naComPartnerAppRecTypeId = nameToPartnerApplicationRecordTypeInfoMap.get('NA Commercial Partner Application').getRecordTypeId();      
          euPartnerAppRecTypeId = nameToPartnerApplicationRecordTypeInfoMap.get('EU Partner Application').getRecordTypeId();          
          auPartnerAppRecTypeId = nameToPartnerApplicationRecordTypeInfoMap.get('AUS Partner Application').getRecordTypeId();     
          jpPartnerAppRecTypeId = nameToPartnerApplicationRecordTypeInfoMap.get('JP Partner Application').getRecordTypeId();     
   }
   //for case 00039606   
    
    public static void setApplicationScore(List<Partner_Application__c> partnerApplicationList){
        
        for(Partner_Application__c partner:partnerApplicationList){
            if(partner.RecordTypeId == naPartnerAppRecTypeId 
                || partner.RecordTypeId == naComPartnerAppRecTypeId){
                        
            partner.Calculated_Application_Score__c = 
                  partner.Marketing_Employees_Score__c
                + partner.Marketing_Source_1_Score__c 
                + partner.Marketing_Source_2_Score__c 
                //+ partner.Member_of_Local_Business_Orgs_Score__c 
                + partner.Projects_Completed_Last_Year_Score__c 
                + partner.Sales_Employees_Score__c 
                //+ partner.Total_Employee_Base_Score__c 
                //+ partner.Website_Score__c 
                + partner.Years_in_Business_Score__c 
                + partner.Installation_Employees_Score__c 
                + partner.Customer_Base_Score__c 
                + partner.Electrician_on_staff_Score__c 
                //+ partner.Existing_Pending_Litigation_Score__c 
                + partner.Formalized_Referral_Program_Score__c 
                + partner.Geographic_Coverage_Score__c
                + partner.CAD_Designer_Available_Score__c 
                //+ partner.Company_Profitable_Score__c
                + partner.Annual_Revenue_1_year_ago_Score__c
                //+ partner.Business_Plan_Score__c
                //+ partner.Credit_Report_Score__c 
                + partner.Consumer_Reporting_Agency_Score__c
                //new added for case #12060
                +partner.Projected_current_FY_Score__c
                +partner.Projected_Next_FY_Score__c
                //cdevarapalli -- Newly added
                +partner.Operations_Employees_Score__c
                +partner.Customer_Service_Employees_Score__c
                +partner.Technical_Employees_Score__c
                +partner.Revenue_per_Sales_Person_Yr_Ago__c;
            }
        }       
    
    }

    //Fill Territory,Regional Sales Manager, Area Sales Manager & Director of Sales
    private static void fillTerritoryManager(List<Partner_Application__c> partnerApplicationList){
        /* Added for Sunpower Case # 00032076 */
        String countryDomain = [SELECT Country_Domain__c FROM User
                WHERE Id = :UserInfo.getUserId()].Country_Domain__c;
        /**************************************/
        
        //Prepare the set of all zip values of partner_application__c
        Set<String> zipSet = new Set<String>();        
        for(Partner_Application__c partner:partnerApplicationList){
            if(partner.zip__c != null 
                && partner.zip__c != ''
                && (partner.Territory__c == null || partner.Territory__c == '')){
                    
                zipSet.Add(partner.zip__c);
                
            }
        }

        //Get the map of zip values and their territories
        map<String,String> mapZipTerritory = new  map<String,String>();
        
        for(Territory_Reference__c territoryRef:
            [Select postal_code__c,territory__c 
                from Territory_Reference__c 
                where postal_code__c in :zipSet limit 1000]){
                    
            mapZipTerritory.put(territoryRef.postal_code__c, territoryRef.territory__c);
            
        }
        
        //Traverse through each record
        for(Partner_Application__c partner:partnerApplicationList){
            
            //If Zip is populated and Territory is blank, 
            // populate the Territory field from TerritoryReference__c
            
            if(partner.zip__c != null && partner.zip__c != '' 
                && (partner.Territory__c == null || partner.Territory__c == '')){
                    
                if(mapZipTerritory.containsKey(partner.zip__c)){
                    partner.Territory__c = mapZipTerritory.get(partner.zip__c);
                }
            }                       
        }
        
        //Prepare the set of all Territory names of Partner Applications
        Set<String> territoryNameSet = new Set<String>();        
        for(Partner_Application__c partner:partnerApplicationList){
            if(partner.territory__c != null && partner.territory__c != ''){
                territoryNameSet.Add(partner.territory__c);
            }
        }
        
        //Prepare the map of all TerritoryID and ParentTerriToryID of  territories of Partner Applications
        map<String,String> territoryIDs = new map<String,String>();
        map<String,String> parentTerritoryIDs = new map<String,String>();
        
        for(Territory terrObj:
            [Select id,ParentTerritoryID,name 
                from Territory 
                where name in :territoryNameSet limit 1000]){
                    
            territoryIDs.put(terrObj.id, terrObj.name);
            parentTerritoryIDs.put(terrObj.ParentTerritoryID, terrObj.name);
            
        }
        
        //Prepare the map for Regional Sales Manager and Area Sales Manager corresponding of TerritoryID and ParentTerriToryID respectively
        map<String,List<User>> mapterritoryRegionalSM = new map<String,List<User>>();
        map<String,List<User>> mapterritoryAreaSM = new map<String,List<User>>();
        map<String,List<User>> mapterritoryDirectorOfSalesNew = new map<String,List<User>>();
        map<String,List<User>> mapterritoryDirectorOfSales = new map<String,List<User>>();
        
        //Map of User and their Role name
        Map<ID,String> mapUserRole = new Map<ID,String>();
        for(UserTerritory userTerritoryObj:
            [Select id,userID,territoryID 
            from UserTerritory 
            where territoryID in :territoryIDs.keySet() or territoryID in :parentTerritoryIDs.keySet() limit 1000]){
            
            //Map for Regional Sales Manager
            if(territoryIDs.containsKey(userTerritoryObj.territoryID)){
                if(mapterritoryRegionalSM.containsKey(territoryIDs.get(userTerritoryObj.territoryID))){
                    mapterritoryRegionalSM.get(territoryIDs.get(userTerritoryObj.territoryID)).Add(new User(id=userTerritoryObj.userID));
                }
                else{
                    List<User> lu = new List<User>();
                    lu.Add(new User(id=userTerritoryObj.userID));
                    mapterritoryRegionalSM.put(territoryIDs.get(userTerritoryObj.territoryID),lu);
                }
                mapUserRole.put(userTerritoryObj.userID,'');
            }
            //Map for Area Sales Manager
            if(parentTerritoryIDs.containsKey(userTerritoryObj.territoryID)){
                if(mapterritoryAreaSM.containsKey(parentTerritoryIDs.get(userTerritoryObj.territoryID))){
                    mapterritoryAreaSM.get(parentTerritoryIDs.get(userTerritoryObj.territoryID)).Add(new User(id=userTerritoryObj.userID));
                }
                else{
                    List<User> lu = new List<User>();
                    lu.Add(new User(id=userTerritoryObj.userID));
                    mapterritoryAreaSM.put(parentTerritoryIDs.get(userTerritoryObj.territoryID),lu);
                }
                mapUserRole.put(userTerritoryObj.userID,'');
            }
            
            //////////////////////Added for case 00011562//////////////////////////////////////////////
            //Map for Director Of sales
             if(parentTerritoryIDs.containsKey(userTerritoryObj.territoryID)){
                if(mapterritoryDirectorOfSalesNew.containsKey(parentTerritoryIDs.get(userTerritoryObj.territoryID))){
                    mapterritoryDirectorOfSalesNew.get(parentTerritoryIDs.get(userTerritoryObj.territoryID)).Add(new User(id=userTerritoryObj.userID));
                }
                else{
                    List<User> lu = new List<User>();
                    lu.Add(new User(id=userTerritoryObj.userID));
                    mapterritoryDirectorOfSalesNew.put(parentTerritoryIDs.get(userTerritoryObj.territoryID),lu);
                }
                mapUserRole.put(userTerritoryObj.userID,'');
            }
            //////////////////////////////////////////////////////////////////////////////////////////
            
            //Map for Director Of sales
             if(parentTerritoryIDs.containsKey(userTerritoryObj.territoryID)){
                if(mapterritoryDirectorOfSales.containsKey(parentTerritoryIDs.get(userTerritoryObj.territoryID))){
                    mapterritoryDirectorOfSales.get(parentTerritoryIDs.get(userTerritoryObj.territoryID)).Add(new User(id=userTerritoryObj.userID));
                }
                else{
                    List<User> lu = new List<User>();
                    lu.Add(new User(id=userTerritoryObj.userID));
                    mapterritoryDirectorOfSales.put(parentTerritoryIDs.get(userTerritoryObj.territoryID),lu);
                }
                mapUserRole.put(userTerritoryObj.userID,'');
            }
        }
        
        //Preapare map of all users with their Roles
        for(User u:[Select id,UserRoleID,UserRole.name 
            from User 
            where id in :mapUserRole.keySet() limit 1000]){
            
            if(u.UserRoleID!=null){
                mapUserRole.put(u.id,u.UserRole.name);
            }
        }
        
        /* Added for Sunpower Case # 00024631 */
        //MAM 09/15/2014 Comment out Area Sales Manager field hardcode user ID call for case 00358830 start
        /*List<User> asmUser = [SELECT Id FROM User WHERE Name = 'Jeff Cavros'];
        ID asmUserId = null;
        if (asmUser.size() > 0) {
            asmUserId = asmUser[0].Id;
        }*/
        //MAM 09/15/2014 end
        
        List<RecordType> recordTypeList = [SELECT Id FROM RecordType
                WHERE SobjectType = 'Partner_Application__c' AND Name = 'NA Commercial Partner Application'];
        ID commPARecordTypeId = null;
        if (recordTypeList.size() > 0) {
            commPARecordTypeId = recordTypeList[0].Id;
        }
        /**************************************/
        
        //Traverse through each record
        for(Partner_Application__c partner:partnerApplicationList){
            //If Territory is populated and Regional Sales Manager is blank
            if(partner.Territory__c != null   && partner.Territory__c != ''   && partner.RSM__c==null){
                
                //Populate the RSM__c field of the Partner Application if any User with role 'Regional Sales Manager' exists in the specified territory
                if(mapterritoryRegionalSM.containsKey(partner.Territory__c)){
                    for(User u:mapterritoryRegionalSM.get(partner.Territory__c)){
                       /* Done for the case # 00050543 on 19Feb2011 */
                        //if(mapUserRole.get(u.id)==strRegionalSalesManager){
                        if(mapUserRole.containsKey(u.id) && mapUserRole.get(u.id).contains(strRegionalSalesManager)){
                            if(partner.RecordTypeId == naPartnerAppRecTypeId 
                                && mapUserRole.get(u.id).contains('Residential')){
                                partner.RSM__c = u.id;
                                break;
                            }else if(partner.RecordTypeId == naComPartnerAppRecTypeId 
                                && mapUserRole.get(u.id).contains('Commercial')){
                                partner.RSM__c = u.id;
                                break;
                            }else if(partner.RecordTypeId == euPartnerAppRecTypeId 
                                || partner.RecordTypeId == auPartnerAppRecTypeId
                                || partner.RecordTypeId == jpPartnerAppRecTypeId){
                                partner.RSM__c = u.id;
                                break;
                            }     
                        }
                    }
                }
            }
            
            //If Territory is populated and Area Sales Manager is blank
            // Added check for AU domain for case 00047329 - closed by customer
            // Added check for BE domain for case 00050644
            if(partner.Territory__c != null && partner.Territory__c != '' && partner.Area_Sales_Manager__c==null
                    && countryDomain != null && (countryDomain.endsWith('-it') || countryDomain.endsWith('-de') || countryDomain.endsWith('-us')  
                    //Start 00105774
                    || countryDomain.endsWith('-au')
                    //End 00105774 
                    || countryDomain.endsWith('-be')
                    || countryDomain.endsWith('-jp'))){
                
                //Populate the Area_Sales_Manager__c field of the Partner Application if any User with role 'Area Sales Manager' exists in the specified territory's parent territory
                if(mapterritoryAreaSM.containsKey(partner.Territory__c)){
                    for(User u:mapterritoryAreaSM.get(partner.Territory__c)){
                        /* Done for the case # 00050543 on 19Feb2011 */
                        //if(mapUserRole.get(u.id)==strAreaSalesManager){
                        if(mapUserRole.containsKey(u.id) && mapUserRole.get(u.id).contains(strAreaSalesManager)){
                            if(partner.RecordTypeId == naPartnerAppRecTypeId 
                                && mapUserRole.get(u.id).contains('Residential')){
                                partner.Area_Sales_Manager__c = u.id;
                                break;
                            }else if(partner.RecordTypeId == naComPartnerAppRecTypeId 
                                && mapUserRole.get(u.id).contains('Commercial')){
                                partner.Area_Sales_Manager__c = u.id;
                                break;
                            }else if (partner.RecordTypeId == euPartnerAppRecTypeId 
                                || partner.RecordTypeId == auPartnerAppRecTypeId
                                || partner.RecordTypeId == jpPartnerAppRecTypeId){
                                partner.Area_Sales_Manager__c = u.id;
                                break;
                            }    
                       }
                    }
                }
            }
            
            //////////////////////Added for case 00011562//////////////////////////////////////////////

            //If Territory is populated and Director of Sales is blank
            // Added check for AU domain for case 00047329 - closed by customer
            // Added check for BE domain for case 00050644
            //Added check for UK domain for Case 00072314
            if(partner.Territory__c != null && partner.Territory__c != '' && partner.Director_of_Sales__c==null
                    && countryDomain != null && (countryDomain.endsWith('-it')
                    || countryDomain.endsWith('-es') || countryDomain.endsWith('-fr')
                    || countryDomain.endsWith('-us') || countryDomain.endsWith('-uk')
                    //Start 00105774
                    || countryDomain.endsWith('-au')
                    //End 00105774 
                    || countryDomain.endsWith('-be')
                    || countryDomain.endsWith('-jp'))){
                
                //Populate the Director_of_Sales__c field of the Partner Application if any User with role 'Director of Sales' exists in the specified territory's parent territory
                if(mapterritoryDirectorOfSalesNew.containsKey(partner.Territory__c)){
                    for(User u:mapterritoryDirectorOfSalesNew.get(partner.Territory__c)){
                        /* Done for the case # 00050543 on 19Feb2011 */
                        //if(mapUserRole.get(u.id)==strAreaSalesManager){
                        if(mapUserRole.containsKey(u.id) && mapUserRole.get(u.id).contains(strAreaSalesManager)){
                            if(partner.RecordTypeId == naPartnerAppRecTypeId 
                                && mapUserRole.get(u.id).contains('Residential')){
                                partner.Director_of_Sales__c = u.id;
                                break;
                            }else if(partner.RecordTypeId == naComPartnerAppRecTypeId 
                                && mapUserRole.get(u.id).contains('Commercial')){
                                partner.Director_of_Sales__c = u.id;
                                break;
                            }else if (partner.RecordTypeId == euPartnerAppRecTypeId 
                                || partner.RecordTypeId == auPartnerAppRecTypeId
                                || partner.RecordTypeId == jpPartnerAppRecTypeId){
                                partner.Director_of_Sales__c = u.id;
                                break;
                            }    
                       }
                    }
                }
            }

            
            ///////////////////////////////////////////////////////////////////
            
            //If Territory is populated and Area Sales Manager is blank (for EU)
            //Added for case 00047329 - closed by customer
            //Added check for BE domain for case 00050644
            if(partner.Territory__c != null && partner.Territory__c != '' && partner.Area_Sales_Manager__c==null
                    && countryDomain != null && (countryDomain.endsWith('-it') || countryDomain.endsWith('-de') || countryDomain.endsWith('-us')  
                    //Start 00105774
                    || countryDomain.endsWith('-au')
                    //End 00105774  
                    || countryDomain.endsWith('-be')
                    || countryDomain.endsWith('-jp'))){
                
                //Populate the Area_Sales_Manager__c field of the Partner Application if any User with role 'Area Sales Manager' exists in the specified territory's parent territory
                if(mapterritoryDirectorOfSales.containsKey(partner.Territory__c)){
                    for(User u:mapterritoryDirectorOfSales.get(partner.Territory__c)){
                       /* Done for the case # 00050543 on 19Feb2011 */
                        if(mapUserRole.containsKey(u.id) && mapUserRole.get(u.id).contains(strDirectorofSales)){                     
                            partner.Area_Sales_Manager__c = u.id;
                            break;
                       }
                    }
                }
            }
            
            /* Added for Sunpower Case # 00024631 */
            if (commPARecordTypeId != null && commPARecordTypeId == partner.RecordTypeId) {
                partner.RSM__c = partner.OwnerId;
                //MAM 09/15/2014 Comment out Area Sales Manager field hardcode user ID call for case 00358830 start
                /*if (asmUserId != null) {
                    partner.Area_Sales_Manager__c = asmUserId;
                }*/
                //MAM 09/15/2014 end
            }
            /**************************************/
        }
    }  
    
    private static void checkDuplicateCompanyName(List<Partner_Application__c> newPartnerApplicationList){
        Set<String> companyNameStringSet = new Set<String>();
        List<Partner_Application__c> partnerApplicationList = new List<Partner_Application__c>();
        Map<String,Partner_Application__c> partnerApplicationMap = new Map<String,Partner_Application__c>();
        for(Partner_Application__c partnerApplication : newPartnerApplicationList){ 
            if(companyNameStringSet.contains(partnerApplication.Company_Name__c)){
               partnerApplication.addError('Partner Application has already been submitted for the Company'+partnerApplication.Company_Name__c);
                break; 
            }else{
                companyNameStringSet.add(partnerApplication.Company_Name__c);
                partnerApplicationMap.put(partnerApplication.Company_Name__c,partnerApplication);
            }   
        }
        partnerApplicationList = [select Id,name,Company_Name__c from Partner_Application__c where Company_Name__c in : companyNameStringSet limit 1000];
        if(partnerApplicationList.size()>0){
            for(Partner_Application__c partnerApp : partnerApplicationList){
                if(companyNameStringSet.contains(partnerApp.Company_Name__c) && partnerApp.Id != partnerApplicationMap.get(partnerApp.Company_Name__c).Id){
                  partnerApplicationMap.get(partnerApp.Company_Name__c).addError('Partner Application has already been submitted for the Company '+ partnerApp.Company_Name__c);
                }
            }   
        }
    }    
}