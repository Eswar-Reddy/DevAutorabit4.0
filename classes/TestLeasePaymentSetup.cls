@isTest
public class TestLeasePaymentSetup {
    public static Account newAccount;
    public static Contact newContact;
    public static Opportunity newOpportunity;
    public static User partnerUser;
    public static Quote newQuote;
    public static Date currentDate;
    public static List<Financier_Criteria_for_FMV_Rates__c> financierCustomSettings;
    public static final String FINANCIER = 'testFinancier1';
    public static String CA;
    public static String MI;
    public static String USA;
    public static Date startDateWithin;
    public static Date endDateWithin;
    public static Date startDateOOB;
    public static Date endDateOOB;


    public static void setup() {

        partnerUser = TestUtils.createLeasePartnerInfo( );
        CA = 'CA';
        MI = 'MI';
        USA = 'USA';

        System.runAs( partnerUser ){
            newAccount = TestUtils.createAccount('CPR TEST ACCOUNT 1', TestUtils.getResidentialRecordTypeId() , false );
            newAccount.BillingCountry = USA;
            insert newAccount;
            newContact = TestUtils.createContact('CPR TEST CONTACT 1', newAccount.Id, true );
            newOpportunity = TestUtils.createOpportunities( 1 , newAccount.Id, newContact.Id, true)[0];
        }
        currentDate = Date.today();
        startDateWithin = currentDate.addDays(-1);
        endDateWithin = currentDate.addDays(1);
        startDateOOB = currentDate.addDays(-2);
        endDateOOB = currentDate.addDays(-1);

    }

    public static void setupFinancierCustomSettings() {
        financierCustomSettings = new List<Financier_Criteria_for_FMV_Rates__c>();
        Financier_Criteria_for_FMV_Rates__c financierCustomSetting = new Financier_Criteria_for_FMV_Rates__c();
        financierCustomSetting.Name = 'testFinancier';
        financierCustomSetting.Financier__c = FINANCIER;
        financierCustomSetting.Lease_Payment_Field__c = 'Lease_Type__c';
        financierCustomSetting.FMV_Rate_Field__c = 'Lease_Type__c';
        insert financierCustomSetting;
    }

    public static final String CA_INTERCONNECT_DOC_TYPE = 'cainterconnectdoctype';
    public static final String CA_INSTALL_DOC_TYPE = 'cainstallconnectdoctype';
    public static final String MI_INSTALL_DOC_TYPE = 'miinstallconnectdoctype';

    public static Map<String, List<Invoice_Document_Data__c>> createCountryStateToDocumentDataMap_InvoiceDocs()
    {
        Invoice_Document_Data__c caInterconnectWithinRange = new Invoice_Document_Data__c();
        caInterconnectWithinRange.Name = CA_INTERCONNECT_DOC_TYPE;
        caInterconnectWithinRange.Start_Date__c = startDateWithin;
        caInterconnectWithinRange.End_Date__c = endDateWithin;
        caInterconnectWithinRange.State__c = CA;
        caInterconnectWithinRange.Country__c = USA;
        caInterconnectWithinRange.Invoice_Type__c = InvoiceDocumentServices.INTERCONNECT_TYPE;
        caInterconnectWithinRange.Archive__c = false;
        caInterconnectWithinRange.Default__c = false;

        Invoice_Document_Data__c caInstallWithinRange = new Invoice_Document_Data__c();
        caInstallWithinRange.Name = CA_INSTALL_DOC_TYPE;
        caInstallWithinRange.Start_Date__c = startDateWithin;
        caInstallWithinRange.End_Date__c = endDateWithin;
        caInstallWithinRange.State__c = CA;
        caInstallWithinRange.Country__c = USA;
        caInstallWithinRange.Invoice_Type__c = InvoiceDocumentServices.INSTALL_TYPE;
        caInstallWithinRange.Archive__c = false;
        caInstallWithinRange.Default__c = false;

        Invoice_Document_Data__c caInterconnectOutOfRange = new Invoice_Document_Data__c();
        caInterconnectOutOfRange.Name = CA_INTERCONNECT_DOC_TYPE;
        caInterconnectOutOfRange.Start_Date__c = startDateOOB;
        caInterconnectOutOfRange.End_Date__c = endDateOOB;
        caInterconnectOutOfRange.State__c = CA;
        caInterconnectOutOfRange.Country__c = USA;
        caInterconnectOutOfRange.Invoice_Type__c = InvoiceDocumentServices.INTERCONNECT_TYPE;
        caInterconnectOutOfRange.Archive__c = false;
        caInterconnectOutOfRange.Default__c = false;

        Invoice_Document_Data__c miInstallWithinRange = new Invoice_Document_Data__c();
        miInstallWithinRange.Name = MI_INSTALL_DOC_TYPE;
        miInstallWithinRange.Start_Date__c = startDateWithin;
        miInstallWithinRange.End_Date__c = endDateWithin;
        miInstallWithinRange.State__c = MI;
        miInstallWithinRange.Country__c = USA;
        miInstallWithinRange.Invoice_Type__c = InvoiceDocumentServices.INSTALL_TYPE;
        miInstallWithinRange.Archive__c = false;
        miInstallWithinRange.Default__c = false;

        Invoice_Document_Data__c miInstallOutOfRange = new Invoice_Document_Data__c();
        miInstallOutOfRange.Name = MI_INSTALL_DOC_TYPE;
        miInstallOutOfRange.Start_Date__c = startDateOOB;
        miInstallOutOfRange.End_Date__c = endDateOOB;
        miInstallOutOfRange.State__c = MI;
        miInstallOutOfRange.Country__c = USA;
        miInstallOutOfRange.Invoice_Type__c = InvoiceDocumentServices.INSTALL_TYPE;
        miInstallOutOfRange.Archive__c = false;
        miInstallOutOfRange.Default__c = false;

        Invoice_Document_Data__c defaultUSA = new Invoice_Document_Data__c();
        defaultUSA.Name = 'Default';
        defaultUSA.Start_Date__c = startDateWithin;
        defaultUSA.End_Date__c = endDateWithin;
        defaultUSA.Country__c = USA;
        defaultUSA.Invoice_Type__c = InvoiceDocumentServices.INSTALL_TYPE;
        defaultUSA.Archive__c = false;
        defaultUSA.Default__c = true;

        Map<String, List<Invoice_Document_Data__c>> countryStateToDocumentData = new Map<String, List<Invoice_Document_Data__c>>
        {
            USA + InvoiceDocumentServices.COUNTRY_STATE_KEY_DELIMITER + CA => new List<Invoice_Document_Data__c>{ caInterconnectWithinRange, caInstallWithinRange, caInterconnectOutOfRange },
            USA + InvoiceDocumentServices.COUNTRY_STATE_KEY_DELIMITER + MI => new List<Invoice_Document_Data__c>{ miInstallWithinRange, miInstallOutOfRange },
            USA + InvoiceDocumentServices.COUNTRY_STATE_KEY_DELIMITER => new List<Invoice_Document_Data__c>{ defaultUSA }
        };

        return countryStateToDocumentData;
    }

    public static Map<String, List<Invoice_Document_Data__c>> createCountryStateToDocumentDataMap_OriginationDocs()
    {
        Invoice_Document_Data__c caOrigination = new Invoice_Document_Data__c();
        caOrigination.Name = CA_INTERCONNECT_DOC_TYPE;
        caOrigination.State__c = CA;
        caOrigination.Country__c = USA;
        caOrigination.Invoice_Type__c = InvoiceDocumentServices.ORIGINATION_TYPE;
        caOrigination.Archive__c = false;
        caOrigination.Default__c = false;

        Invoice_Document_Data__c anotherCaOrigination = new Invoice_Document_Data__c();
        anotherCaOrigination.Name = CA_INSTALL_DOC_TYPE;
        anotherCaOrigination.State__c = CA;
        anotherCaOrigination.Country__c = USA;
        anotherCaOrigination.Invoice_Type__c = InvoiceDocumentServices.ORIGINATION_TYPE;
        anotherCaOrigination.Archive__c = false;
        anotherCaOrigination.Default__c = false;

        Invoice_Document_Data__c miOrigination = new Invoice_Document_Data__c();
        miOrigination.Name = MI_INSTALL_DOC_TYPE;
        miOrigination.State__c = MI;
        miOrigination.Country__c = USA;
        miOrigination.Invoice_Type__c = InvoiceDocumentServices.ORIGINATION_TYPE;
        miOrigination.Archive__c = false;
        miOrigination.Default__c = false;

        Invoice_Document_Data__c defaultUSA = new Invoice_Document_Data__c();
        defaultUSA.Name = 'Default';
        defaultUSA.Country__c = USA;
        defaultUSA.Invoice_Type__c = InvoiceDocumentServices.ORIGINATION_TYPE;
        defaultUSA.Archive__c = false;
        defaultUSA.Default__c = true;

        Map<String, List<Invoice_Document_Data__c>> countryStateToDocumentData = new Map<String, List<Invoice_Document_Data__c>>
        {
            USA + InvoiceDocumentServices.COUNTRY_STATE_KEY_DELIMITER + CA => new List<Invoice_Document_Data__c>{ caOrigination, anotherCaOrigination },
            USA + InvoiceDocumentServices.COUNTRY_STATE_KEY_DELIMITER + MI => new List<Invoice_Document_Data__c>{ miOrigination },
            USA + InvoiceDocumentServices.COUNTRY_STATE_KEY_DELIMITER => new List<Invoice_Document_Data__c>{ defaultUSA }
        };

        return countryStateToDocumentData;
    }
}