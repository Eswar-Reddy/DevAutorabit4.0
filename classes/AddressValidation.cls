public with sharing class AddressValidation {
	public AddressValidation() {
		
	}

	public static Boolean isValid(String address){
		List<UnAcceptableCharactersAddress__c> unAcceptableCharacters = UnAcceptableCharactersAddress__c.getAll().values();
		List<String> characterList = new List<String>();
		for(UnAcceptableCharactersAddress__c a : unAcceptableCharacters){
			characterList.add(a.Name);
		}
		Boolean b = false;
		String errorMessage = System.Label.AddressValidation1;
		String errorString = '';
		for(String  str : characterList){
			if(address.contains(str)){
				errorString += str;
				b = true;
			}
		}
        if(b)
           ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.Error,System.Label.AddressValidation1 + '  '+ errorString + System.Label.AddressValidation2)); 
		return b;
	}
}