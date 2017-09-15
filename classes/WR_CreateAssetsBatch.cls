global class WR_CreateAssetsBatch implements Database.Batchable<sObject>{
	global Set<Id> WarrantyIDs;
	global String query;
	
	global WR_CreateAssetsBatch(Set<Id> warrIDs){
		WarrantyIDs = warrIDs;
		query = 'select Id,Warranty_Registration__c,AssetID__c,WR_FDS_Product__r.Product_Name__c,Warranty_Registration__r.Status__c,Warranty_Registration__r.Customer_SFDC_ID__c,WR_FDS_Product__r.Serial_Number__c,Warranty_Registration__r.Delivery_Date__c,Warranty_Registration__r.Customer_SFDC_ID__r.Country_Domain__c,WR_FDS_Product__r.Item__c from WR_Line_Item__c where Warranty_Registration__c in: WarrantyIDs Order By Warranty_Registration__c';
	}
	global Database.QueryLocator start(Database.BatchableContext BC){
		return Database.getQueryLocator(query);
	}
	global void execute(Database.BatchableContext BC, List<sObject> scope){
		Set<Id> completedWarrantyIds = new Set<ID>();
		List<Asset> deletedAssets = new List<Asset>();
		Set<ID> productIds = new Set<ID>();
		List<Asset> assetList = new List<Asset>();
		List<WR_Line_Item__c> wrLineItemList = new List<WR_Line_Item__c>();
		Map<ID,WR_FDS_Product__c> fdsProductsMap = new Map<ID,WR_FDS_Product__c>();
		Set<String> productNames = new Set<String>();
		Asset asset;
		
		for(WR_Line_Item__c wrLineItem : (List<WR_Line_Item__c>)scope){
			if(wrLineItem.Warranty_Registration__r.Status__c == 'Completed'){
				completedWarrantyIds.add(wrLineItem.Warranty_Registration__c);
		        if(wrLineItem.WR_FDS_Product__r.Product_Name__c != null)
		            productNames.add(wrLineItem.WR_FDS_Product__r.Product_Name__c);
			}
	        // if Warranty Status of Product get Draft
	        if(wrLineItem.Warranty_Registration__r.Status__c == 'Draft'){
	        	if(wrLineItem.AssetID__c != null)
	        		deletedAssets.add(new Asset(id = wrLineItem.AssetID__c));
	        	productIds.add(wrLineItem.WR_FDS_Product__c);
	        }
	        
	    } 
	    //Collect map of Product2
	    Map<String,Product2> productMap = new Map<String,Product2>(); 
	    for(Product2 product : [select ID,Name From Product2 where Name IN :productNames]){
	        productMap.put(product.Name,product);
	    }
		for(WR_Line_Item__c wrLineItem : (List<WR_Line_Item__c>)scope){
			if(wrLineItem.Warranty_Registration__r.Status__c == 'Draft')
				continue;
			if(wrLineItem.WR_FDS_Product__r.Product_Name__c != null)
	            productNames.add(wrLineItem.WR_FDS_Product__r.Product_Name__c);
			wrLineItemList.add(wrLineItem);
			asset = new Asset();
			asset.Name = wrLineItem.WR_FDS_Product__r.Product_Name__c; 
			if(productMap.containsKey(wrLineItem.WR_FDS_Product__r.Product_Name__c))
                asset.Product2Id = productMap.get(wrLineItem.WR_FDS_Product__r.Product_Name__c).id;
            asset.AccountId = wrLineItem.Warranty_Registration__r.Customer_SFDC_ID__c;
            asset.IsCompetitorProduct = false;
            asset.SerialNumber = wrLineItem.WR_FDS_Product__r.Serial_Number__c;
            asset.Quantity = 1;
            asset.InstallDate = wrLineItem.Warranty_Registration__r.Delivery_Date__c;
            //setting Asset currency EU for EU, $ for NA
            if(wrLineItem.Warranty_Registration__r.Customer_SFDC_ID__r.Country_Domain__c != null){
                if(wrLineItem.Warranty_Registration__r.Customer_SFDC_ID__r.Country_Domain__c.endsWith('us'))
                   asset.CurrencyIsoCode = 'USD';
                else
                   asset.CurrencyIsoCode = 'EUR';
            }
            asset.Description = ''; 
            asset.item__c = wrLineItem.WR_FDS_Product__r.Item__c;
            
            assetList.add(asset);
            WR_FDS_Product__c product = new WR_FDS_Product__c(id=wrLineItem.WR_FDS_Product__c,CONVERTED_TO_ASSET__c = true, Not_Modified_by_CastIron__c = true);
			fdsProductsMap.put(wrLineItem.WR_FDS_Product__c,product); 
		}
		
		if(assetList.size() > 0){
			insert assetList;
		}
		
		if(!fdsProductsMap.isEmpty())
	        update fdsProductsMap.values();
		
		for(Integer i=0; i<wrLineItemList.size(); i++){
	        //setting Asset to WR_Line_iem
	        wrLineItemList.get(i).AssetID__c = assetList.get(i).id; 
	    }
	    update wrLineItemList; 
	    
	    if(deletedAssets.size() > 0){
	    	delete deletedAssets;
	    }
	    List<WR_FDS_Product__c> fdsProductList = new List<WR_FDS_Product__c>();
	    if(productIds.size() > 0){
	    	WR_FDS_Product__c product;
	    	for(Id pId : productIds){
	    		product = new WR_FDS_Product__c(id = pId,CONVERTED_TO_ASSET__c = false, Not_Modified_by_CastIron__c = true);
		        fdsProductList.add(product);
	    	}
	    }
	    
	    if(fdsProductList.size() > 0){
	    	update fdsProductList;
	    }
	    if(!completedWarrantyIds.isEmpty()){
		    List<WR_StagingSelection__c> stagingListToDel = new List<WR_StagingSelection__c>();
		 	for(WR_StagingSelection__c stagingRec : [Select id from WR_StagingSelection__c where Warranty_Registration__c in: completedWarrantyIds]){
		 		stagingListToDel.adD(stagingRec);
		 	}
		 	if(stagingListToDel.size() > 0){
		 		delete stagingListToDel;
		 	}	    	
	    }
	    
	}
	global void finish(Database.BatchableContext BC){
			System.debug('Finished Warranty Finish Batch Job..........');
	}
}