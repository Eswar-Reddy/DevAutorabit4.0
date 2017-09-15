/*
  Test functionality of Paginator class.
  @Author Anjali Khandelwal (Appirio Offshore)
*/
@isTest
private class Paginator_test
{   
    /* test Method for Paginator Controller functions */
    static testMethod void test_Paginator() {
	    	// creating list for Sorting
	     List<Warranty_Registration__c> wrList = new List<Warranty_Registration__c>();
	   	 Warranty_Registration__c wr = new Warranty_Registration__c();
	   	 wr.Delivery_Date__c = System.today();
	   	 wr.Status__c = 'Draft';
	   	 wrList.add(wr);
	 	 Warranty_Registration__c wr1 = new Warranty_Registration__c();
	   	 wr1.Delivery_Date__c = System.today();
	   	 wr1.Status__c = 'Draft';
	   	 wrList.add(wr1) ;   	 // list of sorting 
	   	 
	   	 Warranty_Registration__c wr2 = new Warranty_Registration__c();
	   	 wrList.add(wr2) ;   	 // list of sorting
	    	
	      Paginator paginator = new Paginator(wrList, 2);  // passing list for sorting
	      paginator.getRecords(); //call to getRecords() to get records
	      paginator.first();      //call to First() method to go on first page
          System.assertEquals(true,paginator.getHasNext());
	      System.assertEquals(1,paginator.currentPage); //Assert CurrentPage
	      paginator.next();       //call to Next() method to go on next page
	      System.assertEquals(2,paginator.currentPage); //Assert CurrentPage
	      System.assertEquals(true,paginator.getHasPrevious());
	      paginator.last();
	      System.assertEquals(2,paginator.currentPage); //Assert CurrentPage
	      System.assertEquals(false, paginator.getHasNext()); // no more page exists
	      paginator.previous();
	      System.assertEquals(1,paginator.currentPage); //Assert CurrentPage
	       System.assertEquals(false, paginator.getHasPrevious()); // no more page exists
   }
}