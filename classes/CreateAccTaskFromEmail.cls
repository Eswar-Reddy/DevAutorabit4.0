global class CreateAccTaskFromEmail implements Messaging.InboundEmailHandler {
      
      static final String ACCOUNT_ID_PREFIX = Account.SObjectType.getDescribe().getKeyPrefix();
      global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
          
          Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
          
          String emailBody = email.plainTextBody;
          String accountId = '';
          
          // checking for the account Id
          if(emailBody.contains('Id : *** ')){
              accountId = emailBody.substring(emailBody.indexOf('Id : *** ')+9,emailBody.indexOf('Id : *** ')+24);
              system.debug('********** account Id******* = '+accountId);
          }
          
          // Checking for the valid accountId
          if(accountId.contains(ACCOUNT_ID_PREFIX)){
          
              String bodyHeader = 'Email recieved From : '+email.fromName+' < '+email.fromAddress+' > \n'+
                                     '\n Additional\n To:'+ email.toAddresses; 
                                     
              if(email.CcAddresses != null){
                 bodyHeader +=  '\n CC: '+ email.CcAddresses;
              }
              // new Task object to be created from the incoming email
              Task[] newTask = new Task[0];
              
              // Quering Task RecordTypeID for 'Task visible to SunPower only'
              ID visibleToSPonlyRecordTypeId = null;
              Map<String, Schema.RecordTypeInfo> nameToTaskRecordTypeInfoMap = Schema.SObjectType.Task.getRecordTypeInfosByName();
              visibleToSPonlyRecordTypeId = nameToTaskRecordTypeInfoMap.get('Task visible to SunPower only').getRecordTypeId(); 

              
              newTask.add(new Task(
                  Description = bodyHeader + '\n'+'----------------------------------------------------------\n\n'
                                     + emailBody,
                  Priority = 'Normal',
                  RecordTypeId = visibleToSPonlyRecordTypeId,
                  Status = 'Completed',
                  Subject = email.subject,
                  IsReminderSet = true,
                  WhatId = accountId));
             // Insert the new Task and it will be created and appended to the related account record
              try{
                  insert newTask;
              }
              catch (System.Exception e) {
                  System.debug('Error : '+e);
              }
         }
          // Set the result to true, no need to send an email back to the user with an error message
          result.success = true;
          return result;
      }
  }