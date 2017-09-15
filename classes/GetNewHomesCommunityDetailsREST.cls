/**
 * Created by cdevarapalli on 5/10/17.
 */
@RestResource(urlMapping='/getNewHomesCommunityDetails/*')
global without sharing class GetNewHomesCommunityDetailsREST {

    @HttpGet
    global static Response doGet() {
        Response resp = new Response();
        String oppId = RestContext.request.params.get('OpportunityId');
        try{
            if(oppId == null){
                resp.error = 'OpportunityId is null';
                return resp;
            }
            else{
                Opportunity opp = [SELECT CampaignId from Opportunity where Id = :oppId ];
                if(opp.CampaignId == null){
                    resp.error = 'There is no Campagin associated with this Opportunity.';
                    return resp;
                }
                else{
                    Campaign cmpgn = [SELECT NH_Community__c, NH_Community__r.Builder__r.Name, NH_Community__r.Name, NH_Community__r.Community_ID__c, NH_Community__r.Region__c From Campaign c where Id = :opp.CampaignId];
                    if(cmpgn.NH_Community__c == null){
                        resp.error = 'There is no NH Community associated with this Campaign.';
                        return resp;
                    }
                    else{
                        if(cmpgn.NH_Community__r.Builder__r.Name != null)
                            resp.BuilderName = cmpgn.NH_Community__r.Builder__r.Name;
                        if(cmpgn.NH_Community__r.Region__c != null)
                            resp.BuilderDivision = cmpgn.NH_Community__r.Region__c;
                        if(cmpgn.NH_Community__r.Name != null)
                            resp.NewHomeCommunityName = cmpgn.NH_Community__r.Name;
                        if(cmpgn.NH_Community__r.Community_ID__c != null)
                            resp.NewHomeCommunityID = cmpgn.NH_Community__r.Community_ID__c;
                        return resp;
                    }

                }
            }
        }catch(Exception e){
            resp.error = e.getMessage();
            return resp;
        }
    }

    global class Response {
        String error;
        String BuilderName;
        String BuilderDivision;
        String NewHomeCommunityName;
        String NewHomeCommunityID;
    }
}