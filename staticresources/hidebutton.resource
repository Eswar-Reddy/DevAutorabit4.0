var j$ = jQuery.noConflict();
j$(document).ready(function(){
	j$('[name="call_customer"]').hide();
	j$('[name="change_owner"]').hide();
	j$('[name="decline_opportunity"]').hide();
	j$('[name="log_a_call"]').hide();
	var objectID = window.location.href.substring( window.location.href.indexOf('.com/') + 5, window.location.href.indexOf('.com/') + 23 );
	if(sforce.connection.getUserInfo().userType=="PowerPartner" && objectID.substring(0, 3)=="006"){
		j$('[name="new"]').hide();
		j$('[name="newOpp"]').hide();
	}
	if(objectID.substring(0, 3)=="a20"){
	   

	j$('*:contains("Dealer Origination Fee Participant")').each(function(){
     if(j$(this).children().length < 1) {
     //val = j$(this).parent().html();
		val = j$(this).parent().children(".dataCol").html();
		if(val =='False'){
			j$('[name="origination_invoice"]').hide();
		}
		 j$(this).parent().hide();
	   }
});

		
	}

	if(objectID.substring(0, 3)=="a07" && objectID.length>3){
		console.log('objectID ======> '+objectID.substring(0,15));
		var query = "select Quote__r.Opportunity.Account.Partner_Account__r.NH_SSE_Type__c from echosign_dev1__SIGN_Agreement__c where Id = '"+objectID.substring(0,15)+"'";
		//alert(query);
		var records = sforce.connection.query(query);
		//alert(records);
		var recordsList = records.getArray("records");
		//alert(recordsList.length);
		console.log('Create_TPS_PO__c =====> '+recordsList[0].Quote__r.Opportunity.Account.Partner_Account__r.NH_SSE_Type__c);
		if(recordsList[0].Quote__r.Opportunity.Account.Partner_Account__r.NH_SSE_Type__c.indexOf("TPS")>-1){
			j$('[name="adhoc_create_lda"]').hide();
		}
	}

	j$('.sidebarModule:last').hide();
;});
						
						
						

