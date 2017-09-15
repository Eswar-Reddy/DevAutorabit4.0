/**
VERSION HISTORY:

version: KCM_01052016.0201h
author: Kane Macaspac
last date modified: 1/7/2016

details:
- for Case 00623442; added "Dealer Change" Lease Status in the query so that leases with such status 
  would appear in the Lease Timeline
- use the version name/number above as search term to quickly jump to the line/s modified as part of this version.
**/

public with sharing class PartnerTimelineController {

    public static final String BASE_URL = URL.getSalesforceBaseUrl().toExternalForm() + '/servlet/servlet.FileDownload?file=';
    public String selectedStage {get; set;}
    public String contractTypeParam{get;set;}//cdevarapalli Loan Timeline
    public String selectedPages {get; set;} //Case 00746631: Smart Energy - Lease Timeline
    public Integer totalNumberOfLease {get; set;} //Case 00746631: Smart Energy - Lease Timeline
    public String filterLeasename {get; set;} //Case 00746631: Smart Energy - Lease Timeline
    
    public Boolean isStageSelected {
        get {
            return String.isNotBlank(selectedStage);
        }
    }

    private static final Map<String, String> isoCodeToSymbol = new Map<String, String>
    {
        'AUD' => '$',
        'CAD' => '$',
        'EUR' => '€',
        'GBP' => '£',
        'INR' => '₹',
        'JPY' => '¥',
        'KRW' => '₩',
        'USD' => '$',
        'ZAR' => 'R'
    };

    public String currencySymbol {
        get {
            if(currencySymbol == null)
            {
                currencySymbol = isoCodeToSymbol.get(UserInfo.getDefaultCurrency());
            }
            return currencySymbol;
        }
        private set;
    }

    public String negativeClass {
        get {
            if( showGreenLegend ) {
                return 'green-negative';
            } else {
                return 'negative';
            }
        }
        private set;
    }

    public Boolean showRedLegend {
        get {
            if( showRedLegend == null ) {
                showRedLegend = assignLegend(TimelineServices.partnerAccount.BillingCountry, 'Show_Red_Legend__c');
            }
            return showRedLegend;
        }
        private set;
    }
    public Boolean showYellowLegend {
        get {
            if( showYellowLegend == null ) {
                showYellowLegend = assignLegend(TimelineServices.partnerAccount.BillingCountry, 'Show_Yellow_Legend__c');
            }
            return showYellowLegend;
        }
        private set;
    }
    public Boolean showGreenLegend {
        get {
            if( showGreenLegend == null ) {
                showGreenLegend = assignLegend(TimelineServices.partnerAccount.BillingCountry, 'Show_Green_Legend__c');
            }
            return showGreenLegend;
        }
        private set;
    }

    private Boolean assignLegend(String country, String legendField) {
        Boolean toReturn = false;
        Country_To_Lease_Stage__c customSetting = Country_To_Lease_Stage__c.getInstance(country);

        if(customSetting != null) {
            toReturn = (Boolean)customSetting.get(legendField);
        }

        return toReturn;
    }
    public String redLegendCustomLabel {
        get {
            String retVal = 'Partner_Timeline_SLA_Legend_Red_Default';    // default
            if (leaseStageCustomSettingMap != null && leaseStageCustomSettingMap.containsKey(selectedStage)) {
                Lease_Stage_Ordering__c setting = leaseStageCustomSettingMap.get(selectedStage);
                if (setting != null && setting.SLA_Legend_Red_Custom_Label__c != null) {
                    
                    retVal = setting.SLA_Legend_Red_Custom_Label__c;    
                }    
            }            
            return retVal;
        }
        private set;
    }
    public String yellowLegendCustomLabel {
        get {
            String retVal = 'Partner_Timeline_SLA_Legend_Yellow_Default';    // default
            if (leaseStageCustomSettingMap != null && leaseStageCustomSettingMap.containsKey(selectedStage)) {
                Lease_Stage_Ordering__c setting = leaseStageCustomSettingMap.get(selectedStage);
                if (setting != null && setting.SLA_Legend_Yellow_Custom_Label__c != null) {
                    
                    retVal = setting.SLA_Legend_Yellow_Custom_Label__c;    
                }    
            }            
            return retVal;
        }
        private set;
    }
    public String greenLegendCustomLabel {
        get {
            String retVal = 'Partner_Timeline_SLA_Legend_Green_Default';    // default
            if (leaseStageCustomSettingMap != null && leaseStageCustomSettingMap.containsKey(selectedStage)) {
                Lease_Stage_Ordering__c setting = leaseStageCustomSettingMap.get(selectedStage);
                if (setting != null && setting.SLA_Legend_Green_Custom_Label__c != null) {
                    
                    retVal = setting.SLA_Legend_Green_Custom_Label__c;    
                }    
            }            
            return retVal;
        }
        private set;
    }
    
    public enum SLA{RED, YELLOW, GREEN, NONE}

    public void assignCellToShow() {}

    public String ANALYTICS_ID {
        get {
            if (ANALYTICS_ID == null) {
                ANALYTICS_ID = Analytics_Profile_Id__c.getInstance().Lease_Timeline_Id__c;
            }
            return ANALYTICS_ID;
        }
        private set;
    }

    @TestVisible private String leaseStageField {
        get {
            if( leaseStageField == null ) {
                Country_To_Lease_Stage__c customSetting = Country_To_Lease_Stage__c.getInstance(TimelineServices.partnerAccount.BillingCountry);
                if(customSetting != null) {
                    leaseStageField = customSetting.Lease_Stage_API_Name__c;
                }
            }
            return leaseStageField;
        }
        set;
    }

    private List<Lease_Stage_Ordering__c> leaseStageCustomSettings {
        get {
            if(leaseStageCustomSettings == null) {
                String partnerBillingCountry = TimelineServices.partnerAccount.BillingCountry;
                //cdevarapalli Loan Timeline
                /*
                leaseStageCustomSettings = [
                    SELECT Id, Lease_Stage__c, Stage_Description__c, Stage_Description_2__c, Agreement_RecordType__c,
                            Default_View__c, SLA_field_API_Name__c, Show_Agreement__c, Show_Send_Reminder__c, FieldSet_Name__c,
                            SLA_Legend_Green_Custom_Label__c, SLA_Legend_Red_Custom_Label__c, SLA_Legend_Yellow_Custom_Label__c
                    FROM Lease_Stage_Ordering__c
                    WHERE Country__c = :TimelineServices.partnerAccount.BillingCountry
                    ORDER BY Order__c
                ];*/
                String query = 'SELECT Id, Lease_Stage__c, Stage_Description__c, Stage_Description_2__c, Agreement_RecordType__c,Agreement_RecordType_Loan__c,Default_View__c, SLA_field_API_Name__c, Show_Agreement__c, Show_Send_Reminder__c, FieldSet_Name__c,SLA_Legend_Green_Custom_Label__c, SLA_Legend_Red_Custom_Label__c, SLA_Legend_Yellow_Custom_Label__c ';
                query += 'FROM Lease_Stage_Ordering__c ';
                query += 'WHERE Country__c = :partnerBillingCountry ';
                if(contractTypeParam == 'Loan'){
                    query += 'AND Not_Available_for_Loan__c = false '; 
                }
                query += 'ORDER BY Order__c';
                leaseStageCustomSettings = Database.query(query);               
            }
            return leaseStageCustomSettings;
        }
        set;
    }

    private List<String> orderedLeaseStages {
        get {
            if(orderedLeaseStages == null) {
                orderedLeaseStages = new List<String>();
                for(Lease_Stage_Ordering__c leaseCustomSetting : leaseStageCustomSettings) {
                    orderedLeaseStages.add(leaseCustomSetting.Lease_Stage__c);
                }
            }
            return orderedLeaseStages;
        }
         set;
    }

    private Set<String> stagesToShowAgreement {
        get {
            if(stagesToShowAgreement == null) {
                stagesToShowAgreement = getStagesToShow('Show_Agreement__c');
            }
            return stagesToShowAgreement;
        }
        set;
    }

    private Set<String> stagesToShowSendReminder {
        get {
            if(stagesToShowSendReminder == null) {
                stagesToShowSendReminder = getStagesToShow('Show_Send_Reminder__c');
            }
            return stagesToShowSendReminder;
        }
        set;
    }

    @TestVisible
    private Set<String> getStagesToShow(String field) {
        Set<String> stagesToShow = new Set<String>();
        for(Lease_Stage_Ordering__c customSetting : leaseStageCustomSettings) {
            if( (Boolean) customSetting.get(field)) {
                stagesToShow.add(customSetting.Lease_Stage__c);
            }
        }
        return stagesToShow;
    }

    public Map<String, Lease_Stage_Ordering__c> leaseStageCustomSettingMap {
        get {
            if(leaseStageCustomSettingMap == null) {
                leaseStageCustomSettingMap = new Map<String,Lease_Stage_Ordering__c>();
                for(Lease_Stage_Ordering__c leaseCustomSetting : leaseStageCustomSettings) {
                    leaseStageCustomSettingMap.put(leaseCustomSetting.Lease_Stage__c, leaseCustomSetting);
                }
            }
            //system.debug('leaseStageCustomSettingMap '+leaseStageCustomSettingMap);
            return leaseStageCustomSettingMap;
        }
        set;
    }

    public String jsonData {
        get {
            return TimelineChartData.getJSON(orderedLeaseStages, leaseStageToStageColumn);
        }
        private set;
    }

    private Set<String> getLeasePaymentFields() {
        Set<String> slaFields = Pluck.strings('SLA_field_API_Name__c', leaseStageCustomSettingMap.values());

        Set<String> leaseFields = new Set<String>{'Id', 'Partner_Account__c', 'End_Customer_Account__c', 'CurrencyIsoCode', leaseStageField};
        
        
        leaseFields.addAll(slaFields);
        List<String> fieldSetNames = new List<String>(Pluck.strings('FieldSet_Name__c', leaseStageCustomSettingMap.values()));

        for(String fieldSetName : fieldSetNames) {

            Schema.FieldSet fieldSet = SObjectType.LeasePayment__c.FieldSets.getMap().get(fieldSetName);
            List<Schema.FieldSetMember> fieldSetMembers = new List<Schema.FieldSetMember>();

            if(fieldSet != null) {
                fieldSetMembers = fieldSet.getFields();
            }

            for(Schema.FieldSetMember fieldSetMember : fieldSetMembers) {
                system.debug('field set member: '+fieldSetMember);
                leaseFields.add(fieldSetMember.getFieldPath());
            }
        }
        return leaseFields;
    }

    public Map<String, StageColumn> buildColumns(List<LeasePayment__c> leasePayments) {
        Map<String, StageColumn> stageToColumn = new Map<String, StageColumn>();
        for(String leaseStage : orderedLeaseStages) {
            StageColumn stageColumn = new StageColumn(leaseStage);
            stageColumn.showAgreement = stagesToShowAgreement.contains(leaseStage);
            stageColumn.showSendReminder = stagesToShowSendReminder.contains(leaseStage);
            stageColumn.isDefault = leaseStageCustomSettingMap.get(leaseStage).Default_View__c;
            stageColumn.agreementRecordType = leaseStageCustomSettingMap.get(leaseStage).Agreement_RecordType__c;
            if(contractTypeParam == 'Loan'){
                stageColumn.agreementRecordType = leaseStageCustomSettingMap.get(leaseStage).Agreement_RecordType_Loan__c;
            }
            stageColumn.fieldSetName = leaseStageCustomSettingMap.get(leaseStage).FieldSet_Name__c;
            stageToColumn.put(leaseStage, stageColumn);
        }

        Set<Id> accountIds = Pluck.ids('End_Customer_Account__c', leasePayments);
        Set<String> agreementRecordTypes = Pluck.strings('Agreement_RecordType__c', leaseStageCustomSettingMap.values());
        if(contractTypeParam == 'Loan'){
            agreementRecordTypes = Pluck.strings('Agreement_RecordType_Loan__c', leaseStageCustomSettingMap.values());
        }
        Map<String, echosign_dev1__SIGN_Agreement__c> accountIdToAgreement = TimelineServices.getAccountIdToAgreement(accountIds, agreementRecordTypes);
        System.debug('accountIdToAgreement----->'+accountIdToAgreement);
        for(LeasePayment__c leasePayment : leasePayments) {
            StageColumn columnToEdit = stageToColumn.get((String)leasePayment.get(leaseStageField));

            if(columnToEdit.showAgreement || columnToEdit.showSendReminder)
            {
                echosign_dev1__SIGN_Agreement__c agreement =  new echosign_dev1__SIGN_Agreement__c();
                Attachment attachment =  new Attachment();

                String key = TimelineServices.buildAccountAgreementKey(leasePayment.End_Customer_Account__c, columnToEdit.agreementRecordType);
                if(accountIdToAgreement.containsKey(key)) {
                    agreement = accountIdToAgreement.get(key);

                    if(agreement != null && !agreement.Attachments.isEmpty()) {
                        attachment = agreement.Attachments[0];
                    }

                }
                columnToEdit.leaseIdToSignature.put(leasePayment.Id, new SignatureModel(attachment, agreement));
            }
            String slaField = leaseStageCustomSettingMap.get((String)leasePayment.get(leaseStageField)).SLA_field_API_Name__c;
            assignSLA(columnToEdit, leasePayment, slaField);
        }

        return stageToColumn;
    }

    public void assignSLA(StageColumn column, LeasePayment__c leasePayment, String slaField) {

        SLA leaseSLA = getSLAValue(leasePayment, slafield);
        if(leaseSLA == SLA.RED){
            column.redSLA.add(leasePayment);
        } else if(leaseSLA == SLA.YELLOW) {
            column.yellowSLA.add(leasePayment);
        } else if(leaseSLA == SLA.GREEN){
            column.greenSLA.add(leasePayment);
        } else {
            column.noSLA.add(leasePayment);
        }

    }

    public SLA getSLAValue(LeasePayment__c leasePayment, String slaField) {
        SLA slaToReturn;

        String slaHtml;
        if(String.isNotBlank(slaField)) {
            slaHtml = (String) leasePayment.get(slaField);
        }

        if(String.isBlank(slaHTML)){
            slaToReturn = SLA.NONE;

        } else {
            String altTag = slaHtml.split(' ')[2].toLowerCase();
            if(altTag.contains('red')) {
                slaToReturn = SLA.RED;
            } else if(altTag.contains('yellow')) {
                slaToReturn = SLA.YELLOW;
            } else if(altTag.contains('green')){
                slaToReturn = SLA.GREEN;
            } else{
                slaToReturn = SLA.NONE;
            }
        }

        return slaToReturn;
    }

    transient Map<String, StageColumn> leaseStageToStageColumn;

    public Map<String, StageColumn> getLeaseStageToStageColumn() {
        if(leaseStageToStageColumn == null) {
            leaseStageToStageColumn = buildLeaseStageToStageColumn();
        }
        return leaseStageToStageColumn;
    }
    
    //Case 00746631: Smart Energy - Lease Timeline
    //start
    public void assignLeaseName() {}
    
    public PageReference leaseStage_Beginning() { 
      leaseStage_counter = 0;
      return null;
    }
    
    public PageReference leaseStage_Previous() { 
      leaseStage_counter -= leaseStage_list_size;
      return null;
    }
    
    public PageReference leaseStage_Next() { 
      leaseStage_counter += leaseStage_list_size;
      return null;
    }
    
    public PageReference leaseStage_End() { 
      leaseStage_counter = leaseStage_total_size - math.mod(leaseStage_total_size, leaseStage_list_size);
      return null;
    }
    
    public Boolean getleaseStage_DisablePrevious() { 
      if (leaseStage_counter>0) return false; else return true;
    }
    
    public Boolean getleaseStage_DisableNext() { 
      if (leaseStage_counter + leaseStage_list_size < leaseStage_total_size) return false; else return true;
    }
    
    public Integer getleaseStage_Total_size() {
      return leaseStage_total_size;
    }
    
    public Integer leaseStage_counter=0; 
    public Integer leaseStage_list_size=200; 
    public Integer leaseStage_total_size=0;
    
    public String oldStageSelected='';
    public String newStageSelected='';
    
    transient Map<String, StageColumn> leaseStageColumns;
    
    public Map<String, StageColumn> getLeaseStageColumns(){  
        String stage = selectedStage;                    
        Integer index = 0;
        
        if(!oldStageSelected.equals(selectedStage)){
            leaseStage_counter=0; 
            leaseStage_total_size=0;
            oldStageSelected=selectedStage;
        }
        
        Map<String, StageColumn> init = new Map<String, StageColumn>();
        Map<Integer, LeasePayment__c> filtered;
        List<LeasePayment__c> leasePaymentsFromStageColumn = new List<LeasePayment__c>();
        List<LeasePayment__c> leasePayments = new List<LeasePayment__c>();
             
        init = buildLeaseStageToStageColumn();
        
        //System.Debug('leaseStageToStageColumn size-----> ' + init.size());
        //get all lease payments from StageColumns
        for(StageColumn s: init.values()){            
            if(s.leaseStage==stage){
                for(LeasePayment__c l :s.redSLA){
                    leasePaymentsFromStageColumn.add(l);
                }
                for(LeasePayment__c l :s.yellowSLA){
                    leasePaymentsFromStageColumn.add(l);
                }
                for(LeasePayment__c l :s.greenSLA){
                    leasePaymentsFromStageColumn.add(l);
                }
                for(LeasePayment__c l :s.noSLA){
                    leasePaymentsFromStageColumn.add(l);
                }                
            }
        }       
        
        //assign row number
        filtered = new Map<Integer, LeasePayment__c>(); 
        for(LeasePayment__c l: leasePaymentsFromStageColumn ){
            //filter by name                 
            if(!String.isBlank(filterLeasename) && l.Name.startsWith(filterLeasename) ){
                filtered.put(index, l);
                index+=1;
            }else if(String.isBlank(filterLeasename)){
                filtered.put(index, l);
                index+=1;
            }
        }
        
        leaseStage_total_size = filtered.size();
        leaseStageColumns = new Map<String, StageColumn>();
        
        //System.Debug('leaseStage_counter-----> ' + leaseStage_counter);  
        //System.Debug('total_size-----> ' + leaseStage_total_size );
        //System.Debug('Stage -----> ' + stage ); 
        
        Integer list_size = leaseStage_list_size;
        if(leaseStage_list_size>leaseStage_total_size){
            list_size = leaseStage_total_size;
        }
        Integer max_list_size = leaseStage_counter+list_size;
        if(max_list_size>leaseStage_total_size){
            max_list_size = leaseStage_total_size;
        }
        //page range
        totalNumberOfLease = leaseStage_total_size;
        selectedPages = 'Page: '+ ((leaseStage_counter/leaseStage_list_size)+1) + ' (' + (leaseStage_counter + 1) + '-' + max_list_size + ')';
        
        //do pagination
        leasePayments = new List<LeasePayment__c>();
        for(integer i=leaseStage_counter ; i<=max_list_size-1 ; i++){                         
            leasePayments.add(filtered.get(i));
        }
        return buildColumns(leasePayments);
    }
    //Case 00746631: Smart Energy - Lease Timeline
    //end

    public Map<String, StageColumn> buildLeaseStageToStageColumn() {

        Id partnerAccountId = TimelineServices.partnerAccountId;
        String leasePaymentFields = String.join(new List<String>(getLeasePaymentFields()), ', ');
        system.debug('leasePaymentFields '+leasePaymentFields);

        String query = '';
        query += 'SELECT ' + leasePaymentFields + ' ';
        query += 'FROM LeasePayment__c ';
        query += 'WHERE Partner_Account__c = :partnerAccountId ';
        query += 'AND ' + leaseStageField + ' IN :orderedLeaseStages ';
        
        if(contractTypeParam == null || contractTypeParam == 'Lease')
        {   
            query += 'AND RecordType.Name != \'Loan\' ';
        }
        else{
           query += 'AND RecordType.Name = :contractTypeParam ';
        }
        
        
        
        //KCM_01052016.0201h: for Case 00623442; added Dealer Change Lease Status so that it would appear in the Lease Timeline
        //query += 'AND (Status__c = \'' + TimelineServices.ACTIVE_STATUS + '\' OR Status__c = NULL) ';
        query += 'AND (Status__c = \'' + TimelineServices.ACTIVE_STATUS + '\' OR Status__c = NULL OR Status__c = \'Dealer Change\') ';
        
        query += 'ORDER BY Name';
        List<LeasePayment__c> leasePayments = Database.query(query);

        return buildColumns(leasePayments);
    }

    private static String formatStageNameToFieldsetName(String stage) {
        String key = TimelineServices.partnerAccount.BillingCountry + '_' + stage;
        return key.toLowerCase().replace(' ', '_').left(40);
    }

    private String getDefaultStage() {
        String stageToReturn;
        for(Lease_Stage_Ordering__c leaseCustomSetting : leaseStageCustomSettings) {
            if(leaseCustomSetting.Default_View__c) {
                stageToReturn = leaseCustomSetting.Lease_Stage__c;
                break;
            }
        }
        return stageToReturn;
    }

    public PartnerTimelineController(){
        contractTypeParam=ApexPages.currentPage().getParameters().get('contractType');//cdevarapalli Loan Timeline
        leaseStageToStageColumn = buildLeaseStageToStageColumn();
        selectedStage = getDefaultStage();
    }

    public class SignatureModel {
        public Attachment attachment {get; set;}
        public echosign_dev1__SIGN_Agreement__c agreement {get; set;}

        public Boolean hasAgreement{
            get {
                if(hasAgreement == null){
                    hasAgreement = String.isNotBlank(agreement.echosign_dev1__Document__c);
                }
                return hasAgreement;
            }
            private set;
        }

        public String echosignUrl {
            get {
                String url = '';
                if(hasAgreement) {
                    String urlTemplate = 'https://secure.echosignforsalesforce.com/salesforce/nudgeAgreement?namespace=echosign_dev1&Agreement_ID={0}&Version=8&Status={1}&LastEventId={2}&session={3}';
                    url = String.format(urlTemplate, new List<String>{agreement.Id, agreement.echosign_dev1__Status__c, agreement.echosign_dev1__LastEventId__c, UserInfo.getSessionId()});
                }
                return url;
            }
            private set;
        }

        public Boolean hasAttachment {
            get {
                if(hasAttachment == null){
                    hasAttachment = (!hasAgreement && attachment != null && attachment.Id != null);
                }
                return hasAttachment;
            }
            private set;
        }

        public SignatureModel(Attachment attachment, echosign_dev1__SIGN_Agreement__c agreement) {
            this.attachment = attachment;
            this.agreement = agreement;
        }

    }

    public class StageColumn {

        public String leaseStage;
        public Map<Id, SignatureModel> leaseIdToSignature {get; set;}
        public Boolean showAgreement {get; set;}
        public Boolean showSendReminder {get; set;}
        public Boolean isDefault;
        public String agreementRecordType;
        public String fieldSetName;

        public List<LeasePayment__c> redSLA;
        public List<LeasePayment__c> yellowSLA;
        public List<LeasePayment__c> greenSLA;
        public List<LeasePayment__c> noSLA;

        public Boolean isPopulated {
            get {
                if(isPopulated == null) {
                    isPopulated = !leasePayments.isEmpty();
                }
                return isPopulated;
            }
            private set;
        }

        public List<Schema.FieldSetMember> leaseFields {
            get {
                if(leaseFields == null) {

                    Schema.FieldSet fieldSet = SObjectType.LeasePayment__c.FieldSets.getMap().get(fieldSetName);
                    if(fieldSet != null) {
                        leaseFields = fieldSet.getFields();
                    } else {
                        leaseFields = new List<Schema.FieldSetMember>();
                    }
                }
                return leaseFields;
            }
            private set;
        }

        public List<LeasePayment__c> leasePayments {
            get {
                if (leasePayments == null) {
                    leasePayments = new List<LeasePayment__c>();
                    leasePayments.addAll(redSLA);
                    leasePayments.addAll(yellowSLA);
                    leasePayments.addAll(greenSLA);
                    leasePayments.addAll(noSLA);
                }
                return leasePayments;
            }
            private set;
        }


        public StageColumn(String leaseStage) {
            this.leaseStage = leaseStage;
            isDefault = false;
            agreementRecordType = '';
            fieldSetName = '';

            redSLA = new List<LeasePayment__c>();
            yellowSLA = new List<LeasePayment__c>();
            greenSLA = new List<LeasePayment__c>();
            noSLA = new List<LeasePayment__c>();

            leaseIdToSignature = new Map<Id, SignatureModel>();
        }

    }

}