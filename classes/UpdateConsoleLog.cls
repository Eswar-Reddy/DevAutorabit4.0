/*
    CreatedBy         : Vishal Gupta 
    Purpose           : This class is a controller class for the InfoLease VF page 
                        this class will be used to create a record in the new object AppTrackerAudit
                        each time and will log an entry 
    Modified Date     :
    Modified Purpose  :
    
     

*/

public class UpdateConsoleLog {

public User consoleUser{get;set;}
public DateTime TimeConsoleLogged{get;set;}
public AppTrackerAudit__c ConsoleT{get;set;}

//EAL_03152016: additional properties; Case 00677780 - Revise list of WebApps and make it configurable
public Map<string,List<Service_Console_Links_URL__c>> serviceConsoleUrlAndDetails{get;set;}

private List<Service_Console_Links_Section__c> serviceConsoleURLSection;
private List<Service_Console_Links_URL__c> serviceConsoleURLs;

//EAL_03152016: added contructor; Case 00677780 - Revise list of WebApps and make it configurable
public UpdateConsoleLog(){

    serviceConsoleURLSection= Service_Console_Links_Section__c.getAll().values();    
    serviceConsoleURLs = Service_Console_Links_URL__c.getAll().values();
    serviceConsoleURLSection.sort();
    serviceConsoleURLs.sort();
    serviceConsoleUrlAndDetails = new Map<string,List<Service_Console_Links_URL__c>>();
    Set<Service_Console_Links_Section__c> sectionToShow = new Set<Service_Console_Links_Section__c>();
    
    for(Service_Console_Links_Section__c s: serviceConsoleURLSection){
        if(s.Role__c.trim() ==  UserInfo.getUserRoleId().substring(0, 15)){
            sectionToShow.add(s);
        }
    }
    
    for(Service_Console_Links_Section__c s: sectionToShow){
        List<Service_Console_Links_URL__c> sectionURLs= new List<Service_Console_Links_URL__c>();
        for(Service_Console_Links_URL__c u: serviceConsoleURLs){
            if(u.Section_Name__c == s.Section_Name__c){
                sectionURLs.add(u);
            }
        }
        if(sectionURLs.size()>0){
            serviceConsoleUrlAndDetails.put(s.Section_Name__c, sectionURLs);
        }
    }
}

public void InsertIntoConsoleLog(){
    ConsoleT=new AppTrackerAudit__c();
  
    ConsoleT.User__c=UserInfo.getUserID();
    ConsoleT.DateTime_Console_Opens__c=DateTime.now();
    insert ConsoleT;  
System.debug('<----Insertion Done ---->');
}

public void UpdateTimeInAppTracker()
{
if(consoleT!=null) {
list<AppTrackerAudit__c> Clist=[select id , TimeInThisVisit__c from AppTrackerAudit__c where id =:ConsoleT.id];
if(Clist!=null && !Clist.isEmpty()) {
    if(Clist[0].TimeInThisVisit__c!=null)
       Clist[0].TimeInThisVisit__c++; 
    else 
    Clist[0].TimeInThisVisit__c=1;
    
    update Clist[0];
}
}
}
}