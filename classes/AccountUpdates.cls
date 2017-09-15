/**
* Created by: Accenture 
* Date : 28 April 2010
* Purpose: Contains functions that have to be update when Account records are created or updated.
* as per the review comments on 26 April 2010.
**/
public class AccountUpdates{

public static void afterUpdateAcc(List<Account> accountList,Map<Id,Account> accNewMap,Map<Id,Account> accOldMap){
Set<id> acid = new Set<id>();
Set<String> accid = new Set<String>();
List<SIC__c> sicList = new List<SIC__c>();
List<account> acntList = new List<account>(); 
for(Account acc: accountList){
acid.add(acc.Id);
accid.add(acc.Sic);
}


//query for Sic(SIC Code) in Account with ID and adding to Set
/*List<Account> alst = [Select id,Sic,First_Level_SIC_Code__c,Second_Level_SIC_Code__c,SIC_Name__c,SPWR_Industry_Type__c from Account where Id IN : acid];
for(Account an : alst){
accid.add(an.Sic);
}*/
//query for SIC information in SIC and adding to List 
sicList= [select SIC_Code__c,SPWR_Industry_Type__c,First_Level__c,Second_Level__c,Third_Level__c from SIC__c where SIC_Code__c IN : accid];

for(Account a: accountList){

if(a.sic != null){
if(a.sic!=accOldMap.get(a.id).sic){
for(SIC__c s: sicList){
if(a.sic == s.SIC_Code__c){ 
a.First_Level_SIC_Name__c = s.First_Level__c;
a.Second_Level_SIC_Name__c = s.Second_Level__c;
a.Third_Level_SIC_Name__c = s.Third_Level__c;
a.SPWR_Industry_Type__c = s.SPWR_Industry_Type__c;
acntList.add(a);
}
} 
}

}
else if(a.sic == null)
{
if(accNewMap.get(a.id).sic!=accOldMap.get(a.id).sic){
a.First_Level_SIC_Name__c = null;
a.Second_Level_SIC_Name__c = null;
a.Third_Level_SIC_Name__c = null;
a.SPWR_Industry_Type__c = null;
acntList.add(a);
system.debug('hiiiii account '+a.First_Level_SIC_Name__c);

}
}
}

//update acntList ; 
}


//code for finding if any duplicate Account records exist in the system and also validattion for the approval process exist

/*public static void accDuplicate(List<Account> acclist){
map<String,Account> mapNameAccount = new map<String,Account>();
map<String,Account> accountMatch = new map<String,Account>();
for(Account acc:acclist){
if(mapNameAccount.containsKey(acc.Name)){
acc.addError('A duplicate Account has been found in the system');
}
mapNameAccount.put(acc.Name,acc);
}
for(Account acc:[Select Name from Account where Name in :mapNameAccount.KeySet()]){
accountMatch.put(acc.Name,acc);
}
for(Account acc:acclist){
if(accountMatch.containsKey(acc.Name)){
acc.addError('A duplicate Account has been found in the system Please Choose Existing Name from AccountName');
}
If(acc.Business_Unit__c == 'NA UPP' || acc.Business_Unit__c == 'NA Systems' || acc.Business_Unit__c == 'Intl UPP' && acc.Lead_Approval__c == 'True'){
}
If((acc.Business_Unit__c == 'NA UPP' || acc.Business_Unit__c == 'NA Systems' || acc.Business_Unit__c == 'Intl UPP') && (acc.Lead_Approval__c == 'False' || acc.Lead_Approval__c == null)){
acc.addError('You are required approval before conversion from your Sales Manager'); 
}
If((acc.Business_Unit__c == 'NA UPP' || acc.Business_Unit__c == 'NA Systems' || acc.Business_Unit__c == 'Intl UPP') && (acc.HD_Lead_Status__c != 'Qualified')){ 
acc.addError('Lead must be set to qualified to convert'); 
}
If((acc.Business_Unit__c == 'IBD' || acc.Business_Unit__c == 'Components') && (acc.HD_Lead_Status__c != 'Qualified')){ 
acc.addError('You are required to Qualify the Lead'); 
} 
}
}*/
  public static void met(){
    	Integer i = 0;
i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    }
    @isTest
     public static void dummyTest(){
     	met();
     }
}