/*********************************
    Author :(Appirio) Prakash G.
    Reference : - PR-2009
*********************************/
public class TerrirtoryPickListController{
    private boolean isTest =false;
    public Account acct {get;set;}
    public String closeStatus {get;set;}
    public String accid {get;set;}
    //For Test Purpose
    public TerrirtoryPickListController(ApexPages.StandardController ctrl,boolean isTest){
         this.isTest = isTest;
         closeStatus ='none';
         
         if(accid ==null)
            accid = ApexPages.currentPage().getParameters().get('id');
            
         List<Account> lstAccount = 
            new List<Account>([select id,Name,Territory__c 
                from Account 
                where id =:accid]);
                
         if(lstAccount.Size()>0){   
            acct = lstAccount.get(0);
         }  
    }
    public TerrirtoryPickListController(ApexPages.StandardController ctrl){
        
        closeStatus ='none';
        
         if(accid ==null)
            accid = ApexPages.currentPage().getParameters().get('id');
           
         List<Account> lstAccount = 
            new List<Account>([select id,Name,Territory__c 
                from Account 
                where id =:accid]);
                
         if(lstAccount.Size()>0){   
            acct = lstAccount.get(0);
         }  
    }
    
    public List<SelectOption> getTerritoryList(){
      /**
      1. Fetch all territories.
      2. Put all territories in a map id as key and record as value.
      3. Add all territories in a map parent id as key and list of all child categories as value.
      4. add all territories in select option based on display value.
      **/   
      //holds select options to show in picklist      
      List<SelectOption> options = new List<SelectOption>();
      
      //get all territories
      List<Territory> lstTerritories = new List<Territory>();
      lstTerritories = [select Id, Name, ParentTerritoryId, Display_Territory__c from Territory];
      
      //put all territories in a map      
      Map<Id, Territory> mapTerritories = new Map<Id, Territory>();      
      for(Territory terrObj : lstTerritories){
        mapTerritories.put(terrObj.Id, terrObj);
      }
      
      //loop on all territories and add all in a map with parentid as key and list of children as value
      Map<Id, List<Territory>> mapParentIdTerr = new Map<Id, List<Territory>>();  
      for(Territory terr : lstTerritories){
        //if this is root territory
        if(terr.ParentTerritoryId == null && !mapParentIdTerr.containsKey(terr.Id)){
          mapParentIdTerr.put(terr.Id, new List<Territory>());  
        }
        //if its parent is already added as key
        else if(mapParentIdTerr.containsKey(terr.ParentTerritoryId)){
          mapParentIdTerr.get(terr.ParentTerritoryId).add(terr);    
        }
        //if its parent is not added as key, add it and this territory record 
        else{
          mapParentIdTerr.put(terr.ParentTerritoryId, new List<Territory>());
          mapParentIdTerr.get(terr.ParentTerritoryId).add(terr);    
        }
      }
      
      //loop on the key set of mapParentIdTerr
      for(Id parentid : mapParentIdTerr.keySet()){
        Boolean display = false;
        //get all child territories
        List<Territory> lstChildTerr = mapParentIdTerr.get(parentId);
        //check for display 
        for(Territory terr : lstChildTerr){
          if(terr.Display_Territory__c == true){
            display = true;                 
          } 
        }
        //if there are no children or all have display = false
        if(!display){
          continue; 
        }
        //get parent territory record
        if(mapTerritories.containsKey(parentId)){
          Territory parentObj = mapTerritories.get(parentId);
          if(parentObj != null){
            SelectOption opt = new SelectOption(parentObj.Name, '---' + parentObj.Name + '---');
            opt.setDisabled(true);
            options.add(opt);   
          }
          for(Territory terr : lstChildTerr){
            if(terr.Display_Territory__c == true){  
              SelectOption opt = new SelectOption(terr.Name, terr.Name);
              options.add(opt);     
            }
          }
        }       
      }
      return options;
    }
    
    /**
    public List<SelectOption> getTerritoryList(){      
      1. Get all territories where display = true order by parent id
      2. get all territories having parent = null in a separate list
      3. for all territories add all in a Map<ParentId, List<Territory>>      
      4. Fetch all territories in Map.keySet()
      5. Add all in the select option list
            
      
      //holds select options to show in picklist      
      List<SelectOption> options = new List<SelectOption>();
      
      //holds parent territory id as key and list of all child territories as value
      Map<Id, List<Territory>> mapParentIdTerr = new Map<Id, List<Territory>>();      
      
      //get all child territories with display = true 
      List<Territory> lstChildTerritories = new List<Territory>();
      lstChildTerritories = [select Id, Name, ParentTerritoryId, Display_Territory__c
                             from Territory      
                             where Display_Territory__c = true                       
                             order by ParentTerritoryId
                             Limit 1000];
      
      //loop on all territories and add in the map according to parent territory id                       
      for(Territory terrObj : lstChildTerritories){
        if(terrObj.ParentTerritoryId == null){
          mapParentIdTerr.put(terrObj.Id, new List<Territory>());   
        }
        //dont add child category who is parent to any other category           
        if(mapParentIdTerr.containsKey(terrObj.ParentTerritoryId) 
           && !(mapParentIdTerr.containsKey(terrObj.Id))){
          mapParentIdTerr.get(terrObj.ParentTerritoryId).add(terrObj);  
        }
        else{
          mapParentIdTerr.put(terrObj.ParentTerritoryId, new List<Territory>());
          if(!(mapParentIdTerr.containsKey(terrObj.Id))){
            mapParentIdTerr.get(terrObj.ParentTerritoryId).add(terrObj);
          }             
        }
      }
      
      Map<Id, Territory> mapParentTerr = new Map<Id, Territory>([select Id, Name, ParentTerritoryId
                                                                 from Territory
                                                                 where Id in : mapParentIdTerr.keySet()
                                                                 Limit 1000 ]);                             
      
      for(Id terrId : mapParentIdTerr.keySet()){
        Territory parentTerr = null;
        //get parent territory record
        if(mapParentTerr.containsKey(terrId)){
          parentTerr = mapParentTerr.get(terrId);       
        }
        //get child territories list
        List<Territory> lstTerr = mapParentIdTerr.get(terrId);
        
        //if there are no childs to any territory coninue
        if(lstTerr.size() <= 0){          
          continue; 
        }
        
        //add parent as disabled
        if(parentTerr != null){
          SelectOption opt = new SelectOption(parentTerr.Name, '---' + parentTerr.Name + '---');
          opt.setDisabled(true);
          options.add(opt); 
        }
        //add children as selectable
        for(Territory terr : lstTerr){
          if(terr.Display_Territory__c == true){    
            SelectOption opt = new SelectOption(terr.Name, terr.Name);
            options.add(opt);   
          }
        }
      }     
      return options;
    }**/    
    
    /** Old code fetching select list options from Territory_Reference__c 
    public List<SelectOption> getTerritoryList(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.sObjectType t = Territory_Reference__c.sObjectType;
        Schema.DescribeFieldResult f = Schema.sObjectType.Territory_Reference__c.fields.Territory__c;
        //Code commented against the PR-02178
        //SelectOption opt1 = new SelectOption('--None--','--None--');
        //options.add(opt1);                
        for(picklistEntry a : f.picklistValues){
            SelectOption opt = new SelectOption(a.getValue(),a.getLabel());
            options.add(opt);
        }
       return options;
   }
   **/
   
   public PageReference save(){
     if(acct!=null){
         update acct;
     }
     closeStatus='save';
     return null;       
   }
   
   public PageReference cancel(){
     //update acct;
     closeStatus = 'close';
     return null;       
   }   
   
   @isTest
   public static void testMethodthis(){
       Account acct = new Account(name='Test'+Datetime.Now());
       acct.Type ='Commercial';
       acct.Type ='Commercial';
	   acct.billingCity = 'TestCity';
	   acct.BillingCountry = 'TestCountry';
	   acct.BillingPostalCode = '12345';
	   acct.BillingState = 'TestState';
	   acct.BillingStreet = 'TestStreet';
       insert acct;
       ApexPages.StandardController cont = new ApexPages.StandardController(acct);
       ApexPages.currentPage().getParameters().put('id',acct.id);
       TerrirtoryPickListController tr = new TerrirtoryPickListController (cont,true);
       tr.getTerritoryList();
       tr.save();
       tr.cancel(); 
       
       TerrirtoryPickListController tr1 = new TerrirtoryPickListController (cont);
   }
   
}