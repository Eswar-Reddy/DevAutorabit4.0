/**************************************************************************
   wrapper class of Customer (Account)
   @Author Anjali Khandelwal (Appiro offshore)
***************************************************************************/
public with sharing class WR_CustomerWrapper {
	
	public Account customer{get;set;}
    public WR_CustomerWrapper(Account customer){ 
        this.customer = customer;
    } 
}