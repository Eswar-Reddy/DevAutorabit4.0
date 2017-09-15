public class ApplyCustomHeaderController {

    public String extURL { get; set; }
    public String extURLvw { get; set; }
    public String activeTab {get;set;}

    Public ApplyCustomHeaderController (){
        extURL ='';
        extURLvw = '';
        extURL = ApexPages.currentPage().getParameters().get('eURL');

        extURLvw = ApexPages.currentPage().getParameters().get('sURL');
        if(extURL!= null)
            if(extURL.contains('?')){
            extURL = extURL +'&isdtp=lt';
            }else{
            extURL = extURL +'?isdtp=lt';
            }


        if(extURLvw!= null)
            if(extURLvw.contains('?')){
        extURLvw = extURLvw +'&isdtp=vw';
        }else{
            extURLvw = extURLvw +'?isdtp=vw';
        }

        activeTab = 'Home';
        if(ApexPages.currentPage().getParameters().get('activeTab') != null)
            activeTab = ApexPages.currentPage().getParameters().get('activeTab');
    }

}