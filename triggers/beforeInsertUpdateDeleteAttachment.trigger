/********************************************************************************************
Name   : beforeInsertUpdateDeleteAttachment
Author : Jitendra Kothari
Date   : July 08, 2011
Usage  : Trigger on Attachment Object to disallowing insert/update/delete on approved design.
Case   : 00068744
********************************************************************************************/
trigger beforeInsertUpdateDeleteAttachment on Attachment (before delete, before insert, before update,after insert) {    
    if(Trigger.isInsert || Trigger.isUpdate){       
        AttachmentNotesManagement.checkDesignAttach(trigger.new);
     if(Trigger.isAfter){
           
        //    
           TPSDocumentUtility.updateInvoiceDocumentWithUploaded(Trigger.newMap); 
        
        // Enable the Create Lease Contract button based on all the required document are uploaded or not !!   
           TPSDocumentUtility.fApproveLeaseContractCreation(Trigger.newMap); 
        
        if(Trigger.isInsert)
           AgreementUtility.SendNoticeofCancellationEmail(Trigger.New);    
        
        }    
    }
    else if(Trigger.isDelete){      
        AttachmentNotesManagement.checkDesignAttach(trigger.old);
    }
}