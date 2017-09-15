global class CaseMetricCalculationScheduler implements Schedulable {
    global void execute(SchedulableContext sc){
        database.executeBatch(new BatchCalculateTimeForCRMCases()); 
    }    
}