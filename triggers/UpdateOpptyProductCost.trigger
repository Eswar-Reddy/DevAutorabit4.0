trigger UpdateOpptyProductCost on OpportunityLineItem (before insert, before update)
{
    Set<Id> sPBEIds = new Set<Id>(); //Set of PriceBook Entry Id associated with the Oppty Line Item
    Set<Id> sOpptyIds = new Set<Id>();//Set Of Oppty Id related to Oppty Line Item  
    for(OpportunityLineItem OPPLI : Trigger.new)
    {
        sPBEIds.add(OPPLI.PricebookEntryId);
        sOpptyIds.add(OPPLI.OpportunityId);
    if(OPPLI.Cost__c == null)
      OPPLI.Cost__c = 0.0;
    }
  //Extract the related records
  Map<Id, Product2> mP = new Map<Id, Product2>(); //Map of related Products
  Map<Id, PricebookEntry> mPBE = new Map<Id, PricebookEntry>(); //Map of related PriceBookEntry
    if(!sPBEIds.isEmpty())
  {
        for(pricebookentry pbid: [SELECT id, name, 
                     Pricebook2id, Pricebook2.name, 
                     Product2id, Product2.Name, Product2.Unit__c, 
                     Product2.Cost__c, Product2.Product_Type__c, 
                     Product2.Wattage_Out__c 
                  FROM pricebookentry 
                   WHERE id in : sPBEIds])
    {
            mP.put(pbid.Product2Id,
             new Product2(id= pbid.Product2Id,
                        name= pbid.Product2.Name,
                cost__c= pbid.Product2.Cost__c,
                product_type__c= pbid.Product2.Product_Type__c,
                wattage_Out__c= pbid.Product2.Wattage_Out__c,
                unit__c= pbid.Product2.Unit__c)); //Collect the products
      
      mPBE.put(pbid.id, pbid);//Collect the PriceBookEntry     
        }
  }
    
    //All the related Opportunity
    Map<Id, Opportunity> mParentOppty = new Map<Id, Opportunity>([SELECT Id, Pricebook2Id, Pricebook2.Name, PV_Cost_Pricing__c 
                                                                       FROM Opportunity 
                                     WHERE Id IN: sOpptyIds]);
    
  for(OpportunityLineItem oli: Trigger.new)
  {
    if(!mPBE.isEmpty() && mPBE.containsKey(oli.PricebookEntryId) && !mP.isEmpty() && mP.containsKey(mPBE.get(oli.PricebookEntryId).Product2Id))
    {
      PricebookEntry pbe = mPBE.get(oli.PricebookEntryId); //Related PriceBookEntry Record for the Oppty Line Item
      Product2 prod = mP.get(mPBE.get(oli.PricebookEntryId).Product2Id); //Related Product2 Record for the Oppty Line Item
      
      //Various Checks and Calculations
      if(prod.Product_Type__c == 'PV Module' && 
               prod.Name.contains('SPR-') &&  
               !pbe.Pricebook2.Name.contains('Components') && 
         (oli.Cost__c == null || oli.Cost__c == 0) &&
         !mParentOppty.isEmpty() && 
         mParentOppty.containsKey(oli.OpportunityId))
            {
                oli.Cost__c = (mParentOppty.get(oli.OpportunityId).PV_Cost_Pricing__c != null) ? mParentOppty.get(oli.OpportunityId).PV_Cost_Pricing__c : 0;
            }

            if(pbe.Pricebook2.Name.contains('Components') ||  pbe.Pricebook2.Name.contains('Cost By Quarter'))
            {
                oli.Cost__c = (mPBE.get(oli.PricebookEntryId).Product2.Cost__c != null) ? mPBE.get(oli.PricebookEntryId).Product2.Cost__c : 0;
            }
/*
SYSTEM.DEBUG('>>>1>>> ' + !mParentOppty.isEmpty());
SYSTEM.DEBUG('>>>2>>> ' + mParentOppty.containsKey(oli.OpportunityId));
SYSTEM.DEBUG('>>>3>>> ' + mParentOppty.get(oli.OpportunityId).Pricebook2Id);
SYSTEM.DEBUG('>>>4>>> ' + String.isNotBlank(mParentOppty.get(oli.OpportunityId).Pricebook2.Name));
SYSTEM.DEBUG('>>>5>>> ' + mParentOppty.get(oli.OpportunityId).Pricebook2.Name.startsWith('Systems Price Book'));
SYSTEM.DEBUG('>>>6>>> ' + oli.Cost__c);
*/    
      if(!mParentOppty.isEmpty() && 
         mParentOppty.containsKey(oli.OpportunityId) && 
         mParentOppty.get(oli.OpportunityId).Pricebook2Id != null && 
         String.isNotBlank(mParentOppty.get(oli.OpportunityId).Pricebook2.Name) && 
         (mParentOppty.get(oli.OpportunityId).Pricebook2.Name.startsWith('Systems Price Book') ||
          mParentOppty.get(oli.OpportunityId).Pricebook2.Name.startsWith('NA Commercial Direct')) && //KM_08042017: Pivotal 147365117; updated filter to include new price book's name
         oli.Cost__c != null)
            {              
                if(pbe.Product2.Unit__c == 1000)
          oli.Total_Cost1__c = ((oli.Cost__c != null) ? oli.Cost__c : 0) * ((oli.Quantity != null) ? oli.Quantity : 0) * 1000;
                else if(pbe.Product2.Unit__c == 1 || pbe.Product2.Unit__c != 1000)
          oli.Total_Cost1__c = ((oli.Cost__c != null) ? oli.Cost__c : 0) * ((oli.Quantity != null) ? oli.Quantity : 0) * 1;  
            }
            else if(oli.Cost__c != null && prod.Wattage_Out__c != null)
            {                                
                oli.Total_Cost1__c = ((oli.Cost__c != null) ? oli.Cost__c : 0) * ((oli.Quantity != null) ? oli.Quantity : 0) * ((prod.Wattage_Out__c != null) ? prod.Wattage_Out__c : 0);
            }
      else if(oli.Cost__c == null)
      {
        oli.Total_Cost1__c = 0;
      }
      
      //KM_08042017: Pivotal 147365117; setting value of Total_Cost_new__c from within this trigger instead of through the workflow
      if (oli.Total_Cost1__c > 0){
          oli.Total_Cost_new__c = oli.Total_Cost1__c; 
      }
    }
  }//End For
}