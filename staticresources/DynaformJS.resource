/*
	The MIT License (MIT)

	Copyright (c) 2013 Bluewolf, Inc.

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	THE SOFTWARE.

*/
// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/indexOf#Compatibility
if (!Array.prototype.indexOf) {
  Array.prototype.indexOf = function (searchElement, fromIndex) {
    var i,
        pivot = (fromIndex) ? fromIndex : 0,
        length;

    if (!this) {
      throw new TypeError();
    }

    length = this.length;

    if (length === 0 || pivot >= length) {
      return -1;
    }

    if (pivot < 0) {
      pivot = length - Math.abs(pivot);
    }

    for (i = pivot; i < length; i++) {
      if (this[i] === searchElement) {
        return i;
      }
    }
    return -1;
  };
}

jQuery(function(){

	var __BASE_URL = 'https://sunpower.force.com/DynaForm/',
		__SERVICE_URL = __BASE_URL + 'services/apexrest/';

	function salesforceValidation($form, dotsResult)
	{
		var qualRules = $form.data('qualificationRules'),
			qualified = true,
			autoOpen = false,
			disqualReason = '';
		var advancelogic = qualRules.AdvanceLogic;
		var rulefieldNames = '';
		
		console.log('advancelogic ==============>'+advancelogic);
		
		// Updating AND , OR string with logical Operators
		advancelogic = updateAdavanceLogic(advancelogic); 
		
		console.log('advancelogic ==============>'+advancelogic);
		
		//for(var fieldIndex=0; fieldIndex<qualRules.fields.length && qualified; fieldIndex++){
		for(var fieldIndex=0; fieldIndex<qualRules.fields.length; fieldIndex++)
		{
			var RuleIndex = fieldIndex + 1;
			var fieldAndValues = qualRules.fields[fieldIndex],
				$formField = $form.find('[name="'+fieldAndValues.name+'"]');
			
			console.log('========Salesforce Field value ========='+fieldAndValues.name);
			console.log('======== Web form field value   ========='+$formField.val());
			
			if($formField.size() > 0)
			{
				console.log('=======================================================================');
				//@TODO: case sensitive comparisons. is that acceptable behavior?
				var fieldIsOpen = fieldAndValues.AUTOOPEN_VALUES.indexOf($formField.val()) > -1;
				console.log('1. Name of Field  ==========>'+fieldAndValues.name);
				console.log('2. Value of Field ==============>'+$formField.val());
				console.log('3. is Field is Open ==============>'+$formField.val());
				console.log('4. acceptedValues Open 1 ==============>'+fieldAndValues.acceptedValues);
				
				//qualified = qualified && (fieldAndValues.acceptedValues.indexOf($formField.val()) > -1 || fieldIsOpen);
				qualified = (fieldAndValues.acceptedValues.indexOf($formField.val()) > -1 || fieldIsOpen);
				autoOpen = autoOpen || fieldIsOpen;
				console.log('qualified ==============>'+qualified+'===Actually Calculated ==============>'+(fieldAndValues.acceptedValues.indexOf($formField.val()) > -1));
				
				console.log('=== &&&&&&&&&&&&&& &&&&&&&&&&&&&====>'+(rulefieldNames.indexOf(fieldAndValues.name) > -1)+'=== fieldAndValues.name =='+fieldAndValues.name);
				
				// disqualReason Reason should only updated first time
				if(!qualified && disqualReason == '' && !(rulefieldNames.indexOf(fieldAndValues.name) > -1)){
					disqualReason = fieldAndValues.disqualifiedReason;
					console.log(' ******** Disqualified Reason *********'+fieldAndValues.disqualifiedReason);
				}
				
				if(qualified)
				{
					// Checking if field is qualified then it should not again go for disqualifiedReason
					rulefieldNames = rulefieldNames +','+fieldAndValues.name;
				}
			}
			
			// Update rule number with logic
			advancelogic = updateRulewithResult(RuleIndex.toString(),qualified.toString(),advancelogic);
		}
		
		console.log(' After My parsing the result ===>'+advancelogic);
		// Updating the qualified value
		qualified = eval(advancelogic);
		
		console.log('********* After qualified **********'+qualified);
		
		if(qualified && dotsResult === 'Review') {
			jQuery('[name="disqualifiedReason"]').val(null);
		} else if(!qualified || dotsResult !== 'Accept') 
		{
			if(dotsResult === 'Reject') {
				jQuery('[name="disqualifiedReason"]').val('Spam');
			} else {
				jQuery('[name="disqualifiedReason"]').val(disqualReason);
			}
		}
		if(!qualified)
		{
    		jQuery('[name="DataQuality"]').val('Disqualified');
		} else if(autoOpen) 
		{
    		jQuery('[name="DataQuality"]').val('Undetermined');
    		if(dotsResult !== 'Reject'){
                jQuery('[name="disqualifiedReason"]').val(null);
            }
		} else 
		{
		    console.log('############################# Yes I am Qualified ###############');
    		jQuery('[name="DataQuality"]').val('Qualified');
		}
		$form.data('submitted', true).submit();
	}
	
	/*
		Method By : Niket Chandane
		Summary   : Method accepts the advance rule and 
					rule result and return updated advance rule string
	*/
	function updateRulewithResult(ruleNumber,ruleResult,ruleExpression){
		if(ruleExpression.indexOf(ruleNumber) > -1)
		  return ruleExpression.split(ruleNumber).join(ruleResult);
		else return ruleExpression; 
	}
	
	// Method get replace updates the logical operator
	function updateAdavanceLogic(rawAdvanceLogic)
	{
		if(rawAdvanceLogic)
		{
			 
			if(rawAdvanceLogic.indexOf("AND") > -1)
				rawAdvanceLogic = rawAdvanceLogic.split('AND').join('&&');
			else if(rawAdvanceLogic.indexOf("and") > -1)
				rawAdvanceLogic = rawAdvanceLogic.split('and').join('&&');
			if(rawAdvanceLogic.indexOf("OR") > -1)
				rawAdvanceLogic = rawAdvanceLogic.split('OR').join('||');
			else if(rawAdvanceLogic.indexOf("or") > -1)
				rawAdvanceLogic = rawAdvanceLogic.split('or').join('||');
			
			return rawAdvanceLogic;
		}else return rawAdvanceLogic;
	}
	
	function toggleSubmit($form){
		$form.find('input[type="submit"]').toggle();
		$form.find('div.dynaform-spinner').toggle();
	}

	jQuery('form[data-dynaform-id]').each(function(){
		var $this = jQuery(this);
		$this.find('input[type="submit"]').after(jQuery('<div/>').addClass('dynaform-spinner').css({
			'background':'url('+__BASE_URL+'resource/DynaformSpinner'+')',
			'display':'none',
			'height':'29px',
			'width':'29px'
		}));
		/*
		jQuery.ajax({
			url : __SERVICE_URL + 'DynaForm',
			dataType : 'jsonp',
			crossDomain : true,
			data : {
				formId : $this.attr('data-dynaform-id')
			},
			error : function(request, message){
				alert(message);
			},
			success : function(response, status){
				$this.data('qualificationRules', response);
			}
		});*/
		$this.data('qualificationRules', null);
	})
	.submit(function(event){
		if( typeof jQuery(this).data('submitted') === 'undefined'
			&& typeof jQuery(this).data('qualificationRules') !== 'undefined'
            && ( !jQuery(this).valid || jQuery(this).valid() ) )
		{
			toggleSubmit(jQuery(this));
			event.preventDefault();
			var $this = jQuery(this);
			
			jQuery.ajax({
				url : __SERVICE_URL + 'DynaForm',
				dataType : 'jsonp',
				crossDomain : true,
				data : {
					formId : $this.attr('data-dynaform-id'),
					street : $this.find('input[name="StreetAddress"]').val(),
					city   : $this.find('input[name="City"]').val(),
					state  : $this.find('select[name="State"]').val(),
					zip	   : $this.find('input[name="Zip"]').val(),
					country: $this.find('select[name="Country"]').val()
				},
				error : function(request, message){
					alert(message);
				},
				success : function(response, status){
					$this.data('qualificationRules', response);
					var qualRules = $this.data('qualificationRules');
					var dealersFound = qualRules.DealersFound;
					var optedoutdealersFound = qualRules.OptedOutDealersFound;
					$this.find('input[name="DealerFound"]').val(dealersFound);
					$this.find('input[name="OptedOutDealerFound"]').val(optedoutdealersFound);
					salesforceValidation($this, 'Accept');
				}
			});
			
			
		}
	});
});