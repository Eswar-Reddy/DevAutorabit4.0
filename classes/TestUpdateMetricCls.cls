/*********************************************************************
    Name  : TestUpdateMetricCls
    Date  : July 07,2011
    Description:This is a Test Class For Class "UpdateMetricCls".
*********************************************************************/

@isTest
private class TestUpdateMetricCls {

    static testMethod void updateMetricClsTest() {    
        ApexPages.currentPage().getParameters().put('type','incentive');
        ApexPages.currentPage().getParameters().put('batch','1');
        UpdateMetricCls UMCls = new UpdateMetricCls();
        UMCls.getNextURL();
        
        ApexPages.currentPage().getParameters().put('type','performance');
        UpdateMetricCls UMClsP = new UpdateMetricCls();
        UMClsP.getNextURL();
    }
    
}