public with sharing class GATController { 

public String tier {get; set;} 
public String country {get; set;} 
public String account {get; set;} 

public GATController() { 
User userObj = null; 
userObj = [select user.contact.account.type, user.contact.account.Oracle_Operating_Unit__c, user.contact.account.Oracle_Account_Number__c, user.country 
from user 
where id = :UserInfo.getUserId()]; 
if (userObj.contact != null) { 
tier = userObj.contact.account.type; 
account = userObj.contact.account.Oracle_Account_Number__c; 
country = userObj.contact.account.Oracle_Operating_Unit__c; 
} 
else { 
account = 'SUNPOWER'; 
country = userObj.country; 
} 
} 
}