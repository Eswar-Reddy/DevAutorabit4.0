public class SunriseMetricManagement {
	
	public static void afterSunriseMetricInsert(Map<ID,Metric__c> mapSunriseMetric){
		//Case#00088905-Copy achievement and other related information from P1 to P2 for Marketing metrics
		copyMarketingMetricInfo(mapSunriseMetric);
	}
	
	//Case#00088905-Copy achievement and other related information from P1 to P2 for Marketing metrics
	public static void copyMarketingMetricInfo(Map<ID,Metric__c> mapSunriseMetric){
		//Get MetricTierRelation set, AccountID set
		Set<String> setMetricTierID = new Set<String>();
		Set<String> setAccountID = new Set<String>();
		for(Metric__c m : mapSunriseMetric.values()){			
			if(m.Metric_Tier_Relation__c!=null){
				setMetricTierID.add(m.Metric_Tier_Relation__c);
			}
			if(m.Account__c!=null){
				setAccountID.add(m.Account__c);
			}
		}
		
		//Get the detail(Performancemetric/Tier etc)
		Map<ID,Metric_Tier_Relation__c> mapMetricTier = new Map<ID,Metric_Tier_Relation__c>(
														[Select id,Metric_Label__c,tier__r.Country__c,
														tier__r.Tier_Name__c,createdBy.name,createddate,
														Boolean_Metric_Y_N__c, Metric_Min_Value__c   
														from Metric_Tier_Relation__c where 
														Category__c='Marketing' and 
														Performance_Metric__r.Performance_Period__c='P2' and 
														Metric_Input_Type__c='Manual' and 
														ID in :setMetricTierID]);
		
		//If no P2 marketing metric found then return
		if(mapMetricTier.size() == 0){
			return;
		}
		
		Map<String,Metric__c> mapP1MarketingMetric = new Map<String,Metric__c>();
														
		for(Metric__c m: [Select id,Metric_Tier_Relation__r.Metric_Label__c,
												Metric_Tier_Relation__r.tier__c, Attachment_Disabled__c,
												Audit_Date__c, File_Submission_Count__c, File_Submitted_By_Email__c,
												Is_Resubmitted__c, Boolean_Achievement__c,
												Metric_Tier_Relation__r.Boolean_Metric_Y_N__c,
												Achievement_Value__c, goal_met__c,account__c 
												from Metric__c where 
												account__c in :setAccountID and Metric_Tier_Relation__r.Category__c='Marketing' and
												Metric_Tier_Relation__r.Metric_Input_Type__c='Manual' and
												Metric_Tier_Relation__r.Performance_Metric__r.Performance_Period__c='P1' and
												Metric_Tier_Relation__r.Performance_Metric__r.Performance_Year__c= :Date.Today().Year()]){
			
		
				mapP1MarketingMetric.put(String.valueOf(m.account__c).subString(0,15)+m.Metric_Tier_Relation__r.Metric_Label__c+String.valueOf(m.Metric_Tier_Relation__r.tier__c).subString(0,15),m);
		}
		
		//Map of P1 metric with corresponding P2 metric coming for insert
		Map<ID,ID> mapP1P2MetricID = new Map<ID,ID>();
		//List to store metric to update
		List<Metric__c> lstMetricToUpdate = new List<Metric__c>();
		for(Metric__c m : mapSunriseMetric.values()){
			Metric__c mcopy = new Metric__c(id=m.id);
			if(!mapMetricTier.containsKey(m.Metric_Tier_Relation__c)){
				continue;
			}
			Metric_Tier_Relation__c P2MetricTier = mapMetricTier.get(m.Metric_Tier_Relation__c);						
		    String uniqueKey = String.valueOf(m.account__c).subString(0,15)+P2MetricTier.Metric_Label__c+String.valueOf(P2MetricTier.tier__c).substring(0,15);
		   
		    if(mapP1MarketingMetric.containsKey(uniqueKey))
		    {					
				Metric__c P1Metric = mapP1MarketingMetric.get(uniqueKey);
				mapP1P2MetricID.put(P1Metric.ID,m.ID);
				if(P1Metric.Metric_Tier_Relation__r.Boolean_Metric_Y_N__c && P2MetricTier.Boolean_Metric_Y_N__c){
					mcopy.Boolean_Achievement__c = P1Metric.Boolean_Achievement__c;
					if(mcopy.Boolean_Achievement__c)
						mcopy.goal_met__c = true;
					copyMarketingDetail(P1Metric,mcopy);						
					lstMetricToUpdate.add(mcopy);
				}
				else if(!P1Metric.Metric_Tier_Relation__r.Boolean_Metric_Y_N__c && !P2MetricTier.Boolean_Metric_Y_N__c){
					mcopy.Achievement_Value__c = P1Metric.Achievement_Value__c;
					if(mcopy.Achievement_Value__c >= P2MetricTier.Metric_Min_Value__c)
						mcopy.goal_met__c = true;
					copyMarketingDetail(P1Metric,mcopy);
					lstMetricToUpdate.add(mcopy);
				}			
			}			
		}//End of for loop
		
		//Update Metric info (from P1 Meric)
		if(lstMetricToUpdate.size()>0){
			update lstMetricToUpdate;
		}
		
		//Transfer attachment (from P1 Metric)
		List<Attachment> lstAttachmentToInsert = new List<Attachment>();
		for(Attachment attach : [Select id,name,body,bodylength,contenttype,isPrivate,ownerID,parentID,owner.isActive from Attachment where parentID in :mapP1P2MetricID.keySet()]){
			Attachment attNew = attach.clone(false);
			attNew.ParentId = mapP1P2MetricID.get(attach.parentID);
			if(!attach.owner.isActive){
				attNew.OwnerId = userInfo.getUserID();
			}
			lstAttachmentToInsert.add(attNew);
		}
		//Insert attachments
		if(lstAttachmentToInsert.size()>0){
			insert lstAttachmentToInsert;
		}
	}	
	
	//Copy marketing related field's information
	private static void copyMarketingDetail(Metric__c p1Metric, Metric__c p2Metric){
		p2Metric.Attachment_Disabled__c = p1Metric.Attachment_Disabled__c;
		p2Metric.Audit_Date__c = p1Metric.Audit_Date__c;
		p2Metric.File_Submission_Count__c = p1Metric.File_Submission_Count__c;
		p2Metric.File_Submitted_By_Email__c = p1Metric.File_Submitted_By_Email__c;
		p2Metric.Is_Resubmitted__c = p1Metric.Is_Resubmitted__c;
	}
}