/* Class created to process the Google API calls being made
 * method Register() : It takes 3 parameters 
                       prm1: Id of the Objects record
                       prm2: Current logged in user who initiated the process
                       prm3: Timestamp when it was done
 * Uses a customsetting to log the Audit. Custom setting name "GoogleAPIAudit"
 */
public class GoogleAPIAuditLogger
{
    public static void Register(String recId, String loggedinUser, DateTime whenDT)
    {
        GoogleAPIAudit__c gaa = new GoogleAPIAudit__c(name= String.valueOf(DateTime.now().getTime()) + '-' + GoogleAPIAuditLogger.RandomString(),
                                                      WhatID__c= recId,
                                                      LoggedIn_Username__c= loggedinUser,
                                                      API_Call_Made_At__c= whenDT);
        insert gaa;
    }//End Func Register
    
    //Function to generate a random String
    public static String RandomString()
    {
        String str = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghiklmnopqrstuvwxyz';
        Integer randomStringLength = 8;
        String rString = '';
        for (Integer i=0; i<randomStringLength; i++) {
            Integer rnum = Integer.valueOf(Math.floor(Math.random() * str.length()));
            rString += str.substring(rnum, rnum+1);
        }
        return rString;
    }//End Func RandomString
	
	//Cleanup Custom Setting: GoogleAPIAudit__c records which are more than 7 days old 
	//also notify Admins with the last 7 days API Uses
	public static void ProcessCleanUp()
	{
		Integer iSequence = 1;
		Map<Integer, String> mAPICounts = new Map<Integer, String>();	
		for(AggregateResult ar : [SELECT COUNT(Id), 
										 day_only(API_Call_Made_At__c) 
								  FROM GoogleAPIAudit__c 
								  GROUP BY day_only(API_Call_Made_At__c) 
								  ORDER BY day_only(API_Call_Made_At__c) DESC])  
		{
			mAPICounts.put(iSequence++, String.valueOf(ar.get('expr1')).replace(' 00:00:00 GMT ', ' ').subString(0,10) + '==' + String.valueOf(ar.get('expr0')));
		}
									  
		List<Database.DeleteResult> recDels = Database.delete([SELECT Id, API_Call_Made_At__c  
															   FROM GoogleAPIAudit__c 
															   WHERE API_Call_Made_At__c < LAST_N_DAYS:7
															   ORDER BY API_Call_Made_At__c DESC 
															   LIMIT 10000]);
		Integer delResult = 0;
		for(Database.DeleteResult dr : recDels) 
			if (dr.isSuccess())
				delResult++;
		Map<String, GoogleAPIAuditSummaryRecipient__c> mGAASR = GoogleAPIAuditSummaryRecipient__c.getAll();
		GoogleAPIAuditLogger.SendSummaryEmail(mAPICounts, delResult, (!mGAASR.isEmpty() ? mGAASR.keySet() : new Set<String>()));
		//GoogleAPIAuditLogger.SendSummaryEmail(mAPICounts, delResult, [SELECT id, Email FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true]);
	}//End Func ProcessCleanUp

	//Notify Administrator by Summary mail
	public static void SendSummaryEmail(Map<Integer, String> mSummary, Integer deletedRecordCount, Set<String> toEmailList)
	{
		List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>(); 
		String sEmailBdy = '';
		if(!mSummary.isEmpty())
		{
			List<Integer> iSeq = new List<Integer>();
			iSeq.addAll(mSummary.keySet());
			iSeq.sort();
			
			sEmailBdy += '<table>';
			sEmailBdy += '<tr><td></td><td></td></tr>';
			sEmailBdy += '<tr>';
			sEmailBdy += '<td colspan="2" style="font-weight:bold">GoogleAPI Call Audit Summary for: ' + Date.today().format() + '<br/><br/></td>';
			sEmailBdy += '</tr>';
			sEmailBdy += '<tr>';
			sEmailBdy += '<td colspan="2">Total <b>' + String.valueOf(deletedRecordCount) + '</b> old records which were more than 7 days old where deleted from Custom Setting: GoogleAPIAudit today.<br/><br/></td>';
			sEmailBdy += '</tr>';
			sEmailBdy += '<tr><td></td><td></td></tr>';
			sEmailBdy += '<tr><td colspan="2">Google API callout summary:</td></tr>';
			sEmailBdy += '<tr><td></td><td></td></tr>';
			sEmailBdy += '<tr>';
			sEmailBdy += '<td colspan="2"><table width="100%" cell-padding="0"><tr><th style="font-weight:bold;border-bottom:1px solid #000000;" align="left">Date</th><th style="font-weight:bold;border-bottom:1px solid #000000;padding-left:5px" align="left">Total GoogleAPI Calls Made</th></tr>';
			for(Integer i: iSeq)
			{
				sEmailBdy +=  '<tr><td style="border-bottom:1px solid #000000;" align="left">' + mSummary.get(i).split('==')[0] + '</td><td style="border-bottom:1px solid #000000;padding-left:5px" align="left"><b>' + mSummary.get(i).split('==')[1] + '</b> Calls</td></tr>';
			}
			sEmailBdy += '</table></td>';
			sEmailBdy += '</tr>';
			sEmailBdy += '<tr><td></td><td></td></tr>';
			sEmailBdy += '<tr><td><br/><br/></td><td><br/><br/></td></tr>';
			sEmailBdy += '<tr><td colspan="2">Thanks,<br/>SunPower Corporation</td></tr>';
			sEmailBdy += '</table>';			
		}
		
		if(!toEmailList.isEmpty() && String.isNotBlank(sEmailBdy))
		{			
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();        
			List<String> toAddress = new List<String>();
			toAddress.addAll(toEmailList);
			mail.SetToAddresses(toAddress); 
			mail.setReplyTo('noreply@sunpowercorp.com');
			mail.setSenderDisplayName('SunPower Corporation');			
			mail.saveAsActivity = false; 
			mail.setBccSender(false);
			mail.setUseSignature(false);
			mail.setSubject('GoogleAPI Audit Summary for ' + Date.today().format());			
			mail.setHtmlBody(sEmailBdy);
			mailList.Add(mail);
		}
		if(!Test.isRunningTest() && !mailList.isEmpty())  
			Messaging.sendEmail(mailList);  		
	}//End Func SendSummaryEmail
	
/**** As There are Admins in the system which we do not want this communication to be sent, thus the code block is commented
 ****	
	//Notify Administrator by Summary mail
	public static void SendSummaryEmail(Map<Integer, String> mSummary, Integer deletedRecordCount, List<User> toEmailList)
	{
		List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>(); 
		String sEmailBdy = '';
		if(!mSummary.isEmpty())
		{
			List<Integer> iSeq = new List<Integer>();
			iSeq.addAll(mSummary.keySet());
			iSeq.sort();
			
			sEmailBdy += '<table>';
			sEmailBdy += '<tr><td></td><td></td></tr>';
			sEmailBdy += '<tr>';
			sEmailBdy += '<td colspan="2" style="font-weight:bold">GoogleAPI Call Audit Summary for: ' + Date.today().format() + '<br/><br/></td>';
			sEmailBdy += '</tr>';
			sEmailBdy += '<tr>';
			sEmailBdy += '<td colspan="2">Total <b>' + String.valueOf(deletedRecordCount) + '</b> old records which were more than 7 days old where deleted from Custom Setting: GoogleAPIAudit today.<br/><br/></td>';
			sEmailBdy += '</tr>';
			sEmailBdy += '<tr><td></td><td></td></tr>';
			sEmailBdy += '<tr><td colspan="2">Google API callout summary:</td></tr>';
			sEmailBdy += '<tr><td></td><td></td></tr>';
			sEmailBdy += '<tr>';
			sEmailBdy += '<td colspan="2"><table width="100%" cell-padding="0"><tr><th style="font-weight:bold;border-bottom:1px solid #000000;" align="left">Date</th><th style="font-weight:bold;border-bottom:1px solid #000000;padding-left:5px" align="left">Total GoogleAPI Calls Made</th></tr>';
			for(Integer i: iSeq)
			{
				sEmailBdy +=  '<tr><td style="border-bottom:1px solid #000000;" align="left">' + mSummary.get(i).split('==')[0] + '</td><td style="border-bottom:1px solid #000000;padding-left:5px" align="left"><b>' + mSummary.get(i).split('==')[1] + '</b> Calls</td></tr>';
			}
			sEmailBdy += '</table></td>';
			sEmailBdy += '</tr>';
			sEmailBdy += '<tr><td></td><td></td></tr>';
			sEmailBdy += '<tr><td><br/><br/></td><td><br/><br/></td></tr>';
			sEmailBdy += '<tr><td colspan="2">Thanks,<br/>SunPower Corporation</td></tr>';
			sEmailBdy += '</table>';			
		}
SYSTEM.DEBUG(sEmailBdy);		
		if(!toEmailList.isEmpty() && String.isNotBlank(sEmailBdy))
		{			
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();        
			List<String> toAddress = new List<String>();
			for(User usr: toEmailList)
				toAddress.add(usr.Email);
                        toAddress.add('shree.prashant@sunpowercorp.com');
                        toAddress.add('shreeprashant@gmail.com');
			mail.SetToAddresses(toAddress); 
			mail.setReplyTo('noreply@sunpowercorp.com');
			mail.setSenderDisplayName('SunPower Corporation');			
			mail.saveAsActivity = false; 
			mail.setBccSender(false);
			mail.setUseSignature(false);
			mail.setSubject('GoogleAPI Audit Summary for ' + Date.today().format());			
			mail.setHtmlBody(sEmailBdy);
			mailList.Add(mail);
		}
		if(!Test.isRunningTest() && !mailList.isEmpty())  
			Messaging.sendEmail(mailList);  		
	}//End Func SendSummaryEmail
 *****
******/
}//End Class GoogleAPIAuditLogger