/**************************************************
** PR- 01923
**Created By- Harsh Mathur
**Created On- May 13 2009
**Last Modified- 
**Last Modified On-  June 17 2009 
**Desciption- Test class for controller CertificationManagement
*****************************************************/

public class TestCertificationManagement{
	@isTest
  public static void checkCertificationManagement(){
    List<Certification__c> lstCertification = new List<Certification__c>();
    List<Certification__c> lstOldCertification = new List<Certification__c>();
    
    CertificationManagement.afterCertificationInsert(lstCertification);
    CertificationManagement.afterCertificationUpdate(lstCertification, lstOldCertification);
    CertificationManagement.afterCertificationDelete(lstCertification);
  }
}