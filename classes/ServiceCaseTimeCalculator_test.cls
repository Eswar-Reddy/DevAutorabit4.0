/*Test class for the serviceCaseTimeCalculator class 
 * this class will test for each status. 
 */

@isTest(SeeAllData=true)
private class ServiceCaseTimeCalculator_test {
    static testMethod void testServiceCaseTimeCalculator() {

    list<case> newcase=[select id,Status from case limit 1];
    newcase[0].Status='open to work ';
    update newcase[0];
    newcase[0].Status='Pending 3rd Party Action';
    update newcase[0];
   
    
    
    
     
    }
    static testMethod void testServiceCaseTimeCalculator1() {
        list<case> newcase=[select id,Status from case limit 1];
    	newcase[0].Status='Pending Vendor Action';
   		update newcase[0];
        newcase[0].Status='Monitor Action';
    	update newcase[0];
    }
    static testMethod void testServiceCaseTimeCalculator2() {
        list<case> newcase=[select id,Status from case limit 1];
        newcase[0].Status='Pending Customer Action';
    update newcase[0];
    newcase[0].Status='Pending Database Action';
    update newcase[0];
        
    }
    static testMethod void testServiceCaseTimeCalculator3() {
        list<case> newcase=[select id,Status from case limit 1];
        newcase[0].Status='Pending Other SPWR Team Action';
    update newcase[0];
    newcase[0].Status='Pending Partner Action';
    update newcase[0];
        
    }    
        
  }