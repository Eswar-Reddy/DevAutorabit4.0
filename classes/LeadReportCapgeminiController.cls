/************************************************************************************
Name    : LeadReportCapgeminiController
Date    : Feb 20, 2010
Author  : Aashish Mathur
Purpose : Controller class of VF page LeadReportCapgemini which is used to generate
          Lead History Report of Users.
************************************************************************************/

public class LeadReportCapgeminiController {
	
    public final Contact LEAD_FOR_FROM_DATE {get; private set;}
    public final Contact LEAD_FOR_TO_DATE {get; private set;}
    public List<SearchResult> searchResultList {get; private set;}
    public String errorMsg {get; private set;}
    public String company {get; set;}
    public String commaSeparatedRoles {get; set;}
    public List<String> lstSelectedRoles {get; set;}
    public List<SelectOption> lstRoles {get; set;}
    public Integer Governor_Limit {get; set;}
    
    public LeadReportCapgeminiController() {
        Governor_Limit = 10000;
        searchResultList = new List<SearchResult>();
        errorMsg = company = commaSeparatedRoles = '';
        lstSelectedRoles = new List<String>();
        lstRoles = new List<SelectOption>();
        for(UserRole role:[select id, name, PortalType from UserRole where PortalType='None' order by name ]){
        	lstRoles.add(new SelectOption(role.name,role.name));
        }
        
        //Changes done for Case#00061938
        //SSO_First_Contact_Date_Time__c of lead is not editable for all profiles so changed to CSAT_last_reponse_date__c of contact
        LEAD_FOR_FROM_DATE = new Contact();
        LEAD_FOR_TO_DATE = new Contact();
        LEAD_FOR_FROM_DATE.CSAT_last_reponse_date__c =
                LEAD_FOR_TO_DATE.CSAT_last_reponse_date__c = null;
    }
    
    public void clearSearch() {
    	company = '';
    	LEAD_FOR_FROM_DATE.CSAT_last_reponse_date__c = LEAD_FOR_TO_DATE.CSAT_last_reponse_date__c = null;
    	lstSelectedRoles.clear();
    	searchResultList.clear();    	
    }
    public void doSearch() {
        searchResultList = new List<SearchResult>();
        errorMsg = '';
        
        if (company == '' || company == null || lstSelectedRoles.size()==0 
                || LEAD_FOR_FROM_DATE.CSAT_last_reponse_date__c == null
                || LEAD_FOR_TO_DATE.CSAT_last_reponse_date__c == null) {
            errorMsg = 'Please fill every Search Criteria.';
            return;
        }
        
        String emailLike = '%' + company.toLowerCase() + '%';
        Set<String> roles = new Set<String>();
        for(String role :lstSelectedRoles){
        	roles.add(role.trim());
        }
        //for (String role : commaSeparatedRoles.split(',')) {
        //    roles.add(role.trim());
        //}
        
        Map<ID, User> userIdToUserMap = new Map<ID, User>([SELECT Id, Name, Email, CompanyName
                FROM User WHERE IsActive = true
                AND UserRole.Name IN :roles
                AND (CompanyName = :company OR Email LIKE :emailLike) LIMIT :Governor_Limit]);
        
        Integer queryLimitLeadHistory = Governor_Limit - userIdToUserMap.size();
        List<LeadHistory> leadHistoryList = [SELECT CreatedById, LeadId
                FROM LeadHistory WHERE CreatedDate >= :LEAD_FOR_FROM_DATE.CSAT_last_reponse_date__c
                AND CreatedDate <= :LEAD_FOR_TO_DATE.CSAT_last_reponse_date__c
                AND CreatedById IN :userIdToUserMap.keySet()
                ORDER BY CreatedBy.Name, CreatedById, Lead.Name, LeadId LIMIT :queryLimitLeadHistory];
        
        Set<String> leadIdSet = new Set<String>();
        for (LeadHistory leadHistory : leadHistoryList) {
            leadIdSet.add(leadHistory.LeadId);
        }
        
        Integer queryLimitLead = queryLimitLeadHistory - leadHistoryList.size();
        Map<ID, Lead> leadIdToLeadMap = new Map<ID, Lead>([SELECT Id, Name, OwnerId, Owner.Name, CreatedById,
                CreatedBy.Name FROM Lead WHERE Id IN :leadIdSet LIMIT :queryLimitLead]);
        
        if (userIdToUserMap.size() == Governor_Limit || leadHistoryList.size() == queryLimitLeadHistory
                || leadIdToLeadMap.size() == queryLimitLead) {
            errorMsg = 'Search result was limited as per Governor Limit.';
            
            if (userIdToUserMap.size() == Governor_Limit) {
                errorMsg += ' There may be more users of given Company and Roles.';
            }
            
            if (leadHistoryList.size() == queryLimitLeadHistory || leadIdToLeadMap.size() == queryLimitLead) {
                errorMsg += ' There may be more data within given time period.';
            }
        } else if (userIdToUserMap.size() == 0) {
            errorMsg = 'There is not any users of given Company and Roles.';
        }
        
        if (leadIdToLeadMap.size() == 0) {
            return;
        }
        
        Map<String, LeadData> userIdToLeadDataMap = new Map<String, LeadData>();
        List<String> userIdToLeadDataMapKeys = new List<String>();
        
        for (LeadHistory leadHistory : leadHistoryList) {
            String userId = leadHistory.CreatedById;
            String leadId = leadHistory.LeadId;
            LeadData leadData = userIdToLeadDataMap.get(userId);
            
            if (leadData == null) {
                leadData = new LeadData(userIdToUserMap.get(userId));
                userIdToLeadDataMapKeys.add(userId);
                userIdToLeadDataMap.put(userId, leadData);
            }
            
            if (leadData.leadIdSet.contains(leadId) == false) {
                leadData.leadIdSet.add(leadId);
                leadData.leadIdList.add(leadId);
            }
        }
        
        for (String userId : userIdToLeadDataMapKeys) {
            LeadData leadData = userIdToLeadDataMap.get(userId);
            User USER = leadData.USER;
            
            for (String leadId : leadData.leadIdList) {
                Lead LEAD = leadIdToLeadMap.get(leadId);
                if (LEAD != null) {
                    searchResultList.add(new SearchResult(USER, LEAD));
                }
            }
        }
    }
    
    public PageReference exportToCSV() {
        return Page.LeadReportCapgeminiCSV;
    }
    
    private class LeadData {
        private final User USER;
        private Set<String> leadIdSet;
        private List<String> leadIdList;
        
        private LeadData(User USER) {
            this.USER = USER;
            leadIdSet = new Set<String>();
            leadIdList = new List<String>();
        }
    }
    
    private class SearchResult {
        public final User USER {get; private set;}
        public final Lead LEAD {get; private set;}
        
        private SearchResult(User USER, Lead LEAD) {
            this.USER = USER;
            this.LEAD = LEAD;
        }
    }
}