public with sharing class AccountContactRoleNew
{
    public Id accountId{get;set;}
    public List<AccountContactRole> existingRoles{get;set;}
    public List<String> roleValues{get;set;}
    public List<RoleWrapper> wrappers{get;set;}
    public String errorMsg{get;set;}

    public AccountContactRoleNew()
    {
        accountId = ApexPages.currentPage().getParameters().get('accountId');

        if(accountId != null)
		{
			existingRoles = [select Id, AccountId, ContactId, IsPrimary, Role, Contact.Id, Contact.AccountId, Contact.Account.Name, Contact.Name, Contact.Email, Contact.Phone from AccountContactRole where AccountId =: accountId];
		}

		findRoleValues();

		wrappers = new List<RoleWrapper>();
		if(existingRoles!=null && existingRoles.size() > 0)
		{
			for(AccountContactRole ocr : existingRoles)
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

	   	Schema.DescribeFieldResult fieldResult = AccountContactRole.Role.getDescribe();

		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

		for( Schema.PicklistEntry f : ple)
		{
		    roleValues.add(f.getLabel());
		}
	}

	public PageReference submit()
	{
		List<AccountContactRole> rolesToUpdate = new List<AccountContactRole>();
		for(RoleWrapper wrap : wrappers)
		{
			if(wrap.ocr.ContactId != null)
			{
				wrap.ocr.IsPrimary = wrap.isPrimary;
				wrap.ocr.Role = wrap.roleName;
				if(wrap.ocr.accountId == null)
					wrap.ocr.accountId = accountId;

			    rolesToUpdate.add(wrap.ocr);
			}
		}

		if(rolesToUpdate.size() > 0)
			upsert rolesToUpdate;

		PageReference p = new PageReference('/'+accountId);
        p.setRedirect(true);

        return p;
	}

	public PageReference cancel()
	{
		PageReference p = new PageReference('/'+accountId);
        p.setRedirect(true);

        return p;
	}

	public class RoleWrapper
	{
		public Boolean isPrimary{get;set;}
		public AccountContactRole ocr{get;set;}
		public String roleName{get;set;}
		public List<SelectOption> roleOptions{get;set;}

		public RoleWrapper(List<String> roleValues)
		{
			isPrimary = false;
			ocr = new AccountContactRole();
			roleName = null;

			roleOptions = new List<SelectOption>();
			for(String str : roleValues)
				roleOptions.add(new SelectOption(str,str));
		}

		public RoleWrapper(AccountContactRole existRole, List<String> roleValues)
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