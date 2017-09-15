public with sharing class OpportunityContactRolesTable
{
	public Id opportunityId;
	public List<OpportunityContactRole> roles{get;set;}

	public ID getOpportunityId()
    {
    	return opportunityId;
    }

    public void setOpportunityId(ID s)
    {
        opportunityId = s;
        getRoles();
    }

	public void getRoles()
	{
		roles = [select Id, ContactId, IsPrimary, Role, Contact.AccountId, Contact.Account.Name, Contact.Name, Contact.Email, Contact.Phone from OpportunityContactRole where OpportunityId =: opportunityId];

		if(roles == null)
			roles = new List<OpportunityContactRole>();
	}
}