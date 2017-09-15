var $j = jQuery.noConflict();

function load()
{
	setupBlocking();
	bindGoogleAnalyticsEvents();
	$j("[id$='submittedDocuments']").tablesorter();
}

function bindGoogleAnalyticsEvents() {
    var attachGAEventToSelector = function(selector, category, action) {
            $j(selector).click(function() {
                    _gaq.push(['_trackEvent', category, action, userId]);
            });
    };

    attachGAEventToSelector('#submit-table-controlls', 'Page Click', 'Submit Table Controls');
    attachGAEventToSelector('#submit-btn', 'Page Click', 'Submit');
    attachGAEventToSelector('.delete-button', 'Page Click', 'Delete');
    attachGAEventToSelector('.file-input', 'Page Click', 'File Input');
}

function setupBlocking() {
	$j( "[id$='submit-btn']").live( "click", function() {
		var allEmpty = true;
		$j('.file-input').each( function() {
			var $this = $j(this);
			if($this.val() !== "") {
				allEmpty = false;
				//return false to break out of each
				return false;
			}
		});
		if(!allEmpty){
			$j.blockUI();
		}
	});
}

$j( load );
