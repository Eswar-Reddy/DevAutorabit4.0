global with sharing class DataTableController {
    public static Integer queryLimit = 10000;
    public String userProfileName{get;set;}
    public String recordTypeLinks{get;set;}
    public Map<String, Id> recordTypeMap {get;set;}
    public String selectedRecType {get;set;}
    
    public DataTableController() {
        User currentUser = [Select Profile.Name from User where ID = :userInfo.getUserId()];
        userProfileName = currentUser.Profile.Name;
        
        Schema.SObjectType objType = Account.SObjectType;
        recordTypeMap = new Map<string, string>();
        List<RecordTypeInfo> retInfos= new List<RecordTypeInfo>();
        List<RecordTypeInfo> infos = objType.getDescribe().getRecordTypeInfos();
        recordTypeLinks = '';
        
        // If there are multiple RecordTypes...
        if (infos.size() > 1) {
            for (RecordTypeInfo info : infos) {
                if (info.isAvailable() && !info.isMaster()) {
                    //recordTypeLinks +='<a class="dropanchor" href="#" id="'+info.getRecordTypeId()+'">'+info.getName()+'</a>';
                    if(info.getName() == 'Residential Customer'){
                        //recordTypeLinks +='<a class="dropanchor" href="/NewResidentialAccount?ent=Account&nooverride=1&RecordType='+info.getRecordTypeId()+'">'+info.getName()+'</a>';
                        recordTypeLinks +='<a class="dropanchor" href="/NewResidentialAccount?ent=Account&nooverride=1&RecordType='+info.getRecordTypeId()+'">'+info.getName()+'</a>';
                        recordTypeMap.put('Residential Customer', info.getRecordTypeId());
                    } else if(info.getName() == 'Commercial Customer'){
                        //recordTypeLinks +='<a class="dropanchor" href="/EditCommercialAccount?ent=Account&nooverride=1&RecordType='+info.getRecordTypeId()+'">'+info.getName()+'</a>';
                        if (SPCommunityUtility.isNewUIUser(UserInfo.getUserId())) {
                            recordTypeLinks +='<a class="dropanchor" href="/SPCommunityCustomer?ent=Account&nooverride=1&RecordType='+info.getRecordTypeId()+'">'+info.getName()+'</a>';
                        } else {
                            recordTypeLinks +='<a class="dropanchor" href="/EditCommercialAccount?ent=Account&nooverride=1&RecordType='+info.getRecordTypeId()+'">'+info.getName()+'</a>';
                        }
                        recordTypeMap.put('Commercial Customer', info.getRecordTypeId());
                    }
                }
            }
        } else {
            // Otherwise there's just the Master record type,
            // so add it in, since it MUST always be available
            //retInfos.add(infos[0]);
            //recordTypeMap.put(infos[0].getRecordTypeId(), infos[0].getName());
            recordTypeLinks +='<a href="/'+infos[0].getRecordTypeId()+'">'+infos[0].getName()+'</a>';
        } 
    }

    public PageReference navigateToNew() {//TODO: Make better
        PageReference ref = new PageReference('/SPCommunityCustomer?ent=Account&nooverride=1&RecordType='+selectedRecType);
        ref.setRedirect(true);
        return ref;
    }

    @remoteAction
    global static ResultMessage getRecords(String soqlString, Id lastRecordId)
    {
        ResultMessage result = new ResultMessage();
        if (lastRecordId != null)
        {
            if (soqlString.contains('WHERE'))
            {
                soqlString = soqlString.replace('WHERE', 'WHERE Id > :lastRecordId AND');
            }
            else
            {
                String strObjectType = String.valueOf(lastRecordId.getSobjectType());
                soqlString = soqlString.replace('ORDER BY', 'WHERE Id > :lastRecordId ORDER BY');
            }
        }

        soqlString = soqlString.replace('ORDER BY', 'ORDER BY Id,');
        Integer testQueryLimit = queryLimit + 1;
        soqlString = soqlString += ' LIMIT :testQueryLimit';

        for (SObject s : Database.query(soqlString))
        {
            result.payload.add(s);
        }

        if(result.payload.size() > queryLimit)
        {
            result.payloadMap.put('done', false);
            result.payload.remove(result.payload.size()-1);
        }
        else
        {
            result.payloadMap.put('done', true);
        }

        return result;
    }
}