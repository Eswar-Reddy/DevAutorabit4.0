global class BatchScheduler_To_UpdateParentMetrics implements Schedulable 
{
    public String str_CurrPeriod;
    public Integer int_CurrYear;
    public List<String> lstAccTy;
    public List<String> lstCounDom;
    public List<Metrics__c> lst_NewMetrics;
    global BatchScheduler_To_UpdateParentMetrics(String sP,Integer iY , List<String> lsA, List<String> lsC)
    {
        str_CurrPeriod = sP;
        int_CurrYear = iY;
        lstAccTy = lsA;
        lstCounDom = lsC;
    }
    global void execute(SchedulableContext sc)
    {
        Batch_Update_Parent_Metrics_v2_1 bup = new Batch_Update_Parent_Metrics_v2_1();
        bup.prop_GetCurrentPeriod = str_CurrPeriod;
        bup.prop_GetCurrentYear = int_CurrYear; 
        bup.prop_lstAccTy = lstAccTy;
        bup.prop_lstCounDom = lstCounDom;
        if(!Test.isRunningTest())
        {
            ID batchprocessid = Database.executeBatch(bup,50);
        }
        else
        {
            ID batchprocessid = Database.executeBatch(bup,200);
        }
    }
}