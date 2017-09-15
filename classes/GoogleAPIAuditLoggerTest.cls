/* TEST CLASS for APEX CLASS: GoogleAPIAuditLogger
 */
@isTest
public class GoogleAPIAuditLoggerTest
{
    public static testmethod void TM1()
    {
        GoogleAPIAuditLogger.Register('000000000000000','dummy.' + String.valueOf(DateTime.now().getTime()) + '@testx.com', DateTime.now().addDays(-2));
        GoogleAPIAuditLogger.Register('000000000000000','dummy.' + String.valueOf(DateTime.now().getTime()) + '@testx.com', DateTime.now().addDays(-8));
        GoogleAPIAuditLogger.Register('000000000000000','dummy.' + String.valueOf(DateTime.now().getTime()) + '@testx.com', DateTime.now().addDays(-9));
        GoogleAPIAuditLogger.Register('000000000000000','dummy.' + String.valueOf(DateTime.now().getTime()) + '@testx.com', DateTime.now().addDays(-10));
        GoogleAPIAuditLogger.Register('000000000000000','dummy.' + String.valueOf(DateTime.now().getTime()) + '@testx.com', DateTime.now().addDays(-11));   
        
        List<GoogleAPIAuditSummaryRecipient__c> lstGAASR = new List<GoogleAPIAuditSummaryRecipient__c>();
        lstGAASR.add(new GoogleAPIAuditSummaryRecipient__c(name= 'dummyU1.' + String.valueOf(DateTime.now().getTime()) + '@testx.com'));
        lstGAASR.add(new GoogleAPIAuditSummaryRecipient__c(name= 'dummyU2.' + String.valueOf(DateTime.now().getTime()) + '@testx.com'));
        lstGAASR.add(new GoogleAPIAuditSummaryRecipient__c(name= 'dummyU3.' + String.valueOf(DateTime.now().getTime()) + '@testx.com'));
        insert lstGAASR;
        
        GoogleAPIAuditLogger.ProcessCleanUp();
        
        Test.startTest();
         //   String jobId = System.schedule('GoogleAPIAuditLoggerCleanupScheduler', GoogleAPIAuditLoggerCleanupScheduler.CRON_EXP, new GoogleAPIAuditLoggerCleanupScheduler());
         String jobId = System.schedule('GoogleAPIAuditCleanupScheduler' + '-' + GoogleAPIAuditLogger.RandomString(), GoogleAPIAuditLoggerCleanupScheduler.CRON_EXP, new GoogleAPIAuditLoggerCleanupScheduler());
        Test.stopTest();        
    }//End TM1
}//End Class GoogleAPIAuditLoggerTest