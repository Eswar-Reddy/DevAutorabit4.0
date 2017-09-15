public with sharing class Controller_send_designer_email {
 	 public String designID {get; set;}
 	 public String salesAnalyst {get;set;}
     public String projectManager {get;set;}
     public String pvModuleType {get;set;}
     public String mountingSystemType {get;set;}
     public String AdditionalProductRequests {get;set;}
     public String designComments {get;set;}
     
     
 	 public Design__c relatedTo{
 	 	get {
 	 		if (designID != null && designID != '') {
 	 			relatedTo = [Select Site__r.name,Opportunity__c,Opportunity__r.name, Name, CreatedDate,CreatedBy.Name,Owner.Name From Design__c where Id = :designID ];
 	 			
 	 			 salesAnalyst = '';
 	 			List<OpportunityTeamMember> oppTeamMem = [Select id, User.Name, TeamMemberRole , OpportunityId from OpportunityTeamMember where OpportunityId = :relatedTo.Opportunity__c and TeamMemberRole in ('Sales Analyst') ];
 	 			 if (oppTeamMem.size() > 0) {
        
			        for (OpportunityTeamMember oppTeam :oppTeamMem  ) {      
			        		if(oppTeam.User.Name!=null){      
				                if (salesAnalyst != '')
				                    salesAnalyst += ', ' + oppTeam.User.Name ;
				                else
				                    salesAnalyst += oppTeam.User.Name ;
			        		}
			            
			        }// end for
       			}// End If

		        mountingSystemType= '';
		        pvModuleType = '';    
		        AdditionalProductRequests='';   
		        designComments='';			
       			List<PSR__c> psrData = new List<PSR__c>([Select p.PV_Module_Type__r.Name, p.Mounting_System__r.Name, p.Design__c,p.Design_Comments__c, p.Additional_Product_Requests__c From PSR__c p where p.Design__c = :designID]);
       			
       			if(psrData.size()>0){
       				pvModuleType = psrData.get(0).PV_Module_Type__r.Name;
       				mountingSystemType = psrData.get(0).Mounting_System__r.Name;
       				AdditionalProductRequests = psrData.get(0).Additional_Product_Requests__c;
       				designComments = psrData.get(0).Design_Comments__c;
       			}
       			/*
       			(Select Mounting_System__r.name, PV_Module_Type__r.name From PSR__r),
  			        mountingSystemType= '';
			        pvModuleType = '';
			        List<QuoteLineItem> lstQuoteLineItem = [Select Id,Product_Family__c,Product__r.Name,Product_Type__c, PricebookEntry.Product2.Name from QuoteLineItem where Quoteid = :quoteIDVal];
			            if (lstQuoteLineItem.size() > 0) {
			                
			                for( QuoteLineItem ql :lstQuoteLineItem ) {
			                    String prodFamily = ql.Product_Family__c;
			                    if (prodFamily.startsWith('Mounting Systems') &&  ql.PricebookEntry.Product2.Name != null)
			                      mountingSystem += ql.PricebookEntry.Product2.Name +', ';
			                    if (prodFamily.startsWith('PV Module') &&  ql.PricebookEntry.Product2.Name != null)
			                      pvModuleType += ql.PricebookEntry.Product2.Name +', ';
			                    
			                }
			            }
			            */
 	 		}//End If
 	 		 return relatedTo;
 	 	}//end Get
 	 	set;
 	 }                              
    
}