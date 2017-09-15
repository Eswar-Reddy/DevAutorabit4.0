public class DuplicateContactCheck {

public static String processRecords(Contact[] contactArr,Contact matchContact) {
  Integer[] matchCount = new Integer[contactArr.size()];
  String error = '';
  for(Integer i = 0; i < contactArr.size();i++) {
    if(isNameMatches(contactArr[i],matchContact)==1 && isPhoneMatches(contactArr[i],matchContact)==1){
      if(isNameMatches(contactArr[i],matchContact)==1)
        error += 'Name';
      if(isPhoneMatches(contactArr[i],matchContact)==1)
        error += error == '' ? 'Phone':',Phone';
    }
    if(isEmailMatches(contactArr[i],matchContact)==1)
        error += error == '' ? 'Email':',Email';
    if(error != '')
        break;
  }

  if(error != '')
      return 'A possible duplicate was found.The ' + error + ' matches another record in the system';
  else
    return '';
}

public static Integer isPhoneMatches(Contact originalContact,Contact matchContact) {
    if(originalContact.Phone == matchContact.Phone)
        return 1;
    return 0;
}

public static Integer isEmailMatches(Contact originalContact,Contact matchContact) {
    if(originalContact.Email == matchContact.Email) {
        return 1;
    }
        return 0;
}

public static Integer isNameMatches(Contact originalContact,Contact matchContact) {
    if(originalContact.FirstName == matchContact.FirstName
        && originalContact.LastName == matchContact.LastName) {
            return 1;
    }
          return 0;
    }
    
}