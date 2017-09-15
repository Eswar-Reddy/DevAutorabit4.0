trigger DeleteNotesAttachment on Attachment (before delete) {

    String usrProfileName = [select Profile.Name from User where id = :Userinfo.getUserId()].Profile.Name; 
    
    for(Attachment attch:Trigger.OLD) {
        if(usrProfileName.contains('Partner')) {
            if(string.valueOf(attch.ParentId).startsWith('a07')) {    // "ao7" is Agreement ID
                if(test.isrunningTest() == false) 
                    attch.ParentId.addError('You do not have permission to delete this record !!!');
            }
        }
    }
}