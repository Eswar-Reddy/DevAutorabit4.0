global class SchedBatchCOR implements Schedulable{
   global void execute(SchedulableContext sc) {
      BatchCalCloseOppRatio b = new BatchCalCloseOppRatio(); 
      database.executebatch(b,9);
   }
}