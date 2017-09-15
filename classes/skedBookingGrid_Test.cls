@isTest
public class skedBookingGrid_Test {

    static testmethod void SiteSurveyTest() {
        Date startDate = system.today().toStartOfWeek();
        DateTime todayDt = DateTime.newInstance(system.today(), time.newInstance(0, 0, 0, 0));
        Date endDate = startDate.addDays(14);
        
        Map<string, sObject> mapTestData = skedDataSetup.setupCommonTestData(skedConstants.JOB_TYPE_SITE_SURVEY);
        Residential_Project__c testProject = (Residential_Project__c)mapTestData.get('testProject');
        
        Test.startTest();
        skedBookingGrid_MockTest mockClass = new skedBookingGrid_MockTest();
        mockClass.scripts = new List<string>();
        mockClass.scripts.add('getGeocode');
        mockClass.scripts.add('calculateMultiDistances');
        Test.setMock(HttpCalloutMock.class, mockClass);
        
        System.currentPageReference().getParameters().put('id', testProject.Id);
        skedSiteSurveyJobController siteSurveyCon = new skedSiteSurveyJobController(new ApexPages.StandardController(testProject));
        
        System.currentPageReference().getParameters().put('selectedDate', Json.serialize(system.today()));
        siteSurveyCon.Cmd_LoadBookingGrid();
        
        siteSurveyCon.Wrapper.selectedDateTime = Json.serialize(todayDt.addDays(1).addHours(9));
        siteSurveyCon.Cmd_SaveJob();
        
        Test.stopTest();
    }
    
    static testmethod void InstallationTest() {
        Date startDate = system.today().toStartOfWeek();
        DateTime todayDt = DateTime.newInstance(system.today(), time.newInstance(0, 0, 0, 0));
        Date nextWeekStartDate = startDate.addDays(7);
        DateTime nextWeekStart = DateTime.newInstance(nextWeekStartDate, time.newInstance(0, 0, 0, 0));
        Date endDate = startDate.addDays(14);
        
        Map<string, sObject> mapTestData = skedDataSetup.setupCommonTestData(skedConstants.JOB_TYPE_INSTALLATION);
        Residential_Project__c testProject = (Residential_Project__c)mapTestData.get('testProject');

        Test.startTest();
                
        skedBookingGrid_MockTest mockClass = new skedBookingGrid_MockTest();
        mockClass.scripts = new List<string>();
        mockClass.scripts.add('getGeocode');
        mockClass.scripts.add('calculateMultiDistances');
        Test.setMock(HttpCalloutMock.class, mockClass);
        
        System.currentPageReference().getParameters().put('id', testProject.Id);
        
        skedInstallationJobController installationCon = new skedInstallationJobController(new ApexPages.StandardController(testProject));
        installationCon.Wrapper.Duration = 3;
        
        System.currentPageReference().getParameters().put('selectedDate', Json.serialize(system.today()));
        installationCon.Cmd_LoadBookingGrid();
        
        installationCon.Wrapper.selectedDateTime = Json.serialize(nextWeekStart.addDays(1).addHours(9));
        installationCon.Cmd_SaveJob();
        
        Test.stopTest();
    }
    
    static testmethod void InspectionTest() {
        Date startDate = system.today().toStartOfWeek();
        DateTime todayDt = DateTime.newInstance(system.today(), time.newInstance(0, 0, 0, 0));
        Date endDate = startDate.addDays(14);
        
        Map<string, sObject> mapTestData = skedDataSetup.setupCommonTestData(skedConstants.JOB_TYPE_INSPECTION);
        Residential_Project__c testProject = (Residential_Project__c)mapTestData.get('testProject');
        
        Test.startTest();
        skedBookingGrid_MockTest mockClass = new skedBookingGrid_MockTest();
        mockClass.scripts = new List<string>();
        mockClass.scripts.add('getGeocode');
        mockClass.scripts.add('calculateMultiDistances');
        Test.setMock(HttpCalloutMock.class, mockClass);
        
        System.currentPageReference().getParameters().put('id', testProject.Id);
        
        skedInspectionJobController inspectionCon = new skedInspectionJobController(new ApexPages.StandardController(testProject));
        inspectionCon.Wrapper.selectedDateTime = Json.serialize(todayDt.addDays(3).addHours(9));
        inspectionCon.Cmd_SaveJob();
        
        Test.stopTest();
    }
    
    static testmethod void ReschedulingTest() {
        Date startDate = system.today().toStartOfWeek();
        DateTime todayDt = DateTime.newInstance(system.today(), time.newInstance(0, 0, 0, 0));
        Date endDate = startDate.addDays(14);
        
        Map<string, sObject> mapTestData = skedDataSetup.setupCommonTestData(skedConstants.JOB_TYPE_SITE_SURVEY);
        Residential_Project__c testProject = (Residential_Project__c)mapTestData.get('testProject');
        Account testAccount = (Account)mapTestData.get('testAccount');
        sked__Resource__c siteSurveyor1 = (sked__Resource__c)mapTestData.get('siteSurveyor1');
        sked__Region__c anaheimRegion = (sked__Region__c)mapTestData.get('anaheimRegion');
        
        sked__Job__c siteSurveyJob = new sked__Job__c(
            Residential_Project__c = testProject.Id,
            sked__Region__c = anaheimRegion.Id,
            sked__Account__c = testAccount.Id,
            sked__Address__c = '77 Rio Robles, San Jose, CA 95134, USA',
            sked__GeoLocation__Latitude__s = 37.4050308,
            sked__GeoLocation__Longitude__s = -121.9466052,
            sked__Type__c = skedConstants.JOB_TYPE_SITE_SURVEY,
            sked__Start__c = todayDt.addDays(1).addHours(9),
            sked__Finish__c = todayDt.addDays(1).addHours(11),
            sked__Duration__c = 120,
            sked__Job_Status__c = skedConstants.JOB_STATUS_PENDING_DISPATCH
        );
        insert siteSurveyJob;
        
        sked__Job_Allocation__c jobAlloc = new sked__Job_Allocation__c(
        	sked__Job__c = siteSurveyJob.Id,
            sked__Resource__c = siteSurveyor1.Id,
            sked__Status__c = skedConstants.JOB_ALLOCATION_STATUS_DISPATCHED
        );
        insert jobAlloc;
        
        Test.startTest();
        
        skedBookingGrid_MockTest mockClass = new skedBookingGrid_MockTest();
        mockClass.scripts = new List<string>();
        mockClass.scripts.add('getGeocode');
        mockClass.scripts.add('calculateMultiDistances');
        Test.setMock(HttpCalloutMock.class, mockClass);
        
        testProject.Scheduled_Site_Survey_Date__c = todayDt.addDays(1).addHours(9);
        update testProject;
        
        siteSurveyJob.sked__Job_Status__c = skedConstants.JOB_STATUS_DISPATCHED;
        update siteSurveyJob;
        
        System.currentPageReference().getParameters().put('id', testProject.Id);
        System.currentPageReference().getParameters().put('jobId', siteSurveyJob.Id);
        
        skedBookingNavigationController navigationCon = new skedBookingNavigationController(new ApexPages.StandardController(testProject));
        navigationCon.Cmd_Navigation();
        
        skedSiteSurveyJobController siteSurveyCon = new skedSiteSurveyJobController(new ApexPages.StandardController(testProject));
        siteSurveyCon.Wrapper.selectedDateTime = Json.serialize(todayDt.addDays(2).addHours(9));
        siteSurveyCon.Cmd_SaveJob();
        
        Test.stopTest();
    }
    
    static testmethod void JobCompletionTest() {
        Date startDate = system.today().toStartOfWeek();
        DateTime todayDt = DateTime.newInstance(system.today(), time.newInstance(0, 0, 0, 0));
        Date endDate = startDate.addDays(14);
        
        Map<string, sObject> mapTestData = skedDataSetup.setupCommonTestData(skedConstants.JOB_TYPE_SITE_SURVEY);
        Residential_Project__c testProject = (Residential_Project__c)mapTestData.get('testProject');
        Account testAccount = (Account)mapTestData.get('testAccount');
        sked__Resource__c siteSurveyor1 = (sked__Resource__c)mapTestData.get('siteSurveyor1');
        sked__Region__c anaheimRegion = (sked__Region__c)mapTestData.get('anaheimRegion');
        
        sked__Job__c siteSurveyJob = new sked__Job__c(
            Residential_Project__c = testProject.Id,
            sked__Region__c = anaheimRegion.Id,
            sked__Account__c = testAccount.Id,
            sked__Address__c = '77 Rio Robles, San Jose, CA 95134, USA',
            sked__GeoLocation__Latitude__s = 37.4050308,
            sked__GeoLocation__Longitude__s = -121.9466052,
            sked__Type__c = skedConstants.JOB_TYPE_SITE_SURVEY,
            sked__Start__c = todayDt.addDays(1).addHours(9),
            sked__Finish__c = todayDt.addDays(1).addHours(11),
            sked__Duration__c = 120,
            sked__Job_Status__c = skedConstants.JOB_STATUS_PENDING_DISPATCH
        );
        insert siteSurveyJob;
        
        sked__Job_Allocation__c jobAlloc = new sked__Job_Allocation__c(
        	sked__Job__c = siteSurveyJob.Id,
            sked__Resource__c = siteSurveyor1.Id,
            sked__Status__c = skedConstants.JOB_ALLOCATION_STATUS_DISPATCHED
        );
        insert jobAlloc;
        
        Test.startTest();
        
        testProject.Scheduled_Site_Survey_Date__c = todayDt.addDays(1).addHours(9);
        update testProject;
        
        siteSurveyJob.sked__Job_Status__c = skedConstants.JOB_STATUS_DISPATCHED;
        update siteSurveyJob;
                
        siteSurveyJob.sked__Job_Status__c = skedConstants.JOB_STATUS_COMPLETE;
        update siteSurveyJob;
        
        Test.stopTest();
    }

    //Below test is for code coverate of skedModels
    static testmethod void TestSkedModels(){
        skedModels.allocation a = new skedModels.allocation();
        a.travelTimeFrom = 1;
        skedModels.allocation a2 = new skedModels.allocation();
        a2.travelTimeFrom = 2;
        
        list<skedModels.allocation> aList = new list<skedModels.allocation>{a, a2};
        aList.sort();

        skedModels.geometry geometry = new skedModels.geometry(new Location());
        geometry.distance = 1;
        skedModels.geometry geometry2 = new skedModels.geometry(new Location());
        geometry2.distance = 2;
        
        list<skedModels.geometry> gList = new list<skedModels.geometry>{geometry, geometry2};
        gList.sort();
    }
}