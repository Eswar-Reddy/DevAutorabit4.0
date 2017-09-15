global class scheduleUpdateScores implements Schedulable 
{
   global void execute(SchedulableContext sc) 
   {
      updateDealerScoreRollups udsr = new updateDealerScoreRollups(); 
      database.executebatch(udsr,1);      
   }
}