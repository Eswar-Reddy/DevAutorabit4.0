@isTest
private Class TestSalesforceAmbassadorIntegration{
    
    static testmethod void testupdateSSN(){
    
        Contact con1=new Contact();
        con1.LastName = 'TestSFAmbIntCon1';
        con1.Phone = '1234567654';
        insert con1;
        
        boolean ssnUpdated = SalesforceAmbassadorIntegration.updateSSN(con1.Id,'345634538');
    }
    
    static testmethod void testSSNExists(){
    
        Contact con2=new Contact();
        con2.LastName = 'TestSFAmbIntCon2';
        con2.Phone = '1234567652';
        insert con2;
        
        boolean ssnUpdated = SalesforceAmbassadorIntegration.SSNExists(con2.Id);
    }
}