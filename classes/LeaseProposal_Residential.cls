public class LeaseProposal_Residential{
    public String apiKey;   //DC97-20AF-567E
    public String templateName; //Spanish Contract V24
    public String watermark;    //
    public cls_proposalPayload[] proposalPayload;
    public cls_chartPayload chartPayload;
    public cls_nameValuePairs[] nameValuePairs;
    public cls_dynamicImages[]  dynamicImages;
    public class cls_proposalPayload {
        public String dealType; //Lease
        public String dealerLogo;   //
        public cls_dealerInfo dealerInfo;
        public cls_utilityInfo[] utilityInfo;
        public cls_salesPersonInfo salesPersonInfo;
        public cls_clientInfo[] clientInfo;
        public cls_addressInfo[] addressInfo;
        public cls_yearlyProductionList[] yearlyProductionList;
        public cls_monthlyConsumptionList[] monthlyConsumptionList;
        public cls_monthlyProductionList[] monthlyProductionList;
        public cls_monthlyUtilityBillBeforeSolar[] monthlyUtilityBillBeforeSolar;
        public cls_monthlyUtilityBillAfterSolar[] monthlyUtilityBillAfterSolar;
        public cls_monthlyLeasePaymentList[] monthlyLeasePaymentList;
        public cls_inverterList[] inverterList;
        public cls_moduleInfo moduleInfo;
        public cls_annualBillList[] annualBillList;
        public Integer firstYearBillBeforeSolar;    //2122
        public Integer firstYearBillAfterSolar; //358
        public Decimal downPayment; //0
        public Integer annualLeasePaymentIncrease;  //0
        public Double systemSizeDC; //5.5
        public Double systemSizeAC; //5.5
        public String monitoringSetup;  //7 Small Cameras
        public String rackingSetup; //InvisiMount
        public Double yearlyElectricBillIncrease;  //2
        public String quoteNumber;  //123H789456
        public String proposalCreatedDate;  //2015-09-27T00:00:00.000-0500
        public Double grossSystemCost;  //35214.23
        public Integer estimatedRebate; //2512
    }
    public class cls_chartPayload{
        public String chartSource; // "ProposalPayLoad" Hardcoded Value
    }
    public class cls_dealerInfo {
        public String shortName;    //SunPower
        public String legalName;    //SunPower Capital LLC
        public String contractorNumber; //456a-hfg4u
        public String address;  //456 Street Dr
        public String city; //Home
        public String state;    //XS
        public String zipCode;  //854711236
        public String phone;    //1234569870
    }
    public class cls_utilityInfo {
        public String currentOrTarget;  //both
        public String companyName;  //Electricity Power Co.
        public String ratePlan; //Alpha Plan
        public String territoryCode;    //Far Away Region
        public cls_tierInfo[] tierInfo;
        public Boolean timeOfUse;
    }
    public class cls_tierInfo {
        public Integer month;   //1
        public Integer tierNumber;  //1
        public Integer tierSize;    //101
        public Double tierRate; //12.12
    }
    public class cls_salesPersonInfo {
        public String firstName;    //Alan
        public String lastName; //Curtis
        public String email;    //email@gmail.com
        public String phone;    //1630258741
    }
    public class cls_clientInfo {
        public String firstName;    //Mike
        public String lastName; //Warne
        public String email;    //email@gmail.com
        public String phoneCell;    //1234567890
        public String phoneHome;    //1234567890
        public String phoneWork;    //1234567890
    }
    public class cls_addressInfo {
        public String address;  //123564 Main Street
        public String addressSecondLine;
        public String city; //Some Town
        public String state;    //CA
        public String zipCode;  //90210
    }
    public class cls_yearlyProductionList {
        public Integer year;    //1
        public Integer production;  //5362
    }
    public class cls_monthlyConsumptionList {
        public Integer month;   //1
        public Integer consumption; //325
    }
    public class cls_monthlyProductionList {
        public Integer month;   //1
        public Integer production;  //316
    }
    public class cls_monthlyUtilityBillBeforeSolar {
        public Integer month;   //1
        public Decimal amount;  //154
    }
    public class cls_monthlyUtilityBillAfterSolar {
        public Integer month;   //1
        public Decimal amount;  //154
    }
    public class cls_monthlyLeasePaymentList {
        public Integer year;    //1
        public Decimal amount;  //55
    }
    public class cls_inverterList {
        public String inverterManufacturer; //SunPower
        public String inverterType; //SPR-3001 240v
        public Integer inverterCount;   //2
    }
    public class cls_moduleInfo {
        public String moduleManufacturer;   //SunPower
        public String moduleType;   //SPR-250 BLK D
        public Integer moduleCount;
        public String moduleCurrent;
        public String moduleSeries;
        public String moduleWattage;
    }
    public class cls_annualBillList {
        public Integer year;    //1
        public Decimal beforeSolar; //2122
        public Decimal afterSolar;  //358
    }
    public class cls_nameValuePairs {
        public String name; //sector
        public String value;    //Residential
    }
    public class cls_dynamicImages {
        public String imageKey; 
        public String imageUrl;
        public String base64encodedImage;     
    }
}