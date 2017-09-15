function UserRedirect() {
    var links = document.getElementsByTagName("A");
    var tempURL = '';
    for(var i=0; i < links.length; i++) {
        tempURL='';
        tempURL=links[i].href.substring(links[i].href.lastIndexOf('/') + 1, links[i].href.length);
        //console.log('==='+links[i].href.substring(links[i].href.lastIndexOf('/') + 1, links[i].href.length).slice(0,3));
        if(tempURL.slice(0,3) == '005'){
            links[i].href = 'apex/applycustomheader?sURL=/'+tempURL;
        }

		if(links[i].innerHTML=='[Change]'){
            var splitChangeLinks = links[i].href.split('?');
            links[i].href = splitChangeLinks[0]+'?isdtp=mn&'+splitChangeLinks[1];
        }

		if(links[i].innerHTML=='[View Hierarchy]'){
			var HierarchyLink = links[i].href.toString();
			if(HierarchyLink.indexOf('/acc/account_hierarchy')!=-1){
					links[i].href = HierarchyLink.replace('/acc/account_hierarchy','/apex/applycustomheader?sURL=/acc/account_hierarchy');
			}
		}

        //if(links[i].innerHTML.indexOf('Go to list') !== -1) {
            //links[i].href = 'apex/applycustomheader?removeNav=true&eURL=/'+tempURL;
            //links[i].href = 'apex/applycustomheader?removeDoubleHeader=true&eURL=/'+tempURL;
        //}
    }
}

function removeISDTP() {
    var tURL= window.top.location;
    var tURLStr = tURL.toString();
    if((tURLStr.indexOf('&isdtp=mn')!=-1) || (tURLStr.indexOf('&isdtp=mn')!=-1) ){
        finalURLStr = tURLStr.replace('&isdtp=mn','');
        window.top.location.href=finalURLStr;
    }
}


