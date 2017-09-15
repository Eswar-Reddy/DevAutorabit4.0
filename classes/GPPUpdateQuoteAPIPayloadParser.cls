/**
 ** Parser class for GPP UpdateQuote API payload data (POST)
 ** Being used by class: GPPServicesUpdateQuoteDetails
 ** Developed: Birlasoft
 **/

public class GPPUpdateQuoteAPIPayloadParser 
{
/********************************/
/******* FUNCTION : start *******/
/********************************/

    public static GPPUpdateQuoteAPIPayloadParser  parse(String json) {
        return (GPPUpdateQuoteAPIPayloadParser) System.JSON.deserialize(json, GPPUpdateQuoteAPIPayloadParser.class);
    }//End Func parse
    
/********************************/  
/******** FUNCTION : end ********/
/********************************/


/********************************/
/******* VARIABLE : start *******/
/********************************/

    public Quote Quote;

/********************************/  
/******** VARIABLE : end ********/
/********************************/


/***************************************/
/******* WRAPPER CLASSES : start *******/  
/***************************************/

    public class Quote 
    {
        public String  keyQuoteId;
        public String  QuoteNumber;   //Added on 14th May 2014 :Birlasoft
        public String  QuoteCurrency; //Added on 21th May 2014 :Birlasoft
        public Boolean IsLocked;      //Added on 22nd May 2014 :Birlasoft
        public String  XQuoteType;    //Added on 22nd May 2014 :Birlasoft
        public String  Description;
        public String  FinancingType;
        public Integer FinancingTerm;
        public Double  SystemPrice;
        public Double SystemPriceWithoutTax;
        ////EffectiveSmartPackPrice
        public Double  SystemCost;
        public Double  QuoteAmount;  //Added on 05th June 2014 : Birlasoft
        
        public String  SiteAddress1;
        public String  SiteAddress2;
        public String  SiteCity;
        public String  SiteState;
        public String  SitePostCode;
        public String  SiteCountry;
        public String  NMI;
        
        public String  WeatherDataFile;
        public Double  WeatherLongitude;
        public Double  WeatherLatitude;
        
        public String  UtilityRetailer;
        public String  UtilityRate;
        public Double  UtilityRateEscalation;
        public String  UtilityDistributor;
        
        public String  ModuleOraceItemNumber;
        public String  ModuleManufaturer;
        public String  ModuleName;
        public String  QuoteInverterValues;
        public Integer ModuleQuantity;
        public String  RackingName;
        ////RackingQuantity
        ////MonitoringSystem
        public Double  MaximumRatedCapacityDC;
        //public Double  MaximumRatedCapacityAC;
        
        public Double  DealerFeesTotal;
        public Double  DealerFeesSalesPartnerTotal;
        public Double  DealerFeesInstallationPartnerTotal;

        public String  EarlyBuyOutDate;
        public Double  SolarRebate;
        public Boolean FullPrePaid;
        
        public Double MonthlyPaymentBaseYear1;
        public Double MonthlyPaymentTaxYear1;
        public Double MonthlyPaymentTaxFeesYear1;
        public Double TotalMonthlyPaymentBase;
        public Double TotalMonthlyPaymentTax;
        public Double TotalMonthlyPaymentBasePlusTax;
        public Double TotalMonthlyPaymentTaxFees;
        
        public Integer DownPaymentBase;
        public Double  DownPaymentTax;
        public Double  FullPrePaidBase;
        public Double  FullPrePaidTax;          
        ////TaxRate
        
        public Double AnnualPaymentEscalator;
        ////public Double AnnualProductionYear1;
        public Double TotalProductionBase;
        public Double TotalProductionLow;
        public Double TotalProductionHigh;
        public String TotalProductionRange;
        public Double AvergePayBackRatePerKWH;
        public String MountingOption;
        public String MonitoringSystem;
        
        public Double MonthlyBasePlusTaxYear1;  //Added on 01st July 2014: Req from Sangita
        
        public List<QuoteLine>               QuoteLines;
        public List<AnnualEnergyProduction>  AnnualEnergyProductions;
        public List<RoofDetail>              RoofDetails;
        public List<AnnualFinancial>         AnnualFinancials;

    }//End Class Quote  

    public class QuoteLine{
        public String  OracleItemNumber;
        public Integer Quantity;
        public Integer UnitPrice;
        
    }//End Class QuoteLine

    public class AnnualEnergyProduction{
        public Integer RowNumber;
        public Double  AnnualProdutionBase;
        public Double  AnnualProductionLow;
        public Double  AnnualProductionHigh;
        public String  AnnualProductionRange;
        public Double  AnnualPayBackRatePerKWH; 
        public String  AnnualSystemProductionGuaranteeYear;
        
    }//End Func AnnualEnergyProduction

    public class AnnualFinancial{
        public Integer RowNumber;
        public Double  AnnualBase;
        public Double  AnnualSalesTax;
        public Double  AnnualFees;
        public Double  MonthlyBase;
        public Double  MonthlySalesTax;
        public Double  MonthlyFees;
        public Double  MonthlyBasePlusTax;      //Added on 01st July 2014: Req from Sangita
        public Double  AnnualTerminationValue;
        public Double  CostofLeasePerkWh;
        public Double  RemainingLeaseValue; 
        
    }//End Func AnnualFinancial
 
    public class RoofDetail{
        ////RoofNumber;
        public String  RoofDescription;
        public Integer RoofDirection;
        public String  RoofPitch;
        public Double  RoofHeight;
        public String  RoofType;
    
        public Integer SolarAccess_January;
        public Integer SolarAccess_February;
        public Integer SolarAccess_March;
        public Integer SolarAccess_April;
        public Integer SolarAccess_May;
        public Integer SolarAccess_June;
        public Integer SolarAccess_July;
        public Integer SolarAccess_August;
        public Integer SolarAccess_September;
        public Integer SolarAccess_October;
        public Integer SolarAccess_November;
        public Integer SolarAccess_December;   

        public String  ModuleOraceItemNumber;
        public String  ModuleBrand;
        public String  ModuleName;
        public Integer TotalModuleCount;
        public Integer NumberOfModulesMPP1;
        public Integer NumberOfStringsMPP1;
        public Integer NumberOfModulesMPP2;
        public Integer NumberOfStringsMPP2;
        //public String  InverterBrand;
        //public String  InverterModel;
        public String  RoofInverterValues;
        public String  RackingName;
        public Integer RackingQuantity;
            
    }//End Func RoofDetail 
    
/***************************************/   
/******** WRAPPER CLASSES : end ********/
/***************************************/   
}//End Class GPPUpdateQuoteAPIPayloadParser