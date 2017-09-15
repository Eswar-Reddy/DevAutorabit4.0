/********************************************************************************************
Author : Birlasoft
Usage  : Test Class for GPPUpdateQuoteAPIPayloadParser Class
Edits  :    
********************************************************************************************/  

@isTest(SeeAllData=true)
public class GPPUpdateQuoteAPIPayloadParserTest
{
    static testMethod void TM1() 
    {        
        GPPServicesUpdateQuoteDetailsMock fakeUQDResponse = new GPPServicesUpdateQuoteDetailsMock('12345678');
        String sJSON= fakeUQDResponse.sPayLoad;
        GPPUpdateQuoteAPIPayloadParser p= new GPPUpdateQuoteAPIPayloadParser();
            p= GPPUpdateQuoteAPIPayloadParser.parse(sJSON);
            
        GPPUpdateQuoteAPIPayloadParser.Quote q= new GPPUpdateQuoteAPIPayloadParser.Quote();
        GPPUpdateQuoteAPIPayloadParser.QuoteLine ql= new GPPUpdateQuoteAPIPayloadParser.QuoteLine();
        GPPUpdateQuoteAPIPayloadParser.AnnualEnergyProduction aep= new GPPUpdateQuoteAPIPayloadParser.AnnualEnergyProduction();
        GPPUpdateQuoteAPIPayloadParser.RoofDetail rd= new GPPUpdateQuoteAPIPayloadParser.RoofDetail();
        GPPUpdateQuoteAPIPayloadParser.AnnualFinancial af= new GPPUpdateQuoteAPIPayloadParser.AnnualFinancial();
        
        GPPUpdateQuoteAPIPayloadParser obj= GPPUpdateQuoteAPIPayloadParser.parse(sJSON);
            GPPUpdateQuoteAPIPayloadParser.Quote objQ= obj.Quote;
                String var1 = objQ.keyQuoteId;
                String var2 = objQ.QuoteNumber;
                String var3 = objQ.QuoteCurrency;
                Boolean var4 = objQ.IsLocked;
                String var5 = objQ.XQuoteType;
                String var6 = objQ.Description;
                String var7 = objQ.FinancingType;
                Integer var8 = objQ.FinancingTerm;
                Double var9 = objQ.SystemPrice;
                Double var11 = objQ.SystemCost;
                Double var12 = objQ.QuoteAmount;
                String var14 = objQ.SiteAddress1;
                String var15 = objQ.SiteAddress2;
                String var16 = objQ.SiteCity;
                String var17 = objQ.SiteState;
                String var18 = objQ.SitePostCode;
                String var19 = objQ.SiteCountry;
                String var20 = objQ.NMI;
                String var22 = objQ.WeatherDataFile;
                Double var23 = objQ.WeatherLongitude;
                Double var24 = objQ.WeatherLatitude;
                String var26 = objQ.UtilityRetailer;
                String var27 = objQ.UtilityRate;
                Double var28 = objQ.UtilityRateEscalation;
                String var29 = objQ.UtilityDistributor;
                String var31 = objQ.ModuleOraceItemNumber;
                String var32 = objQ.ModuleManufaturer;
                String var33 = objQ.ModuleName;
                String var34 = objQ.QuoteInverterValues;
                Integer var35 = objQ.ModuleQuantity;
                String var36 = objQ.RackingName;
                Double var37 = objQ.MaximumRatedCapacityDC;
                Double var39 = objQ.DealerFeesTotal;
                Double var40 = objQ.DealerFeesSalesPartnerTotal;
                Double var41 = objQ.DealerFeesInstallationPartnerTotal;
                String var43 = objQ.EarlyBuyOutDate;
                Double var44 = objQ.SolarRebate;
                Boolean var45 = objQ.FullPrePaid;
                Double var47 = objQ.MonthlyPaymentBaseYear1;
                Double var48 = objQ.MonthlyPaymentTaxYear1;
                Double var49 = objQ.MonthlyPaymentTaxFeesYear1;
                Double var50 = objQ.TotalMonthlyPaymentBase;
                Double var51 = objQ.TotalMonthlyPaymentTax;
                Double var52 = objQ.TotalMonthlyPaymentTaxFees;
                Integer var54 = objQ.DownPaymentBase;
                Double var55 = objQ.DownPaymentTax;
                Double var56 = objQ.FullPrePaidBase;
                Double var57 = objQ.FullPrePaidTax;
                Double var59 = objQ.AnnualPaymentEscalator;
                Double var60 = objQ.TotalProductionBase;
                Double var61 = objQ.TotalProductionLow;
                Double var62 = objQ.TotalProductionHigh;
                String var63 = objQ.TotalProductionRange;
                Double var64 = objQ.AvergePayBackRatePerKWH;
                String var65 = objQ.MountingOption;
                String var66 = objQ.MonitoringSystem;
                Double var68 = objQ.MonthlyBasePlusTaxYear1;
                List<GPPUpdateQuoteAPIPayloadParser.QuoteLine> objQL = objQ.QuoteLines;
                List<GPPUpdateQuoteAPIPayloadParser.AnnualEnergyProduction> objAEP = objQ.AnnualEnergyProductions;
                List<GPPUpdateQuoteAPIPayloadParser.RoofDetail> objRD = objQ.RoofDetails;
                List<GPPUpdateQuoteAPIPayloadParser.AnnualFinancial> objAF = objQ.AnnualFinancials;
                
    }//End TM1
}//End Class GPPUpdateQuoteAPIPayloadParserTest