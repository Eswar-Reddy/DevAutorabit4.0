/********************************************************************************************
Name   : CreditApplicationInstructionController
Author : Jitendra Kothari
Date   : May 13, 2010
Usage  : Controller of VF page CreditApplicationInstructionPage which is used to show Countrywise Instructions.
********************************************************************************************/
public class CreditApplicationInstructionController {
    public boolean isSpain{get;set;}
    public boolean isGermany{get;set;}
    public boolean isItaly{get;set;}
    public boolean isFrance{get;set;}
    //Start 95081
    public boolean isUK{get;set;}
    //End 95081
    public boolean isAll{get;set;}
    public String accountId{get;set;}
    public CreditApplicationInstructionController(ApexPages.StandardController stdCont) {
        String country = ApexPages.currentPage().getParameters().get('country');
        String accId = ApexPages.currentPage().getParameters().get('accId');
        if(country==null){
            List<Account> accList = [Select Id, BillingCountry from Account where Id = :accId limit 1];
            if(accList.size()>0){
                country = accList.get(0).BillingCountry;
            }
        }
        if(country == 'Spain'){
            isSpain = true;
        }else if(country == 'Germany'){
            isGermany = true;
        }else if(country == 'Italy'){
            isItaly = true;
        }else if(country == 'France'){
            isFrance = true;
        }//Start 95081
        else if(country == 'United Kingdom'){
            isUK = true;
        }//End 95081
        //start Bharti
        else if(country == 'Belgium'){
            isFrance = true;
        }//End Bharti
        else{
            isSpain = true;
            isGermany = true;
            isItaly = true;
            isFrance = true;
            //Start 95081
            isUK = true;
            //End 95081
            isAll = true;
        }
    }   
}