public class GenabilityUsageController {
    
    public Account acc{get;set;}
    public String electricratecurrentselected  {get;set;}
    public String electricrateproposedselected {get;set;}
    public Electric_Rate_Usage_Input__c ElectricUsage {get;set;}
    public boolean ratesEdited{get;set;}
    private Map<String,String> optionvalueLabelNameMap = new Map<String,String>();
    public String billType{get;set;}
    public Decimal billAmount{get;set;}
    public String usage{get;set;}
    private List<SelectOption> currentOptionsRetreived = new List<SelectOption>();
    private List<SelectOption> proposedOptionsRetreived = new List<SelectOption>();
    private Map<String, GenabilityTariffJSON.Tariff> genabilityTariffMap = new Map<String, GenabilityTariffJSON.Tariff>();
    public Boolean IsPartner {get;set;}
    
    //Constructor
    public GenabilityUsageController(ApexPages.StandardController controller) {
        acc=(Account)controller.getRecord();
        acc = [ SELECT
                Id,
                Name,
                BillingCity,
                BillingCountry,
                BillingPostalCode,
                BillingState,
                BillingStreet,
                Genability_Account_Id__c
        FROM Account
        WHERE id=:acc.Id];
        ElectricUsage = new Electric_Rate_Usage_Input__c();
    }
    
    public List<selectoption> getElectricUsageRate(){
        List<SelectOption> options = new List<SelectOption>();
        options.addAll(currentOptionsRetreived);
        System.debug('options size----->'+options.size());
        if(ElectricUsage.Current_Rate__c != null && ElectricUsage.Current_rate_code__c != null){
            if(optionvalueLabelNameMap == null || !optionvalueLabelNameMap.containsKey(ElectricUsage.Current_Rate__c))
                options.add(new SelectOption(ElectricUsage.Current_Rate__c, ElectricUsage.Current_rate_code__c));
        }
        return options;
    }
    
    public List<selectoption> getElectricPropsedRate(){
        List<SelectOption> options_prop = new List<SelectOption>();
        options_prop.addall(proposedOptionsRetreived);
        System.debug('optionvalueLabelNameMap----->'+optionvalueLabelNameMap);
        if(ElectricUsage.Proposed_rate__c != null && ElectricUsage.Proposed_rate_code__c != null){
            if(optionvalueLabelNameMap == null || !optionvalueLabelNameMap.containsKey(ElectricUsage.Proposed_rate__c))
                options_prop.add(new SelectOption(ElectricUsage.Proposed_rate__c, ElectricUsage.Proposed_rate_code__c));
        }
        System.debug('options---getElectricPropsedRate-->'+options_prop);
        return options_prop;
    }

    public void editRates(){
        ratesEdited = true;
        getTariffs();
    }

    // Get Tarrifs for this Accounts zip code
    public void getTariffs(){
        GenabilityAPICallHandler.GenabilityTariff gagt = GenabilityAPICallHandler.GetTariffsforaZipCode(acc, 'Residential', true);
        System.debug('GenabilityAPICallHandler.GenabilityTariff----->'+gagt);
        if(gagt.errorMessage==null && gagt.genResp!=null){

            currentOptionsRetreived.clear();
            proposedOptionsRetreived.clear();

            Map<String,String> optionValueoptionLabelMap = new Map<String,String>();

            System.debug('gagt.genResp.results size ----->'+gagt.genResp.results.size());

            List<SelectOption> tempOptionsRetreived = new List<SelectOption>();

            for(GenabilityTariffJSON.Tariff gtt : gagt.genResp.results) {
                genabilityTariffMap.put(String.valueOf(gtt.masterTariffId), gtt);
                /*tempOptionsRetreived.add(new SelectOption(String.valueOf(gtt.masterTariffId), gtt.lseName + '__' + gtt.tariffName + '__' + gtt.tariffCode));*/
                optionvalueLabelNameMap.put(String.valueOf(gtt.masterTariffId), gtt.lseName + '__' + gtt.tariffName + '__' + gtt.tariffCode);

                boolean bsolarPVEligibleTrue = false;
                boolean bsolarPVEligibleFalse = false;
                if (gtt.Properties != null && !gtt.Properties.isEmpty()) {
                    for (GenabilityTariffJSON.TariffProperty gttTP : gtt.properties) {
                        if (gttTP.keyName == 'solarPvEligible' && gttTP.propertyValue == 'true') {
                            bsolarPVEligibleTrue = true;
                            break;
                        } else if (gttTP.keyName == 'solarPvEligible' && gttTP.propertyValue == 'false') {
                            bsolarPVEligibleFalse = true;
                            break;
                        }
                    }
                }
                System.debug('bsolarPvEligibleTrue ----->' + bsolarPvEligibleTrue);
                System.debug('bsolarPVEligibleFalse ----->' + bsolarPVEligibleFalse);
                //if(bsolarPVEligibleFalse|| (!bsolarPVEligibleTrue && !bsolarPVEligibleFalse)){
                    currentOptionsRetreived.add(new SelectOption(String.valueOf(gtt.masterTariffId), gtt.lseName + '__' + gtt.tariffName + '__' + gtt.tariffCode));
                //}
                if(bsolarPVEligibleTrue|| (!bsolarPVEligibleTrue && !bsolarPVEligibleFalse)){
                    proposedOptionsRetreived.add(new SelectOption(String.valueOf(gtt.masterTariffId), gtt.lseName + '__' + gtt.tariffName +'__' + gtt.tariffCode));
                }

            }/*
            if(currentOptionsRetreived.isEmpty()){
                currentOptionsRetreived.addAll(tempOptionsRetreived);
            }
            if(proposedOptionsRetreived.isEmpty()){
                proposedOptionsRetreived.addAll(tempOptionsRetreived);
            }*/

            System.debug('currentOptionsRetreived size ----->' + currentOptionsRetreived.size());
            System.debug('proposedOptionsRetreived size ----->' + proposedOptionsRetreived.size());
            System.debug('optionValueoptionLabelMap ----->'+optionvalueLabelNameMap);
            gagt = null;
        }
        else if(gagt.errorMessage!=null)
            addPageMessage(gagt.errorMessage);
    }

    //Set MasterTariff property on Genability for this account
    public boolean setTariffonGenabilityAccount(){
        boolean success = false;
        GenabilityAPICallHandler.GenabilityProperty gagp = GenabilityAPICallHandler.SetProperty(acc,'masterTariffId',electricratecurrentselected,100);
        System.debug('GenabilityAPICallHandler.GenabilityProperty----->'+gagp);
        if(gagp.errorMessage==null){
            success = true;
        }
        else{
            addPageMessage(gagp.errorMessage);
        }
        return success;
    }

    public void saveEU(){

        if(usage == 'BILL' && billAmount <= 0.0){
            addPageMessage('Please input a valid Usage');
            return;
        }

        if(ratesEdited){

            ElectricUsage.Current_Rate__c = electricratecurrentselected;
            ElectricUsage.Proposed_rate__c = electricrateproposedselected;
            if(electricratecurrentselected != null && optionvalueLabelNameMap.containsKey(electricratecurrentselected)){
                ElectricUsage.Current_rate_code__c = optionvalueLabelNameMap.get(electricratecurrentselected);
                ElectricUsage.Utility_Description__c = genabilityTariffMap.get(electricratecurrentselected).lseName;
                ElectricUsage.Utility_Id__c = String.valueOf(genabilityTariffMap.get(electricratecurrentselected).lseId);
            }

            if(electricrateproposedselected != null && optionvalueLabelNameMap.containsKey(electricrateproposedselected))
                ElectricUsage.Proposed_rate_code__c = optionvalueLabelNameMap.get(electricrateproposedselected);

            if(!setTariffonGenabilityAccount())
                return;
        }

        try{
            ElectricUsage.Usage__c = usage;
            if(usage == 'BILL'){
                Double totalBill = 0.0;
                if(billType=='monthlyAverage'){
                    totalBill = billAmount * 12;
                    ElectricUsage.Monthly_bill__c = billAmount;
                }
                else if(billType=='totalYearly'){
                    totalBill = billAmount;
                    ElectricUsage.Monthly_bill__c = 0.0;
                }
                ElectricUsage.Annual_Bill__c = totalBill;
                GenabilityAPICallHandler.GenabilityAccount gaga = GenabilityAPICallHandler.GetkWhValue(acc,String.valueOf(totalBill));
                System.debug('gaga----->'+gaga);
                if(gaga.errorMessage!=null)
                    addPageMessage(gaga.errorMessage);
                if(gaga.kWhValue!=null){
                    ElectricUsage.Annual_Usage__c = gaga.kWhValue;
                    ElectricUsage.Monthly_Jan__c = null;
                    ElectricUsage.Monthly_Feb__c = null;
                    ElectricUsage.Monthly_Mar__c = null;
                    ElectricUsage.Monthly_Apr__c = null;
                    ElectricUsage.Monthly_May__c = null;
                    ElectricUsage.Monthly_Jun__c = null;
                    ElectricUsage.Monthly_Jul__c = null;
                    ElectricUsage.Monthly_Aug__c = null;
                    ElectricUsage.Monthly_Sep__c = null;
                    ElectricUsage.Monthly_Oct__c = null;
                    ElectricUsage.Monthly_Nov__c = null;
                    ElectricUsage.Monthly_Dec__c = null;
                    if(upsertUsageProfile('BILL')){
                        updateElectricUsage();
                    }
                    gaga = null;
                }
            }
            else if (usage == 'MONTHLY ENERGY USAGE'){
                billAmount = null;
                ElectricUsage.Annual_Bill__c = 0.0;
                if(ElectricUsage.Monthly_Jan__c == null ||
                        ElectricUsage.Monthly_Feb__c == null ||
                        ElectricUsage.Monthly_Mar__c == null ||
                        ElectricUsage.Monthly_Apr__c == null ||
                        ElectricUsage.Monthly_May__c == null ||
                        ElectricUsage.Monthly_Jun__c == null ||
                        ElectricUsage.Monthly_Jul__c == null ||
                        ElectricUsage.Monthly_Aug__c == null ||
                        ElectricUsage.Monthly_Sep__c == null ||
                        ElectricUsage.Monthly_Oct__c == null ||
                        ElectricUsage.Monthly_Nov__c == null ||
                        ElectricUsage.Monthly_Dec__c == null){
                    addPageMessage('Please input a valid usage in kWh');
                    return;
                }
                ElectricUsage.Annual_Usage__c = ElectricUsage.Monthly_Jan__c +
                                                ElectricUsage.Monthly_Feb__c +
                                                ElectricUsage.Monthly_Mar__c +
                                                ElectricUsage.Monthly_Apr__c +
                                                ElectricUsage.Monthly_May__c +
                                                ElectricUsage.Monthly_Jun__c +
                                                ElectricUsage.Monthly_Jul__c +
                                                ElectricUsage.Monthly_Aug__c +
                                                ElectricUsage.Monthly_Sep__c +
                                                ElectricUsage.Monthly_Oct__c +
                                                ElectricUsage.Monthly_Nov__c +
                                                ElectricUsage.Monthly_Dec__c;
                if(upsertUsageProfile('MONTHLY ENERGY USAGE'))
                    updateElectricUsage();
            }


        }catch(Exception e){
            insertDebugLogs();
            addPageMessage(e.getMessage());
        }

        System.debug('----->'+Limits.getHeapSize());
    }

    public void updateElectricUsage(){
        ElectricUsage.Account__c = acc.Id;
        try{
            update ElectricUsage;
            PageMessages.addMessage(new PageMessages.PageMessage(PageMessages.Severity.INFO, 'Saved Usage Successfully'));
            ratesEdited = false;
        }catch(Exception e){
            addPageMessage(e.getMessage());
        }
    }

    public void checkandCreateAccountinGenability(){
        GenabilityAPICallHandler.GenabilityAccount gaga = new GenabilityAPICallHandler.GenabilityAccount();
        if(acc.Genability_Account_Id__c == null){
            gaga = GenabilityAPICallHandler.CreateAccount(acc);
            System.debug('GenabilityAPICallHandler.GenabilityAccount----->'+gaga);
            insertDebugLogs();
            addPageMessage(gaga.errorMessage);
        }

        checkandCreateElectricUsage();
        if(acc.Genability_Account_Id__c == null && gaga.genabilityAccountId != null){
            Account newAcc = new Account( Id = acc.Id, Genability_Account_Id__c = gaga.genabilityAccountId);
            update newAcc;
        }
    }

    public void addPageMessage(String errorMessage){
        if(errorMessage!=null){
            PageMessages.addMessage(new PageMessages.PageMessage(PageMessages.Severity.ERROR,errorMessage));
        }
    }

    public void insertDebugLogs(){
        List<SpectrumDebugUtility.debugLog> debugLogs = GenabilityAPICallHandler.spExLogsList;
        if(debugLogs!=null && !debugLogs.isEmpty()){
            System.debug('Insert debugLogs----->'+debugLogs);
            try {
                SpectrumDebugUtility.generateDebugLog(debugLogs);
            } catch(Exception e) {}
        }
    }

    public boolean upsertUsageProfile(String sUsage){
        boolean uspertCallSuccess = false;
        List<GenabilityUsageProfileJSON.ReadingData> gupRDList = new List<GenabilityUsageProfileJSON.ReadingData>();

        if(sUsage == 'BILL'){
            gupRDList.add(new GenabilityUsageProfileJSON.ReadingData(null,GenabilityAPICallHandler.fromDate(),GenabilityAPICallHandler.toDate(),'kWh',ElectricUsage.Annual_Usage__c));
        }
        else if(sUsage == 'MONTHLY ENERGY USAGE'){
            String currentYear = String.valueOf(System.Today().year());
            String lastYear = String.valueOf(System.Today().addYears(-1).year());
            gupRDList.add(new GenabilityUsageProfileJSON.ReadingData(null,lastYear+'-01-01',lastYear+'-02-01','kWh',ElectricUsage.Monthly_Jan__c));
            gupRDList.add(new GenabilityUsageProfileJSON.ReadingData(null,lastYear+'-02-01',lastYear+'-03-01','kWh',ElectricUsage.Monthly_Feb__c));
            gupRDList.add(new GenabilityUsageProfileJSON.ReadingData(null,lastYear+'-03-01',lastYear+'-04-01','kWh',ElectricUsage.Monthly_Mar__c));
            gupRDList.add(new GenabilityUsageProfileJSON.ReadingData(null,lastYear+'-04-01',lastYear+'-05-01','kWh',ElectricUsage.Monthly_Apr__c));
            gupRDList.add(new GenabilityUsageProfileJSON.ReadingData(null,lastYear+'-05-01',lastYear+'-06-01','kWh',ElectricUsage.Monthly_May__c));
            gupRDList.add(new GenabilityUsageProfileJSON.ReadingData(null,lastYear+'-06-01',lastYear+'-07-01','kWh',ElectricUsage.Monthly_Jun__c));
            gupRDList.add(new GenabilityUsageProfileJSON.ReadingData(null,lastYear+'-07-01',lastYear+'-08-01','kWh',ElectricUsage.Monthly_Jul__c));
            gupRDList.add(new GenabilityUsageProfileJSON.ReadingData(null,lastYear+'-08-01',lastYear+'-09-01','kWh',ElectricUsage.Monthly_Aug__c));
            gupRDList.add(new GenabilityUsageProfileJSON.ReadingData(null,lastYear+'-09-01',lastYear+'-10-01','kWh',ElectricUsage.Monthly_Sep__c));
            gupRDList.add(new GenabilityUsageProfileJSON.ReadingData(null,lastYear+'-10-01',lastYear+'-11-01','kWh',ElectricUsage.Monthly_Oct__c));
            gupRDList.add(new GenabilityUsageProfileJSON.ReadingData(null,lastYear+'-11-01',lastYear+'-12-01','kWh',ElectricUsage.Monthly_Nov__c));
            gupRDList.add(new GenabilityUsageProfileJSON.ReadingData(null,lastYear+'-12-01',currentYear+'-01-01','kWh',ElectricUsage.Monthly_Dec__c));
        }

        GenabilityAPICallHandler.GenabilityProperty gachGP = new GenabilityAPICallHandler.GenabilityProperty();
        GenabilityAPICallHandler.GenabilityUsageProfile gagup = new GenabilityAPICallHandler.GenabilityUsageProfile();

        System.debug('ElectricUsage.Genability_Profile_Id__c -----> '+ElectricUsage.Genability_Profile_Id__c);

        if(ElectricUsage.Genability_Profile_Id__c != null ){
            gachGP = GenabilityAPICallHandler.DeleteGenabilityProperty(acc, ElectricUsage.Genability_Profile_Id__c);
            if(gachGP.errorMessage != null){
                addPageMessage(gachGP.errorMessage);
                return false;
            }
            else if(gachGP.callSuccess){
                ElectricUsage.Genability_Profile_Id__c = null;
            }
        }


        if(ElectricUsage.Genability_Profile_Id__c == null)
            gagup = GenabilityAPICallHandler.UpsertUsageProfile(acc,
                                                                ElectricUsage,
                                                                gupRDList,
                                                                'ELECTRICITY',
                                                                'ReadingEntry');
        if(gagup.errorMessage != null){
            addPageMessage(gagup.errorMessage);
        }
        else{
            uspertCallSuccess = true;
        }
        if(gagup.profileId != null)
            ElectricUsage.Genability_Profile_Id__c = gagup.profileId;

        return uspertCallSuccess;
    }

    public void checkandCreateElectricUsage(){
        List<Electric_Rate_Usage_Input__c> EuList = new List<Electric_Rate_Usage_Input__c>();
        EuList =  [ SELECT
                    Id,
                    Name,
                    Current_Rate__c,
                    Current_rate_code__c,
                    Proposed_rate__c,
                    Proposed_rate_code__c,
                    Annual_Usage__c,
                    Annual_Bill__c,
                    Monthly_bill__c,
                    Monthly_Jan__c,
                    Monthly_Apr__c,
                    Monthly_Aug__c,
                    Monthly_Dec__c,
                    Monthly_Feb__c,
                    Monthly_Jul__c,
                    Monthly_Jun__c,
                    Monthly_Mar__c,
                    Monthly_May__c,
                    Monthly_Nov__c,
                    Monthly_Oct__c,
                    Monthly_Sep__c,
                    Usage__c,
                    Account__c,
                    month__c,
                    AMPM__c ,
                    Utility_Description__c,
                    Genability_Profile_Id__c
                    FROM Electric_Rate_Usage_Input__c
                    WHERE Account__c =: acc.Id];

        //defaults
        ratesEdited = false;
        billType='monthlyAverage';
        usage = 'BILL';
        IsPartner = SPCommunityUtility.isPartnerUser();
        system.debug('-----> is partner'+IsPartner);
        boolean getTariffsCalled = false;
        if(EuList.size() > 0){
            ElectricUsage = EuList[0];
        }
        else{
            System.debug('-----> Call getTariffs');
            getTariffs();
            getTariffsCalled = true;
            ElectricUsage = new Electric_Rate_Usage_Input__c(Account__c = acc.Id);
            insert ElectricUsage;
        }

        if(ElectricUsage.Current_Rate__c != null){
            electricratecurrentselected = ElectricUsage.Current_Rate__c;
        }
        else{
            ratesEdited = true;
        }
        if(ElectricUsage.Proposed_rate__c != null){
            electricrateproposedselected = ElectricUsage.Proposed_rate__c;
        }
        if(ElectricUsage.Usage__c != null && (ElectricUsage.Usage__c == 'BILL' || ElectricUsage.Usage__c == 'MONTHLY ENERGY USAGE')){
            usage = ElectricUsage.Usage__c;
        }

        if(ElectricUsage.Annual_Bill__c != null && ElectricUsage.Annual_Bill__c > 0){
            billType = 'totalYearly';
            billAmount = ElectricUsage.Annual_Bill__c;
        }
        if(ElectricUsage.Monthly_bill__c != null && ElectricUsage.Monthly_bill__c >0){
            billType = 'monthlyAverage';
            billAmount = ElectricUsage.Monthly_bill__c;
        }

        System.debug('ElectricUsage ----->'+ElectricUsage);

        if(ratesEdited && !getTariffsCalled)
            getTariffs();
    }
}