//
trigger afterCertificationDelete on Certification__c (after Delete)
{  
  	if(UserInfo.getUserId()=='00580000003XtZw' || UserInfo.getUserId()=='00580000003Xtm2' ||UserInfo.getUserId()=='00580000003XrG4')
	{
		return;
	}
  CertificationManagement.afterCertificationDelete (Trigger.old);
  
}