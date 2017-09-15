public with sharing class OpportunityContactRoleNew
{
    public Id opportunityId{get;set;}
    public List<OpportunityContactRole> existingRoles{get;set;}
    public List<String> roleValues{get;set;}
    public List<RoleWrapper> wrappers{get;set;}
    public String errorMsg{get;set;}

    public OpportunityContactRoleNew()
    {
        opportunityId = ApexPages.currentPage().getParameters().get('opportunityId');

        if(opportunityId != null)
		{
			existingRoles = [select Id, OpportunityId, ContactId, IsPrimary, Role, Contact.Id, Contact.AccountId, Contact.Account.Name, Contact.Name, Contact.Email, Contact.Phone from OpportunityContactRole where OpportunityId =: opportunityId];
		}

		findRoleValues();

		wrappers = new List<RoleWrapper>();
		if(existingRoles!=null && existingRoles.size() > 0)
		{
			for(OpportunityContactRole ocr : existingRoles)
			{
				wrappers.add(new RoleWrapper(ocr, roleValues));
			}
		}

		// Add three to the list beyond what already exists
		for(Integer i=0;i<3;i++)
		{
			wrappers.add(new RoleWrapper(roleValues));
		}
    }

    public void findRoleValues()
	{
	  	roleValues = new List<String>();

	   	Schema.DescribeFieldResult fieldResult = OpportunityContactRole.Role.getDescribe();

		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

		for( Schema.PicklistEntry f : ple)
		{
		    roleValues.add(f.getLabel());
		}
	}

	public PageReference submit()
	{
		List<OpportunityContactRole> rolesToUpdate = new List<OpportunityContactRole>();
		for(RoleWrapper wrap : wrappers)
		{
			System.debug('**** OCR: '+wrap.ocr+' prim: '+wrap.isPrimary);

			if(wrap.ocr.ContactId != null)
			{
				wrap.ocr.IsPrimary = wrap.isPrimary;
				wrap.ocr.Role = wrap.roleName;
				if(wrap.ocr.OpportunityId == null)
					wrap.ocr.OpportunityId = opportunityId;

			    rolesToUpdate.add(wrap.ocr);
			}
		}

		if(rolesToUpdate.size() > 0)
			upsert rolesToUpdate;

		PageReference p = new PageReference('/'+opportunityId);
        p.setRedirect(true);

        return p;
	}

	public PageReference cancel()
	{
		PageReference p = new PageReference('/'+opportunityId);
        p.setRedirect(true);

        return p;
	}

	public class RoleWrapper
	{
		public Boolean isPrimary{get;set;}
		public OpportunityContactRole ocr{get;set;}
		public String roleName{get;set;}
		public List<SelectOption> roleOptions{get;set;}

		public RoleWrapper(List<String> roleValues)
		{
			isPrimary = false;
			ocr = new OpportunityContactRole();
			roleName = null;

			roleOptions = new List<SelectOption>();
			for(String str : roleValues)
				roleOptions.add(new SelectOption(str,str));
		}

		public RoleWrapper(OpportunityContactRole existRole, List<String> roleValues)
		{
			isPrimary = existRole.IsPrimary;
			ocr = existRole;
			roleName = existRole.Role;

			roleOptions = new List<SelectOption>();
			for(String str : roleValues)
				roleOptions.add(new SelectOption(str,str));
		}
	}
}