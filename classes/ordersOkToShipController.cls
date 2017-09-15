//cdevarapalli--Controller for orders_ok_to_ship page
public class ordersOkToShipController {
    
    public List<oe_order_headers__c> selectedOrders{get;set;}
    public List<oe_order_headers__c> qualifiedOrders{get;set;}
    public boolean partnerOptedOutOkToShip{get;set;}
    public boolean noQualifiedOrders{get;set;}
    public boolean noOrdersSelected{get;set;}
    public PageReference returnPage;
    
    //controller
    public ordersOkToShipController(ApexPages.StandardSetController controller){
        partnerOptedOutOkToShip=false;
        noQualifiedOrders=false;
        noOrdersSelected=false;
        returnPage = new PageReference(ApexPages.currentPage().getParameters().get('retURL'));
        List<oe_order_headers__c> se = (List<oe_order_headers__c>)controller.getSelected();
        //selectedOrders = [select Name, Lease_Number__c from oe_order_headers__c where Id in :se];
        if(se.isEmpty())
            noOrdersSelected=true;
        qualifiedOrders=qualifyOrders(se);
        
    }
    
    //qualify Orders
    public List<oe_order_headers__c> qualifyOrders(List<oe_order_headers__c> selectedordersList){
        
        List<oe_order_headers__c> qualifiedOrders = new List<oe_order_headers__c>();
        
        selectedOrders = [select Name,Lease_Number__c,ORDER_STATUS__c,Business_Days_Counter__c,Ok_To_Ship__c,
                            RecordType.Name,Parent_Account__r.Country_Domain__c,SAD__c,Hold_Status__c,Order_Type__c
                             from oe_order_headers__c where Id in :selectedordersList];
        
        Set<String> orderStatusCancelSet = new Set<String>();
        orderStatusCancelSet.add('CANCELLED');
        orderStatusCancelSet.add('Cancelled');
        orderStatusCancelSet.add('CLOSED');
        orderStatusCancelSet.add('Closed');
        
        
        
        for(oe_order_headers__c sorder:selectedOrders){
            boolean POContainsRMA = false;
            if(sorder.Lease_Number__c!=null)
                POContainsRMA=sorder.Lease_Number__c.containsIgnoreCase('rma');
            if(!orderStatusCancelSet.contains(sorder.ORDER_STATUS__c) && sorder.Ok_To_Ship__c!='RELEASE'
               && (sorder.Parent_Account__r.Country_Domain__c=='rvar-us' ||
                (sorder.Parent_Account__r.Country_Domain__c=='combo-us' && sorder.Order_Type__c.contains('RVAR')))
                 && (sorder.RecordType.Name=='CASH BOOKED'
               || sorder.RecordType.Name=='LEASE BOOKED') && !POContainsRMA){
                qualifiedOrders.add(sorder);
            }
        }
        
        if(noOrdersSelected==false){
            if(qualifiedOrders.isEmpty()){ 
                    noQualifiedOrders=true;
            }
        }

        return qualifiedOrders;
    }
    
    //Confirm Ok to Ship for the qualified Orders
    public PageReference confirmOkToShip(){
        List<oe_order_headers__c> orderListToUpdate = new List<oe_order_headers__c>();
        for(oe_order_headers__c order:selectedOrders){
            order.OK_To_Ship__c='RELEASE';
            orderListToUpdate.add(order);
        }
        
        if(!orderListToUpdate.isEmpty())
            update orderListToUpdate;
        
        return returnPage;
    }
    
    //Check if partner didn't opt of Ok To Ship
    public PageReference qualifyPartner(){
        Id contactId = [Select contactid from User where id =: Userinfo.getUserid()].contactId;
        if(contactId!=null){
            ID accountId  = [Select AccountID from Contact where id =: contactId].AccountId;
            Account partnerAccount = [select Partner_Opt_Out_Ok_To_Ship__c from Account where Id = :accountId];
            partnerOptedOutOkToShip = partnerAccount.Partner_Opt_Out_Ok_To_Ship__c;
        }
        //partnerOptedOutOkToShip=true;
        return null;
    }
}