public with sharing class EventRedirect 
{
    private final Event ev;

    public EventRedirect(ApexPages.StandardController stdController) 
    {
        this.ev = (Event)stdController.getRecord();
    }

    public PageReference redirect()
    {
        PageReference p;
        if(SPCommunityUtility.isPartnerUser())
        {
            p = new PageReference('/apex/SPCommunityEventDetails?id='+ev.Id);
            p.setRedirect(true);
        }
        else
        {
            p = new PageReference('/'+ev.Id + '?nooverride=1');
            p.setRedirect(true);
        }

        return p.setRedirect(true);
    }
}