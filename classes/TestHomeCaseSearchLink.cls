@isTest
private Class TestHomeCaseSearchLink{
    static testMethod void ChkHomeCaseSearchLink(){
        test.StartTest();
        HomeCaseSearchLink cs = new HomeCaseSearchLink();
        cs.theTextInput = 'test';
        try {
        cs.search();
        }
        catch(Exception ex){}
        test.stoptest();
    }
}