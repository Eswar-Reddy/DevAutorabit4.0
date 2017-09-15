@isTest
public class ResidentialProjectTrigger_Test {

    // On Project creation, any Note or Document records connected to Opportunity and Roof Detail records connected to Quote should transfer over
    static testMethod void testPreProjectRecords() {
        Account customer = TestFactory_StandardObjects.getResidentialCustomerAccount();

        Opportunity opp = TestFactory_StandardObjects.createHomeOwnerOpportunity(customer.Id, NULL);
        insert opp;

        Note n = new Note(ParentId = opp.Id, Title = 'Test', Body = 'Test Body' );
        insert n;

        Document__c doc = new Document__c();
        doc.RecordTypeId = Schema.SObjectType.Document__c.getRecordTypeInfosByName().get('Document').getRecordTypeId();
        doc.Opportunity__c = opp.Id;
        doc.Name = 'Test Doc';
        doc.Document_Type__c = 'Test Doc';
        insert doc;

        Quote q = TestFactory_StandardObjects.createProposalQuote(opp.Id);
        insert q;

        Roof_Design__c roofDesign = new Roof_Design__c();
        roofDesign.RecordTypeId = Schema.SObjectType.Roof_Design__c.getRecordTypeInfosByName().get('Residential Actual Design').getRecordTypeId();
        roofDesign.Account_Name__c = customer.Id;
        roofDesign.Quote__c = q.Id;
        insert roofDesign;

        Roof_Details__c rd = new Roof_Details__c(Roof_Design__c = roofDesign.Id, Name = 'Test Roof');
        insert rd;

        Test.startTest();
        Residential_Project__c project = TestFactory_ResidentialProjMgmt.createSPDProjectWithTemplate(customer.Id, opp.Id, q.Id, NULL);
        insert project;

        Residential_Project__c p = [SELECT Id, (SELECT Id, Name FROM Roof_Details__r), (SELECT Id, Name, Document_Type__c FROM Documents__r WHERE Name = 'Test Doc'), (SELECT Id, Title, Body FROM Notes), (SELECT Id, User__c, Role__c FROM Project_Team_Members__r WHERE Role__c = 'Regional Operations Manager') FROM Residential_Project__c WHERE Id =: project.Id];
        system.assertEquals(p.Roof_Details__r.size(), 1);
        system.assertEquals(p.Notes.size(), 1);
        system.assertEquals(p.Documents__r.size(), 1);
        system.assertEquals(p.Documents__r[0].Document_Type__c, 'Test Doc');
        Test.stopTest();

    }

    static testMethod void testIPUserAssignment(){
        Account partner = TestFactory_StandardObjects.getPartnerAccount();

        Project_Installation_Setting__c pis = TestFactory_ResidentialProjMgmt.createPISettingIPUserAssignment(partner.Id, UserInfo.getUserId());
        pis.Role__c = 'Regional Operations Manager';
        insert pis;

        Test.startTest();
        Residential_Project__c project = TestFactory_ResidentialProjMgmt.createSPDProjectWithTemplate(NULL, NULL, NULL, NULL);
        project.Installation_Partner__c = partner.Id;
        insert project;

        Residential_Project__c p = [SELECT Id, (SELECT Id, User__c, Role__c FROM Project_Team_Members__r WHERE Role__c = 'Regional Operations Manager') FROM Residential_Project__c WHERE Id =: project.Id];
        system.assertEquals(p.Project_Team_Members__r.size(), 1);
        system.assertEquals(p.Project_Team_Members__r[0].User__c, UserInfo.getUserId());

    }

    static void testIPAutoAssignment(){
        List<Account> accToInsert = new List<Account>();

        Account customer = TestFactory_StandardObjects.createResidentialCustomerAccount();
        customer.BillingPostalCode = '50123';
        accToInsert.add(customer);

        Account partner = TestFactory_StandardObjects.createPartnerAccount();
        partner.Name = 'SPRI - Fremont';
        accToInsert.add(partner);

        insert accToInsert;

        Project_Installation_Setting__c pis = TestFactory_ResidentialProjMgmt.createPISettingIPRegion(partner.Id);
        pis.Zip_Code__c = '50123';
        insert pis;
        
        Test.startTest();
        Residential_Project__c project = TestFactory_ResidentialProjMgmt.createSPDProject(customer.Id, NULL, NULL);
        insert project;
        
        Residential_Project__c p = [SELECT Id, Installation_Partner__r.Name FROM Residential_Project__c WHERE Id =: project.Id];
        system.assertEquals(p.Installation_Partner__r.Name, 'SPRI - Fremont');
        Test.stopTest();
    }

    //@isTest
    //static void testUpdateTeamRoles() {
    //    Id partnerRTId = [SELECT Id, Name FROM RecordType WHERE Name = 'Partner' LIMIT 1].Id;

    //    Residential_Project__c tempRP = [SELECT ID, NAME FROM Residential_Project__c WHERE Name = 'SPD Template' LIMIT 1];

    //    Account aPartner = new Account(Name = 'SPRI - Fremont' , BillingCity = 'San Jose', BillingState = 'CA', BillingCountry = 'US', BillingStreet = '123 Main St', BillingPostalCode = '12345', RecordTypeId = partnerRTId);
    //    insert aPartner;

    //    tempRP.Installation_Partner__c = aPartner.Id;
    //    update tempRP;

    //    System.assertEquals(tempRP.Installation_Partner__r.Name, 'SPRI - Fremont'); 
    //}

    static testMethod void testAutoIPandTemplate(){
        List<Account> accToInsert = new List<Account>();
        List<Project_Installation_Setting__c> pisToInsert = new List<Project_Installation_Setting__c>();

        Account customer = TestFactory_StandardObjects.createResidentialCustomerAccount();
        customer.BillingPostalCode = '50123';
        accToInsert.add(customer);

        Account partner = TestFactory_StandardObjects.createPartnerAccount();
        partner.Name = 'SPRI - Fremont';
        accToInsert.add(partner);

        insert accToInsert;

        Residential_Project__c template = TestFactory_ResidentialProjMgmt.createProjectTemplate();
        template.Name = 'Test Template';
        insert template;

        Project_Installation_Setting__c pis = TestFactory_ResidentialProjMgmt.createPISettingIPRegion(partner.Id);
        pis.Zip_Code__c = '50123';
        pisToInsert.add(pis);

        Project_Installation_Setting__c pis2 = TestFactory_ResidentialProjMgmt.createPISettingIPTemplate(partner.Id, template.Id);
        pisToInsert.add(pis2);

        insert pisToInsert;
        
        Test.startTest();
        Residential_Project__c project = TestFactory_ResidentialProjMgmt.createSPDProject(customer.Id, NULL, NULL);
        insert project;
        
        Residential_Project__c p = [SELECT Id, Installation_Partner__r.Name, Project_Template__r.Name FROM Residential_Project__c WHERE Id =: project.Id];
        system.assertEquals(p.Installation_Partner__r.Name, 'SPRI - Fremont');
        system.assertEquals(p.Project_Template__r.Name, 'Test Template');
        Test.stopTest();
    }

    static testMethod void testProjectCancelled(){

        Residential_Project__c project = TestFactory_ResidentialProjMgmt.createSPDProjectWithTemplate(NULL,NULL,NULL,NULL);
        project.Status__c = 'Active';
        insert project;

        Test.startTest();
        Project_Team_Member__c ptm = new Project_Team_Member__c();
        ptm.User__c = UserInfo.getUserId();
        ptm.Residential_Project__c = project.Id;
        ptm.Role__c = 'Regional Operations Manager';
        insert ptm;

        project.Status__c = 'Cancelled';
        project.Cancellation_Justification__c = 'Homeowner Death';
        update project;

        List<Project_Task__c> tasks = [SELECT Id, Status__c FROM Project_Task__c WHERE Residential_Project__c =: project.Id];
        system.assertEquals(tasks.size(), 5);
        system.assertEquals(tasks[0].Status__c, 'Cancelled');
        system.assertEquals(tasks[1].Status__c, 'Cancelled');
        system.assertEquals(tasks[2].Status__c, 'Cancelled');
        system.assertEquals(tasks[3].Status__c, 'Cancelled');
        system.assertEquals(tasks[4].Status__c, 'Cancelled');

        Test.stopTest();
    }

    static testMethod void testProjectQuoteInsert() {

        Test.startTest();

        Opportunity o = TestFactory_StandardObjects.getHomeOwnerOpportunity();

        List<Quote> quotes = new List<Quote>();
        Quote q = TestFactory_StandardObjects.createProposalQuote(o.Id);
        q.Name = 'Test Quote 1';
        quotes.add(q);

        Quote q2 = TestFactory_StandardObjects.createProposalQuote(o.Id);
        q2.Name = 'Test Quote 1';
        quotes.add(q2);
        insert quotes;

        Roof_Design__c roofDesign = new Roof_Design__c();
        roofDesign.RecordTypeId = Schema.SObjectType.Roof_Design__c.getRecordTypeInfosByName().get('Residential Actual Design').getRecordTypeId();
        roofDesign.Quote__c = q.Id;
        insert roofDesign;

        Roof_Design__c roofDesign2 = new Roof_Design__c();
        roofDesign2.RecordTypeId = Schema.SObjectType.Roof_Design__c.getRecordTypeInfosByName().get('Residential Actual Design').getRecordTypeId();
        roofDesign2.Quote__c = q2.Id;
        insert roofDesign2;

        List<Roof_Details__c> details = new List<Roof_Details__c>();
        Roof_Details__c rd = new Roof_Details__c(Roof_Design__c = roofDesign.Id, Name = 'Test Roof');
        details.add(rd);

        Roof_Details__c rd2 = new Roof_Details__c(Roof_Design__c = roofDesign2.Id, Name = 'Test Roof 2');
        details.add(rd2);

        Roof_Details__c rd3 = new Roof_Details__c(Roof_Design__c = roofDesign2.Id, Name = 'Test Roof 3');
        details.add(rd3);
        insert details;
        
        Residential_Project__c testProject = TestFactory_ResidentialProjMgmt.createSPDProject(NULL, o.Id, q.Id);
        insert testProject;
        Test.stopTest();

        Residential_Project__c rp = [SELECT Id, (SELECT Id, Name FROM Roof_Details__r) FROM Residential_Project__c WHERE Id =: testProject.Id];
        system.assertEquals(rp.Roof_Details__r.size(), 1);
        system.assertEquals(rp.Roof_Details__r[0].Name, 'Test Roof');
        
        testProject.Quote__c = q2.Id;
        update testProject;

        Residential_Project__c rp2 = [SELECT Id, (SELECT Id, Name FROM Roof_Details__r ORDER BY Name) FROM Residential_Project__c WHERE Id =: testProject.Id];
        system.assertEquals(rp2.Roof_Details__r.size(), 2);
        system.assertEquals(rp2.Roof_Details__r[0].Name, 'Test Roof 2');
        system.assertEquals(rp2.Roof_Details__r[1].Name, 'Test Roof 3');
        
    }

    // Document records should be deleted when a project is deleted to prevent orphans
    static testMethod void testProjectDelete(){
        Residential_Project__c project = TestFactory_ResidentialProjMgmt.createSPDProject(NULL,NULL,NULL);
        insert project;

        List<Document__c> docs = TestFactory_ResidentialProjMgmt.createProjectDocuments(project.Id, 5);
        insert docs;

        delete project;

        List<Document__c> d = [SELECT Id FROM Document__c WHERE Residential_Project__c = NULL];
        system.assertEquals(d.size(), 0);
    }

    static testMethod void testNHUserAssignmentOnUpdate(){
        Residential_Project__c template = TestFactory_ResidentialProjMgmt.getProjectTemplate();

        NH_Community__c community = TestFactory_ResidentialProjMgmt.getNHCommunity();

        Project_Installation_Setting__c pis = TestFactory_ResidentialProjMgmt.createPISettingNHUserAssignment(community.Id, UserInfo.getUserId());
        pis.Role__c = 'Project Manager';
        insert pis;

        Test.startTest();
        Residential_Project__c project = TestFactory_ResidentialProjMgmt.createNewHomeProject(NULL,NULL,NULL,community.Id);
        insert project; 

        project.Project_Template__c = template.Id;
        update project;

        Residential_Project__c p = [SELECT Id, (SELECT User__c FROM Project_Team_Members__r WHERE Role__c = 'Project Manager') FROM Residential_Project__c WHERE Id =: project.Id];
        system.assertEquals(p.Project_Team_Members__r.size(), 1);
        system.assertEquals(p.Project_Team_Members__r[0].User__c, UserInfo.getUserId());
        Test.stopTest();
    }

    @isTest
    static void testJCOTasks(){
        Residential_Project__c project = TestFactory_ResidentialProjMgmt.createSPDProject(NULL, NULL, NULL);
        insert project;

        Project_Task__c task = new Project_Task__c();
        task.Name = 'System Installation Complete';
        task.Status__c = 'In Progress';
        task.Assigned_To__c = UserInfo.getUserId();
        task.Residential_Project__c = project.Id;
        task.RecordTypeId = Schema.SObjectType.Project_Task__c.getRecordTypeInfosByName().get('Project Task').getRecordTypeId();
        insert task;

        sked__Region__c reg = new sked__Region__c();
        reg.Name = 'Test Region';
        reg.sked__Timezone__c = 'Pacific';
        insert reg;

        sked__Job__c job = new sked__Job__c();
        job.Project_Task__c = task.Id;
        job.sked__Duration__c = 2;
        job.sked__Region__c = reg.Id;
        insert job;

        Form__c form = new Form__c();
        form.RecordTypeId = Schema.SObjectType.Form__c.getRecordTypeInfosByName().get('Job Checkout Form').getRecordTypeId();
        form.Job__c = job.Id;
        form.Project_Task__c = task.Id;
        insert form;

        Attachment att = new Attachment();
        att.Body = Blob.valueOF('ABCD');
        att.Name = 'Modules installed - show all panels in entire system (3)';
        att.contentType = '.jpg';
        att.ParentId = form.Id;
        insert att;

        // START ******* THIS CAN BE REMOVED AFTER THE CUT OVER TO Invoice Compliance Documents
        LeasePayment__c lp = new LeasePayment__c();
        lp.Account__c       = TestFactory_StandardObjects.getResidentialCustomerAccount().Id;
        lp.Opportunity__c   = TestFactory_StandardObjects.getHomeOwnerOpportunity().Id;
        lp.Quote__c         = TestFactory_StandardObjects.getProposalQuote().Id;
        lp.Residential_Project__c = project.Id;
        insert lp;

        Invoice_Documents__c inv = new Invoice_Documents__c();
        inv.Name = 'Photos';
        inv.Invoice_Type__c = 'Install';
        inv.Lease_Payment__c = lp.Id;
        inv.Documents_in_File__c = 'Photos';
        insert inv;
        // END ******* THIS CAN BE REMOVED AFTER THE CUT OVER TO Invoice Compliance Documents

        Invoice_Compliance_Document__c icd = new Invoice_Compliance_Document__c();
        icd.Name = 'Photos';
        icd.Invoice_Type__c = 'Install';
        icd.Residential_Project__c = project.Id;
        icd.Documents_in_File__c = 'Photos';
        insert icd;

        Test.startTest();
            task.Status__c = 'Completed';
            update task;
        Test.stopTest();

        // START ******* THIS CAN BE REMOVED AFTER THE CUT OVER TO Invoice Compliance Documents
        List<Attachment> atts2 = [SELECT Id, Name FROM Attachment WHERE ParentId =: inv.Id];
        system.assertEquals(atts2.size(), 1);
        system.assertEquals(atts2[0].Name, 'Photos.pdf');
        // END ******* THIS CAN BE REMOVED AFTER THE CUT OVER TO Invoice Compliance Documents

        List<Attachment> atts = [SELECT Id, Name FROM Attachment WHERE ParentId =: icd.Id];
        system.assertEquals(atts.size(), 1);
        system.assertEquals(atts[0].Name, 'Photos.pdf');
    }

    static testMethod void testNHProjectDefaults(){
        NH_Community__c community = TestFactory_ResidentialProjMgmt.getNHCommunity();
        community.Total_Number_of_Sets__c = 90;
        community.Sheet_Size__c = 'Test1';
        update community;

        Test.startTest();
        Residential_Project__c project = TestFactory_ResidentialProjMgmt.createNewHomeProject(NULL,NULL,NULL,community.Id);
        insert project; 

        Residential_Project__c p = [SELECT Id, Sheet_Size_Proj__c, Total_Number_of_Sets_Proj__c FROM Residential_Project__c WHERE Id =: project.Id];
        system.assertEquals(p.Sheet_Size_Proj__c, 'Test1');
        system.assertEquals(p.Total_Number_of_Sets_Proj__c, 90);
        Test.stopTest();
    }

    static testMethod void testUncancellingProject(){        
        Residential_Project__c project = TestFactory_ResidentialProjMgmt.createSPDProjectWithTemplate(NULL,NULL,NULL,NULL);
        insert project;
        Test.startTest();
        Project_Team_Member__c ptm = new Project_Team_Member__c();
        ptm.Residential_Project__c = project.Id;
        ptm.User__c = UserInfo.getUserId();
        ptm.Role__c = 'PC Supervisor';
        insert ptm;
        List<Project_Task__c> tasks = [SELECT Id, Status__c, Order__c FROM Project_Task__c WHERE Residential_Project__c =: project.Id ORDER BY Order__c ASC];
        system.assertEquals(tasks[0].Order__c, 1);
        system.assertEquals(tasks[0].Status__c, 'In Progress');

        tasks[0].Status__c = 'Completed';
        update tasks[0];
     
        project.Status__c = 'Cancelled';
        project.Cancellation_Justification__c = 'Other';
        update project;
        List<Project_Task__c> tasks2 = [SELECT Id, Status__c, Order__c FROM Project_Task__c WHERE Residential_Project__c =: project.Id ORDER BY Order__c ASC];
        system.assertEquals(tasks2[0].Order__c, 1);
        system.assertEquals(tasks2[0].Status__c, 'Completed');
        system.assertEquals(tasks2[1].Status__c, 'Cancelled');
        system.assertEquals(tasks2[2].Status__c, 'Cancelled');
        system.assertEquals(tasks2[3].Status__c, 'Cancelled');
        system.assertEquals(tasks2[4].Status__c, 'Cancelled');
           
        project.Status__c = 'Active';
        update project;

        List<Project_Task__c> tasks3 = [SELECT Id, Status__c, Order__c FROM Project_Task__c WHERE Residential_Project__c =: project.Id ORDER BY Order__c ASC];
        system.assertEquals(tasks3[0].Order__c, 1);
        system.assertEquals(tasks3[0].Status__c, 'Completed');
        system.assertEquals(tasks3[1].Status__c, 'In Progress');
        system.assertEquals(tasks3[2].Status__c, 'Not Started');
        system.assertEquals(tasks3[3].Status__c, 'Not Started');
        system.assertEquals(tasks3[4].Status__c, 'Not Started');
        Test.stopTest();

    }

  
    static testMethod void testUncancellingProjectRework(){
        Util.setInContextOfLeadConversion() ;
        Residential_Project__c project = TestFactory_ResidentialProjMgmt.createSPDProject(NULL,NULL,NULL);
        insert project;

        List<Project_Task__c> tasks = TestFactory_ResidentialProjMgmt.createProjectTasks(project.Id, 4);
        tasks[0].Status__c = 'In Progress';
        insert tasks;

        Project_Team_Member__c ptm = new Project_Team_Member__c();
        ptm.Residential_Project__c = project.Id;
        ptm.User__c = UserInfo.getUserId();
        ptm.Role__c = 'PC Supervisor';
        insert ptm;

        tasks[0].Status__c = 'Completed';
        update tasks[0]; 

        Test.startTest();
        Task_Rework_Request__c trr = new Task_Rework_Request__c();
        trr.Initiating_Task__c = tasks[1].Id;
        trr.Rework_Task__c = tasks[0].Id;
        insert trr; 
     
        project.Status__c = 'Cancelled';
        project.Cancellation_Justification__c = 'Other';
        update project;

        List<Project_Task__c> tasks2 = [SELECT Id, Status__c, Order__c FROM Project_Task__c WHERE Residential_Project__c =: project.Id ORDER BY Order__c ASC];
        system.assertEquals(tasks2[0].Order__c, 1);
        system.assertEquals(tasks2[0].Status__c, 'Cancelled');
        system.assertEquals(tasks2[1].Status__c, 'Cancelled');
        system.assertEquals(tasks2[2].Status__c, 'Cancelled');
        system.assertEquals(tasks2[3].Status__c, 'Cancelled');
           
        project.Status__c = 'Active';
        update project;

        List<Project_Task__c> tasks3 = [SELECT Id, Status__c, Order__c FROM Project_Task__c WHERE Residential_Project__c =: project.Id ORDER BY Order__c ASC];
        system.assertEquals(tasks3[0].Order__c, 1);
        system.assertEquals(tasks3[0].Status__c, 'Needs Rework');
        system.assertEquals(tasks3[1].Status__c, 'Pending Rework');
        system.assertEquals(tasks3[2].Status__c, 'Not Started');
        system.assertEquals(tasks3[3].Status__c, 'Not Started');
        Test.stopTest();

    }
}