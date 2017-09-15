@isTest(seeAllData=true)
public class performMetricPageClsTest{
    public static testMethod void tst001(){
        Performance_Metric__c pm = new Performance_Metric__c();
        ApexPages.StandardController aps = new ApexPages.StandardController(pm);
        performMetricPageCls pmCls = new performMetricPageCls(aps);
        pmCls.getShowAdminView();
        system.debug('getPMlist()'+pmCls.getPMlist());
        pmCls.checkCountry('USA');
        PageReference pgObj = pmCls.SysAdminLink();
    } 
    
    public static testMethod void tst002(){
        UserRole userr = [select Id, name from UserRole where name='Business Development Manager'];
        List<User> u = [Select Id from User where userroleId =:userr.Id and IsActive = true];
        //system.runAs(u[0]){
            Performance_Metric__c pm = new Performance_Metric__c();
            ApexPages.StandardController aps = new ApexPages.StandardController(pm);
            performMetricPageCls pmCls = new performMetricPageCls(aps);
            pmCls.getShowAdminView();
        //}
       /* List<User> u1 = [Select Id from User where userroleId =:userr.Id and Country_Domain__c ='rvar-it' and isActive = true]; 
        system.runAs(u1[0]){ 
            Performance_Metric__c pm1 = new Performance_Metric__c();
            ApexPages.StandardController aps1 = new ApexPages.StandardController(pm1);
            performMetricPageCls pmClss = new performMetricPageCls(aps1);    
        }*/
        Profile p = [select id from profile where name='SunPower User'];
        list<User> u2 =[select Id from User where profileid =:p.id and isactive = true limit 2];
        system.runAs(u2[0]){ 
            Performance_Metric__c pm2 = new Performance_Metric__c();
            ApexPages.StandardController aps2 = new ApexPages.StandardController(pm2);
            performMetricPageCls pmClsss = new performMetricPageCls(aps2);    
        }
        list<User> u3 =[select Id from User where profileid =:p.id and isactive = true and Country_Domain__c ='rvar-it'limit 2];
        system.runAs(u3[0]){ 
            Performance_Metric__c pm3 = new Performance_Metric__c();
            ApexPages.StandardController aps3 = new ApexPages.StandardController(pm3);
            performMetricPageCls pmCls3 = new performMetricPageCls(aps3);    
        }
        
        list<User> u4 =[select Id from User where profileid =:p.id and isactive = true and Country_Domain__c ='rvar-de'limit 2];
        system.runAs(u4[0]){ 
            Performance_Metric__c pm4= new Performance_Metric__c();
            ApexPages.StandardController aps4 = new ApexPages.StandardController(pm4);
            performMetricPageCls pmCls4 = new performMetricPageCls(aps4);    
        }
    }
    
}