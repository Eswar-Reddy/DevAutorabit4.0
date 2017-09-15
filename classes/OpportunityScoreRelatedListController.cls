/* Class:     OpportunityScoreRelatedListController
 * Purpose:   This class will populate Opportunity score card same as relatedList on Opportunity
 * CreatedBy: Raee$
 * Date:      6/14/2016
 */
public class OpportunityScoreRelatedListController {
    public String opptyId {get; private set;}
    public List<Opportunity> listOfoppty {get; private set;}
    public String message {get; private set;}
    public String newExistingButton {get; private set;}
    public boolean validOppty {get; private set;}
    public List<Opportunity_Score__c> litOfOpptyScore {get; set;} 
    public List<OpportunityScoreWrapper> listOfOpportunityScoreWrapper {get; private set;}    
    private final Opportunity OpptyObject {get; private set;}
    public Decimal mainFinal;
    public Decimal maxFinal;
    public String finalOpptyScore {get; set;}
    public Object createdBy {get; set;}
    public String attachmentId  {get; set;}
  /* Contructor: OpportunityScoreRelatedListController
   * Param:      ApexPages.StandardController
   * Retrun:     None
   * Purpose:    Contructor load existing score record or show New button 
   * CreatedBy:  Raee$
   * Date:       6/14/2016
   */  
	public OpportunityScoreRelatedListController(ApexPages.StandardController stdController) { 
        this.OpptyObject = (Opportunity)stdController.getRecord();
        System.debug('OpptyObject==>'+OpptyObject);
	  	opptyId = ApexPages.currentPage().getParameters().get('OpptyId');	  	 
        if(opptyId == null) 
       		opptyId = OpptyObject.Id ;
       	//opptyId ='0068A000003TqEC';	// Temperory Oppty Id  
       	attachmentId = '';
	    validateOpportunity();
	    loadScoreWrapperList();
	    if(listOfOpportunityScoreWrapper.isEmpty()){
	    	message = Label.OpportunityScoreNew_PR0;
    	 	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,message));
	    }
		existingOpptyScore();
   }
  /* Method:    loadScoreWrapperList
   * Param:     void
   * Retrun:    None
   * Purpose:   This method will calculate total scores and populate inline page 
   * CreatedBy: Raee$
   * Date:      6/14/2016
   */  
    public void loadScoreWrapperList() {
    	listOfOpportunityScoreWrapper = new List<OpportunityScoreWrapper> ();
    	 List<AggregateResult> somme = [select SUM(Category_Score_Formulea__c)score,SUM(Max_Score__c)maxscore,Main_Category__c,CreatedBy.Name 
    	 								from Opportunity_Score__c 
    	 								where Opportunity__c=:opptyId 
    	 								group by Main_Category__c,CreatedBy.Name
    	 								order by Main_Category__c DESC];
	  	 for(AggregateResult ar : somme){
		    listOfOpportunityScoreWrapper.add(new OpportunityScoreWrapper (ar));
		    System.debug('mainFinal==>'+mainFinal);
		    System.debug('maxFinal==>'+maxFinal);
		    if(mainFinal == null) 
		    	mainFinal = (Decimal) ar.get('score') ;
		    else
		    	mainFinal = mainFinal + (Decimal) ar.get('score') ;	
		    	 
		     if(maxFinal == null)
		    	maxFinal = (Decimal) ar.get('maxscore') ; 
		    else
		    	maxFinal = maxFinal + (Decimal) ar.get('maxscore') ;
		    	createdBy = (Object) ar.get('Name');
		 }  	
		System.debug('listOfOpportunityScoreWrapper==>'+listOfOpportunityScoreWrapper);  
		
		finalOpptyScore = mainFinal +'/'+ maxFinal;
		
    }
  /* Method:    validateOpportunity
   * Param:     void
   * Retrun:    None
   * Purpose:   This method will validate Oppty Type and BU 
   * CreatedBy: Raee$
   * Date:      6/14/2016
   */
   public void validateOpportunity (){
   		listOfoppty = new List<Opportunity>();
        for(Opportunity opp : [Select Id,RecordType.Name, RecordTypeId, Business_Unit__c 
								   		 From Opportunity
								   		 where RecordType.Name='Systems' 
								   		 AND Business_Unit__c ='NA Commercial' 
								   		 AND Id=: opptyId ]){
			   		listOfoppty.add(opp); 	
		}
	   if(!listOfoppty.isEmpty())
	 	 validOppty = true;
	  else
	     validOppty = false;	 	 
	}	
  /* Method:    existingOpptyScore
   * Param:     void
   * Retrun:    None
   * Purpose:   This method will show New/Existing command button based on record created or not 
   * CreatedBy: Raee$
   * Date:      6/14/2016
   */ 
	public void existingOpptyScore(){
		litOfOpptyScore = new List<Opportunity_Score__c>();
			if(opptyId != '' && UserInfo.getUserId() !=''){						
		  	 for(Opportunity_Score__c opptyScore :([Select Id,Category_Value_Score__c,Opportunity__c,Category_Score_Formulea__c,Max_Score__c,Main_Category__c,Sub_Category__c,Category__c,Input_Number__c,CreatedBy.Name 
		  										   From Opportunity_Score__c 
		  										   where Opportunity__c =:opptyId])){	
		  	 	litOfOpptyScore.add(opptyScore);
		  	}
	  		if(!litOfOpptyScore.isEmpty()){ 
				newExistingButton = 'Existing';
			}else{
				newExistingButton = 'New';
			}	
		}
	}
  /* Method:    ShowScorePage
   * Param:     void
   * Retrun:    PageReference
   * Purpose:   This method will redirect to score page
   * CreatedBy: Raee$
   * Date:      6/14/2016
   */ 
	public PageReference ShowScorePage(){
		PageReference pageRef = new PageReference('/apex/OpportunityScorePage?'+opptyId);
    	pageRef.setRedirect(true);
    	return pageRef;
	}
  /* Class:     OpportunityScoreWrapper
   * Param:     void
   * Retrun:    None
   * Purpose:   Wrapper class will calculate total score and max score with respective main categories
   * CreatedBy: Raee$
   * Date:      6/14/2016
   */ 
	public class OpportunityScoreWrapper{
		public Object mainCatogery {get; private set;}
		public String scores {get; private set;}	 
				 
		public OpportunityScoreWrapper(AggregateResult ar){
			System.debug((Decimal) ar.get('score'));
			System.debug((Decimal) ar.get('maxscore'));
			System.debug((Object)ar.get('Main_Category__c'));	      	    
		    mainCatogery = (Object)ar.get('Main_Category__c');
		    scores =(String)((Decimal) ar.get('score') +'/'+(Decimal) ar.get('maxscore'));	
		}
	}
	
  /* Class:     docGenCommericalRequest
   * Param:     void
   * Retrun:    PageReference
   * Purpose:   
   * CreatedBy: Raee$
   * Date:      11/2/2016
   */ 	 
	public void docGenCommericalRequest(){ 
		DocGenCommercial docGenComm = new DocGenCommercial();
	    attachmentId = docGenComm.sendDataToDocGen(opptyId,'No','Commercial','PR0');
	    System.debug('**attachmentId=>'+attachmentId);
	   // if(attachmentId != ''){
	     //  return new PageReference('/servlet/servlet.FileDownload?file='+attachmentId);	      
	   //} else{
	    //     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error in making a call to DocGen'));    
	      //   return null; 
	  //  } 	
	}	
}