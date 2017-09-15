public with sharing class CommunityReportDetail{
    public MAP<String,Reports.ReportFact>  fctmap= new MAP<String,Reports.ReportFact>();
    public String reportId;
    public String reportName{get;set;}
    public Reports.reportResults ReportResults;
    public Reports.ReportMetadata ReportMetaData ;
    public Integer recordCount{get;set;}
    public String accName;
    public List<Reports.ReportFilter> updatedFilters{get;set;}
    public List<string> reportCSV{get;set;}
    public String filename{get;set;}
    public String columnStr{get;set;}
    
            
    public CommunityReportDetail(){
        String repId = apexpages.currentpage().getparameters().get('id');
        reportName='';
        recordCount=0;
        reportCSV = new List<String>();
        columnStr='';
        filename = 'exportreport';
        system.debug(repId+'=====');
        List <Report> reportList = [SELECT Id,Name FROM Report where id = : repId];
        system.debug('==rep list=='+reportList);
        List<user> useracc= [select Account_Name__c from user where id= : UserInfo.getUserId() limit 1];
        system.debug('==='+useracc);
        if(useracc.size()>0 && useracc[0].Account_Name__c!=null && useracc[0].Account_Name__c!=''){
            accName = useracc[0].Account_Name__c;
        }else{
            accName='No Account Found';
        }
        
        if(reportList.size()>0){
            reportId = (String)reportList.get(0).get('Id');
            reportName = (String)reportList.get(0).get('Name');
            filename = reportName;
        }
    }
    
    public void runReport(){
        getReportMetaData();
        getReportResults();
        system.debug('===='+system.now());
    }
    public Reports.ReportMetadata getReportMetaData(){
        system.debug('==rep id=='+reportId);
        if(reportId!=null){
            system.debug('===meta===');
            try{
                Reports.ReportDescribeResult describe = Reports.ReportManager.describeReport(reportId);
                system.debug('===describe==='+describe);
                ReportMetaData = describe.getReportMetadata();
                system.debug('===rep meta=='+ReportMetaData);
                List<Reports.ReportFilter> filters = ReportMetaData.getReportFilters();
                system.debug('filter'+filters);
                if(filters.size()>0){
                    for(Integer i=0; i<filters.size(); i++){
                    //system.debug(filters[0].getColumn());
                        if(filters[i].getColumn() == 'PARTNER_ACCOUNT_NAME'){
                            filters[i].setValue(accName);
                        }
                    }
                   
                }
            }
            catch(Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            }
            system.debug('==matadata=='+ReportMetaData);
            
        }  
        return ReportMetaData;
    }

    public Reports.reportResults getReportResults(){

        if(reportId!=null){
              system.debug('===data==='); 
            try{  
                ReportResults = Reports.ReportManager.runReport(reportId,ReportMetaData, true);
                system.debug('=='+ReportResults);
        
                Reports.ReportExtendedMetadata rmd =   ReportResults.getReportExtendedMetadata();
    
                // Get detail columns from extended metadata
                Map<String,Reports.DetailColumn> colMap = rmd.getDetailColumnInfo();
                columnStr='';
                for(String key : colMap.KeySet()){
                    System.debug('Key=' + Key + ' label=' + colMap.get(key).getLabel());
                    columnStr +=colMap.get(key).getLabel()+',';
                }
                columnStr= columnStr.removeEnd(',');
        
                Reports.ReportFactWithDetails factDetails =(Reports.ReportFactWithDetails)ReportResults.getFactMap().get('T!T');
                recordCount = factDetails.getRows().size();  
                
                List<Reports.ReportDetailRow> detailRows =factDetails.getRows();
                system.debug('----details---'+detailRows);
                String DataStr;
                if(detailRows.size()>0){
                    for(Reports.ReportDetailRow detailRow: detailRows){
                        system.debug('==row =='+detailRow.getDataCells());
                        system.debug('==row size=='+detailRow.getDataCells().size());
                        dataStr = '';
                        for(Integer i=0;i<detailRow.getDataCells().size();i++){
                            dataStr +=detailRow.getDataCells()[i].getLabel().replace(',','')+',';
                            //system.debug('----'+detailRow.getDataCells()[i].getLabel());
                        }
                        dataStr= dataStr.removeEnd(',');
                        reportCSV.add(dataStr);
                        system.debug('============================================');
                    }
                }
            }
            catch(Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            }
        }  
        return ReportResults;
    }
    
     public Pagereference exportCSV(){
        return new Pagereference('/apex/ExportCSVReport');
     }
}