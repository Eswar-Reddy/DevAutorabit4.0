@isTest
public class CreatePartnerApplicationTestData {
    @TestVisible private Lead lead_1;
    
    @TestVisible
    private void createTestData() {
        // lead    
        lead_1 = getNewLead('lead_1', 'lead_1');
        lead_1.LeadSource = 'Web';    // required
        lead_1.Email = 'lead_1@sp.com';    // Email or Phone Number is required
        
        // we will insert in test methods
    }
    
    private static Lead getNewLead(String firstName, String lastName) {
        Lead l = new Lead();
        l.FirstName = firstName;
        l.LastName = lastName;    
        return l;    
    }
    
}