// 
// (c) 2010 Appirio, Inc.
//
// Upload documents(.pdf, .jpeg) files as a proof of completion.
//
// 10/25/2010	Hemant Garg(Appirio offshore)	Original
//  
public without sharing class UploadProofController {
	//------------Variables--------------//
	public Attachment proof{get;set;}
	private String metricId;
	private Metric__c currMetric;
	public Boolean isError{get;set;}
	private User currentUser;
	
	/**
	 * Constructor
	 */
	public UploadProofController(){
		proof = new Attachment();
		isError = false;
		metricId = ApexPages.currentPage().getParameters().get('Id');
		if(metricId == null || metricId == ''){
			Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR,'Please provide metric Id.'));
            isError = true;
            return;
		}else{
			List<Metric__c> listMetrics = [select Id, File_Submission_Count__c, Attachment_Disabled__c, Audit_Date__c, Boolean_Achievement__c, (Select Id, ParentId From Attachments) from Metric__c where Id=:metricId];
			if(listMetrics != null && listMetrics.size() > 0){
				currMetric = listMetrics.get(0);				
			}
			currentUser = [Select Email from User where Id=:UserInfo.getUserId()];
		}  
	}
	
	/**
	 * Action function to create attachment in the metric.
	 * @return PageReference
	 */
	public PageReference saveFile(){
		if(metricId == null || metricId == ''){
			Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR,'Please provide metric Id.'));
            isError = true;
            return null;
		}
		
		System.debug('==========currMetric===='+currMetric);
		//Attachments should not be disabled and
		//File Submission count should be less than 2.
		if(!currMetric.Attachment_Disabled__c && (currMetric.File_Submission_Count__c == null ||currMetric.File_Submission_Count__c < 2)){			
			try{
				//First deleting previous attachments
				if(currMetric.Attachments != null && currMetric.Attachments.size() > 0){
					System.debug('==========deleting previous attachments====');
					delete currMetric.Attachments;					
				}
				
				//Insert new attachment
				if(proof != null && proof.Name != null){
					System.debug('==========inserting attachments====');
					proof.ParentId = metricId;
					insert proof;
				}
				
				//Updating metric Boolean achievement to true
				//and Increasing file submission count
				if(proof.Id != null){
					if(currMetric.Audit_Date__c == null){
						currMetric.Boolean_Achievement__c = true;						
					}	
					if(currMetric.File_Submission_Count__c != null)
						currMetric.File_Submission_Count__c = currMetric.File_Submission_Count__c + 1;
					else
						currMetric.File_Submission_Count__c = 1;	
					currMetric.File_Submitted_By_Email__c = currentUser.Email;		
					System.debug('==========updating currMetric===='+currMetric);	
					update currMetric;
				}
			}catch(Exception ex){
				Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR,'Exception in inserting attachment.'+ex));
	            return null;
			}
			proof.Body = null;
		}
		return new PageReference('/apex/evalIncentPage1?returnTab='+ApexPages.currentPage().getParameters().get('returnTab'));
	}
	
	/**
	 * Action function for Cancel Button.
	 * @return PageReference
	 */
	public PageReference Cancel(){
		return new PageReference('/apex/evalIncentPage1?returnTab='+ApexPages.currentPage().getParameters().get('returnTab'));
	}
}