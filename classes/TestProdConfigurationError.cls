//Test Class for ProdConfigurationError
@isTest
private class TestProdConfigurationError {
    
    static TestMethod void testMethod1(){
        ProdConfigurationError pce = new ProdConfigurationError();
        ProdConfigurationError.Error pceError = ProdConfigurationError.getError(801);
    }

}