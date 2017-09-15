/*** Modified Code -- Sunpower TPO Phase 1 -- 20/10/2013, to implement TPO MPPT integration with Quote ***/
public class QuoteManagement {

    static public string QUOTE_STEP_AWAITING_APPROVAL = '0. Awaiting Approval';
    static public string QUOTE_STEP_PSR_APPROVED = '1. PSR Approved';
    static public string QUOTE_STEP_PSR_IN_PROGRESS = '2. PSR In Progress';
    static public string QUOTE_STEP_PSR_COMPLETE = '3. PSR Complete';
    static public string QUOTE_STEP_PROPOSAL_AWAITING_APPROVAL = '4. Proposal Awaiting Approval';
    static public string QUOTE_STEP_SENT_TO_CUSTOMER = '5. Approved - Sent to Customer';
    static public string QUOTE_STEP_PROPOSAL_INCOMPLETE = '6. Proposal Incomplete';
    //public integer TotalModuleQuantity = 0;
    static public Boolean updateFlag = false;  

    public static void beforeQuoteUpdate(List<Quote> quoteList, 
        List<Quote> oldQuoteList , Map<Id, Quote> oldQuoteMap){ 
		updateFlag = true;

        populateQuoteFields(quoteList);
      //Added by Venkat 
      //for(integer i = 0;i<quoteList.size();i++){
            
            //if(oldQuoteList[i].Name.contains('-')){
                //if(quoteList[i].ShippingCity!=null){
                    //if(quoteList[i].ShippingCity.trim().length()==1 && quoteList[i].ShippingCity.trim()=='.'){
                        //quoteList[i].ShippingCity = '';
                   // }
               // }
               // if(quoteList[i].ShippingCountry!=null){
                    //if(quoteList[i].ShippingCountry.trim().length()==1 && quoteList[i].ShippingCountry.trim() == '.'){
                        //quoteList[i].ShippingCountry = '';
                   // }
               // }
            //}
        //}
        //End 
        
        for(Quote quote : quoteList){
            if(oldQuoteMap.get(quote.Id).Name.contains('-')){
                if(quote.ShippingCity!=null){
                    if(quote.ShippingCity.trim().length()==1 && quote.ShippingCity.trim()=='.'){
                       quote.ShippingCity = '';
                    }
                }
                if(quote.ShippingCountry!=null){
                    if(quote.ShippingCountry.trim().length()==1 && quote.ShippingCountry.trim() == '.'){
                        quote.ShippingCountry = '';
                    }
                }
            }
        }
        
    }

    public static void beforeQuoteInsert(List<Quote> quoteList){
        
      populateQuoteFields(quoteList);

    }

  /* Method :     populateQuoteFields
   * Variables:   list of quotes 
   * Description: If Sales Analyst/Oppty Owner Manager field blank on qoute creation then populate from Oppty-
   *              Populate Opportunity 'Proposal Due Date' on Quote
   * CreatedBy :  Raee$
   * Date:        6/8/2016 
   */

    public static void populateQuoteFields(List<Quote> quoteList){

        List<Id> oppIds = new List<Id> ();
        Map<Id,Opportunity> opportunityMap = new Map<Id,Opportunity> ();        
    	Boolean OpptySAnOwnerBlank = false; // Added Raee$: Populate 'Proposal Due Date' from Opportunity 
		Opportunity parentOpp = null;
		


        for(Quote quote:quoteList){            
            if(quote.sales_analyst__c == null || quote.Opportunity_Owner_S_Manager__c == null) {
            	OpptySAnOwnerBlank = true;

            }
            oppIds.add(quote.opportunityID);           
        } 



        if (oppIds.size()>0){                  


            for(Opportunity opp : [select id, sales_analyst__c,owner.manager.email,Proposal_Due_Date__c,RecordTypeId,Business_Unit__c  
					               from opportunity
					               where id in : oppIds]){    

                opportunityMap.put(opp.Id, opp);   

            }//end-for
        }       
        



        for(Quote quote:quoteList){            
            if (opportunityMap.containsKey(quote.opportunityID)){                
            	parentOpp = opportunityMap.get(quote.opportunityID);  
                if(OpptySAnOwnerBlank){                          
	                //Start 00103412
	                quote.Opportunity_Owner_s_Manager__c = parentOpp.owner.manager.email;
	                //End 00103412
	                quote.sales_analyst__c=parentOpp.sales_analyst__c;
	            }
	            //Added Raee$: Populate 'Proposal Due Date' from Opportunity 
                if( parentOpp.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Systems').getRecordTypeId() &&
                	parentOpp.Business_Unit__c == Label.NA_Commercial &&
                	parentOpp.Proposal_Due_Date__c != null &&
                	!updateFlag){
                	//quote.Proposal_Due__c == null ){
                	quote.Proposal_Due__c = parentOpp.Proposal_Due_Date__c;               		
                }

            }
        }


    }//end-method
   //Venkat added this method on 06-01-10
    public static void beforeQuoteLineItesInsertMethod(List<QuoteLineItem> quoteLineItemsList){
        //@future public static void afterQuoteInsertMethod(Set<Id> quoteIdsList){              
        Set<Id> quoteIdsSet = new Set<Id>();
        for(QuoteLineItem quoteLineITM: quoteLineItemsList){            
            quoteIdsSet.add(quoteLineITM.QuoteId);            
        }
        Set<Id> oppIdsSet = new Set<Id>();
        Map<Id,Quote> quoteMap = new Map<Id,Quote>([select id,LineItemsFromOpp__c,OpportunityId from Quote where id in :quoteIdsSet and LineItemsFromOpp__c=true]);
        System.debug('******Venkat****in**afterQuoteInsertMethod*******quoteMap *****'+quoteMap);
        for(Quote quote:quoteMap.values()){           
            oppIdsSet.add(quote.OpportunityId);        
        }
        
        List<OpportunityLineItem> oppLineItemList = new List<OpportunityLineItem>([Select o.UnitPrice, o.Site__c, o.ServiceDate, o.Quantity, o.PricebookEntryId, o.Description, o.OpportunityId, o.Id, o.Cost__c, o.kWp_Components__c, o.sales_unit_price__c From OpportunityLineItem o where o.OpportunityId in :oppIdsSet and o.PricebookEntryId!=null]);        
        // Start 00126362    
        //Same product can be associated multiple times with an Opportunity, that why used list of OpportunityLineItem
        Map<ID,List<OpportunityLineItem>> mapPriceBookEntryOppLineItem = new  Map<ID,List<OpportunityLineItem>>();               
        for(OpportunityLineItem ol : oppLineItemList){
            if(mapPriceBookEntryOppLineItem.containsKey(ol.PricebookEntryId))
                mapPriceBookEntryOppLineItem.get(ol.PricebookEntryId).add(ol);
            else
                mapPriceBookEntryOppLineItem.put(ol.PricebookEntryId, new List<OpportunityLineItem>{ol});
        }
        
        for(QuoteLineItem quoteLineItem:quoteLineItemsList){ 
            OpportunityLineItem olItem;
            if(mapPriceBookEntryOppLineItem.containsKey(quoteLineItem.PricebookEntryId)){               
                olItem = mapPriceBookEntryOppLineItem.get(quoteLineItem.PricebookEntryId).get(0);
                quoteLineItem.UnitPrice = olItem.UnitPrice;
                quoteLineItem.Site__c = olItem.Site__c;
                quoteLineItem.ServiceDate = olItem.ServiceDate;
                quoteLineItem.Quantity = olItem.Quantity;
                quoteLineItem.Cost__c = olItem.Cost__c;
                quoteLineItem.sales_unit_price__c = olItem.sales_unit_price__c;
                quoteLineItem.kWp_Components__c = olItem.kWp_Components__c;
                quoteLineItem.Description= olItem.Description;
                
                if (mapPriceBookEntryOppLineItem.get(quoteLineItem.PricebookEntryId).size() > 1){
                    mapPriceBookEntryOppLineItem.get(quoteLineItem.PricebookEntryId).remove(0);
                }
            } 
        }   
       //End 00126362 
    }    
    
     public static void SendApprovalEmailtoSalesAnalyst(List<Quote> newQuoteList, List<Quote> oldQuoteList){ 
        
        Map<Id,Quote> mapOldQuote = new Map<Id,Quote> ();  
        Set<Id> OppsIds = new Set<Id>();
        Set<String> strEmail = new  Set<String>();
        String templateFetched='false';
        List<String> lstSalesTeam = new List<String>();
        List<EmailTemplate> lstemailTemp = new list<EmailTemplate>();
        List<Messaging.Email> emailMessages = new List<Messaging.Email>(); 
        List<Contact> lstDelCont = new List<Contact>();               
        List<OpportunityTeamMember> lstOpTeamMember = new List<OpportunityTeamMember>();
        Map<Id,List<OpportunityTeamMember>> mapOppTeamMem = new Map<Id,List<OpportunityTeamMember>>();
        set<id> setOppIdForQuote = new set<id>();
        List<OpportunityTeamMember> oppTeamMem = new list<OpportunityTeamMember>();
        
        if (oldQuoteList != null) {
      
            for (Quote oldQuote : oldQuoteList){
        
                mapOldQuote.put(oldQuote.Id ,oldQuote );
            }
        }
        //populate the opportunitiesids from quote
        for(Quote objQuote : newQuoteList){         
            if (objQuote.IsSendApprovaltoSalesAnalyst__c == true && objQuote.IsSendApprovaltoSalesAnalyst__c != mapOldQuote.get(objQuote.Id).IsSendApprovaltoSalesAnalyst__c ) {
                setOppIdForQuote.add(objQuote.Opportunityid);           
            }
        }
        
        
        if (setOppIdForQuote.size() > 0) {
            
           //   oppTeamMem = new Map<id,List<OpportunityTeamMember>>([Select Id, (Select UserId From OpportunityTeamMembers) From Opportunity where id in :setOppIdForQuote]);
                oppTeamMem = [Select id,User.Name,User.Email, TeamMemberRole , OpportunityId From OpportunityTeamMember where OpportunityId in :setOppIdForQuote];
        
            if (oppTeamMem.size() > 0 ) {
                
                for (OpportunityTeamMember objteamMem : oppTeamMem) {
                    
                    if ( mapOppTeamMem.get(objteamMem.OpportunityId)!= null) {
                        
                        mapOppTeamMem.get(objteamMem.OpportunityId).add(objteamMem);
                    }
                    else {
                        
                        List<OpportunityTeamMember> objlst = new List<OpportunityTeamMember>();
                        objlst.add(objteamMem);
                        mapOppTeamMem.put(objteamMem.OpportunityId,objlst);
                    }
                }
            }
        }
                  
        for (Quote objQuote : newQuoteList) {
            
            //Opportunity objopp = [Select id, Name from Opportunity where id =: objQuote.Opportunityid];
            //User usr = [Select id, Email from User where id = :objQuote.Opportunity.OwnerId];
            if (objQuote.IsSendApprovaltoSalesAnalyst__c == true && objQuote.IsSendApprovaltoSalesAnalyst__c != mapOldQuote.get(objQuote.Id).IsSendApprovaltoSalesAnalyst__c ) {
                if(templateFetched=='false'){
                    lstemailTemp =  [select Id, DeveloperName from EmailTemplate  where DeveloperName = 'Binding_Offer_Quote_Submission_VF' and isActive = true] ;
                    templateFetched='true';                             
                }    
                    
              //  List<OpportunityTeamMember> oppTeamMem = [Select id, User.Name,User.Email, TeamMemberRole , OpportunityId from OpportunityTeamMember where OpportunityId = :objQuote.Opportunityid and TeamMemberRole in ('Sales Analyst') ];
                
                   
                if(mapOppTeamMem.get(objQuote.OpportunityId)!=null){                
                        lstOpTeamMember = mapOppTeamMem.get(objQuote.OpportunityId);
                        for(OpportunityTeamMember teamMemberEmail : lstOpTeamMember){
                            lstSalesTeam.add(teamMemberEmail.User.Email);   
                        }                        
                }
                
                 System.Debug('-------------lstSalesTeam---------' + lstSalesTeam);
                
                if(lstSalesTeam.Size() > 0){                
                    List<Contact> cntlst = [Select id, Email from Contact where Email = :lstSalesTeam.get(0) limit 1];
                    Contact cnt;
                    if ( cntlst.size() == 0) {                    
                        cnt = new Contact(LastName = 'SendEmailMytest', Email = lstSalesTeam.get(0));
                        insert cnt;
                        lstDelCont.add(cnt);
                    }
                    else {
                    
                        cnt = cntlst[0];
                    }
               
                    Map<String,ID> emailTemplates = new Map<String,ID>();
                    //Fetch Email Templates
                               
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setTemplateId(lstemailTemp.get(0).Id);
                    mail.setToAddresses(lstSalesTeam);
                    mail.setTargetObjectId(cnt.Id);
                             
                    mail.setWhatId(objQuote.id);
                    mail.saveAsActivity=false;
                    if(mail.getTemplateId()!=null)
                       
                         emailMessages.add(mail);   
            
                }
                
            }            
        }
        if(emailMessages.size()>0){
         
          List<Messaging.SendEmailResult> sendEmailResults = Messaging.sendEmail(emailMessages);
          
          if (lstDelCont.size() > 0)
           
             delete lstDelCont;
          
          Messaging.SendEmailError[] emailErrors;
          for (Messaging.SendEmailResult sendEmailResult : sendEmailResults) {
             
             if (sendEmailResult.isSuccess() == false) {
               
               //emailSent = false;
               System.debug('Debug: Error(s) sending email:');
               emailErrors = sendEmailResult.getErrors();
               for (Messaging.SendEmailError error : emailErrors) {
                  
                  System.debug('---Debug: Error Message---' + error.getMessage());
                  
               }
               break;
             }
          }
       }  
}



//New Code -- Sunpower TPO Phase 1 -- 20/10/2013
// Method is used to implement TPO MPPT values into the Quote based on Module Quantity
public static void updateQuoteFromStringSizerTool(Map<Id, Quote> map_NewQuote, Map<Id, Quote> map_OldQuote){
    Decimal TotalModuleQuantity = 0;
    List<TPO_MPPT__c> lst_Mppt = [select id,DC_Cabinet__c, Module_Name__c, Module_Quantity__c,Inverter_Quantity__c,Inverter_Quantity2__c,Ac_Cabinet_Type__c,Item_ID__c, MPPT_1_Module_Qty__c, MPPT_1_String_Qty__c, MPPT_2_Module_Qty__c, MPPT_2_String_Qty__c, MPPT_3_Module_Qty__c, MPPT_3_String_Qty__c, MPPT_4_Module_Qty__c, MPPT_4_String_Qty__c, Inverter_Name_1__c, Inverter_Name_2__c from TPO_MPPT__c];
    
    //Process to update the quote only if the non-DSE user is updating it
    if(!Label.TPO_FR_DSE_ProfileID.equalsIgnoreCase(UserInfo.getProfileId())){
    
        //check if Modules_Per_String_Roof1__c, 2, 3, 4 have been updated       
        for(Quote q : map_NewQuote.values()){
            if(checkIfAnyOneRoofIsUpdated(q, map_OldQuote)){
                System.debug('#############:1');
                // if quote is updated, we need to search for the qty and model in the MPPT object
                if(lst_Mppt != null){
                    System.debug('#############:2');
                    for(TPO_MPPT__c mppt : lst_Mppt){
                        if(q.Modules_Per_String_Roof1__c == null){
                            System.debug('#############:3');
                            q.Roof_1_MPPT_1_Module__c = null;
                            q.Roof_1_MPPT_1_string__c = null;
                            q.Roof_1_MPPT_2_Module__c = null;
                            q.Roof_1_MPPT_2_string__c = null;
                            q.Roof_1_MPPT_3_Module__c = null;
                            q.Roof_1_MPPT_3_string__c = null;
                            q.Roof_1_MPPT_4_Module__c = null;
                            q.Roof_1_MPPT_4_string__c = null;
                            
                            q.Inverter_Model_Roof1__c = null;
                            q.Inverter_Model__c = null;
                        }else if((q.Modules_Per_String_Roof1__c == mppt.Module_Quantity__c) && (q.OracleItemNumber__c == mppt.Item_ID__c)){
                            System.debug('############## q.Modules_Per_String_Roof1__c ' + q.Modules_Per_String_Roof1__c);
                            System.debug('############## mppt.Module_Quantity__c ' + mppt.Module_Quantity__c);
                            System.debug('############## q.OracleItemNumber__c ' + q.OracleItemNumber__c);
                            System.debug('############## mppt.Item_ID__c ' + mppt.Item_ID__c);
                            System.debug('############## mppt.mppt.Inverter_Name_2__c ' + mppt.Inverter_Name_2__c);
                            
                           //Need to change System_Model__c to Module_Oracle_Item_Number__c and mppt.Module_Name__c to Item_ID__c
                            q.Roof_1_MPPT_1_Module__c = mppt.MPPT_1_Module_Qty__c;
                            q.Roof_1_MPPT_1_string__c = mppt.MPPT_1_String_Qty__c;
                            q.Roof_1_MPPT_2_Module__c = mppt.MPPT_2_Module_Qty__c;
                            q.Roof_1_MPPT_2_string__c = mppt.MPPT_2_String_Qty__c;
                            q.Roof_1_MPPT_3_Module__c = mppt.MPPT_3_Module_Qty__c;
                            q.Roof_1_MPPT_3_string__c = mppt.MPPT_3_String_Qty__c;
                            q.Roof_1_MPPT_4_Module__c = mppt.MPPT_4_Module_Qty__c;
                            q.Roof_1_MPPT_4_string__c = mppt.MPPT_4_String_Qty__c;
                            q.DC_Cabinet__c           = mppt.DC_Cabinet__c;
                            
                            q.Inverter_Model_Roof1__c = mppt.Inverter_Name_1__c;
                            q.Inverter_Model__c = mppt.Inverter_Name_2__c;
                            //Modified Code -- Sunpower TPO AC Cabinet -- 04/05/2014
                            if(q.Inverter_Model_Roof1__c != null){
                                q.Inverter_Count_Roof1__c = mppt.Inverter_Quantity__c;
                            }else{
                                q.Inverter_Count_Roof1__c = 0;
                            } 
                            
                            if(q.Inverter_Model__c != null){
                                q.Inverter_Quantity__c = mppt.Inverter_Quantity2__c;
                            }else{
                                q.Inverter_Quantity__c = 0;
                            }
                            //End Modified Code -- Sunpower TPO AC Cabinet -- 04/05/2014
                        }       

                        if(q.Modules_Per_String_Roof2__c == null){
                            System.debug('#############:4');
                            q.Roof_2_MPPT_1_Module__c = null;
                            q.Roof_2_MPPT_1_string__c = null;
                            q.Roof_2_MPPT_2_Module__c = null;
                            q.Roof_2_MPPT_2_string__c = null;
                            q.Roof_2_MPPT_3_Module__c = null;
                            q.Roof_2_MPPT_3_string__c = null;
                            q.Roof_2_MPPT_4_Module__c = null;
                            q.Roof_2_MPPT_4_string__c = null;
                            
                            q.Inverter_Model_Roof2__c = null;
                            q.Inverter_Model_2__c = null;                       
                            
                        }else if((q.Modules_Per_String_Roof2__c == mppt.Module_Quantity__c) && (q.System_Model__c.equalsIgnoreCase(mppt.Module_Name__c))){
                            q.Roof_2_MPPT_1_Module__c = mppt.MPPT_1_Module_Qty__c;
                            q.Roof_2_MPPT_1_string__c = mppt.MPPT_1_String_Qty__c;
                            q.Roof_2_MPPT_2_Module__c = mppt.MPPT_2_Module_Qty__c;
                            q.Roof_2_MPPT_2_string__c = mppt.MPPT_2_String_Qty__c;
                            q.Roof_2_MPPT_3_Module__c = mppt.MPPT_3_Module_Qty__c;
                            q.Roof_2_MPPT_3_string__c = mppt.MPPT_3_String_Qty__c;
                            q.Roof_2_MPPT_4_Module__c = mppt.MPPT_4_Module_Qty__c;
                            q.Roof_2_MPPT_4_string__c = mppt.MPPT_4_String_Qty__c;
                            q.DC_Cabinet_Roof2__c     = mppt.DC_Cabinet__c;

                            q.Inverter_Model_Roof2__c = mppt.Inverter_Name_1__c;
                            q.Inverter_Model_2__c = mppt.Inverter_Name_2__c;
                            //Modified Code -- Sunpower TPO AC Cabinet -- 04/05/2014
                            if(q.Inverter_Model_Roof2__c != null){
                                q.Inverter_Count_Roof2__c = mppt.Inverter_Quantity__c;
                            }else{
                                q.Inverter_Count_Roof2__c = 0;
                            } 
                            
                            if(q.Inverter_Model_2__c != null){
                                q.Inverter_Quantity_2__c = mppt.Inverter_Quantity2__c;
                            }else{
                                q.Inverter_Quantity_2__c = 0;
                            } 
                            //End Modified Code -- Sunpower TPO AC Cabinet -- 04/05/2014
                        }

                        if(q.Modules_Per_String_Roof3__c == null){
                            System.debug('#############:5');
                            q.Roof_3_MPPT_1_Module__c = null;
                            q.Roof_3_MPPT_1_string__c = null;
                            q.Roof_3_MPPT_2_Module__c = null;
                            q.Roof_3_MPPT_2_string__c = null;
                            q.Roof_3_MPPT_3_Module__c = null;
                            q.Roof_3_MPPT_3_string__c = null;
                            q.Roof_3_MPPT_4_Module__c = null;
                            q.Roof_3_MPPT_4_string__c = null;
                            
                            q.Inverter_Model_Roof3__c = null;
                            q.Inverter_Model_3__c = null;
                        }else if((q.Modules_Per_String_Roof3__c == mppt.Module_Quantity__c) && (q.System_Model__c.equalsIgnoreCase(mppt.Module_Name__c))){
                            q.Roof_3_MPPT_1_Module__c = mppt.MPPT_1_Module_Qty__c;
                            q.Roof_3_MPPT_1_string__c = mppt.MPPT_1_String_Qty__c;
                            q.Roof_3_MPPT_2_Module__c = mppt.MPPT_2_Module_Qty__c;
                            q.Roof_3_MPPT_2_string__c = mppt.MPPT_2_String_Qty__c;
                            q.Roof_3_MPPT_3_Module__c = mppt.MPPT_3_Module_Qty__c;
                            q.Roof_3_MPPT_3_string__c = mppt.MPPT_3_String_Qty__c;
                            q.Roof_3_MPPT_4_Module__c = mppt.MPPT_4_Module_Qty__c;
                            q.Roof_3_MPPT_4_string__c = mppt.MPPT_4_String_Qty__c;
                            q.DC_Cabinet_Roof3__c     = mppt.DC_Cabinet__c;

                            q.Inverter_Model_Roof3__c = mppt.Inverter_Name_1__c;
                            q.Inverter_Model_3__c = mppt.Inverter_Name_2__c;

                            //Modified Code -- Sunpower TPO AC Cabinet -- 04/05/2014
                            if(q.Inverter_Model_Roof3__c != null){
                                q.Inverter_Count_Roof3__c = mppt.Inverter_Quantity__c;
                            }else{
                                q.Inverter_Count_Roof3__c = 0;
                            } 
                            
                            if(q.Inverter_Model_3__c != null){
                                q.Inverter_Quantity_3__c = mppt.Inverter_Quantity2__c;
                            }else{
                                q.Inverter_Quantity_3__c = 0;
                            }
                            //End Modified Code -- Sunpower TPO AC Cabinet -- 04/05/2014
                        }

                        if(q.Modules_Per_String_Roof4__c == null){
                            System.debug('#############:5');
                            q.Roof_4_MPPT_1_Module__c = null;
                            q.Roof_4_MPPT_1_string__c = null;
                            q.Roof_4_MPPT_2_Module__c = null;
                            q.Roof_4_MPPT_2_string__c = null;
                            q.Roof_4_MPPT_3_Module__c = null;
                            q.Roof_4_MPPT_3_string__c = null;
                            q.Roof_4_MPPT_4_Module__c = null;
                            q.Roof_4_MPPT_4_string__c = null;
                            
                            q.Inverter_Model_Roof4__c = null;
                            q.Inverter_Model_4__c = null;
                        }else if((q.Modules_Per_String_Roof4__c == mppt.Module_Quantity__c) && (q.System_Model__c.equalsIgnoreCase(mppt.Module_Name__c))){
                            q.Roof_4_MPPT_1_Module__c = mppt.MPPT_1_Module_Qty__c;
                            q.Roof_4_MPPT_1_string__c = mppt.MPPT_1_String_Qty__c;
                            q.Roof_4_MPPT_2_Module__c = mppt.MPPT_2_Module_Qty__c;
                            q.Roof_4_MPPT_2_string__c = mppt.MPPT_2_String_Qty__c;
                            q.Roof_4_MPPT_3_Module__c = mppt.MPPT_3_Module_Qty__c;
                            q.Roof_4_MPPT_3_string__c = mppt.MPPT_3_String_Qty__c;
                            q.Roof_4_MPPT_4_Module__c = mppt.MPPT_4_Module_Qty__c;
                            q.Roof_4_MPPT_4_string__c = mppt.MPPT_4_String_Qty__c;
                            q.DC_Cabinet_Roof4__c     = mppt.DC_Cabinet__c;

                            q.Inverter_Model_Roof4__c = mppt.Inverter_Name_1__c;
                            q.Inverter_Model_4__c = mppt.Inverter_Name_2__c;
                            
                            //Modified Code -- Sunpower TPO AC Cabinet -- 04/05/2014
                            if(q.Inverter_Model_Roof4__c != null){
                                q.Inverter_Count_Roof4__c = mppt.Inverter_Quantity__c;
                            }else{
                                q.Inverter_Count_Roof4__c = 0;
                            } 
                            
                            if(q.Inverter_Model_4__c != null){
                                q.Inverter_Quantity_4__c = mppt.Inverter_Quantity2__c;
                            }else{
                                q.Inverter_Quantity_4__c = 0;
                            }
                            //End Modified Code -- Sunpower TPO AC Cabinet -- 04/05/2014
                        } 
                        //New Code -- Sunpower TPO AC Cabinet -- 04/05/2014
                        TotalModuleQuantity = (q.Modules_Per_String_Roof1__c != null ? q.Modules_Per_String_Roof1__c : 0) + (q.Modules_Per_String_Roof2__c != null ? q.Modules_Per_String_Roof2__c : 0) + (q.Modules_Per_String_Roof3__c != null ? q.Modules_Per_String_Roof3__c : 0) + (q.Modules_Per_String_Roof4__c != null ? q.Modules_Per_String_Roof4__c : 0);
                        if((TotalModuleQuantity  == mppt.Module_Quantity__c) && (q.System_Model__c.equalsIgnoreCase(mppt.Module_Name__c))) {
                            q.Ac_Cabinet_Type__c = mppt.Ac_Cabinet_Type__c;
                        }
                        //New Code -- Sunpower TPO AC Cabinet -- 04/05/2014


                        }   
                    }
                }   
            }
        }
    }           

// Method is used to implement to check if the Quote strings are already updated
   public static boolean checkIfAnyOneRoofIsUpdated(Quote q, Map<Id, Quote> map_OldQuoteMap){
    if(     (q.Modules_Per_String_Roof1__c != map_OldQuoteMap.get(q.Id).Modules_Per_String_Roof1__c)
        ||  (q.Modules_Per_String_Roof2__c != map_OldQuoteMap.get(q.Id).Modules_Per_String_Roof2__c) 
        ||  (q.Modules_Per_String_Roof3__c != map_OldQuoteMap.get(q.Id).Modules_Per_String_Roof3__c)
        ||  (q.Modules_Per_String_Roof4__c != map_OldQuoteMap.get(q.Id).Modules_Per_String_Roof4__c) ){
        return true;
    }else{
        return false;
    }
}
//End New Code -- Sunpower TPO Phase 1 -- 20/10/2013
}