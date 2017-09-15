global class DeleteAgreement_CLS {
    
    public string accId {get; set;}
        
    // for creating Test Case..
    public apexpages.standardController cont1 {get; set;}
    
    public DeleteAgreement_CLS(ApexPages.StandardController cont2) {
        cont1 = cont2;
        try{
            //    If(UserInfo.getUserType().contains('Partner'))
            accId = [select Id, Account__c from echosign_dev1__SIGN_Agreement__c 
                     where Id=:ApexPages.currentPage().getParameters().get('Id')].Account__c;
        } catch(QueryException ee) {}
    }
    
    
    //Test Method
    static testMethod void Test_DeleteAgreement_CLS() {
        TestClassFactory.createAndInsertLeaseAgreementSettings();
        
        Account accnt = new Account( Name='Raam');
        accnt.BillingCity = 'Bangalore';
        accnt.BillingCountry = 'India';
        accnt.BillingStreet = 'Whitefield';
        accnt.BillingPostalCode = '2345';
        accnt.Phone = '9874563210';
        insert accnt;
        
        echosign_dev1__SIGN_Agreement__c aggr = new echosign_dev1__SIGN_Agreement__c();
        aggr.Account__c = accnt.Id;
        insert aggr;
        
        /*  START Test Case for DeleteNotesAttachment     */       
        Attachment attch = new Attachment();
        attch.ParentId = aggr.Id;
        attch.Name = 'hllo';
        attch.Body = Blob.valueOf('hiii');
        insert attch;
        
        delete attch;    
        /*  END Test Case for DeleteNotesAttachment    */
        
        
        ApexPages.currentPage().getParameters().put('Id', aggr.Id);
        
        ApexPages.StandardController cont3 = new ApexPages.StandardController(aggr); 
        DeleteAgreement_CLS delAggr = new DeleteAgreement_CLS(cont3);    
        
    }
    
    
}