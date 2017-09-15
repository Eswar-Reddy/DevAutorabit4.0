public class MosaicJSONUtil {
    
    public class Opportunity{
        public Integer id;
        public String firstName;
        public String lastName;
        public String phone;
        public String email;
        public Address address;
        public String status;
        public String waitingOn;
        public String salesRepEmail;
        public SolarSystem solarSystem;
        
        public Opportunity(String fName,String lName,String Phn,String eml,Address addr,String srepEmail,SolarSystem ss){
        	firstName = fName;
            lastName = lName;
            phone = Phn;
            email = eml;
            address = addr;
            salesRepEmail=srepEmail;
            solarSystem=ss;
    	}
    }
    
    public class createLogin{
        public String firstName;
        public String lastName;
        public String phone;
        public String email;
        public String password;
        public String role;
        public String position;

        public createLogin(String fName,String lName,String phn,String eml,String pwd,String uRole,String pos){
            firstName = fName;
            lastName = lName;
            phone = phn;
            email = eml;
            password = pwd;
            role=uRole;
            position=pos;
        }

    }
    public class Address{
        public String street;
        public String streetTwo;
        public String city;
        public String state;
        public String zip;
        
        public Address(String st,String st2,String cty,String stt,String zp){
            street = st;
            streetTwo = st2;
            city = cty;
            state = stt;
            zip = zp;
        }
    } 
    
    public class SolarSystem{
        public Double monthlyBillBeforeSolar;
        public Double monthlyBillAfterSolar;
        public Integer estAnnualProduction;
        public Double dcSystemSizeKw;
        public String pvModules; //must match a manufacturer and module on your equipment list in the Mosaic portal
        public String pvInverter; //must match a manufacturer and inverter on your equipment list in the Mosaic portal
        public Double cost;
        public String estInstallDate; //in the format YYYY-MM-DD
        public String installerAgreementId;
        public String installerAgreementDate; //in the format YYYY-MM-DD
        public String omProvider;
        public Double loanAmountLessDealerFee; //Note: loanAmountLessDealerFee is provided for internal use only and is not to be used in any borrower-facing materials.
        public String loanProductName; //must match one of the product display names in [Loan Terms JSON]
        public Double totalSystemPrice; //Total System Price value to come from System Cost field on Quote
        
        
        public SolarSystem(Double monthlyBillBeforeSolar1,Double monthlyBillAfterSolar1,Integer estAnnualProduction1,Double dcSystemSizeKw1,String pvModules1,
                          	String pvInverter1,Double cost1,String estInstallDate1, String installerAgreementId1,String installerAgreementDate1,String omProvider1,
                          	String loanProductName1, Double totalSystemPrice1){
            monthlyBillBeforeSolar = monthlyBillBeforeSolar1;
            monthlyBillAfterSolar = monthlyBillAfterSolar1;
            estAnnualProduction = estAnnualProduction1;
            dcSystemSizeKw = dcSystemSizeKw1;
            pvModules = pvModules1;
            pvInverter = pvInverter1;
            cost = cost1;
            estInstallDate = estInstallDate1;
            installerAgreementId =installerAgreementId1;
            installerAgreementDate = installerAgreementDate1;
            omProvider = omProvider1;
            loanProductName = loanProductName1;
            totalSystemPrice = totalSystemPrice1;
        }
    }
    
    public class MosaicResponse{
        public boolean successful;
        public Opportunity opp;
        public String responsebody;
        public HttpRequest request;
        public HttpResponse response;
    }
    
    /*
    public class LoanTerms{
        public Integer productId;
    	public String productName;
    	public String productDisplayName;
    	public Integer loanMonthTerm;
    	public Double choiceRate;
    	public Double standardRate;
    	public Integer maxLoanAmount;
    	public Integer minLoanAmount;
        
        public LoanTerms(Integer productId1,String productName1,String productDisplayName1,Integer loanMonthTerm1,Double choiceRate1,Double standardRate1,Integer maxLoanAmount1,Integer minLoanAmount1){
            productId = productId1;
            productName = productName1;
            productDisplayName = productDisplayName1;
            loanMonthTerm = loanMonthTerm1;
            choiceRate = choiceRate1;
            standardRate = standardRate1;
            maxLoanAmount = maxLoanAmount1;
            minLoanAmount = minLoanAmount1;
        }
    }
    
    public class LoanAgreement{
    	public Integer loanAgreementNumber;
    	public Date dateSigned;
    	public Date dateCountersigned;
    	public Integer loanAmount;
    	public Integer choiceMonthlyPayment;
    	public Integer standardMonthlyPayment;
		public LoanTerms loanterms;
        
        public LoanAgreement(Integer loanAgreementNumber1,Date dateSigned1,Date dateCountersigned1,Integer loanAmount1,Integer choiceMonthlyPayment1,Integer standardMonthlyPayment1,LoanTerms loanterms1){
            loanAgreementNumber = loanAgreementNumber1;
            dateSigned = dateSigned1;
            dateCountersigned = dateCountersigned1;
            loanAmount = loanAmount1;
            choiceMonthlyPayment = choiceMonthlyPayment1;
            standardMonthlyPayment = standardMonthlyPayment1;
            loanterms = loanterms1;
        }
    }
    
    public class CreditDecision{
    	public String decision;
    	public Date expirationDate;
        public List<LoanTerms> loanTermsList;
    }*/
}