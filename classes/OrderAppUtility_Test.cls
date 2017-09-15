@isTest
global class OrderAppUtility_Test {
    public static testMethod void testOrderAppUtility() {
        OrderAppUtility oau = new OrderAppUtility();
        String testInstructionString = OrderAppUtility.createSpecialInstructionString('','','','','','','','','');
        testInstructionString = OrderAppUtility.createSpecialInstructionString('','','','','','','');
        Map<String, List<String>> testMap = OrderAppUtility.getDeliveryServicesSelectOptions();
        OrderAppUtility.generateLogging('','','');
        OrderAppUtility.generateGUID();
    }
}