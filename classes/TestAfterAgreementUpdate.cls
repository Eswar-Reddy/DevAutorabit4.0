/**************************************************
** PR- 01948
**Created By- Kapil Goutam
**Created On- June 17 2009
**Last Modified- 
**Last Modified On-  
**Desciption- Test class for trigger AfterAgreementUpdate
*****************************************************/
public class TestAfterAgreementUpdate {
	@isTest
  public static void Test_AfterAgreementUpdate(){
    echosign_dev1__SIGN_Agreement__c obj = new echosign_dev1__SIGN_Agreement__c();
    insert obj;
        
    echosign_dev1__SIGN_Agreement__c obj2 = new echosign_dev1__SIGN_Agreement__c(Id=obj.id);
    update obj2;
    
    TestAgreementManagement.checkInsertUpdateAgreement();
  }
}