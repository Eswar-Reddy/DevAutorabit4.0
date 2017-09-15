/* Schedule Class for APEX Class: GoogleAPIAuditLogger.ProcessCleanup
*/
global class GoogleAPIAuditLoggerCleanupScheduler implements Schedulable 
{
	global void execute(SchedulableContext ctx)
	{
		GoogleAPIAuditLogger.ProcessCleanUp();
	} 
	
	// Below valiable only for Test Method Run, test runs a scheduled job at midnight Sept. 3rd. 2022
	public static String CRON_EXP = '0 0 0 3 9 ? 2022';
}//End Class GoogleAPIAuditLoggerCleanupScheduler