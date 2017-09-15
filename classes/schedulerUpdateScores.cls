public class schedulerUpdateScores
{
    public static void start()
    {
        scheduleUpdateScores m = new scheduleUpdateScores();
        String sch = '0 10 * * * ?';
        String jobID = system.schedule('schedulerUpdateScores', sch, m);
    }
}