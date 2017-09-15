public class MYECController {

    
    public Opportunity_Design__c photo {get;set;}
    public String ownerName {get;set;}
    public String aboutBio {get;set;}
    public Boolean doRender {get;set;}
    public Boolean dontRender {get;set;}

    public MYECController() {
    
        Id userId = apexpages.currentpage().getparameters().get('id');
              
        try {
            photo = [Select Design_Photo__c, User__r.Name, User__r.About__c From Opportunity_Design__c Where User__c =: userId Order By CreatedDate Desc LIMIT 1];
            doRender = true;
            ownerName = photo.User__r.Name;
            aboutBio = photo.User__r.About__c;
        } catch(Exception e) {
            dontRender = true;
        
        }
    }
    
    
}