/*
Modification:
12-Dec-2013 : Sandesh Birlasoft
04-Jun-2014 : Birlasoft : Only Added Debug Statements
01-Jul-2014 : Birlasoft : Added code for Invoice Document Creation code for Australia
03-Jul-2014 : Birlasoft : Matched with UAT Code.
*/
public with sharing class LeasePaymentService{

    public static boolean hasPopulated = false;
    public static Boolean hasRun = false;
    public static Map< Id,Id > quoteIds2LeasePaymentIds = new Map< Id,Id >();
    public static final String STATUS_VALUE = 'Active';
    public static Map<String, List<Financier_Criteria_for_FMV_Rates__c>> financierCriteria {
        get {
            if (financierCriteria == null) {
                financierCriteria = new Map<String, List<Financier_Criteria_for_FMV_Rates__c>>();
                for (Financier_Criteria_for_FMV_Rates__c financierSetting : Financier_Criteria_for_FMV_Rates__c.getAll().values())
                {
                    if(!financierCriteria.containsKey(financierSetting.Financier__c))
                    {
                        financierCriteria.put(financierSetting.Financier__c, new List<Financier_Criteria_for_FMV_Rates__c>());
                    }
                    financierCriteria.get(financierSetting.Financier__c).add(financierSetting);
                }
            }
            return financierCriteria;
        }
        private set;
    }

    public static Map< String, List<Lease_Schedule_Summary_Mapping__c> > leaseScheduleYearToMappings {
        get {
            if ( leaseScheduleYearToMappings == null ){

                leaseScheduleYearToMappings = new Map< String, List<Lease_Schedule_Summary_Mapping__c> >();

                for (Lease_Schedule_Summary_Mapping__c summaryMapping : Lease_Schedule_Summary_Mapping__c.getAll().values() ) {

                    if ( !leaseScheduleYearToMappings.containsKey( summaryMapping.Year_Number__c ) ) {

                        leaseScheduleYearToMappings.put( summaryMapping.Year_Number__c, new List< Lease_Schedule_Summary_Mapping__c >() );

                    }

                    leaseScheduleYearToMappings.get( summaryMapping.Year_Number__c ).add( summaryMapping );

                }
            }

            return leaseScheduleYearToMappings;
        }
        set;
    }

    //cdevarapalli TPS Phase2
    public static Map<Id,List<Attachment>> docIdAttListMap= new Map<Id,List<Attachment>>();
    private static final String attachUrl = 'https://' + URL.getSalesforceBaseUrl().getHost() + '/servlet/servlet.FileDownload?file=';

    private static String fieldsToQuery() {
        String fieldsToQuery = '';
        Set<String> uniqueFields = new Set<String>();

        if(!leaseScheduleYearToMappings.isEmpty()) {
            fieldsToQuery = ', ';

            for(List<Lease_Schedule_Summary_Mapping__c> summaryMappings : leaseScheduleYearToMappings.values()) {
                for(Lease_Schedule_Summary_Mapping__c summaryMapping : summaryMappings) {
                    if(!uniqueFields.contains(summaryMapping.From_Field__c)) {
                        uniqueFields.add(summaryMapping.From_Field__c);
                        fieldsToQuery += summaryMapping.From_Field__c +', ';
                    }
                }
            }
            fieldsToQuery = fieldsToQuery.substring(0, fieldsToQuery.length()-2);
        }
        return fieldsToQuery;
    }

    public static void createLeaseScheduleSummary(Map<Id, LeasePayment__c> lpMap){
        Set<Id> quoteIds = new Set<Id>();

        for(LeasePayment__c lp : lpMap.values()) {
            quoteIds.add(lp.Quote__c);
            quoteIds2LeasePaymentIds.put(lp.Quote__c, lp.Id);
        }

        if(!quoteIds.isEmpty()) {
            String query='SELECT Id, Quote__c, quote__r.Opportunity.account.billingcountry, currencyisocode, Annual_Lease_Payments_Year__c '+fieldsToQuery()+' FROM Lease_Schedule__c WHERE Quote__c IN :quoteIds';

            List<Lease_Schedule__c> leaseSchedules = Database.query(query);

            if(!leaseSchedules.isEmpty()) {
                List<Lease_Schedule_Summary__c> leaseScheduleSummaries = createLeaseScheduleSummary(leaseSchedules);

                List<Lease_Schedule_Summary__c> summariesToRemove = [SELECT Id FROM Lease_Schedule_Summary__c WHERE Quote__c IN :quoteIds];

                doLeaseScheduleSummaryToQuote(leaseScheduleSummaries, lpMap, summariesToRemove);
            }
        }
    }

    public static List<Lease_Schedule_Summary__c> createLeaseScheduleSummary(List<Lease_Schedule__c> leaseSchedules){

        Map<Id, List<Lease_Schedule__c> > quoteId2LeaseSchedules = new Map<Id, List<Lease_Schedule__c> >();

        for(Lease_Schedule__c leaseSchedule : leaseSchedules){

            if ( !quoteId2LeaseSchedules.containsKey( leaseSchedule.Quote__c ) ){

                quoteId2LeaseSchedules.put( leaseSchedule.Quote__c, new List< Lease_Schedule__c >() );

            }

            quoteId2LeaseSchedules.get( leaseSchedule.Quote__c ).add( leaseSchedule );

        }

        List<Lease_Schedule_Summary__c> leaseScheduleSummaries = new List<Lease_Schedule_Summary__c>();

        for(Id quoteId : quoteId2LeaseSchedules.keySet()){


            List< Lease_Schedule__c > relevantLeaseSchedules = quoteId2LeaseSchedules.get( quoteId );

            Lease_Schedule_Summary__c leaseScheduleSummary = copyLeaseScheduleFieldsToLeaseScheduleSummary( quoteId, relevantLeaseSchedules );

            leaseScheduleSummaries.add( leaseScheduleSummary );

        }

        return leaseScheduleSummaries;
    }

    public static Lease_Schedule_Summary__c copyLeaseScheduleFieldsToLeaseScheduleSummary( Id quoteId, List< Lease_Schedule__c > leaseSchedules ){
        //copy fields from lease schedule to summary object
        Lease_Schedule_Summary__c leaseScheduleSummary = new Lease_Schedule_Summary__c();
        leaseScheduleSummary.Quote__c = quoteId;
        if(leaseSchedules.size() > 0)
        {
            leaseScheduleSummary.currencyisocode = leaseSchedules[0].currencyisocode;
            if(leaseSchedules[0].quote__r.Opportunity.account.billingcountry != null && leaseSchedules[0].quote__r.Opportunity.account.billingcountry.equalsIgnorecase(Label.Australia))
                leaseScheduleSummary.Financing_Term_in_Months__c = Decimal.valueof(Label.FinancingTerm_Months_AU);
        }


        for ( Lease_Schedule__c leaseSchedule : leaseSchedules ) {

            //get all mappings and copy//
            if ( leaseScheduleYearToMappings.containsKey( leaseSchedule.Annual_Lease_Payments_Year__c ) ) {

                List< Lease_Schedule_Summary_Mapping__c > mappings = leaseScheduleYearToMappings.get( leaseSchedule.Annual_Lease_Payments_Year__c );

                for ( Lease_Schedule_Summary_Mapping__c mapping : mappings ){

                    String fromField = mapping.From_Field__c;
                    String toField = mapping.To_Field__c;

                    leaseScheduleSummary.put( toField, leaseSchedule.get( fromField ) );

                }
            }

        }

        leaseScheduleSummary.Lease_Payment__c = quoteIds2LeasePaymentIds.get( quoteId );
        return leaseScheduleSummary;
    }

    public static void doLeaseScheduleSummaryToQuote( List< Lease_Schedule_Summary__c > leaseScheduleSummaries, Map< Id, LeasePayment__c > id2LeasePayment, List<Lease_Schedule_Summary__c> summariesToRemove ){
        //link summary object to quote
        System.savepoint sp = Database.setSavepoint();

        try {

            if ( !summariesToRemove.isEmpty() ) {

                delete summariesToRemove;

            }

            insert leaseScheduleSummaries;

        }
        catch(DmlException dmx) {

            for (Integer i = 0; i < dmx.getNumDml(); i++ ) {

                Id leasePaymentId = leaseScheduleSummaries[ dmx.getDmlIndex(i) ].Lease_Payment__c;

                id2LeasePayment.get( leasePaymentId ).addError( dmx.getDmlMessage(i) );
            }

            Database.rollback( sp );
        }

    }

    public static void applyFMVRate(List<LeasePayment__c> leasePayments) {
        Map<String, List<FMV_Rate__c>> stateToRates = queryRatesByState(leasePayments);
        populateLeasePaymentWithRate(leasePayments, stateToRates);
    }

    /*
    Purpose: Query for Rates to be used in the FMV calculation
    Parameters: A list of LeasePayments to use as scope for rate query
    Results: Map of State to List of FMV_Rate__c objects that will need to be iterated through to find the correct rate a specific lease payment
    Side Effects: none
    */
    public static Map<String, List<FMV_Rate__c>> queryRatesByState(List<LeasePayment__c> leasePayments)
    {
        Map<String, List<FMV_Rate__c>> stateToRates = new Map<String, List<FMV_Rate__c>>();
        Map<String, Date> stateToDate = getLatestDateByState(leasePayments);

        Set<String> financierNames = new Set<String>();
        for (LeasePayment__c leasePayment : leasePayments)
        {
            financierNames.add(leasePayment.Funding_Tranche__c);
        }

        String query = '';
        query = 'SELECT ' + String.join(getQueryFields(financierNames), ', ');
        query += ' FROM FMV_Rate__c';
        query += ' WHERE Financier__c IN :financierNames AND (';

        List<String> stateClauses = new List<String>();

        for(String state : stateToDate.keySet())
        {
            //Nikki De Guzman - 07/01/2014 - Check if stateToDate is null
            if (stateToDate.get(state) != null){
                //Ralph Alega - 06/19/2014 - Escaped single quote to include single quote for a French State - Case Number 00364092
                //String stateClause = '(State__c = ' + '\''+state+'\'';
                String stateClause = '(State__c = \'' + String.escapeSingleQuotes(state) + '\'';
                stateClause += ' AND Start_Date__c <= ' + getSOQLformattedDate(stateToDate.get(state)) + ')';
                stateClauses.add(stateClause);
            }
        }

        //Modified By: Nikki De Guzman Check if stateClauses is null
        if (stateClauses != null){
            query += String.join(stateClauses, ' OR ');
            query += ') ORDER BY Start_Date__c DESC';
            system.debug(Logginglevel.ERROR,'query--------'+query);



            List<FMV_Rate__c> orderedRates = Database.query(query);

            for(FMV_Rate__c rate : orderedRates)
            {
                if(stateToRates.get(rate.State__c) == null)
                {
                    stateToRates.put(rate.State__c, new List<FMV_Rate__c>{rate});
                }
                else
                {
                    stateToRates.get(rate.State__c).add(rate);
                }
            }
        }
        return stateToRates;
    }

    private static List<String> getQueryFields(Set<String> financierNames)
    {
        Set<String> queryFields = new Set<String> {  'Id', 'Financier__c', 'Start_Date__c', 'End_Date__c', 'State__c', 'FMV_Rate__c' };
            for (String financierName : financierNames)
        {
            if(financierCriteria.get(financierName) == null) continue;
            for (Financier_Criteria_for_FMV_Rates__c financierCriterion : financierCriteria.get(financierName))
            {
                queryFields.add(financierCriterion.FMV_Rate_Field__c);
            }
        }
        return new List<String>(queryFields);
    }

    public static List<LeasePayment__c> filterLeasePaymentsWithPopulatedField(String fieldToCheck, List<LeasePayment__c> leasePayments, Map<Id, LeasePayment__c> oldLeasePayments)
    {
        List<LeasePayment__c> populatedLeasePayments = new List<LeasePayment__c>();
        for(LeasePayment__c leasePayment : leasePayments)
        {
            Boolean currentFieldNotNull = (leasePayment.get(fieldToCheck) != null);
            Boolean oldFieldIsNull = (oldLeasePayments.get(leasePayment.Id).get(fieldToCheck) == null);
            if(currentFieldNotNull && oldFieldIsNull)
            {
                populatedLeasePayments.add(leasePayment);
            }
        }
        return populatedLeasePayments;
    }

    public static List<LeasePayment__c> filterLeasePaymentsWithPopulatedCheckbox(String fieldToCheck, List<LeasePayment__c> leasePayments, Map<Id, LeasePayment__c> oldLeasePayments)
    {
        List<LeasePayment__c> populatedLeasePayments = new List<LeasePayment__c>();
        for(LeasePayment__c leasePayment : leasePayments)
        {
            Boolean currentField = (Boolean) leasePayment.get(fieldToCheck);
            Boolean oldField = (Boolean) oldLeasePayments.get(leasePayment.Id).get(fieldToCheck);
            if(currentField && (oldField == null || !oldField))
            {
                populatedLeasePayments.add(leasePayment);
            }
        }
        return populatedLeasePayments;
    }

    /*
    *    Rates are assumed to be ordered by Start_Date__c DESC
    */
    public static void populateLeasePaymentWithRate(List<LeasePayment__c> leasePayments, Map<String, List<FMV_Rate__c>> stateToRates)
    {
        for(LeasePayment__c leasePayment : leasePayments)
        {
            List<FMV_Rate__c> ratesForState = stateToRates.get(leasePayment.Site_State_Prov__c);
            if(ratesForState != null)
            {
                for(FMV_Rate__c rate : ratesForState)
                {
                    if(isMatchingFMVRate(rate, leasePayment))
                    {
                        leasePayment.FMV_Rate__c = rate.FMV_Rate__c;
                        break;
                    }
                }
            }
        }
    }

    private static Boolean isMatchingFMVRate(FMV_Rate__c rate, LeasePayment__c leasePayment)
    {
        if (rate.Financier__c != leasePayment.Funding_Tranche__c || rate.Start_Date__c > leasePayment.Date_Countersigned__c) return false;
        if(financierCriteria.get(leasePayment.Funding_Tranche__c) == null) return true;
        for (Financier_Criteria_for_FMV_Rates__c criterion : financierCriteria.get(leasePayment.Funding_Tranche__c))
        {
            if (leasePayment.get(criterion.Lease_Payment_Field__c) != rate.get(criterion.FMV_Rate_Field__c)) return false;
        }
        return true;
    }

    public static Map<String, Date> getLatestDateByState(List<LeasePayment__c> leasePayments)
    {
        Map<String, Date> latestDates = new Map<String, Date>();

        for(LeasePayment__c leasePayment :leasePayments)
        {
            if(!String.isBlank(leasePayment.Site_State_Prov__c))
            {
                Date latestDate = latestDates.get(leasePayment.Site_State_Prov__c);
                if(latestDate == null || leasePayment.Date_Countersigned__c > latestDate)
                {
                    latestDates.put(leasePayment.Site_State_Prov__c, leasePayment.Date_Countersigned__c);
                }
            }
        }

        return latestDates;
    }

    public static String getSOQLformattedDate(Date dateToFormat)
    {
        DateTime holderDateTime = DateTime.newInstance(dateToFormat.year(), dateToFormat.month(), dateToFormat.day());
        return holderDateTime.format('yyyy-MM-dd');

    }

    public static void populateInstallAndInterconnect(List<LeasePayment__c> leasePayments)
    {
        //Get Quotes and their Installation Models
        Set<Id> quoteIds = new Set<Id>();
        List<Id> partnerList = new List<Id>();
        for (LeasePayment__c lp : leasePayments) {
            if (lp.Status__c == 'Active') quoteIds.add(lp.Quote__c);
            partnerList.add(lp.Partner_Account__c);
        }
        Map<Id,Quote> quoteMap = new Map<Id,Quote>([SELECT Id, Installation_Model__c, System_Model__c, Opportunity.Account.BillingState FROM Quote WHERE Id in :quoteIds AND Installation_Model__c != null]);
        Map<Id, List<IDD_Junction__c>> partnerIDDMap = new Map<Id, List<IDD_Junction__c>>();
        for(IDD_Junction__c iddj : [SELECT Id,iSupplier__c,State__c, Invoice_Document_Data__c, Invoice_Type__c, Installation_Model__r.Country__c, Installation_Model__c, System_Type__c, Partner_Account__c, Partner_Account__r.BillingCountry FROM IDD_Junction__c WHERE Partner_Account__c IN: partnerList]){
            if(partnerIDDMap.containsKey(iddj.Partner_Account__c)){
                partnerIDDMap.get(iddj.Partner_Account__c).add(iddj);
            }else{
                partnerIDDMap.put(iddj.Partner_Account__c, new List<IDD_Junction__c>{iddj});
            }
        }
        //Get Map of Installation Models
        Set<Id> modelIds = new Set<Id>();
        for(Quote qt : quoteMap.values()) modelIds.add(qt.Installation_Model__c);
        Map <Id, Installation_Model__c> modelMap = new Map<Id, Installation_Model__c>([SELECT Id, Country__c, (SELECT Id,iSupplier__c,State__c, Invoice_Document_Data__c, Invoice_Type__c, Installation_Model__r.Country__c, Installation_Model__c, System_Type__c, Partner_Account__c, Partner_Account__r.BillingCountry FROM IDD_Junctions__r WHERE Invoice_Type__c IN ('Interconnect', 'Install')) FROM Installation_Model__c WHERE Id IN :modelIds]);

        Set<Id> interconnectIdds = new Set<Id>();
        Set<Id> installIdds = new Set<Id>();

        for(LeasePayment__c lp : leasePayments){
            if (lp.Status__c != 'Active' || String.isBlank(lp.Quote__c) || !quoteMap.containsKey(lp.Quote__c)) break;

            interconnectIdds.clear();
            installIdds.clear();

            Quote q = quoteMap.get(lp.Quote__c);

            // Junctions to run through criteria. Partner and Installation Model
            List<IDD_Junction__c> juncsToVal = new List<IDD_Junction__c>();
            if(modelMap.containsKey(q.Installation_Model__c)) juncsToVal.addAll(modelMap.get(q.Installation_Model__c).IDD_Junctions__r);
            if(partnerIDDMap.containsKey(lp.Partner_Account__c)) juncsToVal.addAll(partnerIDDMap.get(lp.Partner_Account__c));
            // Run IDDs through criteria filters
            List<IDD_Junction__c> validJunctions = iddCriteriaUtility(juncsToVal, lp, q);
            for (IDD_Junction__c idd : validJunctions){
                
                if (idd.Invoice_Type__c == 'Interconnect') interconnectIdds.add(idd.Invoice_Document_Data__c);
                if (idd.Invoice_Type__c == 'Install') installIdds.add(idd.Invoice_Document_Data__c);
                
            }
            lp.Install_Invoice_Docs_Required__c = installIdds.size();
            lp.Interconnect_Invoice_Docs_Required__c = interconnectIdds.size();
        }
    }

    // Utility method used by createInoiceDocument and populateInstallAndInterconnect to run IDD criteria
    public static List<IDD_Junction__c> iddCriteriaUtility(List<IDD_Junction__c> idds, LeasePayment__c lp, Quote q){
        String systemModel          = q == NULL ? lp.Quote__r.System_Model__c: q.System_Model__c;
        String installationModel    = q == NULL ? lp.Quote__r.Installation_Model__c : q.Installation_Model__c;
        String lpState              = q == NULL ? lp.Site_State_Prov__c : q.Opportunity.Account.BillingState;

        // Loop through each junction and identify if it meets additional criteria
        List<IDD_Junction__c> validJunctions = new List<IDD_Junction__c>();
        for(IDD_Junction__c junc : idds){

            Boolean valid = TRUE;

            // Discard Junction records if the Partner Account doesn't match the partner account defined on the FPO
            if(junc.Partner_Account__c != NULL){
                if(lp.Partner_Account__c != junc.Partner_Account__c) valid = FALSE;
            }

            // Discard Junciton records if the Installation Model doesn't match the Installation Model defined on the Quote
            if(junc.Installation_Model__c != NULL){
                if(installationModel != junc.Installation_Model__c) valid = FALSE;
            }

            // Discard Junction if Country = United States and State doesn't match
            if(junc.Installation_Model__c != NULL && junc.Installation_Model__r.Country__c == 'United States' && junc.State__c != NULL){
                if(lpState == NULL) {
                    valid = FALSE;
                }else{
                    if(junc.State__c == NULL || lpState == NULL) valid = FALSE;
                    if(!junc.State__c.contains(lpState)) valid = FALSE;
                }
            }

            // Discard Junction if Country = United States and State doesn't match
            if(junc.Partner_Account__c != NULL && junc.Partner_Account__r.BillingCountry == 'United States' && junc.State__c != NULL){
                if(lpState == NULL) {
                    valid = FALSE;
                }else{
                    if(junc.State__c == NULL || lpState == NULL) valid = FALSE;
                    if(!junc.State__c.contains(lpState)) valid = FALSE;
                }
            }

            // Discard Junction if the System Type doesn't match
            if(systemModel != NULL){
                String systemType = systemModel.contains('-AC') ? 'AC' : 'DC';
                if(junc.System_Type__c != NULL && !junc.System_Type__c.contains(systemType)) valid = FALSE;
            }

            if(lp.Partner_Account__r.iSupplier__c && junc.iSupplier__c == 'NO')
                valid = FALSE;

            if(!lp.Partner_Account__r.iSupplier__c && junc.iSupplier__c == 'YES')
                valid = FALSE;      
        
            if(valid) validJunctions.add(junc);
        }
        return validJunctions;
    }

    //April 13, 2017: Sita Reeves: Replace createInvoiceDocument with new Junction Model - All IDDs come through IMs
    public static void createInvoiceDocuments(List<LeasePayment__c> leasePayments){
        List<Id> imList = new List<Id>(); // List of installation model Ids from lease payment's quote
        Map<Id, List<IDD_Junction__c>> imJunctionMap = new Map<Id, List<IDD_Junction__c>>(); //Key: Installation Model Id, Value: List of related IDD Junctions
        Map<Id, List<IDD_Junction__c>> paJunctionMap = new Map<Id, List<IDD_Junction__c>>(); //Key: Partner Account Id, Value: List of related IDD Junctions
        List<Invoice_Documents__c> invDocsToInsert = new List<Invoice_Documents__c>();
        Set<Id> partnerIdSet = new Set<Id>();
        // ----- REMOVE AFTER INV DOC OPTIMIZATION //
        Map<Id, Id> accMap = new Map<Id, Id>();
        Map<Id, Id> oppMap = new Map<Id, Id>();
        Map<Id, Id> projMap = new Map<Id, Id>();
        Map<Id, Id> partnerMap = new Map<Id, Id>();
        Map<Id, List<Document__c>> accDocMap = new Map<Id, List<Document__c>>();
        Map<Id, List<Document__c>> oppDocMap = new Map<Id, List<Document__c>>();
        Map<Id, List<Document__c>> projDocMap = new Map<Id, List<Document__c>>();
        //-----//

        // Query lease payments to get the quote and installation model
        List<LeasePayment__c> leasePaymentsExtended = [SELECT Id, Lease__c, Partner_Account__c,Partner_Account__r.iSupplier__c, Site_State_Prov__c, Quote__r.System_Model__c, Quote__r.Installation_Model__c, Quote__r.Module_Count__c, Quote__r.Inverter_Count__c, Quote__r.OpportunityId, Quote__r.Opportunity.AccountId, Residential_Project__c, Residential_Project__r.Installation_Partner__c, Residential_Project__r.Installation_Model__c FROM LeasePayment__c WHERE Id IN: leasePayments AND Quote__c != NULL AND Quote__r.Installation_Model__c != NULL AND Status__c = 'Active'];

        // Create list of all lease payment quote Installation Model Ids
        for(LeasePayment__c lp : leasePaymentsExtended){
            if(lp.Quote__r.Installation_Model__c != NULL)                   imList.add(lp.Quote__r.Installation_Model__c);
            if(lp.Quote__r.Opportunity.AccountId != NULL)                   accMap.put(lp.Id, lp.Quote__r.Opportunity.AccountId);
            if(lp.Quote__r.OpportunityId != NULL)                           oppMap.put(lp.Id, lp.Quote__r.OpportunityId);
            if(lp.Residential_Project__c != NULL)                           projMap.put(lp.Id, lp.Residential_Project__c);
            if(lp.Partner_Account__c != NULL)                               partnerMap.put(lp.Id, lp.Partner_Account__c);
        }

        // Query for all junction records based on the installation model from the imList above
        for(IDD_Junction__c iddj : [SELECT  Id, 
                                            Installation_Model__c, 
                                            Installation_Model__r.Country__c, 
                                            Installation_Model__r.Financing_Option__c, 
                                            Invoice_Document_Data__c, 
                                            Invoice_Document_Data__r.Not_Required_For_Approval__c, 
                                            Invoice_Document_Data__r.Name, 
                                            Invoice_Document_Data__r.Sharing_Type__c, 
                                            Shared_With__c,
                                            Partner_Account__c,
                                            Partner_Account__r.BillingCountry,
                                            Document_Owner__c, 
                                            State__c, 
                                            Invoice_Type__c, 
                                            System_Type__c,
                                            Document_Upload_Location__c,
                                            iSupplier__c 
                                            FROM IDD_Junction__c 
                                            WHERE Installation_Model__c IN: imList OR Partner_Account__c IN: partnerMap.values()]){
            // Populate map with all Junction records related to an Installation Model
            if(iddj.Installation_Model__c != NULL){
                if(imJunctionMap.containsKey(iddj.Installation_Model__c)) {
                    imJunctionMap.get(iddj.Installation_Model__c).add(iddj);
                }else{
                    imJunctionMap.put(iddj.Installation_Model__c, new List<IDD_Junction__c>{iddj});
                }
            }
            else if(iddj.Partner_Account__c != NULL){
                if(paJunctionMap.containsKey(iddj.Partner_Account__c)){
                    paJunctionMap.get(iddj.Partner_Account__c).add(iddj);

                }else{
                    paJunctionMap.put(iddj.Partner_Account__c, new List<IDD_Junction__c>{iddj});
                }
            }
        }

        // ------- REMOVE AFTER INV DOC OPTIMIZATION - Location workaround functionality
        // Query for all Document records related to Account, Opportunity, or Residential Project
        List<Document__c> docs = [SELECT    Id, 
                                            Name, 
                                            Document_Type__c, 
                                            Account__c, 
                                            Opportunity__c, 
                                            Residential_Project__c, 
                                            (select Id,Name,CreatedDate from Attachments ORDER BY CreatedDate DESC) 
                                            FROM Document__c 
                                            WHERE (Account__c IN: accMap.values() OR Opportunity__c IN: oppMap.values() OR Residential_Project__c IN: projMap.values()) AND Document_Type__c != NULL];

        for(Document__c d : docs){
            if(d.Attachments.size() > 0){
                if(d.Account__c != NULL){
                    if(accDocMap.containsKey(d.Account__c)){
                        accDocMap.get(d.Account__c).add(d);
                    }else{
                        accDocMap.put(d.Account__c, new List<Document__c>{d});
                    }
                }
                if(d.Opportunity__c != NULL){
                    if(oppDocMap.containsKey(d.Opportunity__c)){
                        oppDocMap.get(d.Opportunity__c).add(d);
                    }else{
                        oppDocMap.put(d.Opportunity__c, new List<Document__c>{d});
                    }
                }
                if(d.Residential_Project__c != NULL){
                    if(projDocMap.containsKey(d.Residential_Project__c)){
                        projDocMap.get(d.Residential_Project__c).add(d);
                    }else{
                        projDocMap.put(d.Residential_Project__c, new List<Document__c>{d});
                    }
                }
            }
        }

        // ------//

        for(LeasePayment__c lp : leasePaymentsExtended){
            //if(imJunctionMap.containsKey(lp.Quote__r.Installation_Model__c)){
            // Define list of Junctions related to this lease payments installation model or partner account
            Map<Id,IDD_Junction__c> junctions = new Map<Id, IDD_Junction__c>(); // put in a map to weed out duplicates
            for(IDD_Junction__c iddj : imJunctionMap.get(lp.Quote__r.Installation_Model__c)){
                junctions.put(iddj.Id, iddj);
            }
            if (!String.isBlank(lp.Partner_Account__c) && paJunctionMap.get(lp.Partner_Account__c) != NULL){
                for(IDD_Junction__c iddj : paJunctionMap.get(lp.Partner_Account__c)){
                    junctions.put(iddj.Id, iddj);
                }
            }

            // Run IDDs through criteria filter
            List<IDD_Junction__c> validJunctions = iddCriteriaUtility(junctions.values(), lp, NULL);
           
            for(IDD_Junction__c junc : validJunctions){
                // Create Invoice Document to add to Lease Payment
                Invoice_Documents__c invDoc = new Invoice_Documents__c();
                invDoc.Lease_Payment__c             = lp.Id;
                invDoc.Name                         = lp.Lease__c + '['+junc.Invoice_Document_Data__r.Name+']';
                invDoc.Documents_in_File__c         = junc.Invoice_Document_Data__r.Name;
                invDoc.FinancingType__c             = junc.Installation_Model__r.Financing_Option__c;
                invDoc.Invoice_Type__c              = junc.Invoice_Type__c;
                invDoc.Location__c                  = junc.Document_Upload_Location__c; // Remove after Inv Doc Optimization project
                invDoc.Document_Owner__c            = junc.Document_Owner__c;
                invDoc.Sharing_Type__c              = junc.Invoice_Document_Data__r.Sharing_Type__c; // Remove after Inv Doc Optimization Project
                invDoc.Shared_With__c               = junc.Shared_With__c;
                InvDoc.Not_Required_For_Approval__c = junc.Invoice_Document_Data__r.Not_Required_For_Approval__c;

                // MAP ADDITIONAL FIELDS HERE //

                // ------- REMOVE AFTER INV DOC OPTIMIZATION //
                if(junc.Document_Upload_Location__c == 'Account' && accDocMap.containsKey(lp.Quote__r.Opportunity.AccountId)){
                    for(Document__c d : accDocMap.get(lp.Quote__r.Opportunity.AccountId)){
                        if(d.Document_Type__c == junc.Invoice_Document_Data__r.Name){
                            Attachment att = d.Attachments[0];
                            InvDoc.Status__c='Pending ';
                            InvDoc.Link_to_Attachment__c=attachUrl+att.Id;
                            InvDoc.Document_Submitted__c=att.CreatedDate.date();
                        }
                    }
                }
                if(junc.Document_Upload_Location__c == 'Opportunity' && oppDocMap.containsKey(lp.Quote__r.OpportunityId)){
                    for(Document__c d : oppDocMap.get(lp.Quote__r.OpportunityId)){
                        if(d.Document_Type__c == junc.Invoice_Document_Data__r.Name){
                            Attachment att = d.Attachments[0];
                            InvDoc.Status__c='Pending ';
                            InvDoc.Link_to_Attachment__c=attachUrl+att.Id;
                            InvDoc.Document_Submitted__c=att.CreatedDate.date();
                        }
                    }
                }
                if(junc.Document_Upload_Location__c == 'Residential Project' && projDocMap.containsKey(lp.Residential_Project__c)){
                    for(Document__c d : projDocMap.get(lp.Residential_Project__c)){
                        if(d.Document_Type__c == junc.Invoice_Document_Data__r.Name){
                            Attachment att = d.Attachments[0];
                            InvDoc.Status__c='Pending ';
                            InvDoc.Link_to_Attachment__c=attachUrl+att.Id;
                            InvDoc.Document_Submitted__c=att.CreatedDate.date();
                        }
                    }
                }
                //------//
            
                invDocsToInsert.add(invDoc);
            }
        }
        insert invDocsToInsert;

    }


    public static Map<Id,Map<String,Id>> getexistingDocuments(List<LeasePayment__c> leasePayments,Map<Id,LeasePayment__c> fpMap){
        //cdevarapalli TPS Phase2
        Map<Id,Set<Id>> lpOpAccIdSetMap = new Map<Id,Set<Id>>();
        Set<Id> AllOppsIdSet = new Set<Id>();
        Set<Id> AllAccsIdSet = new Set<Id>();
        Set<Id> AllProjsIdSet = new Set<Id>();

        for(Id lpId:fpMap.keySet()){
            Set<Id> tempSet = new Set<Id>();
            if(fpMap.get(lpId).Quote__r.OpportunityId != null){
                tempSet.add(fpMap.get(lpId).Quote__r.OpportunityId);
                AllOppsIdSet.add(fpMap.get(lpId).Quote__r.OpportunityId);
            }
            if(fpMap.get(lpId).Quote__r.Opportunity.AccountId!=null){
                tempSet.add(fpMap.get(lpId).Quote__r.Opportunity.AccountId);
                AllAccsIdSet.add(fpMap.get(lpId).Quote__r.Opportunity.AccountId);
            }
            if(fpMap.get(lpId).Residential_Project__c != null){
                tempSet.add(fpMap.get(lpId).Residential_Project__c);
                AllProjsIdSet.add(fpMap.get(lpId).Residential_Project__c);
            }
            if(!tempSet.isEmpty()){
                lpOpAccIdSetMap.put(lpId, tempSet);
            }
        }

        List<Document__c> docList = new List<Document__c>();
        Map<LeasePayment__c,Map<String,List<Document__c>>> lpdocLstMap = new Map<LeasePayment__c,Map<String,List<Document__c>>>();
        docList = [select Id,(select Id,Name,CreatedDate from Attachments ORDER BY CreatedDate DESC),Opportunity__c,Account__c,Document_Type__c,Quote__c, Residential_Project__c from Document__c where Opportunity__c in :AllOppsIdSet or Account__c in :AllAccsIdSet or Residential_Project__c in: AllProjsIdSet];
        Map<Id,Map<String,Id>> lpDocLocTypeComboSetMap = new Map<Id,Map<String,Id>>();

        for(LeasePayment__c lp:leasePayments){
            for(Document__c doc:docList){
                if(doc.Opportunity__c!=null){
                    if(lpOpAccIdSetMap.containsKey(lp.Id) && lpOpAccIdSetMap.get(lp.Id).contains(doc.Opportunity__c)){
                        if(lpDocLocTypeComboSetMap.containsKey(lp.Id)){
                            lpDocLocTypeComboSetMap.get(lp.Id).put(String.valueof(doc.Opportunity__c) + String.valueof(doc.Quote__c) + doc.Document_Type__c,doc.Id);
                        }
                        else{
                            lpDocLocTypeComboSetMap.put(lp.Id, new Map<String,Id>{String.valueOf(doc.Opportunity__c)+ String.valueof(doc.Quote__c)+doc.Document_Type__c => doc.Id});
                        }
                    }
                }
                else if(doc.Account__c!=null){
                    if(lpOpAccIdSetMap.containsKey(lp.Id) && lpOpAccIdSetMap.get(lp.Id).contains(doc.Account__c)){
                        if(lpDocLocTypeComboSetMap.containsKey(lp.Id)){
                            lpDocLocTypeComboSetMap.get(lp.Id).put(doc.Account__c+doc.Document_Type__c,doc.Id);
                        }
                        else{
                            lpDocLocTypeComboSetMap.put(lp.Id, new Map<String,Id>{doc.Account__c+doc.Document_Type__c => doc.Id});
                        }
                    }
                }
                else if(doc.Residential_Project__c!=null){
                    if(lpOpAccIdSetMap.containsKey(lp.Id) && lpOpAccIdSetMap.get(lp.Id).contains(doc.Residential_Project__c)){
                        if(lpDocLocTypeComboSetMap.containsKey(lp.Id)){
                            lpDocLocTypeComboSetMap.get(lp.Id).put(doc.Residential_Project__c+doc.Document_Type__c,doc.Id);
                        }
                        else{
                            lpDocLocTypeComboSetMap.put(lp.Id, new Map<String,Id>{doc.Residential_Project__c+doc.Document_Type__c => doc.Id});
                        }
                    }
                }
                if(!doc.Attachments.isEmpty())
                    docIdAttListMap.put(doc.Id,doc.Attachments);
            }
        }
        return lpDocLocTypeComboSetMap;
    }

    /*
    30-Jan-2017 : Sita Reeves : Connect FPO to Residential Project
    When FPO is created, try to link it to a Res Project through Quote
    Used in LeasePayment Before Insert
    */
    public static void connectFPOtoRP(Map<Id, LeasePayment__c> quoteMap ){
        for(Residential_Project__c rp : [SELECT Id, Quote__c FROM Residential_Project__c WHERE Quote__c IN: quoteMap.keyset() ORDER BY CreatedDate DESC ]){
            LeasePayment__c lp = quoteMap.get(rp.Quote__c);
            if(lp.Residential_Project__c == NULL) lp.Residential_Project__c = rp.Id;
        }
    }

    /*
    30-Jan-2017 : Sita Reeves : Connect FPO to Residential Project on Project Quote change
    When Quote is updated on the Project, clear out FPO links and reassign
    Used in Residential Project After Update
    Map =  Quote Id, Project Id
    */
    public static void updateFPOtoRP(Map<Id, Id> quoteMap ){
        Map<Id, LeasePayment__c> leaseUpdate = new Map<Id, LeasePayment__c>();
        for(LeasePayment__c lp : [SELECT Id, Residential_Project__c, Quote__c FROM LeasePayment__c WHERE Residential_Project__c IN: quoteMap.values() OR Quote__c IN: quoteMap.keyset()]){
            if(lp.Quote__c != null && quoteMap.containsKey(lp.Quote__c)) {
                lp.Residential_Project__c = quoteMap.get(lp.Quote__c);
            }
            else {
                lp.Residential_Project__c = NULL;
            }
            leaseUpdate.put(lp.Id, lp);
        }
        update leaseUpdate.values();
    }

    // called from fpo after insert & after update if the fpo has a payment date interconnect
	public static void sendLienWaiver(Set<Id> quoteIds) {
		try {
			if(System.isFuture()) {
				sendLienWaiverNonFuture(quoteIds);
			} else sendLienWaiverFuture(quoteIds);
		}
		catch(Exception e) {
			ExLog.log(e);
		}
	}

	@future
	private static void sendLienWaiverFuture(Set<Id> quoteIds) {
		sendLienWaiverSet(quoteIds);
	}

	private static void sendLienWaiverNonFuture(Set<Id> quoteIds) {
		sendLienWaiverSet(quoteIds);
	}

	private static void sendLienWaiverSet(Set<Id> quoteIds) {
		List<Quote> quotes = new List<Quote>();
		for(Quote q : [SELECT Id, Send_Lien_Waiver_Agreement__c, Trigger_Checkbox__c FROM Quote WHERE Id IN :quoteIds]) {
			Quote uq = new Quote();
			uq.Id = q.Id;
			uq.Trigger_Checkbox__c = true;
			uq.Send_Lien_Waiver_Agreement__c = true;
			quotes.add(uq);
		}
		if(!quotes.isEmpty()) update quotes;
	}

	// called from fpo before insert & before update to set the email addresses - map is quote Id/fpo
	public static void setLPemailAddresses(Map<Id, LeasePayment__c> quoteIdLP) {
		Map<Id, Quote> quotes = new Map<Id, Quote>([SELECT Id, Lessee__r.Email, Oracle_Vendor_Email__c FROM Quote WHERE Id IN :quoteIdLP.keySet()]);
		for(LeasePayment__c lp : quoteIdLP.values()) {
			Quote q = quotes.get(lp.Quote__c);
			lp.Partner_Oracle_Vendor_Email__c = q.Oracle_Vendor_Email__c;
			lp.Lessee_Email__c = q.Lessee__r.Email;
		}
	}

	// called from the fpo after update to set opportunity stage for placed in service
	@future
	public static void updateOppStage(Set<Id> oppIds) {
		try {
			List<Opportunity> oppList = new List<Opportunity>();

			for(Opportunity o : [SELECT Id FROM Opportunity WHERE Id IN :oppIds AND Lease_Placed_in_Service__c = false]) {
				Opportunity opp = new Opportunity();
				opp.Id = o.Id;
				opp.Lease_Placed_in_Service__c = true;
				opp.StageName = 'Installation Completed';
				oppList.add(opp);
			}
			if(!oppList.isEmpty()) update oppList;
		}
		catch(Exception e) {
			ExLog.log(e);
		}
	}

	// called by the fpo after insert & after update to link icd's to them
	public static void linkICDs(Map<Id, Id> quoteIdFPOId) {
		try {
			// check system future
			if(System.isFuture()) {
				linkICDsNonFuture(quoteIdFPOId);
			} else linkICDsFuture(quoteIdFPOId);
		}
		catch(Exception e) {
			ExLog.log(e);
		}
	}

	@future
	private static void linkICDsFuture(Map<Id, Id> quoteIdFPOId) {
		linkICDMap(quoteIdFPOId);
	}

	private static void linkICDsNonFuture(Map<Id, Id> quoteIdFPOId) {
		linkICDMap(quoteIdFPOId);
	}

	private static void linkICDMap(Map<Id, Id> quoteIdFPOId) {
		// map for ids
		Map<Id, Id> rpIdFPOId = new Map<Id, Id>();
		// get the rp id for fpos
		for(Residential_Project__c rp : [SELECT Id, Quote__c FROM Residential_Project__c WHERE Quote__c IN :quoteIdFPOId.keySet()]) {
			rpIdFPOId.put(rp.Id, quoteIdFPOId.get(rp.Quote__c));
		}

		if(!rpIdFPOId.isEmpty()) {
			List<Invoice_Compliance_Document__c> icdList = new List<Invoice_Compliance_Document__c>();
			// get the icds
			for(Invoice_Compliance_Document__c i : [SELECT Id, Residential_Project__c, Financial_Payment__c FROM Invoice_Compliance_Document__c WHERE Residential_Project__c IN :rpIdFPOId.keySet()]) {
				// new icd and add to list
				Invoice_Compliance_Document__c icd = new Invoice_Compliance_Document__c();
				icd.Id = i.Id;
				icd.Financial_Payment__c = rpIdFPOId.get(i.Residential_Project__c);
				icdList.add(icd);
			}
			// update icd list w/new fpo ids
			if(!icdList.isEmpty()) update icdList;

			// update project docs w/new fpo
			linkProjectDocs(rpIdFPOId);
		}
	}

	private static void linkProjectDocs(Map<Id, Id> rpIdFPOId) {
		List<Document__c> pdocs = new List<Document__c>();
		// get the docs
		for(Document__c pd : [SELECT Id, Financial_Payment__c, Residential_Project__c FROM Document__c WHERE Residential_Project__c IN :rpIdFPOId.keySet()]) {
			Document__c d = new Document__c();
			d.Id = pd.Id;
			d.Financial_Payment__c = rpIdFPOId.get(pd.Residential_Project__c);
			pdocs.add(d);
		}
		if(!pdocs.isEmpty()) update pdocs;
	}

	// called by the fpo after update to null co brand value on account
	@future
	public static void nullCoBranding(Set<Id> accountIds) {
		try {
			List<Account> accounts = new List<Account>();
			for(Account acc : [SELECT Id, CO_BRAND_Partner__c FROM Account WHERE Id IN :accountIds AND CO_BRAND_Partner__c != null AND CO_BRAND_Partner__c != '']) {
				Account a = new Account();
				a.Id = acc.Id;
				a.CO_BRAND_Partner__c = null;
				accounts.add(a);
			}
			if(!accounts.isEmpty()) update accounts;
		}
		catch(Exception e) {
			ExLog.log(e);
		}
	}
}