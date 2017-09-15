public class CHome_ReportController {

    public string rid {get;set;}
    public string rcid {get;set;}
    
    public CHome_ReportController(){
        rid= ApexPages.currentPage().getParameters().get('rid');
        rcid= ApexPages.currentPage().getParameters().get('rcid');
    }

}