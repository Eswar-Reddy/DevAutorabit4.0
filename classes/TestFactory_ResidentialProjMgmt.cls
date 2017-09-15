@isTest
public class TestFactory_ResidentialProjMgmt {

    //---------------------------- NH Community --------------------------------
    
    private static  NH_Community__c nhCommunity;

    public static NH_Community__c getNHCommunity(){
        if(nhCommunity == NULL){
            NH_Community__c nhc = createNHCommunity(NULL, NULL);
            insert nhc;
            nhCommunity = nhc;
        }
        return nhCommunity;
    }

    public static NH_Community__c createNHCommunity(Id installerId, Id builderId){
        if(installerId == NULL) installerId = TestFactory_StandardObjects.getPartnerAccount().Id;
        if(builderId == NULL){
            Account a = TestFactory_StandardObjects.createPartnerAccount();
            insert a;
            builderId = a.Id;
        }
        NH_Community__c c 	= (NH_Community__c)SmartFactory.createSObject('NH_Community__c',false);
        c.Installer__c 		= installerId;
        c.Builder__c 		= builderId;
        return c;
    }

    //---------------------------- Alliance Partner --------------------------------

    public static Alliance_Partner__c createCommunityAlliancePartner(Id nhCommunityId, Id partnerId){
    	if(nhCommunityId == NULL) 	nhCommunityId 	= getNHCommunity().Id;
    	if(partnerId == NULL) 		partnerId 		= TestFactory_StandardObjects.getPartnerAccount().Id;

    	String recTypeId = Schema.SObjectType.Alliance_Partner__c.getRecordTypeInfosByName().get('Community Alliance Partner').getRecordTypeId();

    	Alliance_Partner__c ap = (Alliance_Partner__c)SmartFactory.createSObject('Alliance_Partner__c',false);
    	ap.RecordTypeId 		= recTypeId;
    	ap.Community__c 		= nhCommunityId;
    	ap.Partner_Account__c 	= partnerId;
    	return ap;
    }

    public static Alliance_Partner__c createProjectAlliancePartner(Id projectId, Id partnerId){
        if(projectId == NULL)       projectId       = getspdProject().Id;
        if(partnerId == NULL)       partnerId       = TestFactory_StandardObjects.getPartnerAccount().Id;

        String recTypeId = Schema.SObjectType.Alliance_Partner__c.getRecordTypeInfosByName().get('Project Alliance Partner').getRecordTypeId();

        Alliance_Partner__c ap = (Alliance_Partner__c)SmartFactory.createSObject('Alliance_Partner__c',false);
        ap.RecordTypeId             = recTypeId;
        ap.Residential_Project__c   = projectId;
        ap.Partner_Account__c       = partnerId;
        return ap;
    }

    public static Alliance_Partner__c createTPSAlliancePartner(Id projectId, Id partnerId){
        if(projectId == NULL)       projectId       = getTPSProject().Id;
        if(partnerId == NULL)       partnerId       = TestFactory_StandardObjects.getPartnerAccount().Id;

        String recTypeId = Schema.SObjectType.Alliance_Partner__c.getRecordTypeInfosByName().get('Project Alliance Partner').getRecordTypeId();

        Alliance_Partner__c ap = (Alliance_Partner__c)SmartFactory.createSObject('Alliance_Partner__c',false);
        ap.RecordTypeId             = recTypeId;
        ap.Residential_Project__c   = projectId;
        ap.Partner_Account__c       = partnerId;
        return ap;
    }

    public static Alliance_Partner__c createNHAlliancePartner(Id projectId, Id partnerId){
        if(projectId == NULL)       projectId       = getNewHomeProject().Id;
        if(partnerId == NULL)       partnerId       = TestFactory_StandardObjects.getPartnerAccount().Id;

        String recTypeId = Schema.SObjectType.Alliance_Partner__c.getRecordTypeInfosByName().get('Project Alliance Partner').getRecordTypeId();

        Alliance_Partner__c ap = (Alliance_Partner__c)SmartFactory.createSObject('Alliance_Partner__c',false);
        ap.RecordTypeId             = recTypeId;
        ap.Residential_Project__c   = projectId;
        ap.Partner_Account__c       = partnerId;
        return ap;
    }

    //---------------------------- Residential Project --------------------------------

    private static Residential_Project__c projectTemplate;
    private static Residential_Project__c newHomeProject;
    private static Residential_Project__c spdProject;
    private static Residential_Project__c tpsProject;
    private static Residential_Project__c newHomeProjectWithTemplate;
    private static Residential_Project__c spdProjectWithTemplate;
    private static Residential_Project__c tpsProjectWithTemplate;

    public static Residential_Project__c getProjectTemplate(){
        if(projectTemplate == NULL){            
            Residential_Project__c rp = createProjectTemplate();
            insert rp;
            projectTemplate = rp;

            insert createTemplateTasks(rp.Id, 5);
            insert createTemplateTeamMembers(rp.Id, 5);
            insert createProjectDocuments(rp.Id, 5);
        }
        return projectTemplate;
    }

    public static Residential_Project__c getProjectTemplateTaskOnly(){
        if(projectTemplate == NULL){            
            Residential_Project__c rp = createProjectTemplate();
            insert rp;
            projectTemplate = rp;

            insert createTemplateTasks(rp.Id, 5);
        }
        return projectTemplate;
    }

    public static Residential_Project__c createProjectTemplate(){
    	String recTypeId = Schema.SObjectType.Residential_Project__c.getRecordTypeInfosByName().get('Project Template').getRecordTypeId();
            
        Residential_Project__c rp = (Residential_Project__c)SmartFactory.createSObject('Residential_Project__c',false);
        rp.RecordTypeId = recTypeId;
        return rp;
    }

    public static Residential_Project__c getNewHomeProject(){
        if(newHomeProject == NULL){
            Residential_Project__c rp = createNewHomeProject(NULL, NULL, NULL, NULL);
            insert rp;
            newHomeProject = rp;
        }
        return newHomeProject;
    }

    public static Residential_Project__c createNewHomeProject(Id accountId, Id opportunityId, Id quoteId, Id nhCommunityId){
        if(accountId == NULL) 		accountId 		= TestFactory_StandardObjects.getResidentialCustomerAccount().Id;
        if(opportunityId == NULL) 	opportunityId 	= TestFactory_StandardObjects.getHomeOwnerOpportunity().Id;
        if(quoteId == NULL) 		quoteId 		= TestFactory_StandardObjects.getProposalQuote().Id;
        if(nhCommunityId == NULL) 	nhCommunityId 	= getNHCommunity().Id;
        
        String recTypeId = Schema.SObjectType.Residential_Project__c.getRecordTypeInfosByName().get('New Home').getRecordTypeId();
        
        Residential_Project__c rp = (Residential_Project__c)SmartFactory.createSObject('Residential_Project__c',false);
        rp.RecordTypeId 	= recTypeId;
        rp.Account__c 		= accountId;
        rp.Opportunity__c 	= opportunityId;
        rp.Quote__c 		= quoteId;
        rp.Community__c 	= nhCommunityId;
        

        return rp;
    }

    public static Residential_Project__c createNewHomeProjectNoAccountQuoteOpp(Id nhCommunityId){
        if(nhCommunityId == NULL)   nhCommunityId   = getNHCommunity().Id;

        String recTypeId = Schema.SObjectType.Residential_Project__c.getRecordTypeInfosByName().get('New Home').getRecordTypeId();

        Residential_Project__c rp = (Residential_Project__c)SmartFactory.createSObject('Residential_Project__c',false);
        rp.RecordTypeId     = recTypeId;
        rp.Community__c     = nhCommunityId;

        return rp;
    }

    public static Residential_Project__c getNewHomeProjectWithTemplate(){
        if(newHomeProjectWithTemplate == NULL){
            Residential_Project__c rp = createNewHomeProjectWithTemplate(NULL, NULL, NULL, NULL, NULL);
            insert rp;
            newHomeProjectWithTemplate = rp;
        }
        return newHomeProjectWithTemplate;
    }

    public static Residential_Project__c createNewHomeProjectWithTemplate(Id accountId, Id opportunityId, Id quoteId, Id nhCommunityId, Id templateId){
        if(templateId == NULL) templateId = getProjectTemplate().Id;
        
        Residential_Project__c rp = createNewHomeProject(accountId, opportunityId, quoteId, nhCommunityId);
        rp.Project_Template__c = templateId;
        return rp;
    }

    public static Residential_Project__c createNewHomeProjectWithTemplateTaskOnly(Id accountId, Id opportunityId, Id quoteId, Id nhCommunityId, Id templateId){
        if(templateId == NULL) templateId = getProjectTemplateTaskOnly().Id;
        
        Residential_Project__c rp = createNewHomeProject(accountId, opportunityId, quoteId, nhCommunityId);
        rp.Project_Template__c = templateId;
        return rp;
    }

    public static Residential_Project__c getTPSProject(){
        if(tpsProject == NULL){
            Residential_Project__c rp = createTPSProject(NULL, NULL, NULL);
            insert rp;
            tpsProject = rp;

        }
        return tpsProject;
    }

    public static Residential_Project__c createTPSProject(Id accountId, Id opportunityId, Id quoteId){
        if(accountId == NULL) 		accountId 		= TestFactory_StandardObjects.getResidentialCustomerAccount().Id;
        if(opportunityId == NULL) 	opportunityId 	= TestFactory_StandardObjects.getHomeOwnerOpportunity().Id;
        if(quoteId == NULL) 		quoteId 		= TestFactory_StandardObjects.getProposalQuote().Id;
        
        String recTypeId = Schema.SObjectType.Residential_Project__c.getRecordTypeInfosByName().get('TPS').getRecordTypeId();
        
        Residential_Project__c rp = (Residential_Project__c)SmartFactory.createSObject('Residential_Project__c',false);
        rp.RecordTypeId 	= recTypeId;
        rp.Account__c 		= accountId;
        rp.Opportunity__c 	= opportunityId;
        rp.Quote__c 		= quoteId;
        return rp;
    }

    public static Residential_Project__c getTPSProjectWithTemplate(){
        if(tpsProjectWithTemplate == NULL){
            Residential_Project__c rp = createTPSProjectWithTemplate(NULL, NULL, NULL, NULL);
            insert rp;
            tpsProjectWithTemplate = rp;

        }
        return tpsProjectWithTemplate;
    }

    public static Residential_Project__c createTPSProjectWithTemplate(Id accountId, Id opportunityId, Id quoteId, Id templateId){
        if(templateId == NULL) templateId = getProjectTemplate().Id;
        
        Residential_Project__c rp = createTPSProject(accountId, opportunityId, quoteId);
        rp.Project_Template__c = templateId;
        return rp;
    }

    public static Residential_Project__c createTPSProjectWithTemplateTaskOnly(Id accountId, Id opportunityId, Id quoteId, Id templateId){
        if(templateId == NULL) templateId = getProjectTemplateTaskOnly().Id;
        
        Residential_Project__c rp = createTPSProject(accountId, opportunityId, quoteId);
        rp.Project_Template__c = templateId;
        return rp;
    }

    public static Residential_Project__c getSPDProject(){
        if(spdProject == NULL){
            Residential_Project__c rp = createSPDProject(NULL, NULL, NULL);
            insert rp;
            spdProject = rp;
        }
        return spdProject;
    }

    public static Residential_Project__c createSPDProject(Id accountId, Id opportunityId, Id quoteId){
        if(accountId == NULL) 		accountId 		= TestFactory_StandardObjects.getResidentialCustomerAccount().Id;
        if(opportunityId == NULL) 	opportunityId 	= TestFactory_StandardObjects.getHomeOwnerOpportunity().Id;
        if(quoteId == NULL) 		quoteId 		= TestFactory_StandardObjects.getProposalQuote().Id;
        
        String recTypeId = Schema.SObjectType.Residential_Project__c.getRecordTypeInfosByName().get('SPD').getRecordTypeId();
        
        Residential_Project__c rp = (Residential_Project__c)SmartFactory.createSObject('Residential_Project__c',false);
        rp.RecordTypeId 	= recTypeId;
        rp.Account__c 		= accountId;
        rp.Opportunity__c 	= opportunityId;
        rp.Quote__c 		= quoteId;
        return rp;
    }

    public static Residential_Project__c getSPDProjectWithTemplate(){
        if(spdProjectWithTemplate == NULL){
            Residential_Project__c rp = createSPDProjectWithTemplate(NULL, NULL, NULL, NULL);
            insert rp;
            spdProjectWithTemplate = rp;
        }
        return spdProjectWithTemplate;
    }

    public static Residential_Project__c createSPDProjectWithTemplate(Id accountId, Id opportunityId, Id quoteId, Id templateId){
        if(templateId == NULL) templateId = getProjectTemplate().Id;
        
        Residential_Project__c rp = createSPDProject(accountId, opportunityId, quoteId);
        rp.Project_Template__c = templateId;
        return rp;
    }

    public static Residential_Project__c createSPDProjectWithTemplateTaskOnly(Id accountId, Id opportunityId, Id quoteId, Id templateId){
        if(templateId == NULL) templateId = getProjectTemplateTaskOnly().Id;
        
        Residential_Project__c rp = createSPDProject(accountId, opportunityId, quoteId);
        rp.Project_Template__c = templateId;
        return rp;
    }

    //---------------------------- Project Task --------------------------------
    
    public static List<Project_Task__c> createTemplateTasks(Id projectId, Integer numOfTasks){        
        String recTypeId = Schema.SObjectType.Project_Task__c.getRecordTypeInfosByName().get('Task Template').getRecordTypeId();
        
        List<Project_Task__c> tasks = new List<Project_Task__c>();
        
        for(Integer i = 1; i <= numOfTasks; i++){
            Project_Task__c pt = (Project_Task__c)SmartFactory.createSObject('Project_Task__c',false);
            pt.RecordTypeId 			= recTypeId;
            pt.Residential_Project__c 	= projectId;
            pt.Order__c 				= i;
            pt.Critical_Path__c 		= TRUE;
            tasks.add(pt);
        }
        return tasks;
    }

    public static List<Project_Task__c> createProjectTasks(Id projectId, Integer numOfTasks){
        String recTypeId = Schema.SObjectType.Project_Task__c.getRecordTypeInfosByName().get('Project Task').getRecordTypeId();

        List<Project_Task__c> tasks = new List<Project_Task__c>();

        for(Integer i = 1; i <= numOfTasks; i++){
            Project_Task__c pt = (Project_Task__c)SmartFactory.createSObject('Project_Task__c',false);
            pt.RecordTypeId             = recTypeId;
            pt.Residential_Project__c   = projectId;
            pt.Assigned_To__c           = UserInfo.getUserId();
            pt.Order__c                 = i;
            pt.Critical_Path__c         = TRUE;
            tasks.add(pt);
        }
        return tasks;
    }

    //---------------------------- Project Team Member --------------------------------

    public static List<Project_Team_Member__c> createTemplateTeamMembers(Id projectId, Integer numOfMembers){
        List<Project_Team_Member__c> members = new List<Project_Team_Member__c>();

        for(Integer i = 0; i < numOfMembers; i++){
            Project_Team_Member__c ptm = new Project_Team_Member__c();
            ptm.Residential_Project__c = projectId;
            ptm.Role__c = i == 0 ? 'Project Manager' : i == 1 ? 'Project Coordinator' : i == 2 ? 'Regional Operations Manager' : i == 3 ? 'Technical Sales Project Manager' : i == 4 ? 'Energy Consultant' : 'Executive User';
            members.add(ptm);
        }
        return members;
    }

	public static Project_Team_Member__c getTeamMember(Id projectId, String role) {
        Project_Team_Member__c tm = new Project_Team_Member__c();
        tm.Residential_Project__c = projectId;
        tm.Role__c = role;
        tm.User__c = UserInfo.getUserId();
        insert tm;
        return tm;
    }
	

    public static Project_Team_Member__c createTeamMember(Id projectId, String role, Id userId) {
        Project_Team_Member__c tm = new Project_Team_Member__c();
        tm.Residential_Project__c = projectId;
        tm.Role__c = role;
        tm.User__c = String.isNotBlank(userId) ? userId : UserInfo.getUserId();
        return tm;
    }

    //---------------------------- Document --------------------------------
    
    public static List<Document__c> createProjectDocuments(Id projectId, Integer numOfMembers){        
        String recTypeId = Schema.SObjectType.Document__c.getRecordTypeInfosByName().get('Document').getRecordTypeId();
        
        List<Document__c> docs = new List<Document__c>();
        
        for(Integer i = 0; i < numOfMembers; i++){
            Document__c d = (Document__c)SmartFactory.createSObject('Document__c',false);
            d.Residential_Project__c = projectId;
            docs.add(d);
        }
        return docs;
    }

    //---------------------------- Project Installation Setting --------------------------------
    
    public static Project_Installation_Setting__c createPISettingIPRegion(Id partnerId){
    	if(partnerId == NULL) partnerId = TestFactory_StandardObjects.getPartnerAccount().Id;
    	
    	String recTypeId = Schema.SObjectType.Project_Installation_Setting__c.getRecordTypeInfosByName().get('IP Regions').getRecordTypeId();
    	
    	Project_Installation_Setting__c pis = (Project_Installation_Setting__c)SmartFactory.createSObject('Project_Installation_Setting__c',false);
    	pis.RecordTypeId 			= recTypeId;
    	pis.Installation_Partner__c = partnerId;
    	return pis;
    }

    public static Project_Installation_Setting__c createPISettingIMTemplate(Id installationModelId, Id templateId){
    	if(installationModelId == NULL) installationModelId = getInstallationModelIP().Id;
    	if(templateId == NULL) 			templateId 			= TestFactory_ResidentialProjMgmt.getProjectTemplate().Id;
    	
    	String recTypeId = Schema.SObjectType.Project_Installation_Setting__c.getRecordTypeInfosByName().get('IM Template').getRecordTypeId();

    	Project_Installation_Setting__c pis = (Project_Installation_Setting__c)SmartFactory.createSObject('Project_Installation_Setting__c',false);
    	pis.RecordTypeId 			= recTypeId;
    	pis.Installation_Model__c 	= installationModelId;
    	pis.Project_Template__c 	= templateId;
    	return pis;
    }

    public static Project_Installation_Setting__c createPISettingIPTemplate(Id partnerId, Id templateId){
    	if(partnerId == NULL) 	partnerId 	= TestFactory_StandardObjects.getPartnerAccount().Id;
		if(templateId == NULL) 	templateId 	= TestFactory_ResidentialProjMgmt.getProjectTemplate().Id;
		
		String recTypeId = Schema.SObjectType.Project_Installation_Setting__c.getRecordTypeInfosByName().get('IP Template').getRecordTypeId();
		
		Project_Installation_Setting__c pis = (Project_Installation_Setting__c)SmartFactory.createSObject('Project_Installation_Setting__c',false);
		pis.RecordTypeId 			= recTypeId;
		pis.Installation_Partner__c = partnerId;
		pis.Project_Template__c 	= templateId;
    	return pis;
    }

    public static Project_Installation_Setting__c createPISettingIPUserAssignment(Id partnerId, Id userId){
    	if(partnerId == NULL) 	partnerId 	= TestFactory_StandardObjects.getPartnerAccount().Id;
		if(userId == NULL) 		userId 		= UserInfo.getUserId();
		
		String recTypeId = Schema.SObjectType.Project_Installation_Setting__c.getRecordTypeInfosByName().get('IP User Assignment').getRecordTypeId();
		
		Project_Installation_Setting__c pis = (Project_Installation_Setting__c)SmartFactory.createSObject('Project_Installation_Setting__c',false);
		pis.RecordTypeId 			= recTypeId;
		pis.Installation_Partner__c = partnerId;
		pis.User__c 				= userId;
    	return pis;
    }

    public static Project_Installation_Setting__c createPISettingIMUserAssignment(Id partnerId, Id userId, Id installationModelId){
    	if(partnerId == NULL) 			partnerId 			= TestFactory_StandardObjects.getPartnerAccount().Id;
		if(userId == NULL) 				userId 				= UserInfo.getUserId();
		if(installationModelId == NULL) installationModelId = getInstallationModelIP().Id;
		
		String recTypeId = Schema.SObjectType.Project_Installation_Setting__c.getRecordTypeInfosByName().get('IM User Assignment').getRecordTypeId();
		
		Project_Installation_Setting__c pis = (Project_Installation_Setting__c)SmartFactory.createSObject('Project_Installation_Setting__c',false);
		pis.RecordTypeId 			= recTypeId;
		pis.Installation_Partner__c = partnerId;
		pis.User__c 				= userId;
		pis.Installation_Model__c 	= installationModelId;
    	return pis;
    }

    public static Project_Installation_Setting__c createPISettingNHUserAssignment(Id nhCommunityId, Id userId){
    	if(nhCommunityId == NULL) 		nhCommunityId 		= getNHCommunity().Id;
		if(userId == NULL) 				userId 				= UserInfo.getUserId();
		
		String recTypeId = Schema.SObjectType.Project_Installation_Setting__c.getRecordTypeInfosByName().get('NH User Assignment').getRecordTypeId();
		
		Project_Installation_Setting__c pis = (Project_Installation_Setting__c)SmartFactory.createSObject('Project_Installation_Setting__c',false);
		pis.RecordTypeId 			= recTypeId;
		pis.Community__c 		= nhCommunityId;
		pis.User__c 				= userId;
    	return pis;
    }

    //---------------------------- Installation Model --------------------------------

    private static Installation_Model__c installationModelIP;
    private static Installation_Model__c installationModelIPDRIP;

    public static Installation_Model__c getInstallationModelIP(){
    	if(installationModelIP == NULL){
    		Installation_Model__c im = createInstallationModelIP();
    		insert im;
    		installationModelIP = im;
    	}
    	return installationModelIP;
    }

    public static Installation_Model__c createInstallationModelIP(){
    	Installation_Model__c im = (Installation_Model__c)SmartFactory.createSObject('Installation_Model__c',false);
    	im.Roles__c = 'IP';
    	im.Type__c = 'Manual';
    	return im;
    }

    public static Installation_Model__c getInstallationModelIPDRIP(){
    	if(installationModelIPDRIP == NULL){
    		Installation_Model__c im = createInstallationModelIPDRIP();
    		insert im;
    		installationModelIPDRIP = im;
    	}
    	return installationModelIPDRIP;
    }

    public static Installation_Model__c createInstallationModelIPDRIP(){
    	Installation_Model__c im = (Installation_Model__c)SmartFactory.createSObject('Installation_Model__c',false);
    	im.Roles__c = 'IP;DRIP';
    	im.Type__c = 'Manual';
    	return im;
    }

    //---------------------------- Installation Modle PO Fee Line --------------------------------

    public static POLineFeeSetup__c createPOLineFeeSetup() {
        POLineFeeSetup__c polfs = (POLineFeeSetup__c)SmartFactory.createSObject('POLineFeeSetup__c');
        polfs.Item__c = TestFactory_Configurations.getItem().Id;
        return polfs;
    }
}