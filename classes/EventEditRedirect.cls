public with sharing class EventEditRedirect 
{
	private final Event ev;

    public EventEditRedirect(ApexPages.StandardController stdController) 
    {
        this.ev = (Event)stdController.getRecord();
    }

    public PageReference redirect()
    {
        PageReference p;
        if(SPCommunityUtility.isPartnerUser())
        {
            p = new PageReference('/apex/SPCommunityEventEdit?id='+ev.Id);
            p.setRedirect(true);
        }
        else
        {
            p = new PageReference('/'+ev.Id + '/e?nooverride=1&retURL=%2F'+ev.Id);
            p.setRedirect(true);
        }
        return p.setRedirect(true);
    }
}