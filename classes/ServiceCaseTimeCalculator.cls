/*
Created by :Vishal Gupta 
/*****************************************************
    Purpose     ::   The Purpose of this Class is to calculate the time
                     Spend on the case and divide it 
    *****************************************************/
public class ServiceCaseTimeCalculator {
    
    public static Map<String,String> MapCustomCaseStatus;
    public static Map<String, Schema.SobjectField> caseStatusTrackingfields;
    public static string fieldlist='id,Case__c,Time_In_In_Progress__c,Time_In_Open_to_Work__c,Time_In_Pending_3rd_Party__c,Time_In_Pending_Vendor_Action__c,Time_In_Monitoring_Action__c,Time_In_Pending_Customer_Action__c,Time_In_Pending_Database_action__c,Time_in_Pending_other__c,Time_In_Pending_Partner_Action__c,Time_In_Pending_Technical_Support_Action__c';
    public static String whereClause='';
 /*   
    static{
        caseStatusTrackingfields = Case_Status_Tracking__c.sObjectType.getDescribe().fields.getMap();
        MapCustomCaseStatus = new Map<String,String>();
        for(Case_Status__c CaseStatus : Case_Status__c.getall().values())
            MapCustomCaseStatus.put(CaseStatus.Name,CaseStatus.Name);
    }
 */   
    public Static void calculateTime_betweenStatus(Map<id,case> TriggerNewMap,Map<id,case> TriggerOldMap){
        for(Case tcase :TriggerNewMap.Values()) 
         {
            if(tcase.Status !=TriggerOldMap.get(tcase.id).Status) {
                LogTimebyStatus(TriggerOldMap.get(tcase.id));
            }
         }
        
        
    } 
 /*     
    public static String checkCaseStatusAvaibleForTimeCal(String strCaseStatus)
    {
        if(strCaseStatus == null || strCaseStatus.equalsIgnoreCase('')) return null;
        
        if(!MapCustomCaseStatus.containsKey(strCaseStatus)) return null;
        
        for( String Key : caseStatusTrackingfields.KeySet()){
            if(strCaseStatus.equalsIgnoreCase(caseStatusTrackingfields.get(Key).getDescribe().getlabel()))
            return caseStatusTrackingfields.get(Key).getDescribe().getname();
        }
        return null;
    } 
*/


public Static void LogTimebyStatus(Case modCase) 
{
    Case_Status_Tracking__c CStatus;
    String query='Select '+fieldlist+' from Case_Status_Tracking__c where case__c='+'\''+modCase.id+'\'';
    list<Case_Status_Tracking__c> CST=database.query(query);
        if(CST !=null && !CST.isEmpty()) CStatus=CST[0]; else CStatus=new Case_Status_Tracking__c();
        CStatus.Case__c=modCase.id;   
if(modCase.Status=='IN Progress'){
        CStatus.Time_In_In_Progress__c=CStatus.Time_In_In_Progress__c!=null?CStatus.Time_In_In_Progress__c+CalculateTimeDifferenceinHours(modCase.Last_Status_Changed__c):CalculateTimeDifferenceinHours(modCase.Last_Status_Changed__c);
        CStatus.Number_of_Times_in_IN_PROGRESS__c=CStatus.Number_of_Times_in_IN_PROGRESS__c!=null?CStatus.Number_of_Times_in_IN_PROGRESS__c++:0;   
          }
                      
if(modCase.Status=='OPEN TO WORK'){
      CStatus.Time_In_Open_to_Work__c=CStatus.Time_In_Open_to_Work__c!=null?CStatus.Time_In_Open_to_Work__c+calculateTimeDifferenceinHours(modCase.Last_Status_Changed__c):calculateTimeDifferenceinHours(modCase.Last_Status_Changed__c);
      CStatus.Number_of_Times_in_OPEN_TO_WORK__c=CStatus.Number_of_Times_in_OPEN_TO_WORK__c!=null?CStatus.Number_of_Times_in_OPEN_TO_WORK__c++:0;   
    }
        
if(modCase.Status=='Pending 3rd Party Contractor Action'){
      CStatus.Time_In_Pending_3rd_Party__c=CStatus.Time_In_Pending_3rd_Party__c!=null?CStatus.Time_In_Pending_3rd_Party__c+calculateTimeDifferenceinHours(modCase.Last_Status_Changed__c):calculateTimeDifferenceinHours(modCase.Last_Status_Changed__c);
      CStatus.Number_of_Times_in_3rd_Party__c=CStatus.Number_of_Times_in_3rd_Party__c!=null?CStatus.Number_of_Times_in_3rd_Party__c++:0;  

         }
      
if(modCase.Status=='Pending Vendor Action'){
      CStatus.Time_In_Pending_Vendor_Action__c=CStatus.Time_In_Pending_Vendor_Action__c!=null?CStatus.Time_In_Pending_Vendor_Action__c+calculateTimeDifferenceinHours(modCase.Last_Status_Changed__c):calculateTimeDifferenceinHours(modCase.Last_Status_Changed__c);
      CStatus.Number_of_Times_in_PENDING_VENDOR_ACTION__c =CStatus.Number_of_Times_in_PENDING_VENDOR_ACTION__c!=null?CStatus.Number_of_Times_in_PENDING_VENDOR_ACTION__c ++:0;  
   }
     
if(modCase.Status=='Monitor Action'){
      CStatus.Time_In_Monitoring_Action__c=CStatus.Time_In_Monitoring_Action__c!=null?CStatus.Time_In_Monitoring_Action__c+calculateTimeDifferenceinHours(modCase.Last_Status_Changed__c):calculateTimeDifferenceinHours(modCase.Last_Status_Changed__c);
      CStatus.Number_of_times_in_MONITOR_ACTION__c=CStatus.Number_of_times_in_MONITOR_ACTION__c!=null?CStatus.Number_of_times_in_MONITOR_ACTION__c++:0;  
          }

if(modCase.Status=='Pending Customer Action'){
      CStatus.Time_In_Pending_Customer_Action__c=CStatus.Time_In_Pending_Customer_Action__c!=null?CStatus.Time_In_Pending_Customer_Action__c+calculateTimeDifferenceinHours(modCase.Last_Status_Changed__c):calculateTimeDifferenceinHours(modCase.Last_Status_Changed__c);
      CStatus.Numer_of_Times_in_Pending_Customer__c=CStatus.Numer_of_Times_in_Pending_Customer__c!=null?CStatus.Numer_of_Times_in_Pending_Customer__c++:0;  
   }

if(modCase.Status=='Pending Database Action'){
      CStatus.Time_In_Pending_Database_action__c=CStatus.Time_In_Pending_Database_action__c!=null?CStatus.Time_In_Pending_Database_action__c+calculateTimeDifferenceinHours(modCase.Last_Status_Changed__c):calculateTimeDifferenceinHours(modCase.Last_Status_Changed__c);
      CStatus.Number_of_Times_in_Pending_Database__c=CStatus.Number_of_Times_in_Pending_Database__c!=null?CStatus.Number_of_Times_in_Pending_Database__c++:0;  
         }

if(modCase.Status=='Pending Other SPWR Team Action'){
      CStatus.Time_in_Pending_other__c=CStatus.Time_in_Pending_other__c!=null?CStatus.Time_in_Pending_other__c+calculateTimeDifferenceinHours(modCase.Last_Status_Changed__c):calculateTimeDifferenceinHours(modCase.Last_Status_Changed__c);
      CStatus.Number_of_times_in_Pending_other_SPWR__c=CStatus.Number_of_times_in_Pending_other_SPWR__c!=null?CStatus.Number_of_times_in_Pending_other_SPWR__c++:0;  
          }

if(modCase.Status=='Pending Partner Action'){
      CStatus.Time_In_Pending_Partner_Action__c=CStatus.Time_In_Pending_Partner_Action__c!=null?CStatus.Time_In_Pending_Partner_Action__c+calculateTimeDifferenceinHours(modCase.Last_Status_Changed__c):calculateTimeDifferenceinHours(modCase.Last_Status_Changed__c);
      CStatus.Number_of_Times_in_Pending_Partner__c=CStatus.Number_of_Times_in_Pending_Partner__c!=null?CStatus.Number_of_Times_in_Pending_Partner__c++:0;  
          }
   
if(modCase.Status=='Pending Technical Support Action'){
      CStatus.Time_In_Pending_Technical_Support_Action__c=CStatus.Time_In_Pending_Technical_Support_Action__c!=null?CStatus.Time_In_Pending_Technical_Support_Action__c+calculateTimeDifferenceinHours(modCase.Last_Status_Changed__c):calculateTimeDifferenceinHours(modCase.Last_Status_Changed__c);
      CStatus.Number_of_Times_in_Pending_Tech_Support__c =CStatus.Number_of_Times_in_Pending_Tech_Support__c!=null?CStatus.Number_of_Times_in_Pending_Tech_Support__c++:0;  
         }
 upsert CStatus;           
}


public Static Decimal CalculateTimeDifferenceinHours(DateTime LastStatusChanged){

   if(LastStatusChanged == null) return 0;
   
   return  (((((DateTime.now().getTime())-(LastStatusChanged).getTime())/1000)/60));
}

}