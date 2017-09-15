global class AppirioMetrics implements Database.Batchable<SObject>, Messaging.InboundEmailHandler {


/*** To Run this Class From the Console:
     
id batchId = Database.executeBatch(new AppirioMetrics(), 5);
System.debug('\n\n==> batchId = ' + batchId); 

***/


  public static final String version = '0.9';
  public static final String orgName = UserInfo.getOrganizationName();
  public static final String org_Id = UserInfo.getOrganizationId();
  
  public String jobId = null;
  public DateTime jobDatetime = null;
  public integer batchCnt = 0;
  public Id batchId = null;

  private static Pattern linePattern = Pattern.compile('[^\n]*\n|[^\n]+');
  private Map<String, Schema.SObjectType> name2Token = null;
  private String metricsCSV = '';
  private PluggableFuncs pluggables = null;


  public class AppirioMetricsException extends Exception {}

  /*** CONSTRUCTOR:  Instantiate with null constructor for default query logic ***/

   public AppirioMetrics() {
     this(new PluggableFuncs());
   }


  /*** CONSTRUCTOR:  Instantiate with custom query logic for testing ***/

   public AppirioMetrics(PluggableFuncs funcs) {
     pluggables = funcs;
   }


  /*** INNER CLASS: Super Class for all Appirio Metrics ***/

  // Provides a shared interface for batchable iteration.
  // Encapsulates common properties of the metrics for each
  // kind of object measured.  ClassMetric and TriggerMetric both
  // wrap SObjects, whereas ObjectMetric does not. 
  global virtual class Metric {

    public aclm_Appirio_Metric__c metricSobj = null;
 
    public String jobNumber = '';
    public Datetime jobDatetime = null;
    public Id orgId = AppirioMetrics.org_Id;
    public String MetricType = 'Metric';
    // NOTE:  id is intentially remapped as String for testability.  Be Careful!
    public String sfid; 
    public String name;
    public String createdStr = Datetime.now().format('yyyy-MM-dd');
    public String modifiedStr = Datetime.now().format('yyyy-MM-dd');
    public String modifiedBy = null;
    public Integer lineCnt = 0;
    public Integer blankCnt = 0;
    public Integer charCnt = 0;
    // ClassMetric fields -- intentionally declared on the base class
    // in order to facilitate mapping to Apex_Metric__c
    public ApexClass aClass = null;
    public Integer  tabCnt = 0;
    public Integer  testCnt = 0;
    public Integer  assertCnt = 0;
    public Integer  webserviceCnt = 0;
    public Integer  externalCnt = 0;
    public Integer  calloutCnt = 0;
    public Integer  httpRespCnt = 0;
    public Boolean  generated = false;
    public Integer  futureCnt = 0;
    // TriggerMetric fields -- intentionally declared on the base class.
    public ApexTrigger aTrigger;
    public String objectName = '';
    // ObjectMetric fields -- intentionally declared on the base class. 
    public Integer recordTypeCnt = 0;
    public Integer fieldCnt = 0;
    public Integer relationCnt = 0;
    public Integer pageRefsCnt = 0;
    

    public Decimal getLineDensity() {
      Double tmp = 0;
      if (lineCnt > 0) {
        tmp = (1.0 * (lineCnt - blankCnt)) / lineCnt;
      }
      Decimal ans = Decimal.valueOf(tmp).setScale(2);
      return ans;
    }


    // Note: This logic is written somewhat oddly to make all lines testable,
    // which is tricky since you cannot actually insert triggers and classes when testing.
    public Decimal getCodeDensity() {
      Double tmp = 0.0;
      Integer len = getLengthWithoutComments();
      if (len == null) {
        len = 0;
      }
      if (charCnt > 0) {
        tmp = (1.0 * len) / charCnt;
      }
      Decimal ans = Decimal.valueOf(tmp).setScale(2);
      return ans;
    }


    public virtual integer getLengthWithoutComments() {
      return 0;
    }


    public virtual String getMetricType() {
      return metricType;
    }


    public aclm_Appirio_Metric__c buildSObject() {
      aclm_Appirio_Metric__c ans = null;
      if (metricSobj == null) {
        metricSObj = new aclm_Appirio_Metric__c();
      }
      ans = metricSObj;
      ans.version__c = AppirioMetrics.version;
      ans.org_name__c = AppirioMetrics.orgName;
      ans.org_id__c = AppirioMetrics.org_Id;
      ans.job_number__c = jobNumber;
      ans.job_datetime__c = jobDatetime;
      ans.metric_type__c = getMetricType();
      ans.salesforce_id__c = sfid;
      ans.name = name;
      ans.modified_by__c = modifiedBy;
      ans.object_created__c = createdStr;
      ans.object_modified__c = modifiedStr;
      ans.line_count__c = lineCnt;
      ans.line_density__c = getLineDensity();
      ans.character_count__c = charCnt;
      ans.code_density__c = getCodeDensity();
      ans.tab_count__c = tabCnt;
      ans.test_count__c = testCnt;
      ans.assert_count__c = assertCnt;
      ans.webservice_count__c = webserviceCnt;
      ans.external_count__c = externalCnt;
      ans.callout_count__c = calloutCnt;
      ans.http_response_count__c = httpRespCnt;
      ans.generated__c = generated;
      ans.future_count__c = futureCnt;
      ans.object_name__c = objectName;
      ans.field_count__c = fieldCnt;
      ans.relation_count__c = relationCnt;
      ans.record_type_count__c = recordTypeCnt;
      ans.page_refs_count__c = pageRefsCnt;
      return ans;
    }


    public String buildCSV() {
      String ans = '';
      ans += AppirioMetrics.version + '|';
      ans += AppirioMetrics.orgName + '|';
      ans += jobNumber + '|';
      ans += jobDatetime + '|';
      ans += AppirioMetrics.org_Id + '|';
      ans += sfid + '|';
      ans += name + '|';
      ans += modifiedBy + '|';
      ans += createdStr + '|';
      ans += modifiedStr + '|';
      ans += lineCnt + '|';
      ans += getLineDensity() + '|';
      ans += charCnt + '|';
      ans += getCodeDensity() + '|';
      ans += tabCnt + '|';
      ans += testCnt + '|';
      ans += assertCnt + '|';
      ans += webserviceCnt + '|';
      ans += externalCnt + '|';
      ans += calloutCnt + '|';
      ans += httpRespCnt + '|';
      ans += generated + '|';
      ans += futureCnt + '|';
      ans += objectName + '|';
      ans += fieldCnt + '|';
      ans += relationCnt + '|';
      ans += recordTypeCnt + '|';
      ans += pageRefsCnt;
      return ans;
    }

    /*** protected implementation ***/

  }




  private static List<Metric> Metric_buildFromSObjects(List<aclm_Appirio_Metric__c> sobjs) {

    List<Metric> ans = new List<Metric>();
    
    for(aclm_Appirio_Metric__c am : sobjs) {
      
      System.debug('\n\n Metric_buildFromSObjects ==> ' + am);
      
      Metric m = null;
      if (am.metric_type__c == 'ClassMetric') {
        m = new ClassMetric();
      } else if (am.metric_type__c == 'TriggerMetric') {
        m = new TriggerMetric();
      } else if (am.metric_type__c == 'ObjectMetric') {
        m = new ObjectMetric();
      }
      if (m != null) {
        m.metricSobj = am;
        m.sfid = am.id;
        //m.version = am.version__c;
        //m.orgName = am.org_name__c;
        //m.orgId = am.org_Id__c;
        m.jobNumber = am.job_number__c;
        m.jobDatetime = am.job_datetime__c;
        m.orgId = am.org_id__c;
        m.metricType = am.metric_type__c;
        m.sfid = am.salesforce_id__c;
        m.name = am.name;
        m.modifiedBy = am.modified_by__c;
        m.createdStr = am.object_created__c;
        m.modifiedStr = am.object_modified__c;
        m.lineCnt = (am.line_count__c == null) ? 0 : am.line_count__c.intValue();
        m.charCnt = (am.character_count__c == null) ? 0 : am.character_count__c.intValue();
        m.tabCnt = (am.tab_count__c == null) ? 0 : am.tab_count__c.intValue();
        m.testCnt = (am.test_count__c == null) ? 0 : am.test_count__c.intValue();
        m.assertCnt = (am.assert_count__c == null) ? 0 : am.assert_count__c.intValue();
        m.webserviceCnt = (am.webservice_count__c == null) ? 0 : am.webservice_count__c.intValue();
        m.externalCnt = (am.external_count__c == null) ? 0 : am.external_count__c.intValue();
        m.calloutCnt = (am.callout_count__c == null) ? 0 : am.callout_count__c.intValue();
        m.httpRespCnt = (am.http_response_count__c == null) ? 0 : am.http_response_count__c.intValue();
        m.generated = am.generated__c;
        m.futureCnt = (am.future_count__c == null) ? 0 : am.future_count__c.intValue();
        m.objectName = am.object_name__c;
        m.fieldCnt = (am.field_count__c == null) ? 0 : am.field_count__c.intValue();
        m.relationCnt = (am.relation_count__c == null) ? 0 : am.relation_count__c.intValue();
        m.recordTypeCnt = (am.record_type_count__c == null) ? 0 : am.record_type_count__c.intValue();
        m.pageRefsCnt = (am.page_refs_count__c == null) ? 0 : am.page_refs_count__c.intValue();
        ans.add(m);
      }
    }
    return ans;
  }


  // SIDE-EFFECT: updates the objects stored in ListOfMetrics.
  private static void Metric_initializeAll(PluggableFuncs pluggables, Map<String, Schema.SObjectType> objName2Token, List<Metric> listOfMetrics) {

    // Note:  Id types are intentionally remapped as string for testabilty.
    Map<String,ClassMetric> id2classMetric = new Map<String,ClassMetric>();
    Map<String,TriggerMetric> id2triggerMetric = new Map<String,TriggerMetric>();
    Map<String,ObjectMetric> id2ObjectMetric = new Map<String,ObjectMetric>();

    for(Metric m : listOfMetrics) {
      
      System.debug('\n\n Metric_initializeAll ==> '  + m);

      String key = m.sfid;
      if (key == null) {
        key = m.name;
      }
      
      // Case logic is a little ugly, but it's easiest at this point to keep the 
      // Metrics <==> Appirio_Metrics__c relationship one-to-one.
      if (m instanceof ClassMetric) {
        id2classMetric.put(key, (ClassMetric)m);

      } else if (m instanceof TriggerMetric) {
        id2triggerMetric.put(key, (TriggerMetric)m);

      } else if (m instanceof ObjectMetric) {
        id2ObjectMetric.put(key, (ObjectMetric)m);
      }
    }

    for(ApexClass ac : pluggables.retrieveClassSObjects(new Set<String>(id2ClassMetric.keySet()))) {
      ClassMetric cm = (ClassMetric)testableLookup(id2ClassMetric, ac.id, ac.name);
      cm.initialize(ac);
      //System.debug('\n\n post initialize ==> ac.name = '  + cm.name + ', lineCnt = ' + cm.lineCnt);
    }

    for(ApexTrigger at : pluggables.retrieveTriggerSObjects(new Set<String>(id2TriggerMetric.keySet()))) {
      TriggerMetric tm = (TriggerMetric)testableLookup(id2TriggerMetric, at.id, at.name);
      tm.initialize(at);
      //System.debug('\n\n post initialize ==> tm.name = '  + tm.name + ', lineCnt = ' + tm.lineCnt);
    }
    
SYSTEM.debug('\n\nJOEK >>> ' + ObjName2Token);

    for(ObjectMetric om : id2ObjectMetric.values()) {
      om.initialize(ObjName2Token);
      System.debug('\n\n post initialize ==> om.name = '  + om.name);
    }
  }


  private static List<aclm_Appirio_Metric__c> buildSObjects(List<Metric> metrics) {

    List<aclm_Appirio_Metric__c> ans = new List<aclm_Appirio_Metric__c>();
    for(Metric am : metrics) {
      ans.add(am.buildSObject());
    }
    return ans;
  }
  
  
  private static string buildCSVs(List<Metric> metrics) {

    String ans = '';
    for(Metric am : metrics) {
      ans += am.buildCSV() + '\n';
    }
    return ans;
  }


  private static string buildCSV(aclm_Appirio_Metric__c am) {
    String ans = '';  
    ans += am.version__c + '|';
    ans += am.org_name__c + '|';
    ans += am.job_number__c + '|';
    ans += am.job_datetime__c + '|';
    ans += am.org_id__c + '|';
    ans += am.metric_type__c + '|';
    ans += am.salesforce_id__c + '|';
    ans += am.name + '|';
    ans += am.modified_by__c + '|';
    ans += am.object_created__c + '|';
    ans += am.object_modified__c + '|';
    ans += am.line_count__c + '|';
    ans += am.line_density__c + '|';
    ans += am.character_count__c + '|';
    ans += am.code_density__c + '|';
    ans += am.tab_count__c + '|';
    ans += am.test_count__c + '|';
    ans += am.assert_count__c + '|';
    ans += am.webservice_count__c + '|';
    ans += am.external_count__c + '|';
    ans += am.callout_count__c + '|';
    ans += am.http_response_count__c + '|';
    ans += am.generated__c + '|';
    ans += am.future_count__c + '|';
    ans += am.object_name__c + '|';
    ans += am.field_count__c + '|';
    ans += am.relation_count__c + '|';
    ans += am.record_type_count__c + '\n';
    return ans;
  }


  public static Metric TESTONLY_testableLookup(Map<String,Metric> m, String id, String name) {
    return testableLookup(m, id, name);
  }


  private static Metric testableLookup(Map<String,Metric> m, String id, String name) {
    //System.debug('\n\n testableLookup() ==> id = '  + id + ', name = ' + name);
    Metric ans = null;
    if (id != null) { 
      ans = m.get(id);
    }
    for(String k : m.keySet()) {
      //System.debug('\ntestableLookup() ==> key = '  + k + ', value = ' + m.get(k));
    }
    // When we're testing, we're stuck -- we can't insert ApexClass and ApexTrigger -- so here
    // we need to handle ApexClass and ApexTigger that have id == null;
    // JOEK:  if (ans != null && ans.sfid == null) {
    if (ans == null) {  
      for(Metric met : m.values()) {
        if (met.name == name) {
          ans = met;
          break;
        }
      }
    }
    return ans;
  }


  public Map<String, Schema.SObjectType> getObjName2Token() {
    if (this.name2Token == null) {
      this.name2Token = Schema.getGlobalDescribe();
    }
    return this.name2Token;
  }


  /*** INNER CLASS: Subclass for Appirio Apex Class Metrics ***/
  
  public class ClassMetric extends Metric {

    public String MetricType = 'ClassMetric';
    //TODO: public Integer  emailHandler = 0;
    //TODO: public Integer  sendEmail = 0;
    //TODO: public Boolean  controller = 0;
    //TODO: public Boolean  batchable = 0;

    public ClassMetric() {}
    
    // Instantiates a non-initialized ClassMetric
    // which supports a light-weight batchable protocol
    // by not yet including the actually sobject or scanning
    // the code.
    public ClassMetric(Id id, String name, String jobId, Datetime timestamp) {
      sfid = id;
      this.name = name;
      jobNumber = jobId;
      jobDatetime = timestamp;
    }


    public ClassMetric(ApexClass ac) {  
      sfid = ac.id;
      initialize(ac);
    }


    public void initialize(ApexClass ac) {
      //System.debug('\n\n initializing 0 ==> ac.name = '  + name);
      //System.debug('\n\n initializing 1 ==> at.name = ' + name + ' lineCnt = ' + lineCnt );
      aClass = ac;
      name = ac.name;
      //System.debug('\n\n initializing 2 ==> at.name = ' + name + ' lineCnt = ' + lineCnt );
      Datetime dt = ac.createdDate;
      modifiedBy = ac.lastModifiedBy.email;
      if (dt == null)
        dt = Datetime.now();
      createdStr = dt.format('yyyy-MM-dd');
      dt = ac.lastModifiedDate;
      if (dt == null)
        dt = Datetime.now();
      modifiedStr = dt.format('yyyy-MM-dd');
      
      scanClassCode();

      //Throw away the body after scanning to conserve heapspace
      aClass.body = null;

      //System.debug('\n\n post scan ==> ac.name = '  + name + ', lineCnt = '+ lineCnt);
    }


    public override integer getLengthWithoutComments() {
      integer ans= 0;
      if (aClass != null) {
        ans = aClass.lengthWithoutComments;
      }
      return ans;
    }


    public override String getMetricType() {
      return metricType;
    }


    /*** private implementation ***/
      
    // Note: This method is highly performance-sensitive -- be sure you know
    // the effects on "large" code bases before making changes.  E.g., adding 
    // a single invocation of an apex function adds approximately 0.7ms per 
    // line of code.
    private void scanClassCode() {

      // ApexClass.body will be "null" when body is empty string (normal SObject semantics)
      // findline.matcher(null) throws NPE.
      if (aClass.body != null) {

        // TODO: Test if eliminating regular expression is a peformance improvement.
        Matcher m = linePattern.matcher(aClass.body);

        // Note: this loop is optimized to run quickly.
        // Even adding a single method call inside the loop has significantly
        // impacted performance.
        while (m.find()) {

          String line = m.group();
          ++lineCnt;
          charCnt += line.length();

          if (line.contains('\t')) {
          // Note: it is faster to count just lines with tabs
          // The following two lines can be used to count individual tabs instead
          //String stripped = line.replace('\t', '');
          //tabCnt += (line.length() - stripped.length());
            tabCnt += 1;
          }
          
          if (line.trim() == '') {
            ++blankCnt;

          } else {

            String line_lc = line.toLowerCase();

            if (line_lc.contains('testmethod ') &&   // break line to avoid counting this line! ;-)
              line_lc.contains('static ')) {
              ++testCnt;
            }

            if (line_lc.contains('system.' + 'assert')) {   
              ++assertCnt;
            }

            // The following lines break search strings to avoid 
            // finding these strings when scanning this class file. 

            if (line_lc.contains('web' + 'service ')) {
              if (line_lc.contains('static ')) {
                ++webserviceCnt;
              } else {
                ++externalCnt;
              }
            }

            if (line_lc.contains('web' + 'servicecallout.' + 'invoke')) {
              ++calloutCnt;
            }

            if (line_lc.contains('http' + 'response ')) {
              ++httpRespCnt;
            }

            if (line_lc.contains('@' + 'future')) {
              ++futureCnt;
            }
            
            if (line_lc.contains('page' + 'reference') ||
                line_lc.contains('page' + '.')) {
              ++pageRefsCnt;    
            }

            if (!generated && line_lc.contains('//generated ' + 'by wsdl2apex')) {
              generated = true;
            }
          }   // End non-blank line. 
        }   // End while (m.find())
      }
    }
  }


  /*** INNER CLASS: Subclass for Appirio Apex Trigger Metrics ***/

  public class TriggerMetric extends Metric {

    public String MetricType = 'TriggerMetric';

    public TriggerMetric() {}

    // Instantiates a non-initialized TriggerMetric
    // which supports a light-weight batchable protocol
    // by not yet including the actually sobject or scanning
    // the code.
    public TriggerMetric(Id id, String name, String jobId, Datetime timestamp) {
      sfid = id;
      this.name = name;
      jobNumber = jobId;
      jobDatetime = timestamp;
    }


    public TriggerMetric(ApexTrigger at) {
      sfid = at.id;
      initialize(at);
    }


    public void initialize(ApexTrigger at) {

      aTrigger = at;
      name = at.name;
      objectName = at.TableEnumOrId;
      modifiedBy = at.lastModifiedBy.email;
      Datetime dt = at.createdDate;
      if (dt == null)
        dt = Datetime.now();
      createdStr = dt.format('yyyy-MM-dd');
      dt = at.lastModifiedDate;
      if (dt == null)
        dt = Datetime.now();
      modifiedStr = dt.format('yyyy-MM-dd');
      
      scanTriggerCode();

      //Throw away the body after scanning to conserve heapspace
      aTrigger.body = null;
      //System.debug('\n\n post scan ==> at.name = '  + at.name + ', lineCnt = ' + lineCnt);
    }

    public override integer getLengthWithoutComments() {
      integer ans= 0;
      if (aTrigger != null) {
        ans = aTrigger.lengthWithoutComments;
      }
      return ans;
    }


    public override String getMetricType() {
      return metricType;
    }

    /*** private implementation ***/
         
    // Note: This method is highly performance-sensitive.  It is a small
    // subset of the logic used for scanClassCode() in the ClassMetrics 
    // class.  See comments there.  Generally, there are few triggers and
    // fewer lineCnt in triggers, so this code is less performance sensitive --
    // but still echoes the scanClassCode() logic. 
    private void scanTriggerCode() {

      // ApexClass.body will be "null" when body is empty string (normal SObject semantics)
      // findline.matcher(null) throws NPE.
      if (aTrigger.body != null) {

        // TODO: Test if eliminating regular expression is a peformance improvement.
        Matcher m = linePattern.matcher(aTrigger.body);

        // Note: this loop is optimized to run quickly.
        // Even adding a single method call inside the loop has significantly
        // impacted performance.
        while (m.find()) {

          String line = m.group();

          ++lineCnt;
          charCnt += line.length();

          if (line.contains('\t')) {
          // Note: it is faster to count just lines with tabs
          // The following two lines can be used to count individual tabs instead
          //String stripped = line.replace('\t', '');
          //tabCnt += (line.length() - stripped.length());
            tabCnt += 1;
          }

          if (line.trim() == '') {
            ++blankCnt;
          } else {

            // String line_lc = line.toLowerCase();
          }
        }   // End while (m.find())
      }
    }
  }


  /*** INNER CLASS: Subclass for Appirio Apex Object Metrics ***/

  public class ObjectMetric extends Metric {


    private Schema.SObjectType objType = null;

    public String MetricType = 'ObjectMetric';

    public ObjectMetric() {}

    public ObjectMetric(String newKey, Schema.SObjectType newObjType, String jobId, Datetime jobDatetime) {
      this.name = newKey;
      this.objType = newObjType;
      this.jobNumber = jobId;
      this.jobDatetime = jobDatetime;
    }


    public void initialize(Map<String, Schema.SObjectType> objName2Token) {

      if (this.name == null) {
        System.debug('\n\nWARNING: Current ObjectMetric has null name. ' + this.name);
        throw new AppirioMetricsException('ObjectMetric Object has null name.  AppirioMetrics.ObjectMetric.initialize() failed.');
      }

      if (this.objType == null) {
        this.objType = objName2Token.get(this.name);
      }
      
System.debug('\n\nJOEK >>> this.name = ' + this.name );         
System.debug('\n\nJOEK >>> this.objType = ' + this.objType );      

      Schema.DescribeSObjectResult descResult = this.objType.getDescribe();

      Map<String, Schema.SObjectField> name2Field = descResult.fields.getMap();
      this.fieldCnt = name2Field.keySet().size();

      List<Schema.RecordTypeInfo> rt = descResult.getRecordTypeInfos();
      this.recordTypeCnt = rt.size();
      
      List<Schema.ChildRelationship> relations = descResult.getChildRelationships();
      this.relationCnt = relations.size();
      
    }


    public override String getMetricType() {
      return metricType;
    }
  }



/***
 *
 *  PLUGGABLE FUNCTIONS -- to facilitate testing.
 *
 ***/

  // Overridden by the Test class, which cannot insert Apex Code or actually 
  // run Batchable jobs asynchronously.  This class runs in client orgs, and 
  // 100% coverage is desireable so that the code does not detract from
  // test coverage.
  public virtual class PluggableFuncs {

    private String classQueryStr = 
      'select id, name, lengthWithoutComments, body, ' +
         'CreatedDate, LastModifiedDate, lastModifiedBy.email ' +
      'from apexClass where namespaceprefix = null';

    private String triggerQueryStr = 
      'select id, name, TableEnumOrId, lengthWithoutComments, body, ' +
        'CreatedDate, LastModifiedDate, lastModifiedBy.email ' +
      'from apexTrigger where namespaceprefix = null';

    private List<String> STD_CLASSES = 
      new list<String>{'account', 'asset', 'campaign', 'case', 'contact', 'contract', 'event', 
                       'idea', 'lead', 'opportunity', 'product2', 'solution', 'task', 'user'};

    virtual public string getAppirioMetricsQryStr(String jobId) {
      return 
        'select id,version__c,org_name__c,job_number__c,job_datetime__c,org_id__c,metric_type__c, ' +
          'salesforce_id__c,name,modified_by__c,object_created__c,object_modified__c,line_count__c, ' +
          'line_density__c,character_count__c,code_density__c,tab_count__c,test_count__c, ' +
          'assert_count__c,webservice_count__c,external_count__c,callout_count__c,http_response_count__c, ' +
          'generated__c,future_count__c,object_name__c,field_count__c,relation_count__c, page_refs_count__c, ' +
          'record_type_count__c ' +
        'from aclm_Appirio_Metric__c where job_number__c = \'' + jobId + '\'';
    }

    virtual public List<ApexClass> retrieveClassSObjects() {
      return Database.query(this.classQueryStr);
    }
    
    virtual public List<ApexClass> retrieveClassSObjects(Set<String> soIds) {
       String qryStr = this.classQueryStr + buildQueryClause(soIds);
       System.debug('\n\n==> QryStr = ' + qryStr);
       return Database.query(qryStr);
    }

    virtual public List<ApexTrigger> retrieveTriggerSObjects(Set<String> soIds) {
       String qryStr = this.triggerQueryStr + buildQueryClause(soIds);
       System.debug('\n\n==> QryStr = ' + qryStr);
       return Database.query(qryStr);
    }

    virtual public List<ApexTrigger> retrieveTriggerSObjects() {
      return Database.query(this.triggerQueryStr);
    }

    // test client can override with modified query string.
    virtual public void setTestQueries(String classQueryStr, String triggerQueryStr) {
      this.classQueryStr = classQueryStr;
      this.triggerQueryStr = triggerQueryStr;
    }
    
    virtual public List<String> getStandardObjectList(Map<String, Schema.SObjectType> name2token) {
      Set<String> tmp = new Set<String>(name2Token.keySet());
      tmp.retainAll(STD_CLASSES);
      List<String> ans = new List<String>(tmp);
      ans.sort();
      return ans;
    }

    virtual public List<String> getCustomObjectList(Map<String, Schema.SObjectType> name2token) {
      List<String> ans = new List<String>();
      Set<String> tmp = new Set<String>(name2Token.keySet());
      for( String k : tmp) {
        if (k.endsWith('__c')) {
          ans.add(k);
        }
      }
      ans.sort();
      return ans;
    }

    private String buildQueryClause(Set<String> soIds) {
      String ans = ' and id in (null';
      String tmp;
      for(Id id : soIds) {
        //Note: strange logic for nulls provides testability
        tmp = ',\'' + id + '\'';
        if (id == null) {
          tmp = ',null';
        }
        ans += tmp;
      }
      ans += ') ';
      return ans;
    }
  }
    
  



/***
 *
 *  BATCHABLE -- Logic to create aclm_Appirio_Metric__c objects by scanning
 *               Apex Code for Classes and Triggers, and by scanning the 
 *               Information about objects in the DataDictionary.
 *
 ***/



  /*** IMPLEMENT BATCHABLE SUPPORT: Start, execute, and finish methods ***/
  
  global Database.QueryLocator start(Database.BatchableContext context) {

    jobDatetime = Datetime.now();
    if (context != null) {
      // TODO: This line appears to be untestable.  Is it really?
      jobId = context.getJobId();
    }

    List<Metric> metrics = new List<Metric>();

    for(ApexClass ac : pluggables.retrieveClassSObjects()) {
      metrics.add(new ClassMetric(ac.id, ac.name, jobId, jobDatetime));
    }

    for(ApexTrigger at : pluggables.retrieveTriggerSObjects()) {
      metrics.add(new TriggerMetric(at.id, at.name, jobId, jobDatetime));
    }

    List<String> custKeys = pluggables.getCustomObjectList(getObjName2Token());
    for(String k : custKeys) {
      ObjectMetric om = new ObjectMetric(k, getObjName2Token().get(k), jobId, jobDatetime);
      metrics.add(om);
    }
    
    List<String> stdKeys = pluggables.getStandardObjectList(getObjName2Token());
    for(String k : stdKeys) {
      ObjectMetric om = new ObjectMetric(k, getObjName2Token().get(k), jobId, jobDatetime);
      metrics.add(om);
    }
    
    // Use metric objects to build & insert aclm_Appirio_Metric__c object

    List<aclm_Appirio_Metric__c> newObjs = buildSObjects(metrics);
    
    insert newObjs;

    Database.QueryLocator ans = 
        Database.getQueryLocator(pluggables.getAppirioMetricsQryStr(jobId));
    return ans;
  }


  global void execute(Database.BatchableContext context, List<SOBject> objects) {

    jobDatetime = Datetime.now();
    if (context != null) {
      jobId = context.getJobId();
    }
    
    List<Metric> metrics = Metric_buildFromSObjects((List<aclm_Appirio_Metric__c>)objects);
    
    // Efficiently initialize all the objects in this batch.
    Metric_InitializeAll(pluggables, getObjName2Token(), metrics);

    List<aclm_Appirio_Metric__c> batchObjs = buildSObjects(metrics);
    
    update batchObjs;
    batchCnt += 1;
    
  }


  global void finish(Database.BatchableContext context) {

    Integer metricCnt = 0;
    Integer classCnt = 0;
    Integer triggerCnt = 0;
    Integer lineCnt = 0;
    Integer objectCnt = 0;   
    Integer fieldCnt = 0;   
    Integer relationCnt = 0; 
    Integer recordTypeCnt = 0;
         
    String metricsCSV = '';  

    if (context != null) {
      jobId = context.getJobId();
    }

    // inverted assignment logic provides test coverage -- all these lines run when testing.
    AsyncApexJob job = new AsyncApexJob();
    List<AsyncApexJob> jobs = [select id, status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email 
                                from AsyncApexJob 
                               where id = :jobId];
    if (jobs.size() == 0) {
      jobs.add(job);
    }
    job = jobs[0];
    // end inversion.  Now we have a job object, possibly empty.
    
    
    String qyrStr = pluggables.getAppirioMetricsQryStr(jobId);

    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    mail.setToAddresses( new String[]{'bipin@appirio.com'} );
    mail.setSubject('Batchable Test Completed');

   
    String body  = '=============';   
    
    //List<aclm_Appirio_Metric__c> metrics = Database.query(pluggables.getAppirioMetricsQryStr(jobId) + ' order by id limit 999');
    	for(aclm_Appirio_Metric__c m : Database.query( pluggables.getAppirioMetricsQryStr(jobId) + ' limit 9999' )) {
    		
    		metricCnt += 1;
    		
        if (m.metric_type__c == 'ClassMetric') {
          classCnt += 1;
          lineCnt += m.line_count__c.intValue();
        
        } else if (m.metric_type__c == 'TriggerMetric') {
          triggerCnt += 1;
          lineCnt += m.line_count__c.intValue();
        
        } else if (m.metric_type__c == 'ObjectMetric') {
          if (m.name.endsWith('__c')) {
          	objectCnt += 1;
          	fieldCnt += m.field_count__c.intValue();
          	relationCnt += m.relation_count__c.intValue();
          	recordTypeCnt += m.record_type_count__c.intValue();
          }
        }
        metricsCSV += buildCSV(m);
     }
    	
    
    body += '\norgName = ' + AppirioMetrics.orgName;
    body += '\norgId = ' + AppirioMetrics.org_Id;
    body += '\njobId  = ' + jobId;
    body += '\nMetric Count = ' + metricCnt;
    body += '\nClass Count = ' + classCnt;
    body += '\nTrigger Count = ' + triggerCnt;
    body += '\nLine Count = ' + lineCnt;
    body += '\nObject Count = ' + objectCnt;   
    body += '\nRecord Type Count = ' + recordTypeCnt;   
    body += '\nField Count = ' + fieldCnt;   
    body += '\nRelation Count = ' + relationCnt;
    body += '\n======\n';  
    body += metricsCSV; 
    
    mail.setPlainTextBody(body);

    Messaging.sendEmail( new Messaging.SingleEmailMessage[]{mail} ); 


  }
  
/***
 *
 *  EMAIL HANDLER
 *
 ***/
 
  global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
  
    id batchId = Database.executeBatch(new AppirioMetrics(), 5);
    Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
    result.success = (batchId != null);
    result.message = 'Submitted batchId = ' + batchId;
    return result;
  }

}