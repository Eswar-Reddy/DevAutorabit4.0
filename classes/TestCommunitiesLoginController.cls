@isTest(seeAllData=true)
private class TestCommunitiesLoginController {
    
    //Test Method for code coverage of CommunityLoginController
    static testmethod void testCommunitieslogin() {
        test.startTest();
        PageReference pageRef = Page.CommunityLogin;
        Test.setCurrentPage(pageRef);
        
        ApexPages.currentPage().getHeaders().put('Accept-Language','en-US'); 
        System.debug('CurrentPage Headers -----'+ApexPages.currentPage().getHeaders());
        CommunityLoginController clc1 = new CommunityLoginController();
        clc1.username = 'test@salesforce.com';
        clc1.password = '123456';
        System.assertEquals(clc1.login(),null);
        ApexPages.currentPage().getParameters().put('startURL','/home/home.jsp');
        clc1.login();
        test.stopTest();
    }

    static testmethod void testpartnerportallogin() {
        test.startTest();
        PageReference pageRef = Page.partnerportallogin;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getHeaders().put('Accept-Language','en-US');
        ApexPages.currentPage().getParameters().put('startURL','/home/home.jsp');
        PartnerPortalSiteLoginController ppsl = new PartnerPortalSiteLoginController ();
        ppsl.authCurrentUser();
        test.stopTest();
    }
    
}