@isTest
public class RMACaseTeamTest {
    private static testMethod void test_caseTeam() {
        RMACaseTeamTestData td = new RMACaseTeamTestData();
        td.createTestData_caseTeam();
        
        // verify if rma owner is added to case team
        List <CaseTeamMember> ctmList = [SELECT Id, MemberId, TeamRole.Name FROM CaseTeamMember WHERE ParentId = :td.case_1.Id];
        system.assertEquals(1, ctmList.size());
        system.assertEquals(UserInfo.getUserId(), ctmList[0].MemberId);
        system.assertEquals('RMA Owner', ctmList[0].TeamRole.Name);
        //Creating RMA line item for RMA to honor RMA Line Item Validation Rule 
        RMA_Line_Item__c rmaLineItem=new RMA_Line_Item__c();
        rmaLineItem.RMA__c=td.rma_1.Id;
        rmaLineItem.Name='Test';
        rmaLineItem.OEM__c='Fronius';
        rmaLineItem.Type__c='Return';
        rmaLineItem.Expected_Return_Quantity__c=1;
        insert rmaLineItem;
        // change owner
        td.rma_1.RMA_Owner__c = td.user_2.Id; 
        update td.rma_1;
        ctmList = [SELECT Id, MemberId, TeamRole.Name FROM CaseTeamMember WHERE ParentId = :td.case_1.Id];
        system.assertEquals(2, ctmList.size());
        Set <String> memberIdSet = new Set <String>();
        for (CaseTeamMember ctm : ctmList) {
            system.assertEquals('RMA Owner', ctm.TeamRole.Name);
            memberIdSet.add(ctm.MemberId);
        }
        system.assert(true, memberIdSet.contains(td.user_1.Id));
        system.assert(true, memberIdSet.contains(td.user_2.Id));
        
    }
    
}