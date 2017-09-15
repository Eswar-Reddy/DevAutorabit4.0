/**************************************************
** PR- 01948
**Created By- Kapil Goutam
**Created On- June 17 2009
**Last Modified- 
**Last Modified On-  
**Desciption- Test class for trigger AfterAgreementInsert

*****************************************************/
    
public class TestAfterAgreementInsert {
	@isTest
  public static void Test_AfterAgreementInsert(){
    Test.startTest();
    echosign_dev1__SIGN_Agreement__c obj = new echosign_dev1__SIGN_Agreement__c();
    insert obj;
    
    TestAgreementManagement.checkInsertUpdateAgreement();
    Test.stopTest();
  }
}