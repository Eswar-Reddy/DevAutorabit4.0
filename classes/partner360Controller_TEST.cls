@isTest
public class partner360Controller_TEST {

    static String Country = 'US'; 
    static String County = 'San Francisco'; 
    static String Address1 = '1234 Madison Ave'; 
    static String Address2 = 'San Ramon';
    static String City = 'San Francisco'; 
    static String State = 'CA'; 
    static String Zip = '94123'; 
    static String partner = 'Sky Power Systems';
    static String oppName = 'Sky Power Systems';
    
    static testMethod void partner360Controller1(){
    
        Account acc = new Account();    
        acc.Name='Test p360Ctrl1';
        acc.BillingCountry='USA';
        acc.BillingState ='CA';
        acc.BillingCity='San Jose';
        acc.BillingStreet='123 p360Ctrl1';
        acc.BillingPostalCode = '95865';
        insert acc;
        
        ApexPages.StandardController sc1 = new ApexPages.StandardController(acc);
        PageReference pageRef = Page.partner360;
        Test.setCurrentPageReference(pageRef);
        partner360Controller p360C1 = new partner360Controller(sc1);
        
        p360C1.Save();
        p360C1.Cancel();
        p360C1.toShortDetailPage();
    }
}