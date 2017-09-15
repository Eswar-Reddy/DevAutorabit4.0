/******************************************************************
**Created By - Harsh Mathur
**Created On - June 24 2009
**Last Modified - Harsh Mathur
**Last Modified On -  June 30 2009 
**Desciption- Controller class for PartnerPerformanceDashboard
*******************************************************************/

public with sharing class PartnerPerformanceDashboardController{
  //This contoller will provide the data needed to populate the partner dashboard using google visualizations.
  
  public static Integer topLimit = 5;  

  //Properties  
  //holds current user
  public User currentUser{get;set;}
  
  //holds current user Id
  public String currentUserId{get;set;}
  
  //holds current contact Id
  public String currentContactId {get; set;}    
  
  //holds current Account Id
  public String currentAccountId {get; set;}
  
  //holds top open opportunities
  public List<Opportunity> lstTopOpportunities{get;set;}
  
  //holds top abandoned opportunities
  public List<Opportunity> lstTopAbandonedOpportunities{get;set;}

  //holds all open opportunities for the current account
  public List<Opportunity> lstAllOpportunities{get;set;}
  
  //holds all the abandoned opportunities for the current account
  public List<Opportunity> lstAllAbandonedOpportunities{get;set;}
  
  public List<Double> lstSumAmountOpenOpp{get;set;}
  public List<Double> lstSumAmountAbandonedOpp{get;set;}
  
  //Constructor
  public PartnerPerformanceDashboardController(){
    //get current user, contactId and AccountId
    this.currentUserId = UserInfo.getUserId();
    if(this.currentUserId == null){
      return;
    }
    List<User> lstUser = new List<User>();
    lstUser = [Select Id, LastName, FirstName, Contact.AccountId, ContactId from User where ContactId != null and Id = :currentUserId Limit 1];
    if(lstUser.size() <= 0){
      return;
    }
    this.currentUser = lstUser[0];
    this.currentContactId = this.currentUser.ContactId;
    this.currentAccountId = this.currentUser.Contact.AccountId;
    
    //get top 5 opportunities
    this.lstTopOpportunities = [Select o.Id, o.PartnerAccount.Name, o.PartnerAccountId, 
      o.Name, o.IsWon, o.IsDeleted, o.IsClosed, o.Amount, o.AccountId, o.StageName 
      From Opportunity o 
      where o.PartnerAccountId =: this.currentAccountId and o.IsClosed = false and o.IsWon = false  
      order by o.Amount desc limit :topLimit ];    
    
    //get abandoned opportunities
    this.lstTopAbandonedOpportunities = [Select o.Id, o.PartnerAccount.Name, o.PartnerAccountId, 
      o.Name, o.IsWon, o.IsDeleted, o.IsClosed, o.Amount, o.AccountId, o.StageName 
      From Opportunity o 
      where o.Is_Abandonded__c = true and o.PartnerAccountId =: this.currentAccountId and o.IsClosed = false and o.IsWon = false   
      order by o.Amount desc limit :topLimit ];       
      
    //get all open opportunities for current account
    this.lstAllOpportunities = [Select o.Id, o.PartnerAccount.Name, o.PartnerAccountId, 
      o.Name, o.IsWon, o.IsDeleted, o.IsClosed, o.Amount, o.AccountId, o.StageName, o.Probability 
      From Opportunity o 
      where o.PartnerAccountId =: this.currentAccountId and o.IsClosed = false and o.IsWon = false and o.Amount > 0 
      order by o.Amount desc ];
      
    //get all abandoned opportunities for current account
    this.lstAllAbandonedOpportunities = [Select o.Id, o.PartnerAccount.Name, o.PartnerAccountId, 
      o.Name, o.IsWon, o.IsDeleted, o.IsClosed, o.Amount, o.AccountId, o.StageName, o.Probability
      From Opportunity o 
      where o.Is_Abandonded__c = true and o.PartnerAccountId =: this.currentAccountId and o.IsClosed = false and o.IsWon = false and o.Amount > 0 
      order by o.Amount desc ];
    
    //Sum up amounts of opportunities based on probability  
    sumOpenOpportunities();  
    sumAbandonedOpportunities();
  }//end constructor  
  
  public void sumOpenOpportunities(){
    //sum up open opportunities
    this.lstSumAmountOpenOpp = new List<Integer>();
    for(Integer iter = 0; iter < 9; iter++){
      this.lstSumAmountOpenOpp.add(0);
    }
    Integer scale = 1000;
    //loop on all open opportunities and sum up amounts    
    for(Opportunity opp : this.lstAllOpportunities){
      if(opp.Probability >= 95){
        this.lstSumAmountOpenOpp[8] += (opp.Amount / scale );
      }
      else if(opp.Probability >= 90){
        this.lstSumAmountOpenOpp[7] += (opp.Amount / scale  );
      }
      else if(opp.Probability >= 85){
        this.lstSumAmountOpenOpp[6] += (opp.Amount / scale  );
      }
      else if(opp.Probability >= 75){
        this.lstSumAmountOpenOpp[5] += (opp.Amount / scale );
      }
      else if(opp.Probability >= 60){
        this.lstSumAmountOpenOpp[4] += (opp.Amount / scale );
      }
      else if(opp.Probability >= 50){
        this.lstSumAmountOpenOpp[3] += (opp.Amount / scale  );
      }        
      else if(opp.Probability >= 25){
        this.lstSumAmountOpenOpp[2] += (opp.Amount / scale );
      }             
      else if(opp.Probability >= 20){
        this.lstSumAmountOpenOpp[1] += (opp.Amount / scale  );
      }                         
      else{
        this.lstSumAmountOpenOpp[0] += (opp.Amount / scale  );
      }
    }
  }
  
  public void sumAbandonedOpportunities(){
    //sum up abandoned opportunities
    this.lstSumAmountAbandonedOpp = new List<Integer>();
    for(Integer iter = 0; iter < 9; iter++){
      this.lstSumAmountAbandonedOpp.add(0);
    }
    Integer scale = 1000;
    //loop on all abandoned opportunities and sum up amounts  
    for(Opportunity opp : this.lstAllAbandonedOpportunities){
      if(opp.Probability >= 95){
        this.lstSumAmountAbandonedOpp[8] += (opp.Amount / scale );
      }
      else if(opp.Probability >= 90){
        this.lstSumAmountAbandonedOpp[7] += (opp.Amount / scale  );
      }
      else if(opp.Probability >= 85){
        this.lstSumAmountAbandonedOpp[6] += (opp.Amount / scale  );
      }
      else if(opp.Probability >= 75){
        this.lstSumAmountAbandonedOpp[5] += (opp.Amount / scale  );
      }
      else if(opp.Probability >= 60){
        this.lstSumAmountAbandonedOpp[4] += (opp.Amount / scale );
      }      
      else if(opp.Probability >= 50){
        this.lstSumAmountAbandonedOpp[3] += (opp.Amount / scale );
      }      
      else if(opp.Probability >= 25){
        this.lstSumAmountAbandonedOpp[2] += (opp.Amount / scale );
      }      
      else if(opp.Probability >= 20){
        this.lstSumAmountAbandonedOpp[1] += (opp.Amount / scale );
      }            
      else{      
        this.lstSumAmountAbandonedOpp[0] += (opp.Amount / scale );
      }
    }
  }
  
  /*
  public List<PartnerPerformance__c> allPartnerPerformance{ 
    get{ 
      if (allPartnerPerformance == null ){
        allPartnerPerformance = [Select p.Partner_Account__r.Id, p.HRS_Training_Score__c, 
          p.HRS_Total__c, p.Submit_Status__c, p.HRS_Sales_Score__c, 
          p.HRS_Marketing_Score__c, p.HRS_Customer_Service_Score__c, p.Date__c 
          From PartnerPerformance__c p Order by p.Date__c desc];            
      }    
      return allPartnerPerformance ;
    }
    set; 
  }

  public List<PartnerPerformance__c> partnerPerformance{ 
    get{ 
      if (partnerPerformance == null){
        List<PartnerPerformance__c> myPartnerPerformance = new List<PartnerPerformance__c>();                
        
        //get the current contact based on the current user
        currentUserId = UserInfo.getUserId();
        currentContactId = null;
        currentAccountId = null;
        for (User eachUser : [Select u.ContactId From User u where u.Id = :currentUserId]){
          if(eachUser.ContactId != null){
            currentContactId = eachUser.ContactId;
          }
        }
        if(currentContactId != null){
          for (Contact  eachContact : [Select c.Id, c.AccountId From Contact c where c.Id = :currentContactId] ){
            if (eachContact.AccountId != null){
              currentAccountId = eachContact.AccountId;
            }
          }
        }
        if (currentAccountId != null ){
          myPartnerPerformance = [Select p.Partner_Account__r.Id, p.HRS_Training_Score__c, 
            p.HRS_Total__c, p.Submit_Status__c, p.HRS_Sales_Score__c, p.HRS_Marketing_Score__c, 
            p.HRS_Customer_Service_Score__c, p.Date__c 
            From PartnerPerformance__c p 
            Where p.Partner_Account__r.Id = :currentAccountId
            Order by p.Date__c desc];            
        }  
        partnerPerformance = myPartnerPerformance;                   
      }
      return partnerPerformance;
    }
    set; 
  }

  public PartnerPerformance__c recentPartnerPerformance{ 
    get{ 
      if(partnerPerformance == null){
        if(allPartnerPerformance != null){
          recentPartnerPerformance = allPartnerPerformance[0];
        }
      }
      else{
        for(PartnerPerformance__c eachPartnerPerformance : partnerPerformance){
          recentPartnerPerformance = eachPartnerPerformance;
        }
      }
      return recentPartnerPerformance;
    }
    set;
  }*/  
}