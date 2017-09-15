public class CashProposal_NewHomes{
    public String apiKey;   //DC97-20AF-567E
    public String documentType; //cash
    public cls_dealerInfo dealerInfo;
    public cls_utilityInfo[] utilityInfo;
    public cls_salesPersonInfo salesPersonInfo;
    public cls_clientInfo[] clientInfo;
    public cls_addressInfo[] addressInfo;
    public cls_yearlyProductionList[] yearlyProductionList;
    public cls_monthlyConsumptionList[] monthlyConsumptionList;
    public cls_monthlyProductionList[] monthlyProductionList;
    public cls_monthlyUtilityBillBeforeSolar[] monthlyUtilityBillBeforeSolar;
    public cls_inverterList[] inverterList;
    public cls_moduleInfo moduleInfo;
    public Integer firstYearBillBeforeSolar;    //2122
    public Integer firstYearBillAfterSolar; //358
    public Double grossSystemCost;  //35214.23
    public Integer estimatedRebate; //2512
    public Double salesTaxRate; //7.5
    public Double systemSizeDC; //5.5
    public String monitoringSetup;  //7 Small Cameras
    public String rackingSetup; //InvisiMount
    public Integer yearlyElectricBillIncrease;  //2
    public String quoteNumber;  //123H789456
    public String proposalCreatedDate;  //2015-09-27T00:00:00.000+0000
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
        public Boolean timeOfUse;// Has to be removed when moved to UAT. 
        public cls_tierInfo[] tierInfo;
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
        public cls_addressSecondLine addressSecondLine;
        public String city; //Some Town
        public String state;    //CA
        public String zipCode;  //90210
    }
    public class cls_addressSecondLine {
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
    public class cls_inverterList {
        public String inverterManufacturer; //SunPower
        public String inverterType; //SPR-3001 240v
        public Integer inverterCount;   //2
    }
    public class cls_moduleInfo {
        public String moduleManufacturer;   //SunPower
        public String moduleType;   //SPR-250 BLK D
        public Integer moduleCount; //20
    }
    
}