// 
// (c) 2010 Appirio, Inc.
//
// Audit uploaded documents(proof) and Accept/Reject them.
//
// 10/25/2010	Hemant Garg(Appirio offshore)	Original
//   
public with sharing class InlineMetricDocumentController {
	//-------------Variables---------------//
	public Metric__c currentMetric{get;set;}
	public String attachmentId{get;set;}
	private static String Task_Description = 'Please Modify the uploaded file.';
	
	/**
	 * Constructor
	 */
	public InlineMetricDocumentController(ApexPages.StandardController stdController){
		currentMetric = (Metric__c)stdController.getRecord();
		List<Metric__c> listMetrics = [select Id, File_Submission_Count__c, Boolean_Achievement__c, (Select Id, ParentId, CreatedById From Attachments order by CreatedDate desc limit 1) from Metric__c where Id=:currentMetric.Id];
		if(listMetrics != null && listMetrics.size() > 0){
			currentMetric = listMetrics.get(0);	
			if(currentMetric.Attachments != null && currentMetric.Attachments.size() > 0)
				attachmentId = currentMetric.Attachments.get(0).Id;
		}
		
	}
	
	/**
	 * Function to update a metric.
	 * @return Boolean
	 */
	private Boolean updateMetric(){	
		Boolean isSuccess = true;
		try{
			update currentMetric;			
		}catch(Exception ex){
			Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR,'Exception in updating current metric.'+ex));          
			isSuccess = false;
		}
		System.debug('---updateMetric-----'+isSuccess);
		return isSuccess;
	}
	
	/**
	 * Action function to accept attachment in the metric.
	 * @return PageReference
	 */
	public PageReference acceptAttach(){
		//Setting Boolean Achievement to false
		currentMetric.Boolean_Achievement__c = true;
		//Setting Audit date
		currentMetric.Audit_Date__c = Date.Today();
		Boolean updationRes = updateMetric();
		if(updationRes){
			System.debug('---accept-----'+updationRes);
			PageReference pg = new PageReference('/apex/InlineMetricDocument?Id='+currentMetric.Id);
			pg.setRedirect(true);
			return pg;
		}else{
			return null;
		}
	}
	
	/**
	 * Action function to reject attachment in the metric.
	 * @return PageReference
	 */
	public PageReference rejectAttach(){
		//Setting Boolean Achievement to false
		currentMetric.Boolean_Achievement__c = false;
		//Updating Audit date only if it is audited previously
		if(currentMetric.File_Submission_Count__c > 1){
			currentMetric.Audit_Date__c = Date.Today();
		}
		Boolean updationRes = updateMetric(); 
		System.debug('---reject-----'+updationRes);
		if(updationRes ){
			//If the document is getting rejected first time
			//assign a task for the partner to upload again
			if(currentMetric.File_Submission_Count__c == 1){			
				try{
					Task tsk = new Task();
					tsk.ActivityDate = Date.Today().addDays(2);
					tsk.Subject = 'Other';
					tsk.Priority = 'Normal';
					tsk.status = 'Not Started';
					tsk.Description = Task_Description;
					tsk.WhatId = currentMetric.Id;
					tsk.OwnerId = currentMetric.Attachments.get(0).CreatedById;
					insert tsk;
				}catch(Exception ex){
					Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR,'Exception in assigning task.'+ex));          
					return null;
				}
			}
			PageReference pg = new PageReference('/apex/InlineMetricDocument?Id='+currentMetric.Id);
			pg.setRedirect(true);
			return pg;
		}else{
			return null;
		}
	}
}