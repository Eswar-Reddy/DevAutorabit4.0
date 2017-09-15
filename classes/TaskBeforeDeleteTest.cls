@isTest
public class TaskBeforeDeleteTest {

    private static testMethod void test_sysAdmin() {
        TaskBeforeDeleteTestData td = new TaskBeforeDeleteTestData();
        td.createTestData_sysAdmin();

        Boolean gotException = false;
        system.runAs(td.user_1) {
            try {
                delete td.task_1;
            } catch(Exception e) {
                gotException = true;
            }
        }
        system.assertEquals(false, gotException);
    }

    private static testMethod void test_stdUser() {
        TaskBeforeDeleteTestData td = new TaskBeforeDeleteTestData();
        td.createTestData_stdUser();
        
        Boolean gotException = false;
        system.runAs(td.user_2) {
            try {
                delete td.task_1;
            } catch(Exception e) {
                // This is auto created SPVT task. You cannot delete it. Please contact System Administrator to delete it
                gotException = true;
            }
        }
        system.assertEquals(true, gotException);
    }

}