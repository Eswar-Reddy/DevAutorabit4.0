public class GPPQueryHelper
{
    public static String strBaseQueryUser;
    public static String strBaseQueryQuote;
    public static String strBaseQueryAccount;
    public static String strBaseQueryLeaseSchedule;
    
    static
    {
        //User's Base Query
        strBaseQueryUser= 'SELECT Id, Name,LanguageLocaleKey, ' +  
                                'Country_Domain__c, Type__c, Business_Function__c, ' + 
                                'ContactId, Contact.Country_Domain__c, Contact.Account_Type__c, ' + 
                                'Contact.Account.Id, Contact.Account.name, Contact.Account.type, ' +  
                                'Contact.Account.Country_Domain__c, Contact.Account.Theater__c, ' + 
                                'Contact.Account.Dealer_Tier__c, Contact.Account.Business_Function__c, ' + 
                                'Contact.Account.Line_of_Business__c, Contact.Account.Same_as_Cash_Program_Partner__c, ' +
                                'Contact.Account.Can_Sell_SunPower_20yr_Loan__c, Contact.Account.BillingCountry, Contact.Account.Specialized_Seller__c, Contact.Account.Specialized_Installer__c, ' +
                                'Contact.Account.Phone, Contact.Account.Email__c, Contact.Account.partner_facts__c '+
                          'FROM User ';
        
        //Quote's Base Query                  
            strBaseQueryQuote= 'SELECT Id, Name, QuoteNumber, CurrencyISOCode, Is_Locked__c, Date_Modified__c, Quote_Type__c, ' + 
                                  'Account__c, Account__r.ParentId, Account__r.RecordTypeId, Account__r.Type, Account__r.Name, ' +
                                  'OpportunityId, Opportunity.Name, Opportunity.NMI__c, Opportunity.Account.Id, Opportunity.Account.Name, Opportunity.Account.Sales_Tax_Rate__c, ' + 
                                  'Description, Description__c, QuoteType__c, Loan_Term__c, System_Price__c, System_Cost__c, Sales_Tax__c, Quote_Amount__c, ' + 
                                  'Site_Address_Line_1__c, Site_Address_Line_2__c, Site_City__c, Site_State__c, Site_PostalCode__c, Site_Country__c, ' + 
                                  'Weather_Data_File__c, WeatherFile_Longitude__c, WeatherFile_Latitude__c, ' + 
                                  'Proposed_Electric_Utility__c, Proposed_Rate_Name__c, ' + 
                                  'Utility_Bill_Annual_Escalation__c, Utility_Distributor__c, Module_Oracle_Item_Number__c, Module_Brand__c, Module__c, ' + 
                                  'Quote_Inverter_Values__c, Module_Quantity__c, Maximum_Rated_Capacity_DC__c, ' + 
                                  'Dealer_Fees__c, Dealer_Fees_Sales_Partner_Total__c, Dealer_Fee_Installation_Partner_Total__c, ' + 
                                  'Early_Buyout_Option_Date__c, Solar_Rebate_Amount__c, Full_Prepaid_Lease__c, ' + 
                                  'Monthly_Payment_Base_Year_1__c, Monthly_Payment_Tax_Year_1__c, Monthly_Payment_Tax_Fees_Year_1__c, Monthly_Base_Plus_Tax_Year_1__c, ' + 
                                  'Total_Monthly_Payment_Base__c, Total_Monthly_Payment_Tax__c, Total_Monthly_Payment_Tax_Fees__c, TotalMonthlyPaymentBasePlusTax__c , ' + 
                                  'Down_Payment__c, Down_Payment_Tax__c, Full_PrePayment_Amount_Base_Amount__c, Full_PrePayment_Amount_Estimated_Tax_on__c, ' + 
                                  'lease_annual_escalation__c, Total_Production_Base__c,  Total_Production_Low__c, Total_Production_High__c, Total_Production_Range__c, Averge_Payback_Rate_Per_KWH__c,  ' + 
                                  'Installer__r.id,Installer__r.name, Account__r.Partner_Account__c, Opportunity.installer__c,'+
                                  'Installer__r.Fee_Cal_Latitude__c,Installer__r.Fee_Cal_Longitude__c, Mounting_Option__c, Monitoring_System__c, '+ 
                                  '(Select id from Quote_Lines__r) '+
                           'FROM Quote '; 
                           
        //Lease Schedule's Query
            strBaseQueryLeaseSchedule= 'SELECT Annual_Lease_Payment__c, Annual_Lease_Payments_Year__c, Annual_SystemProduction_Guarantee_Year__c, ' + 
                                               'Approximate_Price_per_kWh__c, Base_Monthy_Payment__c, Cash_Payment__c, ' +  
                                               'Cash_Price_Return_On_Investment_year1__c, Cash_Price_Return_On_Investment_year5__c, Cost_of_Lease_Per_kWh__c, ' +  
                                               'Cost_per_watt_AC__c, Cost_per_watt_DC__c, Cumulative_Production_kWh__c, ' +  
                                               'Cumulative_Production_kWh_Text__c, CurrencyIsoCode, Est_Monthly_Paymt_w_o_formula__c, ' +  
                                               'Est_Mthly_Paymt_includingTax_w_auto_ACH__c, Est_Mthly_Paymt_with_formula__c, Estimated_Monthly_Payment_inclusive_of_T__c, ' +  
                                               'Estimated_Tax_on_Monthly_Payment__c, Final_Base_Monthly_Payment__c, Final_Estimated_Monthly_W_Tax_No_ACH__c, ' +  
                                               'Final_Estimated_Monthly_W_Tax_No_ACH_p2__c, Final_Estimated_Monthly_W_Tax_W_ACH__c, Final_Estimated_Tax_on_Monthly__c, ' +  
                                               'Final_Tax_Rate__c, Final_Total_Yearly_Page_2__c, Final_Total_Yearly_Page_4__c, ' +  
                                               'Guarantee_Year__c, Guaranteed_Range_of_Annual_Production__c, Id, Lease_Payments_Year__c, ' +  
                                               'Monthly_Electric_Bill_saving_year1__c, Monthly_Electric_Bill_saving_year5__c, Monthly_Electric_Bill_With_PV_year1__c, ' +  
                                               'Monthly_Electric_Bill_With_PV_year5__c, Monthly_Electric_Bill_Without_PV_year1__c, Monthly_Electric_Bill_Without_PV_year5__c, ' +  
                                               'Monthly_Lease_Payment__c, Monthly_Lease_Payment_7_50_discount__c, Monthly_Loan_Payment_net_of_ITC__c, ' +  
                                               'Monthly_Loan_Payment_with_ITC__c, Monthly_Payments_and_with_automatic_ACH__c, Name, ' +  
                                               'PeGu_Estimate__c, Percentage_Electricity_Produced__c, Quote__c, Rate_Per_KWH__c, ' +  
                                               'Rebate_Design_Factor__c, Record_Count__c, Remaining_Lease_Period__c, ' +  
                                               'Remaining_Lease_Value__c, RoundOff_Base_Monthly_Payment__c, RoundOff_Rate_Per_KWH__c, ' +  
                                               'RoundOff_Remaining_Lease_Value__c, Solar_Loan_Interest_Rate__c, System_Production_Annual_Production__c, ' +  
                                               'System_Production_Annual_Production_Text__c, System_Size_AC__c, System_Size_DC__c, ' +  
                                               'Tax_Rate__c, Temp_Monthly_Lease_Payments__c, Upfront_Incentives__c, Upfront_Lease_Payment__c, ' +  
                                               'X105_of_S_P_A_P__c, X105_of_S_P_A_P_1__c, X95_of_S_P_A_P__c, X95_of_S_P_A_P_1__c, Year__c, Years__c ' + 
                                        'FROM Lease_Schedule__c ';                       
                           
        //Account's Base Query
        strBaseQueryAccount= 'SELECT id, Name, ' + 
                                     'BillingStreet, BillingCity, BillingState, BillingCountry, BillingPostalCode, ' + 
                                     'Geolocation__latitude__s,Geolocation__longitude__s, Lat__c, Log__c, ' + 
                                     'Sales_Tax_Rate__c,Description,' +
                                     'Fee_Cal_Latitude__c,Fee_Cal_Longitude__c, Specialized_Seller__c, Specialized_Installer__c, partner_facts__c, Email__c, Phone, '+
                                     '(SELECT Id, FirstName, LastName, ' + 
                                              'Phone, Email, Primary__c, ' + 
                                              'Role__c, Include_in_Lease_Doc__c ' + 
                                      'FROM Contacts ' + 
                                      'ORDER BY CreatedDate ASC), ' + 
                                      '(SELECT Id, Name, Lead_Manufacturer__c, ' +
                                               'NMI__c ' +
                                      'FROM Opportunities ' + 
                                      'ORDER BY CreatedDate ASC) ' + 
                             'FROM Account ';                  
    }

    public static List<User> GetUsers(String strWhereClause)
    {
        return (List<User>) Database.query(strBaseQueryUser + strWhereClause);        
    }//End FUnc GetUsers
        
    public static List<Quote> GetQuotes(String strWhereClause)
    {       
        return (List<Quote>) Database.query(strBaseQueryQuote + strWhereClause);
    }//End Func GetQuotes

    public static List<Lease_Schedule__c> GetLeaseSchedules(String strWhereClause)
    {       
        return (List<Lease_Schedule__c>) Database.query(strBaseQueryLeaseSchedule + strWhereClause);
    }//End Func GetLeaseSchedules
        
    public static List<Account> GetAccounts(String strWhereClause)
    {      
        return (List<Account>) Database.query(strBaseQueryAccount + strWhereClause);
    }//End Func GetAccounts
}//End Class GPPQueryHelper