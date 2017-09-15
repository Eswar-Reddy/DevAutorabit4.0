@isTest
private class AppirioMetrics_Test {

  public static testMethod void testAppirioMetricInnerClass() {

    AppirioMetrics.Metric am = new AppirioMetrics.Metric();
    am.name = 'testName';
    System.assertEquals('testName', am.name, 'AppirioMetrics must have public name property');
    System.assertEquals(0, am.getLengthWithoutComments(), 'Base class must have virtual implementation returning 0.');

    ApexClass ac = new ApexClass();
    AppirioMetrics.ClassMetric cm = new AppirioMetrics.ClassMetric(ac);
    System.assertEquals(ac, cm.aClass, 'ClassMetric should wrapp ApexClass SObject with which it is instantiated.');

    ApexTrigger at = new ApexTrigger();
    AppirioMetrics.TriggerMetric tm = new AppirioMetrics.TriggerMetric(at);
    System.assertEquals(at, tm.aTrigger, 'TriggerMetric should wrapp ApexTrigger SObject with which it is instantiated.');

    //AppirioMetrics.ObjectMetric om = new AppirioMetrics.ObjectMetric();
    System.assert(true);
  }
 
  public static testMethod void testSharedMetricFields() {

    ApexClass c1 = new ApexClass(name = 'shared fields');
    c1.body = '';
    AppirioMetrics.ClassMetric cm1 = new AppirioMetrics.ClassMetric(c1);
    System.assertEquals(null, cm1.sfid, 'Cannot insert an ApexClass from Apex, so c1\'s id must be null.');
    System.assertEquals('shared fields', cm1.name, 'Name property should have been set.');
    System.assertEquals(Datetime.now().format('yyyy-MM-dd'), cm1.createdStr, 'Date should default to today and be in proper format.');
    System.assertEquals(Datetime.now().format('yyyy-MM-dd'), cm1.modifiedStr, 'Date should default to today and be in proper format.');     
  }

  
  public static testMethod void testEmptyClassBody() {
    
    ApexClass c1 = new ApexClass(name = 'empty', body = '');
    AppirioMetrics.ClassMetric cm = new AppirioMetrics.ClassMetric(c1);
    System.assertEquals(0, cm.lineCnt, 'An empty body should have zero ines of code.');
  }


  private static testMethod void testClasslineCnt() {

    // It's easy to forget that Apex assignment to SObject properties strips leading and trailing
    // whitespace -- the confusion this has cause is memorialized in this test case. 
    ApexClass c1 = new ApexClass(name = 'lineCnt-and-whitespace');
    c1.body = '\n\n\t\n \n  \n  ';
    AppirioMetrics.ClassMetric cm1 = new AppirioMetrics.ClassMetric(c1);
    System.assertEquals(0, cm1.lineCnt, 'c1 has no lines of code, since Apex strips leading and training whitespace on assignment');
    System.assertEquals(0, cm1.charCnt, 'c1 has no characters, since Apex strips these all characters.');

    ApexClass c2 = new ApexClass(name = 'lineCnt');
    c2.body = 'x\n\n\t\n \nx\n';
    AppirioMetrics.ClassMetric cm2 = new AppirioMetrics.ClassMetric(c2);
    System.assertEquals(5, cm2.lineCnt, 'c2 has 5 \\n characters -- even though Apex strips the trailing \\n, the code must still have 5 lines of code.');
    System.assertEquals(8, cm2.charCnt, 'C2 has 8 total characters.  Last newline is stripped by Apex.');
    System.assertEquals(3, cm2.blankCnt, 'C2 has 3 blank lines.  Last newline is stripped by Apex.');
    
    ApexClass c3 = new ApexClass(name = 'lineCnt-with-no-trailing-newline');
    c3.body = 'xxx\nyyy';
    AppirioMetrics.ClassMetric cm3 = new AppirioMetrics.ClassMetric(c3);
    System.assertEquals(2, cm3.lineCnt, 'c3 has only one \\n character but must have 2 lines of code.');   
  }
  
  
  private static testMethod void testClassScanForTestInfo() {
    
    ApexClass c1 = new ApexClass(name = 'assert-counts');
    c1.body = '   System.assertTrue(true);\n\n' +
              '   System.debug(\'asserted something.\')\n\n' +
              '   // System.assertEquals(0,0,\'works.\')';
    AppirioMetrics.ClassMetric cm1 = new AppirioMetrics.ClassMetric(c1);
    System.assertEquals(2, cm1.assertCnt, 'c1 has two assertions.  The commented assertion still counts...but maybe shouldn\'t.');
    
    ApexClass c2 = new ApexClass(name = 'assert-counts');
    c2.body = '   private static testmethod void testing() {\n\n' +
              '   STATic TestMETHOD \n\n' +
              '   private\nstatic\testmethod';
    AppirioMetrics.ClassMetric cm2 = new AppirioMetrics.ClassMetric(c2);
    System.assertEquals(2, cm2.testCnt, 'c2 has two testmethod.  Order of keywords does not matter, but they must be on same line.');    
  }


  private static testMethod void testWebserviceAndCalloutCounts() {

    ApexClass c1 = new ApexClass(name = 'web-service-counts');
    c1.body = '   global static web' + 'service example()\n\n' +
              '   web' + 'service integer\nweb' + 'service string\n' +
              '   WebServiceCallout.' + 'invoke(...) ' +
              '   Http' + 'Response resp = .... ' +
              '   //generated ' +  'by wsdl2apex ';
    AppirioMetrics.ClassMetric cm1 = new AppirioMetrics.ClassMetric(c1);
    System.assertEquals(1, cm1.webserviceCnt, 'c1 has one static webservice method declaration.');
    System.assertEquals(2, cm1.externalCnt, 'c1 has two externals marked by keyword \'webservice \'.');
    System.assertEquals(1, cm1.calloutCnt, 'c1 has exactly one webservice callout.');
    System.assertEquals(1, cm1.calloutCnt, 'c1 has exactly one HttpReponse object (implies HTTP callout).');
    System.assertEquals(true, cm1.generated, 'c1 contains the phrase \'//generated by wsdl2apex\'.');
  }


  private static testMethod void testFutureCount() {

    ApexClass c1 = new ApexClass(name = 'assert-counts');
    c1.body = '   @' + 'future public static example() { ...';
    AppirioMetrics.ClassMetric cm1 = new AppirioMetrics.ClassMetric(c1);
    System.assertEquals(1, cm1.futureCnt, 'c1 has one metho with future annotation.');
  }


  private static testMethod void testDensityMetrics() {

    ApexClass c1 = new ApexClass(name = 'line-density-1');
    c1.body = '';
    AppirioMetrics.ClassMetric cm1 = new AppirioMetrics.ClassMetric(c1);
    System.assertEquals(0.0, cm1.getLineDensity(), 'c1 has no lines, so density should 0.');
    System.assertEquals(0.0, cm1.getCodeDensity(), 'c1 has no characters, so density should 0.');

    ApexTrigger t1 = new ApexTrigger(name = 'line-density-2');
    t1.body = '123456789\n\n\t\t\n// comment';
    AppirioMetrics.TriggerMetric tm1 = new AppirioMetrics.TriggerMetric(t1);
    System.assertEquals(4, tm1.lineCnt, 't1 has 4 lines total.');
    System.assertEquals(2, tm1.blankCnt, 't1 has 2 blank lines total.');
    System.assertEquals(0.50, tm1.getLineDensity(), 't1 has 2 nonblank lines and 4 total lines for line density 0.50');
    
    ApexTrigger t2 = new ApexTrigger(name = 'char-density-3');
    t2.body = '123456789\n//34567890';
    t2.lengthWithoutComments = 10;
    System.assertEquals(10, t2.lengthWithoutComments, 't2 should have lengthWithoutComments of 10.');  
    AppirioMetrics.TriggerMetric tm2 = new AppirioMetrics.TriggerMetric(t2);
    System.assertEquals(tm2.aTrigger, t2, 'TriggerMetric should wrap testdata just created');   
    System.assertEquals(tm2.charCnt, 20, 'TriggerMetric should have scanned 20 chars');  
    System.assertEquals(10, tm2.getLengthWithoutComments(), 'answer should still be 10.');   
    System.assertEquals(0.50, tm2.getCodeDensity(), 't2 has 10 non-comment characters of 20 total characters for a code density of 0.50');
  }


  private static testMethod void testRunningDefaultConstrutor() {
    AppirioMetrics am = new AppirioMetrics();
    System.assert(am != null);
  }


  // Prevent Schema inquiry.
  private class TestFuncs extends AppirioMetrics.PluggableFuncs {

    public String strListOfIds = '(null)';

    override public List<String> getStandardObjectList(Map<String, Schema.SObjectType> name2token) {
      List<String> ans = new List<String>();
      return ans;
    }

    override public virtual List<String> getCustomObjectList(Map<String, Schema.SObjectType> name2token) {
      List<String> ans = new List<String>();
      return ans;
    }
    
    override public virtual string getAppirioMetricsQryStr(String jobId) {
      String ans =
        'select id,version__c,org_name__c,job_number__c,job_datetime__c,org_id__c,metric_type__c, ' +
          'salesforce_id__c,name,modified_by__c,object_created__c,object_modified__c,line_count__c, ' +
          'line_density__c,character_count__c,code_density__c,tab_count__c,test_count__c, ' +
          'assert_count__c,webservice_count__c,external_count__c,callout_count__c,http_response_count__c, ' +
          'generated__c,future_count__c,object_name__c,field_count__c,relation_count__c, ' +
          'record_type_count__c ' +
        'from aclm_Appirio_Metric__c where id in ' + strListOfIds;
SYSTEM.debug('\n\nJOE>>> query = ' + ans);
      return ans;
    }

  }


  private static testMethod void testEmptyBatchableProtocol() {

    // Apex cannot insert ApexClass and ApexTrigger objects, so we run queries
    // that don't actually return any SObjects in order cover the query code in testing.
    // The class is then used to test iteratng over the empty set.
    TestFuncs funcs = new TestFuncs();

    String classQueryStr = 'select id, name, lengthWithoutComments, body, CreatedDate, LastModifiedDate ' +
                           'from apexClass where id = null';

    String triggerQueryStr = 'select id, name, TableEnumOrId, lengthWithoutComments, body, CreatedDate, LastModifiedDate ' +
                             'from apexTrigger where id = null';

    //String jobQueryStr = 'select id, status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email ' +
    //                     'from AsyncApexJob where id = :context.getJobId()';
    
    funcs.setTestQueries(classQueryStr,triggerQueryStr);
    
    AppirioMetrics am = new AppirioMetrics(funcs);

    Database.QueryLocator queryLocator = am.start(null);
    
    List<SObject> listOfSObjs = new List<aclm_Appirio_Metric__c>();
    am.execute(null, listOfSObjs);
    
    am.finish(null);
    
  }


  // Tests NPE conditions
  private static testMethod void testSimpleScan() {

    TestFuncs funcs = new TestFuncs();

    AppirioMetrics am = new AppirioMetrics(funcs);
    
    aclm_Appirio_Metric__c aClassMetric = new aclm_Appirio_Metric__c();
    aClassMetric.metric_type__c = 'ClassMetric';
    
    aclm_Appirio_Metric__c aTriggerMetric = new aclm_Appirio_Metric__c();
    aTriggerMetric.metric_type__c = 'TriggerMetric';
    
    aclm_Appirio_Metric__c anObjectMetric = new aclm_Appirio_Metric__c();
    anObjectMetric.metric_type__c = 'ObjectMetric';
    //anObjectMetric.object_type__c = 'aclm_Appirio_Metric__c';
    anObjectMetric.name = 'aclm_Appirio_Metric__c';
    
    List<SObject> listOfSObjs = new List<aclm_Appirio_Metric__c>{aClassMetric, aTriggerMetric, anObjectMetric};
    insert listOfSObjs;
    
    am.execute(null, listOfSObjs);
    
    funcs.strListOfIds = '(\'' + aClassMetric.id +    '\',' +
                          '\'' + aTriggerMetric.id +  '\',' + 
                          '\'' + anObjectMetric.id +  '\')';
    am.finish(null);

  }


  // Allows test class to inject SObjects that haven't been inserted 
  // into the database for testing.
  private class NoQueryFuncs extends AppirioMetrics.PluggableFuncs {

    public Integer uniqueTestId = Math.abs(Crypto.getRandomInteger());

    public List<ApexClass> testClasses = 
        new List<ApexClass>{
          new ApexClass(name = 'Test Class 1 ' + uniqueTestId, body = '1'),
          new ApexClass(name = 'Test Class 2 ' + uniqueTestId, body = '1\n2')
        };

     public List<ApexTrigger> testTriggers = 
        new List<ApexTrigger>{
          new ApexTrigger(name = 'Test Trigger 1 ' + uniqueTestId, body = '1\n2\n3'),
          new ApexTrigger(name = 'Test Trigger 2 ' + uniqueTestId, body = '1\n2\n3\n4')
        };

    override public List<ApexClass> retrieveClassSObjects() {
      //System.debug('\n\n==> retrieveClassSObjects = ' + this.testClasses);
      return this.testClasses;
    }

    override public List<ApexTrigger> retrieveTriggerSObjects() {
      //System.debug('\n\n==> retrieveTriggerSObjects = ' + this.testTriggers);
      return this.testTriggers;
    }
        
    override public List<ApexClass> retrieveClassSObjects(Set<String> soIds) {
      //System.debug('\n\n==> retrieveClassSObjects() = ' + this.testClasses);
      return this.testClasses;
    }

    override public List<ApexTrigger> retrieveTriggerSObjects(Set<String> soIds) {
      //System.debug('\n\n==> retrieveTriggerSObjects() = ' + this.testTriggers);
      return this.testTriggers;
    }
  }


  private static testMethod void testBatchableStartProtocol() {

    NoQueryFuncs funcs = new NoQueryFuncs();
    AppirioMetrics am = new AppirioMetrics(funcs);

    am.start(null);

    String pattern = '%' + funcs.uniqueTestId + '%';
    Integer metricCount = [select count() from aclm_Appirio_Metric__c where name like :pattern];  
    System.assertEquals(4,metricCount, 'Should have created 4 TriggerMetric objects');
  }

}