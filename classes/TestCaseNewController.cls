/*******************************************
**Created by - Kapil Goutam
**Created On - June 05 2009
**Last Modified On- 
**Last Modifiled by- 
**Description- Test Class for CaseNewController
********************************************/
public class TestCaseNewController {
    @isTest
    public static void Test_CaseNewController(){
        Case newCase = new Case();
        insert newCase;
        
        Test.startTest();
        Apexpages.Standardcontroller controller = new ApexPages.Standardcontroller(newCase);
        CaseNewController caseController = new CaseNewController(controller);
        
        Map<String, Schema.RecordTypeInfo> nameToCaseRecordTypeInfoMap = Schema.SObjectType.Case.getRecordTypeInfosByName();
        
        String url = caseController.getRedirectUrl();
        System.assertEquals(url, '/500/e?retURL=%2F500%2Fo&RecordType=null&cancelURL=%2F500%2Fo&ent=Case&nooverride=1');
        
        caseController = new CaseNewController(controller);
        Apexpages.currentPage().getParameters().put('RecordType',nameToCaseRecordTypeInfoMap.get('CRM Case').getRecordTypeId());
        url = caseController.getRedirectUrl();
        System.assertEquals(url, '/500/e?retURL=%2F500%2Fo&RecordType='+nameToCaseRecordTypeInfoMap.get('CRM Case').getRecordTypeId()+'&cancelURL=%2F500%2Fo&ent=Case&nooverride=1');
        
        caseController = new CaseNewController(controller);
        String recordTypeId = nameToCaseRecordTypeInfoMap.get('System Design Case').getRecordTypeId();
        recordTypeId = recordTypeId.subString(0,15);
        Apexpages.currentPage().getParameters().put('RecordType',recordTypeId);
        try{
        	url = caseController.getRedirectUrl();
        	//System.assertEquals(url, '/apex/InspectionReport?RecordType='+recordTypeId);
        }catch(Exception e){
        	
        }
        Test.stopTest();
    }   

}