public class WorkOrderEditExtension {
    private final WorkOrder wo;
    ApexPages.StandardController stdController;
    
    public WorkOrderEditExtension(ApexPages.StandardController stdController) {
        this.wo = (WorkOrder)stdController.getRecord();
        this.stdController = stdController;
    }
    
    public PageReference redirectPage() {
        PageReference retPr = stdController.edit();

        Map <String, String> paramMap = ApexPages.currentPage().getParameters();
        for (String param : paramMap.keySet()) {
            if (param == 'retURL') {
                retPr.getParameters().put(param, paramMap.get(param));
            }
        }
        retPr.getParameters().put('nooverride','1');

        return retPr;    
    }

}