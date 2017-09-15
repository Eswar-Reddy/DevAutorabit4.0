@isTest
public class TestupdateRoofAcceptency{
    
       public static Account accountObj;
  public static Contact contactObj;
  static{
    accountObj = new Account();
      accountObj.Name = 'Testing' +String.valueOf(DateTime.Now());
      accountObj.Type ='Commercial';
      accountObj.billingCity = 'TestCity';
      accountObj.BillingCountry = 'TestCountry';
      accountObj.BillingPostalCode = '12345';
      accountObj.BillingState = 'TestState';
      accountObj.BillingStreet = 'TestStreet';
      
      accountObj.shippingCity = 'TestCity';
      accountObj.shippingCountry = 'TestCountry';
      accountObj.shippingPostalCode = '12345';
      accountObj.shippingState = 'TestState';
      accountObj.shippingStreet = 'TestStreet';    
      insert accountObj;
      
      contactObj = new Contact();
      contactObj.FirstName = 'Test' + String.valueOf(DateTime.Now()) ;
      contactObj.LastName = 'Test' + String.valueOf(DateTime.Now());
      //contactObj.Email = 'testB'+ String.ValueOf(Datetime.now())+'@nom.com';
      contactObj.AccountId = accountObj.Id;
      insert contactObj;
      } 

    @isTest
    public static void Test_allHundres(){
       
        
        Roof_Details__c  R = new Roof_Details__c();
        
        R.Jan__c = 100 ; R.Feb__c=100 ; R.Mar__c = 100 ; R.Apr__c = 100 ; R.May__c=100 ; R.Jun__c =100
                ; R.Jul__c =100 ; R.Aug__c = 100 ; R.Sep__c=100 ; R.Oct__c = 100 ; R.Nov__c = 100 ; R.Dec__c=100;
                R.Roof1_Accepted__c=false;
                R.Account__c = accountObj.Id;
                
                Insert R;
        Roof_Details__c  R1 = new Roof_Details__c();
        
        R1.Jan__c = 100 ; R1.Feb__c=99 ; R1.Mar__c = 100 ; R1.Apr__c = 100 ; R1.May__c=100 ; R1.Jun__c =100
                ; R1.Jul__c =100 ; R1.Aug__c = 99; R1.Sep__c=100 ; R1.Oct__c = 100 ; R1.Nov__c = 100 ; R1.Dec__c=100;
                R1.Roof1_Accepted__c=true;
                R1.Account__c = accountObj.Id;
                
                Insert R1;        
        
        
    }

}