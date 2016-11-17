global class ARScht1 implements Schedulable{
    //static Integer i = 0;
    //sample shedule class added.
    
    //Sys
    //
    //
    //
    global void execute(SchedulableContext SC) {
        
        test();
        
    }
    public static void test(){
        /*List<Student__c> ll = new List<Student__c>();
        ll = [select Id, Student_Texter__c from Student__c];
        for(Student__c s : ll){
            i++;
            s.Student_Texter__c = 'abc'+i;
        }
        update ll; */
 Student__c sb = new Student__c();
        sb.Student_Texter__c = 'ab';
        
        upsert sb;
        
    }
    
    
    
    
    
}