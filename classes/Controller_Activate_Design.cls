/****************************************************************************
Class                   :   Controller_Activate_Design
Related Page            :   Activate_Design
Created By              :   Appirio Offshore
Created On              :   Feb 04, 2010
Desciption              :   Controller apex class for vf page Activate_Design.
Related PR              :   PR-03640
******************************************************************************/
public class Controller_Activate_Design{

	public List<Design__c> lstselectDesign ;
	//return id
    public String  returnID {get;set;}
	
    public Controller_Activate_Design(ApexPages.StandardSetController controller) {
    	
		lstselectDesign = new List<Design__c>();
		if(controller.getSelected().size() == 0){
			lstselectDesign.add(new Design__c (id = Apexpages.currentPage().getParameters().get('Id')));
		}else{
        	lstselectDesign = (List<Design__c>)controller.getSelected();
		}   
        lstselectDesign = [select id , Site__c from Design__c where id IN : lstselectDesign];


 	       	
        
		updateDesign();
    }
    
    public void updateDesign(){      	
        for(Design__c design : lstselectDesign ){
        	returnID = (design.Site__c != null )? design.Site__c : design.id;
        }
    }
    
    //Action: it will set True Actvie filed and return to Current Design Object 
    public PageReference ActivateDesign(){
    	PageReference returnPage = null; 
        try{           
            update lstselectDesign;            
            returnPage = new PageReference('/' + returnID);
        }catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
        }
        return returnPage;
    }    
}