public class OrderCloneController {
	public Id clonedPurchasedOrderId {get;set;}
	public Purchase_Order__c purchaseOrder{get;set;}
	public Purchase_Order__c clonedPurchaseOrder{get;set;}
	public List<Purchase_Order_Line__c> clonedPurchaseOrderLine{get;set;}
	
	public OrderCloneController(){		
		clonedPurchasedOrderId = ApexPages.currentPage().getParameters().get('id');
		
		clonedPurchaseOrder = [Select p.System_Size__c, p.SystemModstamp, p.SunPower_Design__c, 
		p.Special_Instructions__c, p.SmartPack_Mounting_Type__c, p.SmartPack_Inverter_Type__c, 
		p.SmartPack_Flag__c, p.SmartMount__c, p.Shipping_Method__c, p.Ship_to_Site__c, 
		p.Requested_Delivery_Date__c, p.Primary_PSR_Email__c, p.PO_Submit_SP_WW__c, p.PO_Submit_Date__c, 
		p.OwnerId, p.Organization_ID__c, p.Order_Wizard_Step__c, p.Order_Total__c, p.Order_Submit_Date__c, 
		p.Order_Status__c, p.Order_Status_Interface_Message__c, p.Order_Booked_Date__c, 
		p.Oracle_Ship_to_Site_ID__c, p.Oracle_Order_Status__c, p.Oracle_Order_Number__c, p.Opportunity__c, 
		p.Notes__c, p.Name, p.LastModifiedDate, p.LastModifiedById, p.LastActivityDate, p.Is_Taxible_Order__c, 
		p.IsDeleted, p.Id, p.Delivery_Charges__c, p.Dealer_Account__c, p.DSR_PO_Group_Email__c, 
		p.CurrencyIsoCode, p.CreatedDate, p.CreatedById, p.Contact_ID__c, p.ConnectionSentId, 
		p.ConnectionReceivedId, p.Bill_to_Site__c, p.Attention__c, p.Assigned_RSM__c, 
		p.Assigned_DSR__c, p.Accept_Partial_Shipment__c, p.Accept_Expedited_Delivery_Charges__c 
		From Purchase_Order__c p where p.id = : clonedPurchasedOrderId];

        clonedPurchaseOrderLine = [Select p.Unit_of_Measure__c, p.Unit_Price__c, p.SystemModstamp, 
        p.SmartPack_Item__c, p.Quantity_per_Box__c, p.Quantity__c, p.Purchase_Order__c, p.Price__c, 
        p.Organization_ID__c, p.Order_Line_Number__c, p.Oracle_Item_ID__c, p.Name, p.LastModifiedDate, 
        p.LastModifiedById, p.Item_Number__c, p.Item_ID__c, p.Item_Description__c, p.IsDeleted, 
        p.Id, p.CurrencyIsoCode, p.CreatedDate, p.CreatedById, p.ConnectionSentId, p.ConnectionReceivedId, 
        p.Item_Source__c, //for Case#00077093 
        p.Category__c From Purchase_Order_Line__c p where p.Purchase_Order__c = : clonedPurchasedOrderId]; 
          
		
	}
	public ID insertPurchaseOrder(){
		Purchase_Order__c p = new Purchase_Order__c();
		p.System_Size__c = clonedPurchaseOrder.System_Size__c;
		p.SunPower_Design__c = clonedPurchaseOrder.SunPower_Design__c; 
		//p.Special_Instructions__c = clonedPurchaseOrder.Special_Instructions__c;
		p.Special_Instructions__c =''; 
		//p.SmartPack_Mounting_Type__c = clonedPurchaseOrder.SmartPack_Mounting_Type__c; 
		//p.SmartPack_Inverter_Type__c = clonedPurchaseOrder.SmartPack_Inverter_Type__c; 
		//p.SmartPack_Flag__c = clonedPurchaseOrder.SmartPack_Flag__c; 
		p.SmartMount__c = clonedPurchaseOrder.SmartMount__c; 
		p.Shipping_Method__c = clonedPurchaseOrder.Shipping_Method__c; 
		p.Ship_to_Site__c = clonedPurchaseOrder.Ship_to_Site__c; 
		p.Requested_Delivery_Date__c = null; 
		//p.Primary_PSR_Email__c = clonedPurchaseOrder.Primary_PSR_Email__c; 
		p.PO_Submit_SP_WW__c = null; 
		p.PO_Submit_Date__c = null;
		p.Organization_ID__c = clonedPurchaseOrder.Organization_ID__c; 
		p.Order_Wizard_Step__c = 'Step 1'; 
		p.Order_Total__c = clonedPurchaseOrder.Order_Total__c; 
		p.Order_Submit_Date__c = null; 
		p.Order_Status__c = 'New'; 
		p.Order_Status_Interface_Message__c = null; 
		p.Order_Booked_Date__c = clonedPurchaseOrder.Order_Booked_Date__c; 
		p.Oracle_Ship_to_Site_ID__c = clonedPurchaseOrder.Oracle_Ship_to_Site_ID__c; 
		p.Oracle_Order_Status__c = null;
		p.Oracle_Order_Number__c = null; 
		p.Opportunity__c = clonedPurchaseOrder.Opportunity__c;
		p.Notes__c = clonedPurchaseOrder.Notes__c; 
		//p.Name = 'Clone:' + clonedPurchaseOrder.Name;
		p.Is_Taxible_Order__c = clonedPurchaseOrder.Is_Taxible_Order__c; 
		p.Delivery_Charges__c = null; 
		p.Dealer_Account__c = clonedPurchaseOrder.Dealer_Account__c; 
		p.DSR_PO_Group_Email__c = clonedPurchaseOrder.DSR_PO_Group_Email__c; 
		p.Contact_ID__c = clonedPurchaseOrder.Contact_ID__c; 
		//p.ConnectionSentId = clonedPurchaseOrder.ConnectionSentId; 
		//p.ConnectionReceivedId = clonedPurchaseOrder.ConnectionReceivedId; 
		p.Bill_to_Site__c = clonedPurchaseOrder.Bill_to_Site__c; 
		p.Attention__c = clonedPurchaseOrder.Attention__c; 
		p.Assigned_RSM__c = clonedPurchaseOrder.Assigned_RSM__c;
		p.Assigned_DSR__c = clonedPurchaseOrder.Assigned_DSR__c; 
		p.Accept_Partial_Shipment__c = clonedPurchaseOrder.Accept_Partial_Shipment__c; 
		p.Accept_Expedited_Delivery_Charges__c = false;
		
		insert p;
		p.Name='';
		update p;
		return p.id;
			 	
	}
	
	public void insertPurchaseOrderLine(Id purchaseOrderId){
		List<Purchase_Order_Line__c> insertLst = new List<Purchase_Order_Line__c>();
			 
		for(Purchase_Order_Line__c item : clonedPurchaseOrderLine){
		    Purchase_Order_Line__c p = new Purchase_Order_Line__c(); 	
			p.Unit_of_Measure__c = item.Unit_of_Measure__c; 
	        p.Unit_Price__c = item.Unit_Price__c;
	        p.SmartPack_Item__c = item.SmartPack_Item__c; 
	        p.Quantity_per_Box__c = item.Quantity_per_Box__c; 
	        p.Quantity__c = item.Quantity__c;         
	        p.Purchase_Order__c = purchaseOrderId; 
	        p.Price__c = item.Price__c; 
	        p.Organization_ID__c = item.Organization_ID__c; 
	        p.Order_Line_Number__c = item.Order_Line_Number__c; 
	        p.Oracle_Item_ID__c = item.Oracle_Item_ID__c; 
	        //p.Name = item.Name; 
	        p.Item_Number__c = item.Item_Number__c; 
	        p.Item_ID__c = item.Item_ID__c; 
	        p.Item_Description__c = item.Item_Description__c; 
	        p.Category__c = item.Category__c;
	        p.Item_Source__c = item.Item_Source__c; //for Case#00077093 	        
	        insertLst.add(p);			
		}
		
		if(insertLst.size() > 0){
		  insert insertLst;
		}
		
	}
	
	public PageReference ClonePurchaseOrder(){
		
		
		ID newPurchaseOrderId = insertPurchaseOrder();
		insertPurchaseOrderLine(newPurchaseOrderId);
		
		PageReference pg = new PageReference('/apex/PurchaseOrderWizard?cln=1&POID='+newPurchaseOrderId);
		//PageReference pg = new PageReference('/' + newPurchaseOrderId);
		return pg;		
	}
		

}