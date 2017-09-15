/***************************************
***PR-01926
***Created By- Kapil Goutam
***On - June 10 2009
***Last Modified- 
***Last Modified On - 
***Description- Class which update "Submit Status" & "Validation Status" according to specified validation
***Class method will be called from before insert & before update trigger of partner performance object  
****************************************/
public class PartnerPerformanceManagement {
	
	public static void beforePartnerPerformanceInsert (List<PartnerPerformance__c> partnerPerformanceList){
		Boolean isComplete = true;
 		for(PartnerPerformance__c pp:partnerPerformanceList){
 			 
 			if(pp.Brand_Guidelines__c == null){
 				isComplete = false;
 			}
 			if(isComplete && pp.Logo_Gear__c == null){
 				isComplete = false;
 			}
 			if(isComplete && pp.MDTF_Funds_Used__c == null){
 				isComplete = false;
 			}
 			if(isComplete && pp.Marketing_Material__c == null){
 				isComplete = false;
 			}
 			if(isComplete && pp.Office_Display__c == null){
 				isComplete = false;
 			}
 			if(isComplete && pp.Vehicle_Signage__c == null){
 				isComplete = false;
 			}
 			if(isComplete && pp.Website_Logo__c == null){
 				isComplete = false;
 			}
 			if(isComplete && pp.Sales_Training_Score__c == null){
 				isComplete = false;
 			}
 			if(isComplete && pp.Install_Training_Score__c == null){
 				isComplete = false;
 			}
 			if(isComplete && pp.Design_Training_Score__c == null){
 				isComplete = false;
 			}
 			if(isComplete && pp.Opportunity_Contact__c == null){
 				isComplete = false;
 			}
 			if(isComplete && pp.Home_Inspection_Score__c == null){
 				isComplete = false;
 			}
 			if(isComplete && pp.On_Time_Sales_Forecast_Score__c == null){
 				isComplete = false;
 			}
 			if(isComplete && pp.Warranty_Card_Return_Score__c == null){
 				isComplete = false;
 			}
 	
 			//to set status
 			if(isComplete == false){
 				//pp.Submit_Status__c = 'Incomplete';
 				pp.Validation_Status__c = 'Missing Data';
 			}
 			else{
 				//pp.Submit_Status__c = 'Complete';
 				pp.Validation_Status__c = 'Data Entry Complete';
 			}
 		}
    }        

    public static void beforePartnerPerformanceUpdate (List<PartnerPerformance__c> partnerPerformanceList, 
        List<PartnerPerformance__c> oldPartnerPerformanceList){
        	beforePartnerPerformanceInsert(partnerPerformanceList);
       
    }

}