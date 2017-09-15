/* Trigger:   beforeDeleteSite
 * Purpose:   This trigger will be keep primary design records under site
 * CreatedBy: Raee$
 * Date:      8/24/2016
 */ 
trigger beforeDeleteSite on Site_Information_Form__c (before delete) {
	
	DesignManagement.deleteFinalDesignSite(Trigger.old,'Site'); 	
	
}