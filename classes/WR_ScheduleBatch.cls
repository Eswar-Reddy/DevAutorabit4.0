/**************************************************************************************************************************
    Class is schedulable class used for scheduling batch classes WR_BatchUpdateAsset,WR_BatchUpdateFDSProduct and WR_BatchUpdateOracleSalesOrder
    
    @Author Anjali Khandelwal (Appiro offshore)
***************************************************************************************************************************/
global with sharing class WR_ScheduleBatch implements Schedulable{
	
	// global method - execute
    // Call Batch method
    global void execute(SchedulableContext sc) {
        //  Instantiate batch class 
        WR_BatchUpdateAsset batchUpdateAssets = new WR_BatchUpdateAsset();
        WR_BatchUpdateOracleSalesOrder batchUpdateSalesOrder = new WR_BatchUpdateOracleSalesOrder();
        WR_BatchUpdateFDSProduct batchUpdateFDSProduct = new WR_BatchUpdateFDSProduct();
        database.executeBatch(batchUpdateFDSProduct);
        database.executebatch(batchUpdateSalesOrder);
        database.executebatch(batchUpdateAssets);
        
        
    }

}