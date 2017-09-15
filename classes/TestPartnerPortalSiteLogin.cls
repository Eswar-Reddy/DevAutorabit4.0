@isTest(seeAllData=true)
private class TestPartnerPortalSiteLogin {
    /*
    
    //Test Method for code coverage of partnerportalSiteLoginController
    static testmethod void testpartnerportallogin() {
    
        PageReference pageRef = Page.partnerportallogin;
        Test.setCurrentPage(pageRef);
        
        ApexPages.currentPage().getHeaders().put('Accept-Language','en-US'); 
        System.debug('CurrentPage Headers -----'+ApexPages.currentPage().getHeaders());
        PartnerPortalSiteLoginController ppsl = new PartnerPortalSiteLoginController ();
        ppsl.username = 'test@salesforce.com';
        ppsl.password = '123456';
        System.assertEquals(ppsl.login(),null);
        ppsl.authCurrentUser();
        ApexPages.currentPage().getParameters().put('startURL','/home/home.jsp');
        ppsl.login();
    }
    
    //Test Method for coverage of PartnerPortalForgotPasswordController
    static testmethod void testpartnerportalforgotpassword(){
    
        PageReference pageRef = Page.partnerportalforgotpassword;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getHeaders().put('Accept-Language','en-US'); 
        System.debug('CurrentPage Headers -----'+ApexPages.currentPage().getHeaders());
        
        PartnerPortalForgotPasswordController ppfp = new PartnerPortalForgotPasswordController ();
        ppfp.username = 'test@salesforce.com';
        ppfp.forgotPassword();
        
        User u = [select username from User where isActive=true and isPortalEnabled=true limit 1];
        ppfp.username = u.username;
        ppfp.forgotPassword();
        
        ppfp.newPassword='12345678';
        ppfp.verifyNewPassword ='12345678';
        ppfp.changePassword();
    }
    
    static testmethod void testpartnerportallanding(){
		string testcurrentServer='https://login.salesforce.com';
        if(UserInfo.getOrganizationId()!=Label.Production_Org_Id){
           testcurrentServer='https://test.salesforce.com';
        }     
        testcurrentServer += '/apex/partnerportallanding?un=test@un.com&pw=password&comm=y&startURL=strturl1';
		PageReference pageRef = new PageReference(testcurrentServer);
        
        Test.setCurrentPage(pageRef);
        
        partnerportallandingController ppl = new partnerportallandingController();
        ppl.forwardToPartnerPortalHome();
    }*/
    
}