public class CreditAppPdfController {

    public Credit_Application__c creditApp{get;set;} 
    public string id{get;set;} 
    public List<ListOption> listoptOrgType{get;set;}
    // Applicant_Type__c
    public List<ListOption> listoptApplicantType{get;set;}
    
    //Tax_Exempt__c
    public List<ListOption> listTaxExempt{get;set;}
    
     //load all picklist and checkbox values
    public void populate() {
    	creditApp = new Credit_Application__c();
    	List<Credit_Application__c> listCreditApps = new List<Credit_Application__c>([Select Years_in_Business__c, VAT_Number__c, 
    								Trade_Reference_2_Zip__c, Trade_Reference_2_State__c, Trade_Reference_2_Phone__c, 
    								Trade_Reference_2_Fax__c, Trade_Reference_2_Email__c, Trade_Reference_2_Country__c, 
    								Trade_Reference_2_Contact_Account__c, Trade_Reference_2_Company__c, Trade_Reference_2_City__c, 
    								Trade_Reference_2_Address__c, Trade_Reference_1_Zip__c, Trade_Reference_1_State__c, 
    								Trade_Reference_1_Phone__c, Trade_Reference_1_Fax__c, Trade_Reference_1_Email__c, 
    								Trade_Reference_1_Country__c, Trade_Reference_1_Contact_Account__c, Trade_Reference_1_Company__c, 
    								Trade_Reference_1_City__c, Trade_Reference_1_Address__c, Tax_Exempt__c, 
    								SystemModstamp, Status__c, State_of_Incorporation__c, Ship_To_Zip__c, Ship_To_State__c, 
    								Ship_To_Phone__c, Ship_To_Country__c, Ship_To_City__c, Ship_To_Address__c, Sent_to_Oracle__c, 
    								Resale_Certificate_Form__c, Principal_4_Zip__c, Principal_4_Title__c, Principal_4_State__c, 
    								Principal_4_SSN__c, Principal_4_Name__c, Principal_4_Home_Address__c, Principal_4_Email__c, 
    								Principal_4_Contact__c, Principal_4_City__c, Principal_3_Zip__c, Principal_3_Title__c, 
    								Principal_3_State__c, Principal_3_SSN__c, Principal_3_Name__c, 
    								Principal_3_Home_Address__c, Principal_3_Email__c, Principal_3_Contact__c, 
    								Principal_3_City__c, Principal_2_Zip__c, Principal_2_Title__c, 
    								Principal_2_State__c, Principal_2_SSN__c, Principal_2_Name__c, 
    								Principal_2_Home_Address__c, Principal_2_Email__c, Principal_2_Contact__c, 
    								Principal_2_City__c, Principal_1_Zip__c, Principal_1_Title__c, 
    								Principal_1_State__c, Principal_1_SSN__c, Principal_1_Name__c, 
    								Principal_1_Home_Address__c, Principal_1_Email__c, Principal_1_Contact__c, 
    								Principal_1_City__c, Parent_Company_Name__c, OwnerId, 
    								Organization_Type__c, Number_of_Employees__c, 
    								Notarized_Personal_Guaranty__c, Name, List_D_B_A_s__c, Letter_of_Credit__c, Legal_Company_Name__c, 
    								LastModifiedDate, LastModifiedById, LastActivityDate, IsDeleted, Invalid_Legal_Name__c, 
    								Insurance_Insurer__c, Insurance_Amount_of_Liability_Insured__c, Insurance_Account_Number__c, 
    								Id, Financial_Statements_2008__c, Financial_Statements_2007__c, 
    								Financial_Officer__c, Financial_Officer_Phone__c, 
    								Financial_Officer_Email__c, Financial_Officer_Contact__c, Financial_Office_Fax__c, 
    								Federal_Tax_ID__c, Dun_Bradstreet_Number__c, Date_of_Incorporation__c, 
    								Date_of_Application__c, CurrencyIsoCode, Cross_Corporate_Guaranty__c, 
    								Credit_Review_Date__c, Credit_Limit__c, Credit_Limit_Requested__c, 
    								Credit_Application_Signature_Date__c, Credit_Application_Signatory_2_Title__c, 
    								Credit_Application_Signatory_2_Name__c, Credit_Application_Signatory_2_Date__c, 
    								Credit_Application_Signatory_1_Title__c, Credit_Application_Signatory_1_Name__c, 
    								Credit_Application_Signatory_1_Date__c, Credit_Application_Received_Date__c, 
    								Credit_Application_Accepted_Date__c, CreatedDate, CreatedById, Bill_To_Zip__c, 
    								Bill_To_State__c, Bill_To_Phone__c, Bill_To_Country__c, 
    								Bill_To_City__c, Bill_To_Address__c, Bank_Reference_Zip__c, Bank_Reference_State__c, 
    								Bank_Reference_Phone__c, Bank_Reference_Name__c, Bank_Reference_Fax__c, Bank_Reference_Email__c, 
    								Bank_Reference_Credit_Line_Available__c, Bank_Reference_Country__c, Bank_Reference_Contact__c, 
    								Bank_Reference_City__c, Bank_Reference_Address__c, Bank_Information_Release_Signatory_Title__c, 
    								Bank_Information_Release_Signatory_Name__c, Bank_Information_Release_Signatory_Date__c,  
    								Bank_Account_Numbers__c, Applicant_Type__c, Accounts_Payable__c, Accounts_Payable_Phone__c, 
    								Accounts_Payable_Fax__c, Accounts_Payable_Email__c, Accounts_Payable_Contact__c, Account__c 
    								From Credit_Application__c 
    								where Id=:id limit 1]);
    	if(listCreditApps.Size()>0){
    		creditApp =  listCreditApps.get(0);
    		//[Select Years_in_Business__c, VAT_Number__c, Trade_Reference_2_Zip__c, Trade_Reference_2_State__c, Trade_Reference_2_Phone__c, Trade_Reference_2_Fax__c, Trade_Reference_2_Email__c, Trade_Reference_2_Country__c, Trade_Reference_2_Contact_Account__c, Trade_Reference_2_Company__c, Trade_Reference_2_City__c, Trade_Reference_2_Address__c, Trade_Reference_1_Zip__c, Trade_Reference_1_State__c, Trade_Reference_1_Phone__c, Trade_Reference_1_Fax__c, Trade_Reference_1_Email__c, Trade_Reference_1_Country__c, Trade_Reference_1_Contact_Account__c, Trade_Reference_1_Company__c, Trade_Reference_1_City__c, Trade_Reference_1_Address__c, Tax_Exempt__c, SystemModstamp, Status__c, State_of_Incorporation__c, Ship_To_Zip__c, Ship_To_State__c, Ship_To_Phone__c, Ship_To_Country__c, Ship_To_City__c, Ship_To_Address__c, Sent_to_Oracle__c, Resale_Certificate_Form__c, Principal_4_Zip__c, Principal_4_Title__c, Principal_4_State__c, Principal_4_SSN__c, Principal_4_Name__c, Principal_4_Home_Address__c, Principal_4_Email__c, Principal_4_Contact__c, Principal_4_City__c, Principal_3_Zip__c, Principal_3_Title__c, Principal_3_State__c, Principal_3_SSN__c, Principal_3_Name__c, Principal_3_Home_Address__c, Principal_3_Email__c, Principal_3_Contact__c, Principal_3_City__c, Principal_2_Zip__c, Principal_2_Title__c, Principal_2_State__c, Principal_2_SSN__c, Principal_2_Name__c, Principal_2_Home_Address__c, Principal_2_Email__c, Principal_2_Contact__c, Principal_2_City__c, Principal_1_Zip__c, Principal_1_Title__c, Principal_1_State__c, Principal_1_SSN__c, Principal_1_Name__c, Principal_1_Home_Address__c, Principal_1_Email__c, Principal_1_Contact__c, Principal_1_City__c, Parent_Company_Name__c, OwnerId, Organization_Type__c, Number_of_Employees__c, Notarized_Personal_Guaranty__c, Name, List_D_B_A_s__c, Letter_of_Credit__c, Legal_Company_Name__c, LastModifiedDate, LastModifiedById, LastActivityDate, IsDeleted, Invalid_Legal_Name__c, Insurance_Insurer__c, Insurance_Amount_of_Liability_Insured__c, Insurance_Account_Number__c, Id, Financial_Statements_2008__c, Financial_Statements_2007__c, Financial_Officer__c, Financial_Officer_Phone__c, Financial_Officer_Email__c, Financial_Officer_Contact__c, Financial_Office_Fax__c, Federal_Tax_ID__c, Dun_Bradstreet_Number__c, Date_of_Incorporation__c, Date_of_Application__c, CurrencyIsoCode, Cross_Corporate_Guaranty__c, Credit_Review_Date__c, Credit_Limit__c, Credit_Limit_Requested__c, Credit_Application_Signature_Date__c, Credit_Application_Signatory_2_Title__c, Credit_Application_Signatory_2_Name__c, Credit_Application_Signatory_2_Date__c, Credit_Application_Signatory_1_Title__c, Credit_Application_Signatory_1_Name__c, Credit_Application_Signatory_1_Date__c, Credit_Application_Received_Date__c, Credit_Application_Accepted_Date__c, CreatedDate, CreatedById, Bill_To_Zip__c, Bill_To_State__c, Bill_To_Phone__c, Bill_To_Country__c, Bill_To_City__c, Bill_To_Address__c, Bank_Reference_Zip__c, Bank_Reference_State__c, Bank_Reference_Phone__c, Bank_Reference_Name__c, Bank_Reference_Fax__c, Bank_Reference_Email__c, Bank_Reference_Credit_Line_Available__c, Bank_Reference_Country__c, Bank_Reference_Contact__c, Bank_Reference_City__c, Bank_Reference_Address__c, Bank_Information_Release_Signatory_Title__c, Bank_Information_Release_Signatory_Name__c, Bank_Information_Release_Signatory_Date__c, Bank_Account_Numbers__c, Applicant_Type__c, Accounts_Payable__c, Accounts_Payable_Phone__c, Accounts_Payable_Fax__c, Accounts_Payable_Email__c, Accounts_Payable_Contact__c, Account__c From Credit_Application__c where Id=:id];
    	}	
    	loadOrgType();
    	loadApplicantType();
    	
    	listTaxExempt = new List<ListOption> ();
    	listTaxExempt =  loadCheckBoxValues('Tax_Exempt__c');
    }
	public CreditAppPdfController(ApexPages.StandardController controller){
		
		if(ApexPages.CurrentPage().getParameters().get('id') != null) {
         	id = ApexPages.CurrentPage().getParameters().get('id');
         }
        populate();
	}	
	
	//to get Organization_Type__c 
    public String getOrganizationType(){
    	String orgType;
    	List<Credit_Application__c> lpa = new List<Credit_Application__c>([Select  Organization_Type__c from Credit_Application__c where Id=:id]);
    	if(lpa.Size()>0){
    		orgType = lpa.get(0).Organization_Type__c;
    	}
    	return orgType;
    }
    
      //to show all picklist values on pdf Organization_Type__c
    public void loadApplicantType(){
    	listoptApplicantType = new List<ListOption>();
    	String at = getApplicantType();
    	ListOption lo;
    	Schema.DescribeFieldResult F = Credit_Application__c.Applicant_Type__c.getDescribe();
        List<Schema.PicklistEntry> P = F.getPicklistValues();
        for(Schema.PicklistEntry entry : P){
        	 lo =  new ListOption(entry.getLabel());
        	 if(at == entry.getLabel()) {
        	 	lo.renderChecked = true;
        	 }
        	 else {
        	 	lo.renderChecked = false; 
        	 }	
        	listoptApplicantType.add(lo);
        }
    }
    
    //to get Applicant_Type__c 
    public String getApplicantType(){
    	String at;
    	List<Credit_Application__c> lpa = new List<Credit_Application__c>([Select  Applicant_Type__c from Credit_Application__c where Id=:id]);
    	if(lpa.Size()>0){
    		at = lpa.get(0).Applicant_Type__c;
    	}
    	return at;
    }
    
      //to show all picklist values on pdf Organization_Type__c
    public void loadOrgType(){
    	listoptOrgType = new List<ListOption>();
    	String orgType = getOrganizationType();
    	ListOption lo;
    	Schema.DescribeFieldResult F = Credit_Application__c.Organization_Type__c.getDescribe();
        List<Schema.PicklistEntry> P = F.getPicklistValues();
        for(Schema.PicklistEntry entry : P){
        	 lo =  new ListOption(entry.getLabel());
        	 if(orgType == entry.getLabel()) {
        	 	lo.renderChecked = true;
        	 }
        	 else {
        	 	lo.renderChecked = false; 
        	 }	
        	listoptOrgType.add(lo);
        }
    }
	
	
     //to show yes no on pdf
    public List<ListOption> loadCheckBoxValues(String fieldname){
    	List<ListOption> loTemp = new List<ListOption>();
    	Boolean val = getValue(fieldname);
    	ListOption lo =  new ListOption('Yes');
    	lo.renderChecked = true;
    	if(val){
    		lo.renderChecked = true;
    	}
    	else{
    		lo.renderChecked = false;
    	}
    	loTemp.add(lo);
    	lo =  new ListOption('No');
    	lo.renderChecked = true;
    	if(val){
    		lo.renderChecked = false;
    	}
    	else{
    		lo.renderChecked = true;
    	}
    	loTemp.add(lo);
        return loTemp;	
        
    }
   public Boolean getValue(String fieldname){
    	Boolean val;
    	if(creditApp != null && creditApp.get(fieldname) != null) {
    		val = Boolean.valueOf(creditApp.get(fieldname));
    	    return val;	 
    	}
    	return false;
    }
     
    public class ListOption{
    	public listOption(string name){
    		this.name = name;
    	}
    	public string name{get;set;}
    	//public string imageName{get;set;}
    	public Boolean renderChecked{get;set;}
    }
   
}