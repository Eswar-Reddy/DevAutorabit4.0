public with sharing class AccountContactRolesTable 
{
	public Id accountId;
	public List<AccountContactRole> roles{get;set;}

	public ID getAccountId()
    {
    	return accountId;
    }

    public void setAccountId(ID s)
    {
        accountId = s;
        getRoles();
    }

	public void getRoles()
	{
		roles = [select Id, ContactId, IsPrimary, Role, Contact.AccountId, Contact.Account.Name, Contact.Name, Contact.Email, Contact.Phone from AccountContactRole where AccountId =: accountId];

		if(roles == null)
			roles = new List<AccountContactRole>();
	}
}