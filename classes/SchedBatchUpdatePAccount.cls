global class SchedBatchUpdatePAccount implements Schedulable{
   global void execute(SchedulableContext sc) {
      UpdatePartnerAccount  b = new UpdatePartnerAccount(); 
      database.executebatch(b,9);
   }
}