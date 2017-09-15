/********************************************************************************************
Author : Birlasoft
Usage  : Response Mock for GPPServicesUpdateQuoteDetails Rest Resource Class
Edits  :  
********************************************************************************************/

@isTest
public class GPPServicesUpdateQuoteDetailsMock implements HttpCalloutMock 
{
/****** VARIABLE: start ******/
        protected String sQuoteNumber;
        public    String sPayLoad;
/******* VARIABLE: end *******/

/****** CONSTRUCTOR: start ******/
        public GPPServicesUpdateQuoteDetailsMock(String sQNum) {
            this.sQuoteNumber = sQNum;
            this.sPayLoad= '{'+
                            '   \"Quote\" : {'+
                            '       \"keyQuoteId\" : null,'+
                            '       \"QuoteNumber\" : \"' + sQuoteNumber + '\",'+
                            '       \"QuoteCurrency\" : \"AUD\",'+
                            '       \"Description\" : \"' + sQuoteNumber + '\",'+
                            '       \"FinancingType\" : \"Lease\",'+
                            '       \"FinancingTerm\" : 25,'+
                            '       \"SystemPrice\" : 30000,'+
                            '       \"SystemCost\" : 30000,'+
                            '       \"SiteAddress1\" : \"23\",'+
                            '       \"SiteAddress2\" : \"Shelley Street\",'+
                            '       \"SiteCity\" : \"Sydney\",'+
                            '       \"SiteState\" : \"New South Wales\",'+
                            '       \"SitePostCode\" : \"2000\",'+
                            '       \"SiteCountry\" : \"Australia\",'+
                            '       \"NMI\" : \"45678\",'+
                            '       \"WeatherDataFile\" : 48545,'+
                            '       \"WeatherLongitude\" : 151.25,'+
                            '       \"WeatherLatitude\" : -33.85,'+
                            '       \"UtilityRetailer\" : \"Origin Energy\",'+
                            '       \"UtilityRateEscalation\" : 3.0,'+
                            '       \"UtilityRate\" : \"Flat Rate\",'+
                            '       \"UtilityDistributor\" : \"Essential\",'+
                            '       \"ModuleOraceItemNumber\" : \"501433\",'+
                            '       \"ModuleName\" : \"SPR-327NE-WHT-D AR-A3\",'+
                            '       \"ModuleManufaturer\" : \"SunPower\",'+
                            '       \"QuoteInverterValues\" : \"PowerOne-UNO-2.0-I-OUTD-AU(1)\",'+
                            '       \"ModuleQuantity\" : 6,'+
                            '       \"MaximumRatedCapacityDC\" : 1962.0,'+
                            '       \"DealerFeesTotal\" : 3140.39,'+
                            '       \"DealerFeesSalesPartnerTotal\" : 588.6,'+
                            '       \"DealerFeesInstallationPartnerTotal\" : 2551.79,'+
                            '       \"EarlyBuyOutDate\" : \"12/02/2020\",'+
                            '       \"SolarRebate\" : 81.34451999999999,'+
                            '       \"FullPrePaid\" : false,'+
                            '       \"MonthlyPaymentBaseYear1\" : 54.77562797864266,'+
                            '       \"MonthlyPaymentTaxYear1\" : 0.0,'+
                            '       \"MonthlyPaymentTaxFeesYear1\" : 62.27562797864266,'+
                            '       \"MonthlyBasePlusTaxYear1\" : 59.7756,'+
                            '       \"TotalMonthlyPaymentBase\" : 23964.949186395697,'+
                            '       \"TotalMonthlyPaymentTax\" : 0.0,'+
                            '       \"TotalMonthlyPaymentTaxFees\" : 26214.949186395697,'+
                            '       \"DownPaymentBase\" : 0,'+
                            '       \"DownPaymentTax\" : 0.0,'+
                            '       \"FullPrePaidBase\" : 0.0,'+
                            '       \"FullPrePaidTax\" : 0.0,'+
                            '       \"AnnualPaymentEscalator\" : 0.03,'+
                            '       \"TotalProductionBase\" : 65896.68456242213,'+
                            '       \"TotalProductionLow\" : 62601.0,'+
                            '       \"TotalProductionHigh\" : 65897.0,'+
                            '       \"TotalProductionRange\" : \"62601.0 - 65897.0\",'+
                            '       \"AvergePayBackRatePerKWH\" : 0.39939171856892824,'+
                            '       \"RoofDetails\" : [{'+
                            '               \"RoofDescription\" : \"ROOF 1\",'+
                            '               \"RoofDirection\" : 180,'+
                            '               \"RoofPitch\" : 22.5,'+
                            '               \"RoofHeight\" : 0.0,'+
                            '               \"RoofType\" : \"Asphalt Shingle\",'+
                            '               \"SolarAccess_January\" : 77,'+
                            '               \"SolarAccess_February\" : 78,'+
                            '               \"SolarAccess_March\" : 80,'+
                            '               \"SolarAccess_April\" : 81,'+
                            '               \"SolarAccess_May\" : 82,'+
                            '               \"SolarAccess_June\" : 83,'+
                            '               \"SolarAccess_July\" : 83,'+
                            '               \"SolarAccess_August\" : 82,'+
                            '               \"SolarAccess_September\" : 81,'+
                            '               \"SolarAccess_October\" : 80,'+
                            '               \"SolarAccess_November\" : 78,'+
                            '               \"SolarAccess_December\" : 77,'+
                            '               \"ModuleOraceItemNumber\" : \"501433\",'+
                            '               \"ModuleBrand\" : \"SunPower\",'+
                            '               \"ModuleName\" : \"SPR-327NE-WHT-D AR-A3\",'+
                            '               \"TotalModuleCount\" : 6,'+
                            '               \"NumberOfModulesMPP1\" : 6,'+
                            '               \"NumberOfStringsMPP1\" : 1,'+
                            '               \"NumberOfModulesMPP2\" : 0,'+
                            '               \"NumberOfStringsMPP2\" : 0,'+
                            '               \"RoofInverterValues\" : \"PowerOne-UNO-2.0-I-OUTD-AU(1)\",'+
                            '               \"RackingName\" : null,'+
                            '               \"RackingQuantity\" : 0'+
                            '           }'+
                            '       ],'+
                            '       \"QuoteLines\" : [{'+
                            '               \"OracleItemNumber\" : \"501433\",'+
                            '               \"Quantity\" : 6,'+
                            '               \"UnitPrice\" : 365'+
                            '           }, {'+
                            '               \"OracleItemNumber\" : \"506576\",'+
                            '               \"Quantity\" : 1,'+
                            '               \"UnitPrice\" : 968'+
                            '           }'+
                            '       ],'+
                            '       \"AnnualFinancials\" : [{'+
                            '               \"RowNumber\" : 1,'+
                            '               \"MonthlySalesTax\" : 0.0,'+
                            '               \"MonthlyFees\" : 62.27562797864266,'+
                            '               \"MonthlyBase\" : 54.77562797864266,'+
                            '               \"MonthlyBasePlusTax\" : 66.27562797864266,'+
                            '               \"AnnualTerminationValue\" : 0.0,'+
                            '               \"AnnualSalesTax\" : 0.0,'+
                            '               \"AnnualFees\" : 747.3075357437119,'+
                            '               \"AnnualBase\" : 657.3075357437119,'+
                            '               \"CostofLeasePerkWh\" : 0.211166301857693231128592575600924,'+
                            '               \"RemainingLeaseValue\" : 30000'+
                            '           }, {'+
                            '               \"RowNumber\" : 2,'+
                            '               \"MonthlySalesTax\" : 0.0,'+
                            '               \"MonthlyFees\" : 63.91889681800194,'+
                            '               \"MonthlyBase\" : 56.41889681800194,'+
                            '               \"MonthlyBasePlusTax\" : 67.91889681800194,             '+
                            '               \"AnnualTerminationValue\" : 0.0,'+
                            '               \"AnnualSalesTax\" : 0.0,'+
                            '               \"AnnualFees\" : 767.0267618160233,'+
                            '               \"AnnualBase\" : 677.0267618160233,'+
                            '               \"CostofLeasePerkWh\" : 0.211166301857693231128592575600924,'+
                            '               \"RemainingLeaseValue\" : 30000'+
                            ''+
                            '           }, {'+
                            '               \"RowNumber\" : 3,'+
                            '               \"MonthlySalesTax\" : 0.0,'+
                            '               \"MonthlyFees\" : 65.611463722542,'+
                            '               \"MonthlyBase\" : 58.111463722542,'+
                            '               \"MonthlyBasePlusTax\" : 69.611463722542,               '+
                            '               \"AnnualTerminationValue\" : 0.0,'+
                            '               \"AnnualSalesTax\" : 0.0,'+
                            '               \"AnnualFees\" : 787.337564670504,'+
                            '               \"AnnualBase\" : 697.337564670504,'+
                            '               \"CostofLeasePerkWh\" : 0.211166301857693231128592575600924,'+
                            '               \"RemainingLeaseValue\" : 30000'+
                            ''+
                            '           }, {'+
                            '               \"RowNumber\" : 4,'+
                            '               \"MonthlySalesTax\" : 0.0,'+
                            '               \"MonthlyFees\" : 67.35480763421826,'+
                            '               \"MonthlyBase\" : 59.85480763421826,'+
                            '               \"MonthlyBasePlusTax\" : 71.35480763421826,                 '+
                            '               \"AnnualTerminationValue\" : 0.0,'+
                            '               \"AnnualSalesTax\" : 0.0,'+
                            '               \"AnnualFees\" : 808.2576916106191,'+
                            '               \"AnnualBase\" : 718.2576916106191,'+
                            '               \"CostofLeasePerkWh\" : 0.211166301857693231128592575600924,'+
                            '               \"RemainingLeaseValue\" : 30000'+
                            ''+
                            '           }, {'+
                            '               \"RowNumber\" : 5,'+
                            '               \"MonthlySalesTax\" : 0.0,'+
                            '               \"MonthlyFees\" : 69.15045186324481,'+
                            '               \"MonthlyBase\" : 61.65045186324481,'+
                            '               \"MonthlyBasePlusTax\" : 73.15045186324481,             '+
                            '               \"AnnualTerminationValue\" : 0.0,'+
                            '               \"AnnualSalesTax\" : 0.0,'+
                            '               \"AnnualFees\" : 829.8054223589377,'+
                            '               \"AnnualBase\" : 739.8054223589377,'+
                            '               \"CostofLeasePerkWh\" : 0.211166301857693231128592575600924,'+
                            '               \"RemainingLeaseValue\" : 30000'+
                            ''+
                            '           }, {'+
                            '               \"RowNumber\" : 6,'+
                            '               \"MonthlySalesTax\" : 0.0,'+
                            '               \"MonthlyFees\" : 70.99996541914216,'+
                            '               \"MonthlyBase\" : 63.49996541914216,'+
                            '               \"MonthlyBasePlusTax\" : 74.99996541914216,                 '+
                            '               \"AnnualTerminationValue\" : 0.0,'+
                            '               \"AnnualSalesTax\" : 0.0,'+
                            '               \"AnnualFees\" : 851.9995850297059,'+
                            '               \"AnnualBase\" : 739.8054223589377,'+
                            '               \"CostofLeasePerkWh\" : 0.211166301857693231128592575600924,'+
                            '               \"RemainingLeaseValue\" : 30000'+
                            '           }, {'+
                            '               \"RowNumber\" : 7,'+
                            '               \"MonthlySalesTax\" : 0.0,'+
                            '               \"MonthlyFees\" : 72.90496438171643,'+
                            '               \"MonthlyBase\" : 65.40496438171643,'+
                            '               \"MonthlyBasePlusTax\" : 76.90496438171643,             '+
                            '               \"AnnualTerminationValue\" : 0.0,'+
                            '               \"AnnualSalesTax\" : 0.0,'+
                            '               \"AnnualFees\" : 874.8595725805972,'+
                            '               \"AnnualBase\" : 739.8054223589377,'+
                            '\"CostofLeasePerkWh\" : 0.211166301857693231128592575600924,'+
                            '               \"RemainingLeaseValue\" : 30000'+
                            '           }, {'+
                            '               \"RowNumber\" : 8,'+
                            '               \"MonthlySalesTax\" : 0.0,'+
                            '               \"MonthlyFees\" : 74.86711331316792,'+
                            '               \"MonthlyBase\" : 67.36711331316792,'+
                            '               \"MonthlyBasePlusTax\" : 78.86711331316792,                 '+
                            '               \"AnnualTerminationValue\" : 0.0,'+
                            '               \"AnnualSalesTax\" : 0.0,'+
                            '               \"AnnualFees\" : 898.405359758015,'+
                            '               \"AnnualBase\" : 739.8054223589377,'+
                            '\"CostofLeasePerkWh\" : 0.211166301857693231128592575600924,'+
                            '               \"RemainingLeaseValue\" : 30000'+
                            '           }, {'+
                            '               \"RowNumber\" : 9,'+
                            '               \"MonthlySalesTax\" : 0.0,'+
                            '               \"MonthlyFees\" : 76.88812671256295,'+
                            '               \"MonthlyBase\" : 69.38812671256295,'+
                            '               \"MonthlyBasePlusTax\" : 78.86711331316792,             '+
                            '               \"AnnualTerminationValue\" : 0.0,'+
                            '               \"AnnualSalesTax\" : 0.0,'+
                            '               \"AnnualFees\" : 922.6575205507554,'+
                            '               \"AnnualBase\" : 739.8054223589377,'+
                            '\"CostofLeasePerkWh\" : 0.211166301857693231128592575600924,'+
                            '               \"RemainingLeaseValue\" : 30000'+
                            '           }, {'+
                            '               \"RowNumber\" : 10,'+
                            '               \"MonthlySalesTax\" : 0.0,'+
                            '               \"MonthlyFees\" : 78.96977051393984,'+
                            '               \"MonthlyBase\" : 71.46977051393984,'+
                            '               \"MonthlyBasePlusTax\" : 78.86711331316792,             '+
                            '               \"AnnualTerminationValue\" : 0.0,'+
                            '               \"AnnualSalesTax\" : 0.0,'+
                            '               \"AnnualFees\" : 947.637246167278,'+
                            '               \"AnnualBase\" : 739.8054223589377,'+
                            '\"CostofLeasePerkWh\" : 0.211166301857693231128592575600924,'+
                            '               \"RemainingLeaseValue\" : 30000'+
                            '           }, {'+
                            '               \"RowNumber\" : 11,'+
                            '               \"MonthlySalesTax\" : 0.0,'+
                            '               \"MonthlyFees\" : 81.11386362935804,'+
                            '               \"MonthlyBase\" : 73.61386362935804,'+
                            '               \"MonthlyBasePlusTax\" : 78.86711331316792,             '+
                            '               \"AnnualTerminationValue\" : 0.0,'+
                            '               \"AnnualSalesTax\" : 0.0,'+
                            '               \"AnnualFees\" : 973.3663635522964,'+
                            '               \"AnnualBase\" : 739.8054223589377,'+
                            '\"CostofLeasePerkWh\" : 0.211166301857693231128592575600924,'+
                            '               \"RemainingLeaseValue\" : 30000'+
                            '           }, {'+
                            '               \"RowNumber\" : 12,'+
                            '               \"MonthlySalesTax\" : 0.0,'+
                            '               \"MonthlyFees\" : 83.32227953823877,'+
                            '               \"MonthlyBase\" : 75.82227953823877,'+
                            '               \"MonthlyBasePlusTax\" : 78.86711331316792,             '+
                            '               \"AnnualTerminationValue\" : 0.0,'+
                            '               \"AnnualSalesTax\" : 0.0,'+
                            '               \"AnnualFees\" : 999.8673544588653,'+
                            '               \"AnnualBase\" : 739.8054223589377,'+
                            '\"CostofLeasePerkWh\" : 0.211166301857693231128592575600924,'+
                            '               \"RemainingLeaseValue\" : 30000'+
                            '           }, {'+
                            '               \"RowNumber\" : 13,'+
                            '               \"MonthlySalesTax\" : 0.0,'+
                            '               \"MonthlyFees\" : 85.59694792438594,'+
                            '               \"MonthlyBase\" : 78.09694792438594,'+
                            '               \"MonthlyBasePlusTax\" : 78.86711331316792,             '+
                            '               \"AnnualTerminationValue\" : 0.0,'+
                            '               \"AnnualSalesTax\" : 0.0,'+
                            '               \"AnnualFees\" : 1027.1633750926312,'+
                            '               \"AnnualBase\" : 739.8054223589377,'+
                            '\"CostofLeasePerkWh\" : 0.211166301857693231128592575600924,'+
                            '               \"RemainingLeaseValue\" : 30000'+
                            '           }, {'+
                            '               \"RowNumber\" : 14,'+
                            '               \"MonthlySalesTax\" : 0.0,'+
                            '               \"MonthlyFees\" : 87.93985636211752,'+
                            '               \"MonthlyBase\" : 80.43985636211752,'+
                            '               \"MonthlyBasePlusTax\" : 78.86711331316792,             '+
                            '               \"AnnualTerminationValue\" : 0.0,'+
                            '               \"AnnualSalesTax\" : 0.0,'+
                            '               \"AnnualFees\" : 1055.2782763454102,'+
                            '               \"AnnualBase\" : 739.8054223589377,'+
                            '\"CostofLeasePerkWh\" : 0.211166301857693231128592575600924,'+
                            '               \"RemainingLeaseValue\" : 30000'+
                            '           }, {'+
                            '               \"RowNumber\" : 15,'+
                            '               \"MonthlySalesTax\" : 0.0,'+
                            '               \"MonthlyFees\" : 90.35305205298106,'+
                            '               \"MonthlyBase\" : 82.85305205298106,'+
                            '               \"MonthlyBasePlusTax\" : 78.86711331316792,             '+
                            '               \"AnnualTerminationValue\" : 0.0,'+
                            '               \"AnnualSalesTax\" : 0.0,'+
                            '               \"AnnualFees\" : 1084.2366246357726,'+
                            '               \"AnnualBase\" : 739.8054223589377,'+
                            '\"CostofLeasePerkWh\" : 0.211166301857693231128592575600924,'+
                            '               \"RemainingLeaseValue\" : 30000'+
                            '           }, {'+
                            '               \"RowNumber\" : 16,'+
                            '               \"MonthlySalesTax\" : 0.0,'+
                            '               \"MonthlyFees\" : 92.83864361457049,'+
                            '               \"MonthlyBase\" : 85.33864361457049,'+
                            '               \"MonthlyBasePlusTax\" : 78.86711331316792,             '+
                            '               \"AnnualTerminationValue\" : 0.0,'+
                            '               \"AnnualSalesTax\" : 0.0,'+
                            '               \"AnnualFees\" : 1114.0637233748457,'+
                            '               \"AnnualBase\" : 739.8054223589377,'+
                            '\"CostofLeasePerkWh\" : 0.211166301857693231128592575600924,'+
                            '               \"RemainingLeaseValue\" : 30000'+
                            '           }, {'+
                            '               \"RowNumber\" : 17,'+
                            '               \"MonthlySalesTax\" : 0.0,'+
                            '               \"MonthlyFees\" : 95.3988029230076,'+
                            '               \"MonthlyBase\" : 87.8988029230076,'+
                            '               \"MonthlyBasePlusTax\" : 78.86711331316792,             '+
                            '               \"AnnualTerminationValue\" : 0.0,'+
                            '               \"AnnualSalesTax\" : 0.0,'+
                            '               \"AnnualFees\" : 1144.7856350760912,'+
                            '               \"AnnualBase\" : 739.8054223589377,'+
                            '\"CostofLeasePerkWh\" : 0.211166301857693231128592575600924,'+
                            '               \"RemainingLeaseValue\" : 30000'+
                            '           }, {'+
                            '               \"RowNumber\" : 18,'+
                            '               \"MonthlySalesTax\" : 0.0,'+
                            '               \"MonthlyFees\" : 98.03576701069782,'+
                            '               \"MonthlyBase\" : 90.53576701069782,'+
                            '               \"MonthlyBasePlusTax\" : 78.86711331316792,             '+
                            '               \"AnnualTerminationValue\" : 0.0,'+
                            '               \"AnnualSalesTax\" : 0.0,'+
                            '               \"AnnualFees\" : 1176.4292041283738,'+
                            '               \"AnnualBase\" : 739.8054223589377,'+
                            '\"CostofLeasePerkWh\" : 0.211166301857693231128592575600924,'+
                            '               \"RemainingLeaseValue\" : 30000'+
                            '           }, {'+
                            '               \"RowNumber\" : 19,'+
                            '               \"MonthlySalesTax\" : 0.0,'+
                            '               \"MonthlyFees\" : 100.75184002101877,'+
                            '               \"MonthlyBase\" : 93.25184002101877,'+
                            '               \"MonthlyBasePlusTax\" : 78.86711331316792,             '+
                            '               \"AnnualTerminationValue\" : 0.0,'+
                            '               \"AnnualSalesTax\" : 0.0,'+
                            '               \"AnnualFees\" : 1209.0220802522251,'+
                            '               \"AnnualBase\" : 739.8054223589377,'+
                            '\"CostofLeasePerkWh\" : 0.211166301857693231128592575600924,'+
                            '               \"RemainingLeaseValue\" : 30000'+
                            '           }, {'+
                            '               \"RowNumber\" : 20,'+
                            '               \"MonthlySalesTax\" : 0.0,'+
                            '               \"MonthlyFees\" : 103.54939522164933,'+
                            '               \"MonthlyBase\" : 96.04939522164933,'+
                            '               \"MonthlyBasePlusTax\" : 78.86711331316792,             '+
                            '               \"AnnualTerminationValue\" : 0.0,'+
                            '               \"AnnualSalesTax\" : 0.0,'+
                            '               \"AnnualFees\" : 1242.592742659792,'+
                            '               \"AnnualBase\" : 739.8054223589377,'+
                            '\"CostofLeasePerkWh\" : 0.211166301857693231128592575600924,'+
                            '               \"RemainingLeaseValue\" : 30000'+
                            '           }, {'+
                            '               \"RowNumber\" : 21,'+
                            '               \"MonthlySalesTax\" : 0.0,'+
                            '               \"MonthlyFees\" : 106.43087707829882,'+
                            '               \"MonthlyBase\" : 98.93087707829882,'+
                            '               \"MonthlyBasePlusTax\" : 78.86711331316792,             '+
                            '               \"AnnualTerminationValue\" : 0.0,'+
                            '               \"AnnualSalesTax\" : 0.0,'+
                            '               \"AnnualFees\" : 1277.170524939586,'+
                            '               \"AnnualBase\" : 739.8054223589377,'+
                            '\"CostofLeasePerkWh\" : 0.211166301857693231128592575600924,'+
                            '               \"RemainingLeaseValue\" : 30000'+
                            '           }, {'+
                            '               \"RowNumber\" : 22,'+
                            '               \"MonthlySalesTax\" : 0.0,'+
                            '               \"MonthlyFees\" : 109.39880339064779,'+
                            '               \"MonthlyBase\" : 101.89880339064779,'+
                            '               \"MonthlyBasePlusTax\" : 78.86711331316792,             '+
                            '               \"AnnualTerminationValue\" : 0.0,'+
                            '               \"AnnualSalesTax\" : 0.0,'+
                            '               \"AnnualFees\" : 1312.7856406877734,'+
                            '               \"AnnualBase\" : 739.8054223589377,'+
                            '\"CostofLeasePerkWh\" : 0.211166301857693231128592575600924,'+
                            '               \"RemainingLeaseValue\" : 30000'+
                            '           }, {'+
                            '               \"RowNumber\" : 23,'+
                            '               \"MonthlySalesTax\" : 0.0,'+
                            '               \"MonthlyFees\" : 112.45576749236722,'+
                            '               \"MonthlyBase\" : 104.95576749236722,'+
                            '               \"MonthlyBasePlusTax\" : 78.86711331316792,             '+
                            '               \"AnnualTerminationValue\" : 0.0,'+
                            '               \"AnnualSalesTax\" : 0.0,'+
                            '               \"AnnualFees\" : 1349.4692099084066,'+
                            '               \"AnnualBase\" : 739.8054223589377,'+
                            '\"CostofLeasePerkWh\" : 0.211166301857693231128592575600924,'+
                            '               \"RemainingLeaseValue\" : 30000'+
                            '           }, {'+
                            '               \"RowNumber\" : 24,'+
                            '               \"MonthlySalesTax\" : 0.0,'+
                            '               \"MonthlyFees\" : 115.60444051713823,'+
                            '               \"MonthlyBase\" : 108.10444051713823,'+
                            '               \"MonthlyBasePlusTax\" : 78.86711331316792,             '+
                            '               \"AnnualTerminationValue\" : 0.0,'+
                            '               \"AnnualSalesTax\" : 0.0,'+
                            '               \"AnnualFees\" : 1387.2532862056587,'+
                            '               \"AnnualBase\" : 739.8054223589377,'+
                            '\"CostofLeasePerkWh\" : 0.211166301857693231128592575600924,'+
                            '               \"RemainingLeaseValue\" : 30000'+
                            '           }, {'+
                            '               \"RowNumber\" : 25,'+
                            '               \"MonthlySalesTax\" : 0.0,'+
                            '               \"MonthlyFees\" : 118.84757373265238,'+
                            '               \"MonthlyBase\" : 111.34757373265238,'+
                            '               \"MonthlyBasePlusTax\" : 78.86711331316792,             '+
                            '               \"AnnualTerminationValue\" : 0.0,'+
                            '               \"AnnualSalesTax\" : 0.0,'+
                            '               \"AnnualFees\" : 1426.1708847918285,'+
                            '               \"AnnualBase\" : 739.8054223589377,'+
                            '\"CostofLeasePerkWh\" : 0.211166301857693231128592575600924,'+
                            '               \"RemainingLeaseValue\" : 30000'+
                            '           }'+
                            '       ],'+
                            '       \"AnnualEnergyProductions\" : [{'+
                            '               \"RowNumber\" : 1,'+
                            '               \"AnnualProdutionBase\" : 2717.5997044347773,'+
                            '               \"AnnualProductionRange\" : \"2582.0 - 2718.0\",'+
                            '               \"AnnualProductionLow\" : 2582.0,'+
                            '               \"AnnualProductionHigh\" : 2718.0,'+
                            '               \"AnnualPayBackRatePerKWH\" : 0.27498808397874086,'+
                            '               \"AnnualSystemProductionGuaranteeYear\" : 2014'+
                            '           }, {'+
                            '               \"RowNumber\" : 2,'+
                            '               \"AnnualProdutionBase\" : 2710.78867760661,'+
                            '               \"AnnualProductionRange\" : \"2575.0 - 2711.0\",'+
                            '               \"AnnualProductionLow\" : 2575.0,'+
                            '               \"AnnualProductionHigh\" : 2711.0,'+
                            '               \"AnnualPayBackRatePerKWH\" : 0.28295335898084134,'+
                            '\"AnnualSystemProductionGuaranteeYear\":2015'+
                            ''+
                            '           }, {'+
                            '               \"RowNumber\" : 3,'+
                            '               \"AnnualProdutionBase\" : 2703.977650778455,'+
                            '               \"AnnualProductionRange\" : \"2569.0 - 2704.0\",'+
                            '               \"AnnualProductionLow\" : 2569.0,'+
                            '               \"AnnualProductionHigh\" : 2704.0,'+
                            '               \"AnnualPayBackRatePerKWH\" : 0.2911775415169705,'+
                            '\"AnnualSystemProductionGuaranteeYear\":2014'+
                            ''+
                            '           }, {'+
                            '               \"RowNumber\" : 4,'+
                            '               \"AnnualProdutionBase\" : 2697.1666239503024,'+
                            '               \"AnnualProductionRange\" : \"2562.0 - 2697.0\",'+
                            '               \"AnnualProductionLow\" : 2562.0,'+
                            '               \"AnnualProductionHigh\" : 2697.0,'+
                            '               \"AnnualPayBackRatePerKWH\" : 0.2911775415169705,'+
                            '\"AnnualSystemProductionGuaranteeYear\":2014'+
                            ''+
                            '           }, {'+
                            '               \"RowNumber\" : 5,'+
                            '               \"AnnualProdutionBase\" : 2690.3555971221413,'+
                            '               \"AnnualProductionRange\" : \"2556.0 - 2690.0\",'+
                            '               \"AnnualProductionLow\" : 2556.0,'+
                            '               \"AnnualProductionHigh\" : 2690.0,'+
                            '               \"AnnualPayBackRatePerKWH\" : 0.2911775415169705,'+
                            '\"AnnualSystemProductionGuaranteeYear\":2014'+
                            ''+
                            '           }, {'+
                            '               \"RowNumber\" : 6,'+
                            '               \"AnnualProdutionBase\" : 2683.544570293987,'+
                            '               \"AnnualProductionRange\" : \"2549.0 - 2684.0\",'+
                            '               \"AnnualProductionLow\" : 2549.0,'+
                            '               \"AnnualProductionHigh\" : 2684.0,'+
                            '               \"AnnualPayBackRatePerKWH\" : 0.2911775415169705,'+
                            '\"AnnualSystemProductionGuaranteeYear\":2014'+
                            ''+
                            '           }, {'+
                            '               \"RowNumber\" : 7,'+
                            '               \"AnnualProdutionBase\" : 2676.733543465841,'+
                            '               \"AnnualProductionRange\" : \"2543.0 - 2677.0\",'+
                            '               \"AnnualProductionLow\" : 2543.0,'+
                            '               \"AnnualProductionHigh\" : 2677.0,'+
                            '               \"AnnualPayBackRatePerKWH\" : 0.2911775415169705,'+
                            '\"AnnualSystemProductionGuaranteeYear\":2014'+
                            ''+
                            '           }, {'+
                            '               \"RowNumber\" : 8,'+
                            '               \"AnnualProdutionBase\" : 2669.922516637666,'+
                            '               \"AnnualProductionRange\" : \"2536.0 - 2670.0\",'+
                            '               \"AnnualProductionLow\" : 2536.0,'+
                            '               \"AnnualProductionHigh\" : 2670.0,'+
                            '               \"AnnualPayBackRatePerKWH\" : 0.2911775415169705,'+
                            '\"AnnualSystemProductionGuaranteeYear\":2014'+
                            ''+
                            '           }, {'+
                            '               \"RowNumber\" : 9,'+
                            '               \"AnnualProdutionBase\" : 2663.111489809519,'+
                            '               \"AnnualProductionRange\" : \"2530.0 - 2663.0\",'+
                            '               \"AnnualProductionLow\" : 2530.0,'+
                            '               \"AnnualProductionHigh\" : 2663.0,'+
                            '               \"AnnualPayBackRatePerKWH\" : 0.2911775415169705,'+
                            '\"AnnualSystemProductionGuaranteeYear\":2014'+
                            ''+
                            '           }, {'+
                            '               \"RowNumber\" : 10,'+
                            '               \"AnnualProdutionBase\" : 2656.300462981359,'+
                            '               \"AnnualProductionRange\" : \"2523.0 - 2656.0\",'+
                            '               \"AnnualProductionLow\" : 2523.0,'+
                            '               \"AnnualProductionHigh\" : 2656.0,'+
                            '               \"AnnualPayBackRatePerKWH\" : 0.2911775415169705,'+
                            '\"AnnualSystemProductionGuaranteeYear\":2014'+
                            ''+
                            '           }, {'+
                            '               \"RowNumber\" : 11,'+
                            '               \"AnnualProdutionBase\" : 2649.489436153202,'+
                            '               \"AnnualProductionRange\" : \"2517.0 - 2649.0\",'+
                            '               \"AnnualProductionLow\" : 2517.0,'+
                            '               \"AnnualProductionHigh\" : 2649.0,'+
                            '               \"AnnualPayBackRatePerKWH\" : 0.2911775415169705,'+
                            '\"AnnualSystemProductionGuaranteeYear\":2014'+
                            ''+
                            '           }, {'+
                            '               \"RowNumber\" : 12,'+
                            '               \"AnnualProdutionBase\" : 2642.678409325049,'+
                            '               \"AnnualProductionRange\" : \"2511.0 - 2643.0\",'+
                            '               \"AnnualProductionLow\" : 2511.0,'+
                            '               \"AnnualProductionHigh\" : 2643.0,'+
                            '               \"AnnualPayBackRatePerKWH\" : 0.2911775415169705,'+
                            '\"AnnualSystemProductionGuaranteeYear\":2014'+
                            ''+
                            '           }, {'+
                            '               \"RowNumber\" : 13,'+
                            '               \"AnnualProdutionBase\" : 2635.867382496888,'+
                            '               \"AnnualProductionRange\" : \"2504.0 - 2636.0\",'+
                            '               \"AnnualProductionLow\" : 2504.0,'+
                            '               \"AnnualProductionHigh\" : 2636.0,'+
                            '               \"AnnualPayBackRatePerKWH\" : 0.2911775415169705,'+
                            '\"AnnualSystemProductionGuaranteeYear\":2014'+
                            ''+
                            '           }, {'+
                            '               \"RowNumber\" : 14,'+
                            '               \"AnnualProdutionBase\" : 2629.0563556687252,'+
                            '               \"AnnualProductionRange\" : \"2498.0 - 2629.0\",'+
                            '               \"AnnualProductionLow\" : 2498.0,'+
                            '               \"AnnualProductionHigh\" : 2629.0,'+
                            '               \"AnnualPayBackRatePerKWH\" : 0.2911775415169705,'+
                            '\"AnnualSystemProductionGuaranteeYear\":2014'+
                            ''+
                            '           }, {'+
                            '               \"RowNumber\" : 15,'+
                            '               \"AnnualProdutionBase\" : 2622.245328840573,'+
                            '               \"AnnualProductionRange\" : \"2491.0 - 2622.0\",'+
                            '               \"AnnualProductionLow\" : 2491.0,'+
                            '               \"AnnualProductionHigh\" : 2622.0,'+
                            '               \"AnnualPayBackRatePerKWH\" : 0.2911775415169705,'+
                            '\"AnnualSystemProductionGuaranteeYear\":2014'+
                            ''+
                            '           }, {'+
                            '               \"RowNumber\" : 16,'+
                            '               \"AnnualProdutionBase\" : 2615.4343020124093,'+
                            '               \"AnnualProductionRange\" : \"2485.0 - 2615.0\",'+
                            '               \"AnnualProductionLow\" : 2485.0,'+
                            '               \"AnnualProductionHigh\" : 2615.0,'+
                            '               \"AnnualPayBackRatePerKWH\" : 0.2911775415169705,'+
                            '\"AnnualSystemProductionGuaranteeYear\":2014'+
                            ''+
                            '           }, {'+
                            '               \"RowNumber\" : 17,'+
                            '               \"AnnualProdutionBase\" : 2608.6232751842554,'+
                            '               \"AnnualProductionRange\" : \"2478.0 - 2609.0\",'+
                            '               \"AnnualProductionLow\" : 2478.0,'+
                            '               \"AnnualProductionHigh\" : 2609.0,'+
                            '               \"AnnualPayBackRatePerKWH\" : 0.2911775415169705,'+
                            '\"AnnualSystemProductionGuaranteeYear\":2014'+
                            ''+
                            '           }, {'+
                            '               \"RowNumber\" : 18,'+
                            '               \"AnnualProdutionBase\" : 2601.8122483560965,'+
                            '               \"AnnualProductionRange\" : \"2472.0 - 2602.0\",'+
                            '               \"AnnualProductionLow\" : 2472.0,'+
                            '               \"AnnualProductionHigh\" : 2602.0,'+
                            '               \"AnnualPayBackRatePerKWH\" : 0.2911775415169705,'+
                            '\"AnnualSystemProductionGuaranteeYear\":2014'+
                            ''+
                            '           }, {'+
                            '               \"RowNumber\" : 19,'+
                            '               \"AnnualProdutionBase\" : 2595.001221527941,'+
                            '               \"AnnualProductionRange\" : \"2465.0 - 2595.0\",'+
                            '               \"AnnualProductionLow\" : 2465.0,'+
                            '               \"AnnualProductionHigh\" : 2595.0,'+
                            '               \"AnnualPayBackRatePerKWH\" : 0.2911775415169705,'+
                            '\"AnnualSystemProductionGuaranteeYear\":2014'+
                            ''+
                            '           }, {'+
                            '               \"RowNumber\" : 20,'+
                            '               \"AnnualProdutionBase\" : 2588.1901946997837,'+
                            '               \"AnnualProductionRange\" : \"2459.0 - 2588.0\",'+
                            '               \"AnnualProductionLow\" : 2459.0,'+
                            '               \"AnnualProductionHigh\" : 2588.0,'+
                            '               \"AnnualPayBackRatePerKWH\" : 0.2911775415169705,'+
                            '\"AnnualSystemProductionGuaranteeYear\":2014'+
                            ''+
                            '           }, {'+
                            '               \"RowNumber\" : 21,'+
                            '               \"AnnualProdutionBase\" : 2581.3791678716243,'+
                            '               \"AnnualProductionRange\" : \"2452.0 - 2581.0\",'+
                            '               \"AnnualProductionLow\" : 2452.0,'+
                            '               \"AnnualProductionHigh\" : 2581.0,'+
                            '               \"AnnualPayBackRatePerKWH\" : 0.2911775415169705,'+
                            '\"AnnualSystemProductionGuaranteeYear\":2014'+
                            ''+
                            '           }, {'+
                            '               \"RowNumber\" : 22,'+
                            '               \"AnnualProdutionBase\" : 2574.5681410434677,'+
                            '               \"AnnualProductionRange\" : \"2446.0 - 2575.0\",'+
                            '               \"AnnualProductionLow\" : 2446.0,'+
                            '               \"AnnualProductionHigh\" : 2575.0,'+
                            '               \"AnnualPayBackRatePerKWH\" : 0.2911775415169705,'+
                            '\"AnnualSystemProductionGuaranteeYear\":2014'+
                            ''+
                            '           }, {'+
                            '               \"RowNumber\" : 23,'+
                            '               \"AnnualProdutionBase\" : 2567.757114215303,'+
                            '               \"AnnualProductionRange\" : \"2439.0 - 2568.0\",'+
                            '               \"AnnualProductionLow\" : 2439.0,'+
                            '               \"AnnualProductionHigh\" : 2568.0,'+
                            '               \"AnnualPayBackRatePerKWH\" : 0.2911775415169705,'+
                            '\"AnnualSystemProductionGuaranteeYear\":2014'+
                            ''+
                            '           }, {'+
                            '               \"RowNumber\" : 24,'+
                            '               \"AnnualProdutionBase\" : 2560.9460873871544,'+
                            '               \"AnnualProductionRange\" : \"2433.0 - 2561.0\",'+
                            '               \"AnnualProductionLow\" : 2433.0,'+
                            '               \"AnnualProductionHigh\" : 2561.0,'+
                            '               \"AnnualPayBackRatePerKWH\" : 0.2911775415169705,'+
                            '\"AnnualSystemProductionGuaranteeYear\":2014'+
                            ''+
                            '           }, {'+
                            '               \"RowNumber\" : 25,'+
                            '               \"AnnualProdutionBase\" : 2554.135060558999,'+
                            '               \"AnnualProductionRange\" : \"2426.0 - 2554.0\",'+
                            '               \"AnnualProductionLow\" : 2426.0,'+
                            '               \"AnnualProductionHigh\" : 2554.0,'+
                            '               \"AnnualPayBackRatePerKWH\" : 0.2911775415169705,'+
                            '\"AnnualSystemProductionGuaranteeYear\":2014'+
                            ''+
                            '           }'+
                            '       ],'+
                            '       \"IsLocked\" : true,'+
                            '       \"XQuoteType\" : \"Residential Lease Quotation\"'+
                            '   }'+
                            '}';
        }
/******* CONSTRUCTOR: end *******/

/****** FUNCTION: start ******/
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse resp = new HttpResponse();
                resp.setHeader('Content-Type', 'application/json');
                resp.setStatusCode(200);
                resp.setStatus('Complete');             
                resp.setBodyAsBlob(Blob.valueOf(sPayLoad));
            return resp;
        }
/******* FUNCTION: end *******/ 
    
}//End Class GPPServicesUpdateQuoteDetailsMock