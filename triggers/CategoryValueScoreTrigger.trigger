/* Trigger:   CategoryValueScoreTrigger
 * Porpose:   This trigger will update Score on Opportunity score card during new/existing category value insert/updated/deleted. 
 * CreatedBy: Raee$
 * Date:      6/14/2016
 */
trigger CategoryValueScoreTrigger on Category_Value_Score__c (after insert, after update , after delete) {
	
	Map<String,Category_Value_Score__c> mapOfExistingCVS = new Map<String,Category_Value_Score__c> ();
	Map<String,Category_Value_Score__c> tempCatMaxScore = new Map<String,Category_Value_Score__c> ();
	Map<Id,Category_Value_Score__c> mapOfCatScore = new Map<Id,Category_Value_Score__c> ();
	Map<Id,Boolean> mapOfCatScoreDecreased = new Map<Id,Boolean> ();
	List<Opportunity_Score__c> listotUpdate = new List<Opportunity_Score__c>();
		
	for(Category_Value_Score__c o: trigger.isDelete ? trigger.Old : trigger.new){
		System.debug('o==>'+o);		
		if(o.Score__c != null && o.Category__c != null ){
			mapOfCatScore.put(o.Category__c,o);
		}
		if( trigger.isUpdate && o.Score__c != trigger.oldMap.get(o.ID).Score__c && o.Score__c < trigger.oldMap.get(o.ID).Score__c){
			mapOfCatScoreDecreased.put(o.Category__c,true);
			System.debug('mapOfCatScoreDecreased==>'+mapOfCatScoreDecreased);
		}
		if(trigger.isDelete){
			mapOfCatScoreDecreased.put(o.Category__c,true);
			System.debug('mapOfCatScoreDecreased=DELETE=>'+mapOfCatScoreDecreased);
		}	
	}
	for(Category_Value_Score__c ob :[Select Name,Score__c,Category__r.Name from Category_Value_Score__c where Id NOT IN : trigger.isDelete ? trigger.Old :Trigger.new AND Category__c IN: mapOfCatScore.KeySet() order by Score__c DESC]){
		if(tempCatMaxScore.size() == 0 ){
			tempCatMaxScore.put(ob.Category__r.Name,ob);
			System.debug('tempCatMaxScore==>'+tempCatMaxScore);
		}
		if(!tempCatMaxScore.isEmpty() && tempCatMaxScore.containsKey(ob.Category__r.Name) && tempCatMaxScore.get(ob.Category__r.Name).Score__c <ob.Score__c){
			tempCatMaxScore.put(ob.Category__r.Name,ob);					
		}		 		
		if(!tempCatMaxScore.isEmpty() && mapOfCatScore.containsKey(ob.Category__c)){
			
		  if(!trigger.isDelete && mapOfCatScore.get(ob.Category__c).Score__c > tempCatMaxScore.get(ob.Category__r.Name).Score__c ){
				mapOfExistingCVS.put(ob.Category__r.Name,mapOfCatScore.get(ob.Category__c));
		  }else if(!mapOfCatScoreDecreased.isEmpty() && mapOfCatScoreDecreased.get(ob.Category__c)){
		  		System.debug('tempCatMaxScore.get(ob.Category__r.Name)==>'+tempCatMaxScore.get(ob.Category__r.Name));
		  		mapOfExistingCVS.put(ob.Category__r.Name,tempCatMaxScore.get(ob.Category__r.Name)); //PREVIUS MAX SCORE		  		
		  }
		}
	}
		
	System.debug('mapOfExistingCVS==>'+mapOfExistingCVS);	
	if(!mapOfExistingCVS.isEmpty()){	
		for(Opportunity_Score__c objOpScore:[Select Id,Category_Value_Score__c,Max_Score__c,Main_Category__c,Sub_Category__c,Category__c
											 From Opportunity_Score__c 
											 where Category__c =:mapOfExistingCVS.KeySet()]){
			if(mapOfExistingCVS.containsKey(objOpScore.Category__c)){ //&& mapOfExistingCVS.get(objOpScore.Category__c).Score__c > objOpScore.Max_Score__c){
				objOpScore.Max_Score__c = mapOfExistingCVS.get(objOpScore.Category__c).Score__c;
				listotUpdate.add(objOpScore);
			}
		}		
	}
	System.debug('listotUpdate==>'+listotUpdate);		
	if(!listotUpdate.isEmpty()){	
		Database.SaveResult[] srUpdateList = Database.update(listotUpdate, false);   
	}
  
}