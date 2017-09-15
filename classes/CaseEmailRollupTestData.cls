@isTest
public class CaseEmailRollupTestData {

    public Case case_1;
    public EmailMessage emailMessage_1;
    public List <Case> caseList_1 = new List <Case>();
    
    public void createTestData() {
        // case
        case_1 = new Case();
        case_1.Subject = 'Test';    
    
        insert new List <Case>{case_1};
        
        // email message
        emailMessage_1 = new EmailMessage();
        emailMessage_1.FromAddress = 'fromtest@sunpower.com';
        emailMessage_1.Incoming = true; 
        emailMessage_1.ToAddress = 'totest@sunpower.com';
        emailMessage_1.Subject = 'Test subject';
        emailMessage_1.TextBody = 'Test body'; 
        emailMessage_1.ParentId = case_1.Id;
        emailMessage_1.Status = '0';    // New=0, Read=1, Replied=2, Sent=3, Forwarded=4, Draft=5
        
        insert new List <EmailMessage>{emailMessage_1};
            
    }
    
    public void createTestDataBulk(Integer caseSize, Integer messageSize) {
        for (Integer i=0; i<caseSize; i++) {    
            Case c = new Case(Subject = 'Test');    
            caseList_1.add(c);
        }
        insert caseList_1;
        
        List <EmailMessage> emList = new List <EmailMessage>();
        for (Case c : caseList_1) {
            for (Integer j=0; j<messageSize; j++) {        
                EmailMessage em = new EmailMessage();
                em.FromAddress = 'fromtest@sunpower.com';
                em.Incoming = true; 
                em.ToAddress = 'totest@sunpower.com';
                em.Subject = 'Test subject';
                em.TextBody = 'Test body'; 
                em.ParentId = c.Id;
                em.Status = '0';    // New=0, Read=1, Replied=2, Sent=3, Forwarded=4, Draft=5
                
                emList.add(em);        
            }
        }
        insert emList;
        
    }
    
}