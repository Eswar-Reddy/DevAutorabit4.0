public with sharing class ResidentialProjectNewTaskRedirect 
{
	private final Project_Task__c myTask;

	public ResidentialProjectNewTaskRedirect(ApexPages.StandardController stdController) 
	{
		this.myTask = (Project_Task__c)stdController.getRecord();
	}

    public PageReference redirect()
    {
        Id defaultRecordTypeId = null;

        List<RecordTypeInfo> infos = RecordTypeController.getAvailableRecordTypeNamesForSObject(Project_Task__c.SObjectType);
        if(infos != null && infos.size() > 0)
        {
            for(RecordTypeInfo info : infos)
            {
                if (info.getName() == 'Ad Hoc') 
                {
                    defaultRecordTypeId = info.RecordTypeId;
                }
            }
        }

    	Id projId = ApexPages.currentPage().getParameters().get('Residential_Project__c');
    	String projName = ApexPages.currentPage().getParameters().get('Residential_Project_Name');
    	String retUrlStr = '&retURL=/'+projId+'&Residential_Project__c='+projId;

        PageReference p;
        if(SPCommunityUtility.isPartnerUser())
        {
            String recTypeStr = '&RecordType='+defaultRecordTypeId+'&tasktype=Ad+Hoc&status=Not+Started';
            String urlStr = '/apex/SPCommunityResidentialProjectNewTask?objecttype=Project_Task__c';
            urlStr = urlStr + retUrlStr + recTypeStr;
            
            p = new PageReference(urlStr);
            p.setRedirect(true);
        }
        else
        {
            String recTypeStr = '&RecordType='+defaultRecordTypeId+'&CF00N23000000OQ6u=' + projName + '&00N29000000VhmK=Ad+Hoc&00N34000005CDog=Not+Started';
        	String urlStr = '/a74/e?nooverride=1';
            urlStr = urlStr + retUrlStr + recTypeStr;

            p = new PageReference(urlStr);
            p.setRedirect(true);
        }
        return p;
    }
}