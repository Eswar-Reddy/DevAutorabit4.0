public without sharing class SPCommunityDesignTools
{
	public List<String> headlines;

	public SPCommunityDesignTools()
	{
		setHeadlines();
	}

	public List<String> getHeadlines()
	{
		return headlines;
	}

	public void setHeadlines()
	{
		headlines = new List<String>();

		List<APPR_PUB__Headline__c> lines = [select Id, Name, APPR_PUB__Long_Description__c from APPR_PUB__Headline__c where APPR_PUB__Tab__c = 'DesignTools'];
		if(lines != null && lines.size() > 0)
		{
			for(APPR_PUB__Headline__c ln : lines)
				headlines.add(ln.APPR_PUB__Long_Description__c.replaceAll('<[^>]+>',' '));
		}
	}
}