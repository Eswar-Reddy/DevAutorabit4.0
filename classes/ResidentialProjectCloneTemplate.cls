global class ResidentialProjectCloneTemplate {
	webservice static Id cloneTemplate(Id projectId, String projectName){
		try{
			Residential_Project__c newProject = new Residential_Project__c();
			newProject.RecordTypeId = ResidentialProjectUtility.ptpId;
			newProject.Name = projectName + ' Clone';
			insert newProject;

			List<Project_Team_Member__c> insertptm = new List<Project_Team_Member__c>();
			List<Project_TAsk__c> insertpt = new List<Project_Task__c>();
			List<Document__c> docsToInsert = new List<Document__c>();

			Residential_Project__c rp = [SELECT Id, (SELECT Role__c, User__c, Project_Dashboard_User__c FROM Project_Team_Members__r), (SELECT Name, RecordTypeId, SLA_Days__c, Critical_Path__c, Document_Required__c, Required_Project_Fields__c, Role_Assignment__c, Order__c, Milestone__c, Description__c FROM Project_Tasks__r), (SELECT Name, Project_TAsk__c, Document_Type__c, Type__c, Project_Task__r.Name FROM Documents__r) FROM Residential_Project__c WHERE Id =: projectId];

			for(Project_Team_Member__c ptm : rp.Project_Team_Members__r){
				Project_Team_Member__c nptm = new Project_Team_Member__c();
				nptm.Residential_Project__c = newProject.Id;
				nptm.Role__c = ptm.Role__c;
				nptm.User__c = ptm.User__c;
				nptm.Project_Dashboard_User__c = ptm.Project_Dashboard_User__c;
				insertptm.add(nptm);
			}

			for(Project_Task__c pt : rp.Project_Tasks__r){
				Project_Task__c npt = new Project_Task__c();
			    npt.RecordTypeId = pt.RecordTypeId;
				npt.Residential_Project__c = newProject.Id;
				npt.Name = pt.Name;
				npt.SLA_Days__c = pt.SLA_Days__c;
				npt.Critical_Path__c = pt.Critical_Path__c;
				npt.Document_Required__c = pt.Document_required__c;
				npt.Required_Project_Fields__c = pt.Required_Project_Fields__c;
				npt.Role_Assignment__c = pt.Role_Assignment__c;
				npt.Order__c = pt.Order__c;
				npt.Description__c = pt.Description__c;
				npt.Milestone__c = pt.Milestone__c;
				insertpt.add(npt);
			}
			insert insertptm;
			insert insertpt;

			for(Document__c d : rp.Documents__r){
			    
		        if(d.Project_Task__c != NULL){
		        	for(Project_Task__c pt : insertpt){
		        		if(d.Project_Task__r.Name == pt.Name){
				            Document__c nd = new Document__c();
				            nd.Name = d.Name;
				            nd.Document_type__c = d.document_type__c;
				            nd.type__c = d.type__c;
				            nd.residential_project__c = newproject.Id;
				            nd.project_task__c = pt.Id;
				            docsToInsert.add(nd);
				        }
			        }
		        }
		        if(d.Project_Task__c == NULL){
		            Document__c nd = new Document__c();
		            nd.Name = d.Name;
		            nd.Document_type__c = d.document_type__c;
		            nd.type__c = d.type__c;
		            nd.residential_project__c = newproject.Id;
		            docsToInsert.add(nd);
		        }
			    
			}
			insert docstoinsert;
			return newProject.Id;
		}catch(Exception e){
			return NULL;
		}

	}
}