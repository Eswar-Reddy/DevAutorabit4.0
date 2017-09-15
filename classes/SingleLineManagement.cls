public class SingleLineManagement {
    
    
    public static void beforeSingleLineUpdate(List<Single_Line__c> singleLineList, 
        List<Single_Line__c> oldSingleLineList){

        populateSingleLineFields(singleLineList);
 
    }

    public static void beforeSingleLineInsert(List<Single_Line__c> singleLineList){
        
        populateSingleLineFields(singleLineList); 

    }

    public static void afterSingleLineUpdate(List<Single_Line__c> singleLineList, 
        List<Single_Line__c> oldSingleLineList){

        populateRelatedObjects(singleLineList);
        
        // Done for case # 00066565
        sendEmailOnSingleLineCompleteOrCancelled(singleLineList,oldSingleLineList); 
                       
    }

    public static void afterSingleLineInsert(List<Single_Line__c> singleLineList){
        
        //populateRelatedObjects(singleLineList);               

    }

    public static void populateSingleLineFields(List<Single_Line__c> singleLineList){

      List<Id> siteIds = new List<Id>();
      Map<Id,Site_Information_Form__c> sites = new Map<Id,Site_Information_Form__c> ();

      List<Id> designIds = new List<Id>();
      Map<Id,Design__c> designs = new Map<Id,Design__c> ();

      List<Id> quoteIds = new List<Id>();
      Map<Id,Quote> quotes = new Map<Id,Quote> ();

      // Done for case # 00062214 
      /* Popoulating the PSR Owner Field */      
      List<Id> PSRIds = new List<Id> ();
      Map<Id,PSR__c> PSRMap = new Map<Id,PSR__c> (); 
      
      // get all sites/designs associated with the estimate      
      for(Single_Line__c singleLine : singleLineList){          
        
        if (singleLine.site__c != null){
            siteIds.add(singleLine.site__c);    
        }   
        
        if (singleLine.design__c != null){
            designIds.add(singleLine.design__c);    
        }   

        if (singleLine.quote__c != null){
            quoteIds.add(singleLine.quote__c);  
        }
        
        // Done for case # 00062214           
        if (singleLine.PSR__c != null){
            PSRIds.add(singleLine.PSR__c);    
        }    

      }

      // get all site records
      if (siteIds.size()>0){
        
        sites = new Map<Id,Site_Information_Form__c> 
            ([select id, Opportunity_del__c, Site_Name__c, Opportunity_del__r.name 
                from Site_Information_Form__c 
              where id in :siteIds]);       
      }

      // get all design records
      if (designIds.size()>0){
        
        designs = new Map<Id,Design__c> 
            ([select id, site__c, site__r.name, Opportunity__c, Opportunity__r.name 
                from Design__c 
              where id in :designIds]);         
      }

      // get all quote records
      if (quoteIds.size()>0){
        
        quotes = new Map<Id,Quote>([select id,Opportunity.id,Opportunity.name from Quote 
    where id in :quoteIds]);        
      }

      // get all PSR records
      if (PSRIds.size()>0){
        PSRMap = new Map<Id,PSR__c> 
                    ([select id, OwnerId from PSR__c where id in :PSRIds]);       
      }
      
      for(Single_Line__c singleLine : singleLineList){
        
        if (singleLine.design__c != null 
            && (singleLine.site__c == null || singleLine.opportunity__c == null)
            && designs.size()>0
            && designs.containsKey(singleLine.design__c)){
                
            if (singleLine.opportunity__c == null){
                singleLine.opportunity__c = designs.get(singleLine.design__c).Opportunity__c;
            }
        
            if (singleLine.site__c == null){
                singleLine.site__c = designs.get(singleLine.design__c).site__c;
            }
        }               

                
        if (singleLine.site__c != null 
            && singleLine.opportunity__c == null
            && sites.size()>0
            && sites.containsKey(singleLine.site__c)){
          
            singleLine.opportunity__c = sites.get(singleLine.site__c).Opportunity_del__c;
            
        }               


        if (singleLine.quote__c != null 
            && singleLine.opportunity__c == null
            && quotes.size()>0
            && quotes.containsKey(singleLine.quote__c)){
          
            singleLine.opportunity__c = quotes.get(singleLine.quote__c).Opportunity.id;
                        
        }   
        
        if (singleLine.PSR__c != null 
            && singleLine.PSR_Owner__c == null
            && PSRMap.size()>0
            && PSRMap.containsKey(singleLine.PSR__c)){

            singleLine.PSR_Owner__c = PSRMap.get(singleLine.PSR__c).OwnerId;
        }               

      }

    } 
    
    public static void populateRelatedObjects(List<Single_Line__c> singleLineList){

      List<Id> psrIds = new List<Id>();
      Map<Id,PSR__c> PSRs = new Map<Id,PSR__c> ();
      List<PSR__c> updatedPSRs = new List<PSR__c>();

      
      for(Single_Line__c singleLine : singleLineList){          

        if (singleLine.PSR__c != null){
            psrIds.add(singleLine.PSR__c);  
        }   

      }//end-for
        
      // get all psr records
      if (psrIds.size()>0){
        
        PSRs = new Map<Id,PSR__c> 
            ([select id, array_layout_completed__c, electrical_support_completed__c, 
            	electrical_support_tracking__c,
                cost_estimate_completed__c 
                from PSR__c 
              where id in :psrIds]);        
      }//end-if
      
            
      PSR__c psr = null;
            
      for(Single_Line__c singleLine : singleLineList){          

        if (singleLine.Primary_PSR_Single_Line__c
            && singleLine.PSR__c != null
            && PSRs.size()>0 
            && PSRs.containsKey(singleLine.PSR__c)){
            
            psr = PSRs.get(singleLine.PSR__c);
            
            if( psr.electrical_support_completed__c!=singleLine.Single_Line_Completed__c 
            || psr.electrical_support_tracking__c!=singleLine.Single_Line_Tracking__c){
	            psr.electrical_support_completed__c=singleLine.Single_Line_Completed__c;
	            psr.electrical_support_tracking__c=singleLine.Single_Line_Tracking__c;                                    
	            updatedPSRs.add(psr);
            }
        }   

      }//end-for
      
      if (updatedPSRs.size()>0)
        update updatedPSRs;

    }//end-method
    
    // Done for case # 00066565
    /* Whenever Single Line on a PSR go to 'Completed' or 'Cancelled' status,
       It send a notification to all owners of related objects(Design,Estimate,SingleLine) on the PSR and user 'Sunpower Archive'.*/
    private static void sendEmailOnSingleLineCompleteOrCancelled(List<Single_Line__c> singleLineList , List<Single_Line__c> oldSingleLineList)
    {   
        
        // Preparing the old Single Line Map     
        Map<Id,Single_Line__c> oldSingleLineMap = new Map<Id,Single_Line__c> ();  
        if(oldSingleLineList != null){
            for (Single_Line__c oldSingleLine : oldSingleLineList){
                oldSingleLineMap.put(oldSingleLine.Id ,oldSingleLine );
            }
        }
        // List of associated PSR IDs  
        List<ID> psrIDsList = new List<ID>();                             
        
        //If SingleLine is completed or cancelled. 
        //CompletedDate check is added on cancelled also to restrict the email being sent twice because completedDate is updated through workflow
        for(Single_Line__c singleLine : singleLineList){        
            if((singleLine.Status__c == 'Completed' && oldSingleLineMap.get(singleLine.id).Status__c != 'Completed' && singleLine.Single_Line_Completed__c != null)
                || (singleLine.Status__c == 'Cancelled' && oldSingleLineMap.get(singleLine.id).Status__c != 'Cancelled' && singleLine.Single_Line_Completed__c != null)
                && singleLine.PSR__c != null){               
                psrIDsList.Add(singleLine.PSR__c);
            }
        }
        // Calling the method from class PSRManagement to send email notification                
        if(psrIDsList.size()>0){ 
            PSRManagement.sendEmailOnCompletedOrCancelledStatusOfRelatedObjects(psrIDsList,'Single Line');
        }
    }
 
}