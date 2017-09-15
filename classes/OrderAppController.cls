/*
* OrderAppController - controller for cash based ordering system
* SFDC Release - https://na29.salesforce.com/a5B34000000xp2Y
*
* Pivotal Tracker Updates:
* ID #114754041 - Print Order (PDF) - 3/18/16
* ID #114755381 - Add the a la carte selection to the Equinox Ordering Experience - 3/18/16
* ID #114709951 - Add Contact Phone to the Order Submission Screen - 3/18/16
* ID #114753873 - Monitoring Opt Out Checkbox - 3/18/16
* ID #115641829 - BUG: User not finding an Opportunity - SFDC Case #00678010 - 3/17/16
* ID #114754241 - Dynamic kit configurations based on kit size for invisimount - 3/29/16
* ID #116005357, #119616037 - SolarEdge Storage availability Hawaii (SFDC) - 6/3/2016
* ID #121852503 - Remove Ok to Ship - 6/22/16
* ID #114921295 - Remove Shipping Method Selection - WW32
* ID #124934431, #123866151 - Remove Monitoring Opt Out for AC & SolarEdge - 07/10/2016
* ID #126052379 - Allow a partner user responsible for creating purchase orders the ability clone an order
* ID #126076059 - Valid shipping sites in order creation
* ID #126078665 - Valid shipping contacts in order creation
* ID #127348167 - Create Shipping Site & route to Oracle
* ID #128988357 - Real time Oracle order creation via Informatica eliminating SOA
* ID #131120319 - Racking calculation logic cash ordering controller - 10/05/16
* ID #130249379 - Structured Shipping Data in order creation (NA)
* ID #133369091 - Oracle Ship To Contact creation
*
*
*/

global without sharing class OrderAppController extends PageControllerBase {

    //Component controller sharing
    public ShippingSiteComponentController shippingSiteController {set;
        get{
        //get the map, then the component controller using the appropriate key
            if(getComponentControllerMap()!=null){
                ShippingSiteComponentController sscc;
                sscc = (ShippingSiteComponentController )getComponentControllerMap().get('shippingComponent');
                if(sscc!= null)
                    return sscc;
            }
            //just in case something goes wrong return something...this can be handled better
            return new ShippingSiteComponentController();
        }
    }

    public AlaCarteController alacarteController {set;
        get{
        //get the map, then the component controller using the appropriate key
            if(getComponentControllerMap()!=null){
                AlaCarteController acc;
                acc = (AlaCarteController )getComponentControllerMap().get('alacarteComponent');
                if(acc!= null)
                    return acc;
            }
            //just in case something goes wrong return something...this can be handled better
            return new AlaCarteController();
        }
    }



    //constants
    private final Date todayDate = Date.Today();
    private final String alaCarte = 'Ala Carte';
    private final String equinox = 'Equinox';
    private final String storageBundle = 'Storage Bundle';
    private final String hiStorage = 'Storage - Hawaii';

    //variables, collections, etc
    public Boolean isPartnerUser{get;set;}
    public Boolean isCalloutError {get;set;}
    public String errorFromORC {get;set;}
    public Purchase_Order__c purchaseOrder {get;set;}
    private List<Purchase_Order_Line__c> disconnectLines {get;set;}
    public String poID {get;set;}
    public Price_List__c cashPriceList { get; private set; }
    public String oppId {get; set;}
    public Opportunity opp {get; set;}
    public User currentUser {get; set;}
    public static Id partnerAccountId {get;set;}
    public string reqDeliveryDate {get;set;}
    public Boolean powerWallPartner {  //#116005357
        get {
            if(powerWallPartner == null)
                powerWallPartner = false;
            return powerWallPartner;
        }
        set;
    }
    public Boolean blockMonitoringOptOut { //#124934431, #123866151
        get {
            if(blockMonitoringOptOut == null)
                blockMonitoringOptOut = false;
            return blockMonitoringOptOut;
        }
        set;
    }

    public List<Purchase_Order_Line__c> orderLines {get;set;}
    public List<ReturnItem> returnLines {get;set;}
    public Bill_To_Site__c bts {get;set;}
    public Ship_To_Site__c sts {get;set;}
    public Contact shipContact {get;set;} //#114709951
    public String TOCDocId {get;set;}
    public String specialInstructions {
        get {
            return purchaseOrder.Special_Instructions__c;
        }
        set;
    }
    private Boolean isRealTimeOrder {get;set;}

    //Page selection vars and collections
    @TestVisible
    private Map<Id, Module_Configuration__c> configurators;
    private Map<Id, MasterModuleInverterJunction__c> specificInverters {get;set;}
    private List<ModuleInverterJunction__c> manufacturers = new List<ModuleInverterJunction__c>();
    public Id selectedModuleTypeIdentifier {get;set;}
    public String selectedManufacturer {get;set;}
    public String selectedType {get;set;}
    public String selectedConfigurationModel {get;set;}
    public String moduleWattage {get;set;}
    public List<SelectOption> inverterManufacturerOptions {get;set;}
    public List<SelectOption> inverterTypeOptions {get;set;}
    public List<SelectOption> rackingOptions {get;set;}
    public String selectedStorageId {get;set;} //#116005357

    //#126052379
    public Order_Template__c template {get;set;}

    //Callout items
    public Decimal totalPrice {get; set;}
    public String totalPriceFormatted {get; set;}
    public String jsonHeader {get;set;}

    //constructor
    private ApexPages.StandardController sc;
    global OrderAppController(ApexPages.StandardController standardController) {
        sc = standardController;

        currentUser = [Select Id, Name, Profile.Name, UserType, Contact.Country_Domain__c, Contact.Account.RSM__c,
                ContactId, Contact.AccountID, Contact.Authorized_to_Order__c, Contact.Account.Primary_PSR__c,
                Contact.Account.Oracle_Operating_Unit__c, Contact.Account.Online_Order_Access__c,
                Contact.Account.AccountNumber, Contact.Account.Name, Contact.Account.Special_Programs__c ,
                Contact.Account.Oracle_Account_Number__c, CurrencyISOCode, Contact.Account.Partner_Opt_Out_Ok_To_Ship__c
            From User Where Id =: UserInfo.getUserId()];

        partnerAccountId = currentUser.Contact.AccountId;

        if(currentUser.Contact.Account.Special_Programs__c != null) {
            List<String> programs = new List<String>(currentUser.Contact.Account.Special_Programs__c.split(';'));
            if(!programs.isEmpty()) {
                for(String s : programs) {
                    if(s != null && s.containsIgnoreCase(HIStorage)) { //#116005357
                        powerWallPartner = true;
                        break;
                    }
                }
            }
        }

        purchaseOrder = (Purchase_Order__c)sc.getRecord();
        purchaseOrder.Dealer_Account__c = currentUser.Contact.AccountId;

        //#126052379
        template = new Order_Template__c();

        try {
            cashPriceList = [SELECT Id, Name, DSR_PO_Group_Email__c
                             FROM Price_List__c
                             WHERE Oracle_Operating_Unit__c != null
                             AND Oracle_Operating_Unit__c =: currentUser.Contact.Account.Oracle_Operating_Unit__c
                             LIMIT 1];
        } catch(Exception e) {

        }
        poID = ApexPages.currentPage().getParameters().get('POID');
        if(poID != null) {
            purchaseOrder = [SELECT Id, Name, Order_Type__c, Number_Of_Systems__c, Bill_to_Site__c, Ship_To_Site__c, Dealer_Account__c,
                                    Module_Quantity__c, Module_Type__c, Racking_Type__c, Racking_Opt_Out__c, Assigned_DSR__c,
                                    Racking_Quantity__c, Monitoring_Quantity__c, Accept_Terms__c, Order_Status__c, Assigned_RSM__c,
                                    Opportunity__r.Name, System_Size__c, Special_Instructions__c, Ok_To_Ship__c,
                                    Requested_Delivery_Date__c, Ship_To_Contact__c, Ship_To_contact__r.Phone, Is_Taxible_Order__c,
                                    Monitoring_Opt_Out__c, Dealer_Account__r.Name, Storage__c, Storage_Quantity__c, Ship_To_Site__r.Status__c,
                                    Ship_To_Site__r.SiteID__c, Interface_Status__c
                             FROM Purchase_Order__c
                             WHERE Id =: poID];
            if(String.isNotBlank(purchaseOrder.Opportunity__c)){
                opp = [Select Id, Name, PartnerAccount.Name, Primary_Contact__c, Account.Phone, AccountId
                       From Opportunity Where id = :purchaseOrder.Opportunity__c];
            }

            if(purchaseOrder.Bill_to_Site__c == null) {
                try {
                    bts = [SELECT Id, Address1__c, City__c, State__c, Zip__c FROM Bill_To_Site__c
                           WHERE Dealer_Account__c =: currentUser.Contact.AccountId
                           AND Oracle_Operating_Unit_Code__c =: currentUser.Contact.Account.Oracle_Operating_Unit__c
                           Order By LastModifiedDate DESC LIMIT 1];
                    purchaseOrder.Bill_to_Site__c = bts.Id;
                }  catch(Exception e) {
                    System.debug('BTS ERROR: ' + e.getMessage());
                    bts = new Bill_to_site__c();
                }
            }

            if(String.isNotBlank(purchaseOrder.Interface_Status__c)) {
                isRealTimeOrder = false;
            } else isRealTimeOrder = true;

            //Resets
            // check to make sure the ship to site is still active
            if(String.isNotBlank(purchaseOrder.Ship_To_Site__c) && String.isNotBlank(purchaseOrder.Ship_To_Site__r.SiteID__c) && purchaseOrder.Ship_To_Site__r.Status__c == 'Inactive') {
                purchaseOrder.Ship_To_Site__c = null;
            }
            purchaseOrder.Monitoring_Opt_Out__c = false;
            purchaseOrder.Monitoring_Quantity__c = 1;

            purchaseOrder.Racking_Opt_Out__c = false;
            purchaseOrder.Racking_Type__c = null;
            purchaseOrder.Racking_Quantity__c = 0;

            purchaseOrder.Storage__c = null;
            purchaseOrder.Storage_Quantity__c = null;
        }

        else {
            //Defaults
            purchaseOrder.Number_of_Systems__c = 1;
            purchaseOrder.Module_Quantity__c = 1;
            purchaseOrder.Monitoring_Quantity__c = 1;

            if(currentUser.Contact.Account.Primary_PSR__c != null)
                purchaseOrder.Assigned_DSR__c = currentUser.Contact.Account.Primary_PSR__c;
            if(currentUser.Contact.Account.RSM__c != null)
                purchaseOrder.Assigned_RSM__c = currentUser.Contact.Account.RSM__c;
            if(cashPriceList != null) {
                purchaseOrder.DSR_PO_Group_Email__c = cashPriceList.DSR_PO_Group_Email__c;
            }

            try {
                bts = [SELECT Id, Address1__c, City__c, State__c, Zip__c FROM Bill_To_Site__c
                       WHERE Dealer_Account__c =: currentUser.Contact.AccountId
                       AND Oracle_Operating_Unit_Code__c =: currentUser.Contact.Account.Oracle_Operating_Unit__c
                       Order By LastModifiedDate DESC LIMIT 1];
                purchaseOrder.Bill_to_Site__c = bts.Id;
            }  catch(Exception e) {
                System.debug('BTS ERROR: ' + e.getMessage());
                bts = new Bill_to_site__c();
            }

            isRealTimeOrder = false;
            for(OracleRealTimeCashOrderOnOffSwitch__mdt rto : [SELECT Interface_Status__c FROM OracleRealTimeCashOrderOnOffSwitch__mdt WHERE DeveloperName = 'Default' LIMIT 1]) {
                if(String.isBlank(rto.Interface_Status__c)) isRealTimeOrder = true;
            }
        }

        try {
            String folderName='Terms and Conditions';
            String opName = currentUser.Contact.Account.Oracle_Operating_Unit__c;
            if(opName.length() > 4) opName = opName.substring(0, 4);
            for(Document d :[select id,DeveloperName,name from Document where DeveloperName =: opName and Folder.Name =: folderName Limit 1]){
                TOCDocId = d.id;
            }

        } catch(Exception e) {
            TOCDocId = '';
        }

        initModules();

        orderLines = new List<Purchase_Order_Line__c>();
        initOrderLines();

        isPartnerUser = SPCommunityUtility.isPartnerUser();
    }

    /* Inverter Table and Ratio table methods
    *  getFlexiRatios() - gets Inverter/Module ratios for modal help display - updated #116005357
    *  addOrderLine() - adds additional inverter selection line to table
    *  removeOrderLine() - removes selected inverter selection line from table
    *  calculateInverterCapacity() - calculates total inverter capacity for selected inverters
    *  defaultMonitoringQuantity() - sets monitoring to same as number of systems
    */

    public List<OrderAppUtility.RatioWrapper> flexiRatios {
        get {
            if(flexiRatios == null) {
                flexiRatios = getFlexiRatios();
            }
            return flexiRatios;
        }
        set;
    }
    public List<OrderAppUtility.RatioWrapper> getFlexiRatios() {
        flexiRatios = new List<OrderAppUtility.RatioWrapper>();
        if(purchaseOrder == null || String.isBlank(purchaseOrder.Order_Type__c))
            return flexiRatios;
        try {
            if(purchaseOrder.Order_Type__c == storageBundle) {
                List<Storage_Inverter_Module_Ratio__c> storageRatios = new List<Storage_Inverter_Module_Ratio__c>(Storage_Inverter_Module_Ratio__c.getAll().values());
                for(Storage_Inverter_Module_Ratio__c r : storageRatios) {
                    OrderAppUtility.RatioWrapper w = new OrderAppUtility.RatioWrapper();
                    w.sortVal = Integer.valueOf(r.Name);
                    w.lowerLimit = r.Total_System_Size_Min__c;
                    w.upperLimit = r.Total_System_Size_Max__c;
                    w.ratioLimit = r.Inverter_Module_Ratio__c;
                    flexiRatios.add(w);
                }
            } else {
                List<ModuleInverterRatio__c> ratios = new List<ModuleInverterRatio__c>(ModuleInverterRatio__c.getAll().values());
                for(ModuleInverterRatio__c r : ratios) {
                    OrderAppUtility.RatioWrapper w = new OrderAppUtility.RatioWrapper();
                    w.sortVal = Integer.valueOf(r.Name);
                    w.lowerLimit = r.Total_System_Size_Min__c;
                    w.upperLimit = r.Total_System_Size_Max__c;
                    w.ratioLimit = r.InverterModule_Ratio__c;
                    flexiRatios.add(w);
                }
            }
        } catch(Exception e) {
            return flexiRatios;
        }
        flexiRatios.sort();
        return flexiRatios;
    }

    public PageReference addOrderLine() {
        orderLines.add(new Purchase_Order_Line__c(Quantity__c = 1, Item_ID__c = ''));

        calculateInverterCapacity();

        //#116005357
        if(purchaseOrder.Order_Type__c == storageBundle)
            buildStorageSelections();

        return null;
    }

    public PageReference removeOrderLine() {
        if(orderLines.size() > 1){
            Integer indexVal = Integer.valueof(System.currentpagereference().getparameters().get('index'));
            orderLines.remove(indexVal - 1);
        }
        calculateInverterCapacity();

        //#116005357
        if(purchaseOrder.Order_Type__c == storageBundle)
            buildStorageSelections();

        return null;
    }

    public Decimal inverterCapacity {get;set;}
    public Decimal moduleCapacity {get;set;}
    public Decimal invModuleRatio {get;set;}

    public PageReference calculateInverterCapacity() {

        if(inverterData == null || inverterData.isEmpty())
            return null;

        Decimal totalInverterCapacity = 0;
        for(Purchase_Order_Line__c l : orderLines) {
            for(Inverter_Configuration__c i : inverterData.values()) {
                if(l.Item_ID__c == i.Item__r.Item_ID__c) {
                    Decimal temp = 0;
                    try {
                        temp = Integer.valueOf(i.Item__r.Item_Category_3__c) * l.Quantity__c;
                    } catch(Exception e) {
                        System.debug('Inv Capacity is NaN');
                    }
                    totalInverterCapacity += temp;
                }
            }
        }

        totalInverterCapacity=totalInverterCapacity/1000;// converting to KW
        inverterCapacity = totalInverterCapacity.setScale(2);

        Integer moduleWattage = Integer.valueOf(getWattage());
        Decimal modCount = purchaseOrder.Module_Quantity__c == null ? 0 : purchaseOrder.Module_Quantity__c;
        Decimal totalModCapacity =(moduleWattage * modCount)/1000;//converting to KW
        moduleCapacity = totalModCapacity.setScale(2);

        try {
            invModuleRatio = (totalInverterCapacity/totalModCapacity).setScale(3);
        } catch(Exception e) {
            invModuleRatio = totalInverterCapacity.setScale(3);
        }

        //#116005357
        if(purchaseOrder.Order_Type__c == storageBundle)
            buildStorageSelections();

        return null;
    }

    //Updated PT #114753873
    public PageReference defaultMonitoringQuantity() {

        if(purchaseOrder.Monitoring_Opt_Out__c) {
            purchaseOrder.Monitoring_Quantity__c = 0;
        }
        else {
            purchaseOrder.Monitoring_Quantity__c = purchaseOrder.Number_of_Systems__c;
        }
        return null;
    }


    /* SelectOptions and other dynamic option configurations
    *  initModules() - gather modules and related information for the configuration
    *  getModuleTypes() - Available Modules select options
    *  buildManufacturers() - Inverter Manufacturer select options
    *  getEquinoxModules() -
    */

    Set<Id> masterIds {get;set;}
    @TestVisible
    private void initModules() {
        if(sts == null || sts.State__c == null)
            return;

        //Get Master Ids for this sales process
        if(purchaseOrder.Order_Type__c == equinox)
            masterIds = ProductConfigurationUtility.fetchEquinoxMasterIDs(sts.State__c, currentUser.Contact.Account.Oracle_Operating_Unit__c, 'Cash', 'Order', 'Residential', 'Indirect', currentUser.Contact.AccountId);
        else
            masterIds = ProductConfigurationUtility.fetchMasterIds(sts.State__c, currentUser.Contact.Account.Oracle_Operating_Unit__c, 'Cash', 'Order', 'Residential', 'Indirect', currentUser.Contact.AccountId);

        System.debug('masterIds: ' + masterIds);

        //Collect modules based on the sales config records
        configurators = ProductConfigurationUtility.fetchModules(masterIds);
    }

    //Populate picklist of modules
    public List<SelectOption> getModuleTypes() {
        if(configurators == null)
            initModules();

        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','Select...'));
        for(Module_Configuration__c m: configurators.values()){
            options.add(new SelectOption(String.valueOf(m.Id),m.Name));
        }
        return options;
    }

    //Gather and return Inverter Manufacturers based on the selected module
    Map<Id, Inverter_Configuration__c> inverterData {get;set;}
    public PageReference buildManufacturers(){

        if(selectedModuleTypeIdentifier == null)
            return null;
        if(configurators == null || !configurators.containsKey(selectedModuleTypeIdentifier))
            return null;

        selectedConfigurationModel = configurators.get(selectedModuleTypeIdentifier).Current_Type__c;

        if(orderLines == null)
            initOrderLines();
        else {
            if(!orderLines.isEmpty())
                orderLines.clear();
            initOrderLines(); //recalculate table here
        }

        //gather inverters in Map
        inverterData = ProductConfigurationUtility.fetchInvertersByModule(selectedModuleTypeIdentifier, masterIds);

        inverterManufacturerOptions = new List<SelectOption>();
        Set<String> manufacturersSet = new Set<String>();
        inverterManufacturerOptions.add(new SelectOption('','Select...'));

        for(Inverter_Configuration__c i : inverterData.values()) {
            manufacturersSet.add(i.Inverter_Manufacturer__c);
        }

        for(String s : manufacturersSet) {
            inverterManufacturerOptions.add(new SelectOption(s,s));
        }

        //#124934431, #123866151 - hide monitoring opt-out for any one specified inverter
        //Defaulting and setting for AC
        blockMonitoringOptOut = false; //reset on load or on change
        if(selectedConfigurationModel != null && !manufacturersSet.isEmpty()) {
            for(String s : manufacturersSet) {
                selectedManufacturer = s;
                break;
            }
            buildInverterTypes();
        }

        buildRackingSelection();
        calculateInverterCapacity();
        return null;
    }

    public PageReference buildInverterTypes() {
        inverterTypeOptions = new List<SelectOption>();

        //#124934431, #123866151 - hide monitoring opt-out for any one specified inverter
        //Defaulting and setting for AC
        blockMonitoringOptOut = false; //reset on load or on change

        if(selectedManufacturer == null)
            return null;

        Map<String, String> inverterMap = new Map<String, String>();

        for(Inverter_Configuration__c inverter : inverterData.values()){
            if(inverter.Inverter_Manufacturer__c == selectedManufacturer) {
                inverterMap.put(inverter.Item__r.Description__c, inverter.Item__r.Item_ID__c);
                //#124934431, #123866151 - hide monitoring opt-out for any one specified inverter
                if(blockMonitoringOptOut != true && inverter.On_Board_Monitoring__c == true) {
                    blockMonitoringOptOut = true;
                    purchaseOrder.Monitoring_Opt_Out__c = false;
                }
            }
        }
        inverterTypeOptions.add(new SelectOption('','Select...'));
        for(String s: inverterMap.keySet()){
            inverterTypeOptions.add(new SelectOption(inverterMap.get(s),s));
        }
        if(orderLines == null || orderLines.isEmpty())
            initOrderLines();
        //#116005357
        if(purchaseOrder.Order_Type__c == storageBundle)
            buildStorageSelections();

        return null;
    }

    //#116005357
    public List<SelectOption> storageOptions {get;set;}
    Map<Id, Storage_Configuration__c> storageMap {get;set;}
    public PageReference buildStorageSelections() {

        storageMap = new Map<Id, Storage_Configuration__c>();
        storageOptions = new List<SelectOption>();

        if(inverterData == null || inverterData.isEmpty() || String.isBlank(selectedManufacturer) || orderLines == null || orderLines.isEmpty())
            return null;

        Set<Id> inverterIds = new Set<Id>();
        for(Inverter_Configuration__c i : inverterData.values()) {
            if(i.Inverter_Manufacturer__c == selectedManufacturer && i.Storage_Ready_Inverter__c) {
                for(Purchase_Order_Line__c l : orderLines) {
                    if(l.Item_ID__c == i.Item__r.Item_Id__c)
                       inverterIds.add(i.Id);
                }
            }
        }

        for(Storage_Configuration__c s : [SELECT Id, Name, Item__r.Description__c, Item__r.Item_ID__c,
                                                 (SELECT Id, Item__c, Item__r.Item_ID__c FROM Storage_Item_Junctions__r)
                                          FROM Storage_Configuration__c
                                          WHERE ID IN (SELECT Storage_Configuration__c
                                                        FROM Inverter_Storage_Junction__c
                                                        WHERE Inverter_Configuration__c IN: inverterIds)]) {
            storageMap.put(s.Id, s);
            storageOptions.add(new SelectOption(s.Id, s.Item__r.Description__c));
        }

        if(storageOptions.isEmpty())
            purchaseOrder.Storage_Quantity__c = null;
        return null;
    }

    //Load Equinox stuff, default values to first option in list
    public List<SelectOption> getEquinoxModules() {
        List<SelectOption> options = new List<SelectOption>();

        if(configurators == null)
            initModules();

        configurators = ProductConfigurationUtility.fetchModules(masterIds);

        for(Module_Configuration__c m : configurators.values()){
            options.add(new SelectOption(String.valueOf(m.Id),m.Name));
        }

        if(options.size() > 0 && String.isBlank(purchaseOrder.Module_Type__c)) {
            selectedModuleTypeIdentifier = options[0].getValue();
            purchaseOrder.Module_Type__c = options[0].getLabel();
            moduleWattage = configurators.get(selectedModuleTypeIdentifier).Item__r.Item_Category_3__c;

            getMonitoringForAC();
            getRacking();

            purchaseOrder.Racking_Type__c = rackingItemJunctions.values()[0].Racking_Configuration__r.Type__c;
        }
        return options;
    }

    //wattage of selected module type - used for calculations
    public String getWattage() {
        try {
            moduleWattage = configurators.get(selectedModuleTypeIdentifier).Item__r.Item_Category_3__c == null ? '0' : configurators.get(selectedModuleTypeIdentifier).Item__r.Item_Category_3__c;
        } catch(Exception e) {
            moduleWattage = '0';
        }
        return moduleWattage;
    }

    //Monitoring stuff
    public List<Purchase_Order_Line__c> monitoringLines {get;set;}
    public Map<Id, Monitoring_Configuration__c> monitoringMap {get;set;}

    public void getMonitoring() {
        monitoringLines = new List<Purchase_Order_Line__c>();
        if(purchaseOrder.Monitoring_Opt_Out__c)
            return;

        Decimal monQty = purchaseOrder.Monitoring_Quantity__c == null ? 1 : purchaseOrder.Monitoring_Quantity__c;
        if(purchaseOrder.Order_Type__c == equinox)
            purchaseOrder.Monitoring_Quantity__c = 1;

        try {
            Set<Id> monitoringIds = new Set<Id>();

            for(Purchase_Order_Line__c l : orderLines) {
                for(Inverter_Configuration__c i : inverterData.values()) {
                    if(l.Item_ID__c == i.Item__r.Item_ID__c) {
                        monitoringIds.add(i.Monitoring__c);
                    }
                }
            }

            monitoringMap = ProductConfigurationUtility.fetchMonitoringByInverterList(monitoringIds);

            for(Monitoring_Configuration__c c : monitoringMap.values()) {
                for(Monitoring_Item_Junction__c mj : c.Monitoring_Item_Junction__r) {
                    monitoringLines.add(new Purchase_Order_Line__c(Quantity__c = monQty, Item_ID__c = mj.Item__r.Item_Id__c, Oracle_Item_ID__c = mj.Item__c));
                }
            }

         } catch(Exception e) {
             monitoringMap = new Map<Id, Monitoring_Configuration__c>();
         }

    }

    public void getMonitoringForAC() {

        monitoringLines = new List<Purchase_Order_Line__c>();

        Decimal avgSystemSize = Decimal.valueOf(Label.Average_System_Size);
        Decimal systemSize = getSystemSize();
        Decimal qtyOfMonitoring = purchaseOrder.System_Size__c.divide(avgSystemSize,0,System.RoundingMode.UP);

        if(qtyOfMonitoring > purchaseOrder.number_of_systems__c){
            purchaseOrder.Monitoring_Quantity__c = purchaseOrder.number_of_systems__c;
        }

        if(purchaseOrder.Order_Type__c == equinox)
            purchaseOrder.Monitoring_Quantity__c = 1;

        //gather inverters in Map
        inverterData = ProductConfigurationUtility.fetchInvertersByModule(selectedModuleTypeIdentifier, masterIds);

        if(!inverterData.isEmpty()) {

            try {
                Set<Id> monitoringIds = new Set<Id>();

                for(Inverter_Configuration__c i : inverterData.values()) {
                    monitoringIds.add(i.Monitoring__c);
                    purchaseOrder.Inverter_Manufacturer__c = i.Inverter_Manufacturer__c;
                }

                monitoringMap = ProductConfigurationUtility.fetchMonitoringByInverterList(monitoringIds);

                for(Monitoring_Configuration__c c : monitoringMap.values()) {
                    for(Monitoring_Item_Junction__c mj : c.Monitoring_Item_Junction__r) {
                        monitoringLines.add(new Purchase_Order_Line__c(Quantity__c = purchaseOrder.Monitoring_Quantity__c, Item_ID__c = mj.Item__r.Item_Id__c, Oracle_Item_ID__c = mj.Item__c));
                    }
                }

            } catch(Exception e) {
                 monitoringMap = new Map<Id, Monitoring_Configuration__c>();
            }
        }
    }

    /* * #114921295
    public List<SelectOption> getShippingInputOptions() {
        List<SelectOption> options = new List<SelectOption>();
        for(String s : cashPriceList.Shipping_Codes__c.split('\\;')){
            SelectOption opt = new SelectOption(s,s);
            options.add(opt);
        }
        return options;
    }
    */

    /* Racking options and calculations
     * buildRackingSelection() - SelectOptions
     * getRacking() - retrive racking junctions for selected option
     * calculateRacking() - calculates racking qty, creates racking order line
     * buildKitsBySystemSize() - dynaminc kit configuration based on kW kit size for invisimount kits PT #114754241
     * getSystemSize() - System_Size__c in kW
     *
    */

    public Map<Id, Racking_Item_Junction__c> rackingItemJunctions {get;set;}
    public String rackingQuantity {get;set;}
    public List<Purchase_Order_Line__c> rackingLines {get;set;}
    Map<String, Integer> rackingKitToQty {get;set;}

    public PageReference buildRackingSelection() {
        Set<String> typeSet = new Set<String>();
        rackingOptions = new List<SelectOption>();

        if(selectedModuleTypeIdentifier == null)
            return null;

        getRacking();

        rackingOptions.add(new SelectOption('','Select...'));
        try {
            for(Racking_Item_Junction__c rackingItem : rackingItemJunctions.values()) {
                typeSet.add(rackingItem.Racking_Configuration__r.Type__c);
            }
            for(String s : typeSet)
                rackingOptions.add(new SelectOption(s, s));

        } catch(Exception e) {

        }

        try {
            calculateRacking();
        } catch(Exception e) {
            System.debug('calc racking error: ' + e);
        }
        return null;
    }

    public void getRacking() {
        rackingItemJunctions = new Map<Id, Racking_Item_Junction__c>();

        if(selectedModuleTypeIdentifier == null)
            return;

        try {
            rackingItemJunctions = ProductConfigurationUtility.fetchRackingByModule(selectedModuleTypeIdentifier, masterIds);
            if(purchaseOrder.Order_Type__c == equinox) {
                for(Id i : rackingItemJunctions.keySet()) {
                    if(rackingItemJunctions.get(i).Racking_Configuration__r.Type__c != 'Invisimount')
                        rackingItemJunctions.remove(i);
                }
             }
        } catch(Exception e) {

        }
    }

    //calculates racking quantity based on input parameters
    public PageReference calculateRacking() {

        if(purchaseOrder.Racking_Type__c == null || purchaseOrder.Module_Quantity__c == null) {
            rackingQuantity = null;
            return null;
        }

        if(purchaseOrder.Racking_Opt_Out__c) {
            purchaseOrder.Racking_Quantity__c = 0;
            purchaseOrder.Racking_Type__c = null;
            rackingLines = new List<Purchase_Order_Line__c>();
            return null;
        }

        if(rackingLines == null)
            rackingLines = new List<Purchase_Order_Line__c>();

        if(!rackingLines.isEmpty())
            rackingLines.clear();

        Decimal systemSize = getSystemSize();

        getRacking();

        Racking_Item_Junction__c selectedRacking;//temporary

        Map<Id, Racking_Item_Junction__c> eligibleRackingsMap = new Map<Id, Racking_Item_Junction__c>();

        for(Racking_Item_Junction__c j : rackingItemJunctions.values()) {
            if(j.Racking_Configuration__r.Type__c.equalsIgnoreCase(purchaseOrder.Racking_Type__c)) {
                selectedRacking = j;
                eligibleRackingsMap.put(j.Id, j);
            }
            else if(j.Racking_Configuration__r.Name.equalsIgnoreCase(purchaseOrder.Racking_Type__c)) {
                selectedRacking = j;
                eligibleRackingsMap.put(j.Id, j);
            }
        }

        Decimal calculatedQty = 0;
        rackingQuantity = '0';

        if(selectedRacking == null)
            return null;
        System.debug('Racking Type: '+selectedRacking.Racking_Configuration__r.Type__c);
        if(selectedRacking.Racking_Configuration__r.Type__c.equalsIgnoreCase('Invisimount') && !eligibleRackingsMap.isEmpty()) {
            RackingCalculationUtility rcu = new RackingCalculationUtility();
            Map<String, Integer> rackingItemsMap = rcu.calculateInvisimount(eligibleRackingsMap, purchaseOrder.Module_Quantity__c);
            for(String kit : rackingItemsMap.keySet()) {
                Purchase_Order_Line__c l = new Purchase_Order_Line__c();
                l.Quantity__c = rackingItemsMap.get(kit);
                l.Item_ID__c = kit;
                l.Item_Number__c = kit;
                rackingLines.add(l);
            }
        }
        else if((selectedRacking.Racking_Configuration__r.Type__c.equalsIgnoreCase('Solar Mount') || selectedRacking.Racking_Configuration__r.Type__c.equalsIgnoreCase('SolarMount')) && !eligibleRackingsMap.isEmpty()) {
            System.debug('Solarmount Calculation');
            RackingCalculationUtility rcu = new RackingCalculationUtility();
            Purchase_Order_Line__c rackingOrderLine = rcu.calculateSolarmount(selectedRacking, purchaseOrder.Module_Quantity__c, configurators.get(selectedModuleTypeIdentifier).Item__r.Module_Width__c == null ? 0 : configurators.get(selectedModuleTypeIdentifier).Item__r.Module_Width__c);
            System.debug('OrderLine: '+rackingOrderLine);
            calculatedQty = rackingOrderLine.Quantity__c;
            purchaseOrder.Racking_Quantity__c = calculatedQty;
            rackingOrderLine.Quantity__c = calculatedQty;
            rackingOrderLine.Item_Description__c = selectedRacking.Item__r.Description__c;
            rackingLines.add(rackingOrderLine);
            rackingQuantity = String.valueOf(calculatedQty.intValue());
        }

        return null;
    }

    private void buildKitsBySystemSize(Decimal systemSize, Map<Id, Racking_Item_Junction__c> rackingItemsMap) {

        if(rackingItemsMap.isEmpty())
            return;

        rackingKitToQty = new Map<String, Integer>();

        Decimal maxSize = systemSize.round(System.RoundingMode.UP);

        List<OrderAppUtility.DescSorter> sortingList = new List<OrderAppUtility.DescSorter>();
        for(Id i : rackingItemsMap.keySet()) {
            if(rackingItemsMap.get(i).Racking_Configuration__r.Kit_Size__c != null && rackingItemsMap.get(i).Racking_Configuration__r.Kit_Size__c > 0) {
                OrderAppUtility.DescSorter s = new OrderAppUtility.DescSorter();
                s.identifier = i;
                s.sortingValue = rackingItemsMap.get(i).Racking_Configuration__r.Kit_Size__c.intValue();
                sortingList.add(s);
            }
        }
        OrderAppUtility.SORT_DIR = OrderAppUtility.SortDirection.DESCENDING;
        sortingList.sort();

        Integer temp = maxSize.intValue();

        Integer counter = 0;
        Map<String, Integer> kitsWithQty = new Map<String, Integer>();
        for(OrderAppUtility.DescSorter r : sortingList) {

            if(temp <= 0) break;

            if(r.sortingValue != 0 && temp > 0) {

                if(temp >= r.sortingValue) {
                    while(temp >= r.sortingValue) {
                        counter ++;
                        temp = (temp - r.sortingValue) < 0 ? 0 : temp - r.sortingValue;
                    }
                    kitsWithQty.put(r.identifier, counter);
                    counter = 0;
                }
            }
        }
        if(kitsWithQty.isEmpty() || temp != 0) {
            OrderAppUtility.SORT_DIR = OrderAppUtility.SortDirection.ASCENDING;
            sortingList.sort();

            try {
                counter = 1;
                if(kitsWithQty.containsKey(sortingList[0].identifier))
                    counter = kitsWithQty.get(sortingList[0].identifier) + 1;

                kitsWithQty.put(sortingList[0].identifier, counter);
            } catch(Exception e) {
                System.debug('list split error: ' + e);
            }
        }

        for(String kit : kitsWithQty.keySet()) {
            Integer sortingValue = 0;
            try {
                sortingValue = kitsWithQty.get(kit);
            } catch(Exception e) {

            }
            Purchase_Order_Line__c l = new Purchase_Order_Line__c();
            l.Quantity__c = sortingValue;
            l.Item_ID__c = rackingItemsMap.get(kit).Item__r.Item_ID__c;
            l.Item_Number__c = rackingItemsMap.get(kit).Item__c;
            l.Item_Description__c = rackingItemsMap.get(kit).Item__r.Description__c;
            rackingLines.add(l);
        }

    }

    //return system size in kw
    private Decimal getSystemSize() {

        String wattage = getWattage();
        Double quantityOfModules = purchaseOrder.Module_Quantity__c == null ? 0 : purchaseOrder.Module_Quantity__c;
        Decimal systemSize = (Integer.valueOf(wattage) * quantityOfModules)/1000;//system size in kw
        purchaseOrder.System_Size__c = systemSize;
        return systemSize;
    }

    private void buildDisconnects() {
        //
        if(disconnectLines != null && !disconnectLines.isEmpty())
            disconnectLines.clear();

        Set<String> items = new Set<String>();

        if(orderLines != null && !orderLines.isEmpty()) {
            for(Purchase_Order_Line__c line : orderLines) {
                if(line.Item_ID__c != null)
                    items.add(line.Item_Id__c);
            }
        }

        if(alacarteController != null && alacarteController.selProductItems != null && alacarteController.selProductItems.size() > 0) {
            for(AlaCarteController.PriceItemWrapper w : alacarteController.selProductItems) {
                if(w.itemID != null) {
                    items.add(w.itemID);
                }
            }
        }
        if(items.isEmpty()) return;

        Map<String, String> disconnects = new Map<String, String>();
        for(Item__c i : [SELECT Item_Id__c, Disconnect_Item_Id__c FROM Item__c WHERE Disconnect_Item_Id__c != null AND Item_Id__c IN: items]) {
            disconnects.put(i.Item_Id__c, i.Disconnect_Item_Id__c);
        }

        if(disconnects.isEmpty()) return;

        disconnectLines = new List<Purchase_Order_Line__c>();
        if(orderLines != null) {
            for(Purchase_Order_Line__c l : orderLines) {
                if(disconnects.containsKey(l.Item_ID__c) && disconnects.get(l.Item_ID__c) != null) {
                    disconnectLines.add(new Purchase_Order_Line__c(Item_Id__c=disconnects.get(l.Item_ID__c), Quantity__c=l.Quantity__c));
                }
            }
        }
        if(alacarteController != null && alacarteController.selProductItems != null) {
            for(AlaCarteController.PriceItemWrapper w : alacarteController.selProductItems) {
                if(disconnects.containsKey(w.ItemId) && disconnects.get(w.ItemId) != null) {
                    disconnectLines.add(new Purchase_Order_Line__c(Item_Id__c=disconnects.get(w.ItemId), Quantity__c=Decimal.valueOf(w.Qty), Item_Type__c='Ala Carte'));
                }
            }
        }

    }

    //#116005357
    List<Purchase_Order_Line__c> storageLines {get;set;}
    private void buildStorageItems() {

        storageLines = new List<Purchase_Order_Line__c>();
        if(String.isBlank(selectedStorageId) || storageMap == null || storageMap.isEmpty())
            return;

        List<Storage_Item_Junction__c> junctions = new List<Storage_Item_Junction__c>();

        try {
            storageLines.add(new Purchase_Order_Line__c(Item_Id__c = storageMap.get(selectedStorageId).Item__r.Item_Id__c, Quantity__c = Decimal.valueOf(purchaseOrder.Storage_Quantity__c)));//TODO: Fix QTY!!
            for(Storage_Item_Junction__c i : storageMap.get(selectedStorageId).Storage_Item_Junctions__r) {
                storageLines.add(new Purchase_Order_Line__c(Item_ID__c=i.Item__r.Item_ID__c, Quantity__c=1));
            }
        } catch(Exception e) {
            System.debug(LoggingLevel.ERROR, 'STORAGE LINE FAILURE: ' + e);
        }

    }

    /* PageReference methods
     * ToOpportunitySelect()
     * ToShipping()
     * ToShippingWithoutOpp()
     * ToSystemsConfig()
     * ToOrderType()
     * Pagination Methods:
     */
    public PageReference ToOpportunitySelect(){
        return Page.OrderOpportunitySelection;
    }

    public PageReference ToShipping(){
        if(String.isNotBlank(purchaseOrder.Opportunity__c)){
            opp = [Select Id, Name, PartnerAccount.Name, Primary_Contact__c, Account.Phone, AccountId From Opportunity Where id = :purchaseOrder.Opportunity__c];
        }
        return Page.OrderShipping;
    }

    public PageReference ToShippingWithoutOpp(){
        purchaseOrder.Opportunity__c = null;
        opp = null;
        return Page.OrderShipping;
    }

    public PageReference ToSystemsConfig() {

        if(purchaseOrder.Order_Type__c == alaCarte) {
            initModules();
            return Page.OrderAlaCarteConfiguration;
        }
        else if(purchaseOrder.Order_Type__c == equinox) {
            initModules();
            return Page.OrderEquinoxConfiguration;
        }
        else if(purchaseOrder.Order_Type__c == storageBundle) { //#116005357
            initModules();
            return Page.OrderStorageConfiguration;
        }
        else {
            return Page.OrderConfiguration;
        }
    }

    public PageReference ToOrderType(){
        return Page.OrderTypeSelection;
    }

    public PageReference callComponent1ControllerMethod() {
        return shippingSiteController.compControllerTest2();
    }

    public PageReference setAlaCarteOrderItems(){
        alacarteController.setJSON();
        return null;
    }

    /* RemoteActions and other queries
     * getOpportunities() - opportunity selection list
     * getShippingContacts() - ship to contacts for partner account
     * getDealerWarehouses() - shipping sites for the partner account - only 1 opportunity, all dealer warehouses, and installation sites
     * getAvailableTemplates() - retrieve avaliable order templates for smartpack configurations
     *
     *
     */
    @RemoteAction
    global static ResultMessage getOpportunities() {
        Id oppRecTypeId = SFDCSpecialUtilities.getRecordTypeIdsByDeveloperName(Opportunity.sObjectType).get('Home_Owner');
        Id partnerAcctId = [SELECT Contact.AccountId FROM User WHERE Id =: UserInfo.getUserId()].Contact.AccountId;
        List<String> oppStageFilter = Label.Cash_Orders_Opportunity_Filter.split(';');

        ResultMessage result = new ResultMessage();
        result.success = true;
        List<Opportunity> oList = new List<Opportunity>();
        try{
            oList = [Select Id, Name, StageName, CloseDate, Amount From Opportunity
                            WHERE PartnerAccountId =: partnerAcctId
                            AND CreatedDate = LAST_N_DAYS:365
                            AND RecordTypeId =: oppRecTypeId
                            AND StageName NOT IN: oppStageFilter
                            ORDER BY LastModifiedDate DESC];
            result.payloadMap.put('queriedRecords', oList);
        }catch (Exception e) {
            result.success = false;
            result.payload.add(e);
        }
        return result;
    }

    @RemoteAction
    global static ResultMessage getShippingContacts() {
        Id accId = [SELECT Contact.AccountId From User WHERE Id =: UserInfo.getUserId()].Contact.AccountId;

        ResultMessage result = new ResultMessage();
        result.success = true;
        List<Contact> conList = new List<Contact>();
        try {
            conList = [SELECT Id, Name, Phone
                       FROM Contact
                       WHERE AccountId =: accId AND Terminated__c = FALSE AND RecordType.Name = 'Partner' AND ((Oracle_Contact_id__c != null AND Oracle_Contact_Status__c = 'Active') OR  Oracle_Contact_id__c = null OR  Oracle_Contact_id__c = '') ORDER BY Name ASC]; //#126078665 changed where clause
             result.payloadMap.put('queriedRecords', conList);
        } catch(Exception e) {
            result.success = false;
            result.payload.add(e);
        }
        return result;
    }

    @RemoteAction
    global static ResultMessage getDealerWarehouses(String accId) {
        Id partnerId;
        String operatingUnit;
        for(User u : [SELECT Contact.AccountId, Contact.Account.Oracle_Operating_Unit__c From User WHERE Id =: UserInfo.getUserId()]) {
            partnerId = u.Contact.AccountId;
            operatingUnit = u.Contact.Account.Oracle_Operating_Unit__c;
        }

        ResultMessage result = new ResultMessage();
        result.success = true;
        List<Ship_To_Site__c> warehouses = new List<Ship_To_Site__c>();
        try {
            warehouses = [SELECT Id, Type__c, Address1__c, Address2__c, Address3__c, Address__c, City__c, Zip__c, State__c, Country__c,
                            RecordType.Name, Dealer_Account__c, Contact_Email__c, Contact_First_Name__c, Contact_Last_Name__c, Contact_Phone__c,
                            DeliverySiteType__c, DeliveryTimeEnd__c, DeliveryTimeStart__c, DriverAssist__c, DropTrailer__c, LiftGatePalletJack__c, SpecialEquipment__c
                          FROM Ship_To_Site__c
                          WHERE State__c != null AND ((Dealer_Account__c = :accId AND RecordType.Name = 'Opportunity')
                                                 OR (Dealer_Account__c =: partnerId AND SiteID__c > '0' AND Status__c = 'Active' AND Oracle_Operating_Unit__c = :operatingUnit
                                                    AND (RecordType.Name = 'Installation Site'
                                                        OR (RecordType.Name = 'Dealer Warehouse' AND (Residential_Customer_Account__c = '' OR Residential_Customer_Account__c = null)))))
                          ORDER BY LastModifiedDate DESC]; //#126076059 changed where clause

            result.payloadMap.put('queriedRecords', warehouses);
        } catch(Exception e) {
            result.success = false;
            result.payload.add(e);
        }
        return result;
    }

    //#126052379
    public List<Order_Template__c> templates {get;set;}
    public Boolean hasTemplates {get;set;}
    public Boolean hasPrevious {get;set;}
    public Boolean hasNext {get;set;}
    public Integer pageNo {get;set;}
    public List<Order_Template__c> tempTemplateList {get;set;}
    public Integer count {get;set;}

    public PageReference getAvailableTemplates(){

        templates = new List<Order_Template__c>();
        tempTemplateList = new List<Order_Template__c>();
        hasTemplates = false;
        count = 0;
        hasPrevious = false;
        hasNext = false;
        pageNo = 1;
        Set<Id> moduleIds = new Set<Id>(); //collection of matching modules

        try {
            //initModules - to get the available modules for the shipping location, if the module list contains the module on the template, add
            initModules();

            //break if no matching modules
            if(configurators == null)
                return null;

            Date todayDate = Date.today();
            Id partnerId = currentUser.Contact.AccountId;
            String query = 'SELECT Id, Name, Short_Description__c, Module_Configuration__c, Module_Configuration__r.Name, ' +
                'Module_Configuration__r.Current_Type__c, Module_Quantity__c, Racking_Opt_Out__c, ' +
                'Monitoring_Opt_Out__c, Racking_Type__c, Number_Of_Systems__c, Inverter_Manufacturer__c, ' +
                '(Select Id, Inverter_Configuration__c, Inverter_Configuration__r.Item__r.Item_Id__c, Quantity__c, ' +
                'Inverter_Configuration__r.Start_Date__c, Inverter_Configuration__r.End_Date__c ' +
                'FROM Order_Template_Lines__r)  FROM Order_Template__c WHERE Account__c =: partnerId ' +
                'AND Module_Configuration__c != NULL AND Active__c = TRUE ';
                if(purchaseOrder.Order_Type__c == 'Single System') {
                    query += 'AND Number_Of_Systems__c = 1 ';
                }
                query += 'ORDER BY CreatedDate DESC';

            //Retrieve templates
            for(Order_Template__c t : Database.query(query)) {
                for(Module_Configuration__c m : configurators.values()) {
                    if(t.Module_Configuration__c == m.Id) { //only get templates w/ modules available in master set
                        templates.add(t);
                        moduleIds.add(t.Module_Configuration__c);
                    }
                }
            }
            System.debug('total templates before: ' + templates.size());

            //Return out if nothing matches
            if(templates.isEmpty() || moduleIds.isEmpty())
                return null;

            //Pass to set for easier instance removal
            Set<Order_Template__c> templateSet = new Set<Order_Template__c>();
            templateSet.addAll(templates);
            System.debug('templateSet: ' + templateSet.size() + ' ' + templateSet);

            //get inverter data from util class for collection of templates for the specific module within the available master Ids
            Map<Id, Map<Id, Inverter_Configuration__c>> modToInverterMap = ProductConfigurationUtility.fetchInvertersGroupedByModule(moduleIds, masterIds);
            for(Order_Template__c t : templateSet) {
                for(Id i : modToInverterMap.keySet()) {
                    if(t.Module_Configuration__c == i) {
                        System.debug('Match on Module');

                        Map<Id, Inverter_Configuration__c> inverters = modToInverterMap.get(i);
                        if(inverters == null || inverters.isEmpty()) {
                            System.debug('no inverters, removing template');
                            templateSet.remove(t);
                        }
                        else {
                            for(Order_Template_Line__c otl : t.Order_Template_Lines__r) {
                                System.debug('otl: ' + otl);
                                if(otl.Inverter_Configuration__c == null) {
                                    System.debug('null inverter on template');
                                    templateSet.remove(t);
                                }
                                else if(inverters.containsKey(otl.Inverter_Configuration__c)
                                   && inverters.get(otl.Inverter_Configuration__c).Inverter_Manufacturer__c == t.Inverter_Manufacturer__c) {
                                       System.debug('Inverter Found, matching dates: ' + otl.Inverter_Configuration__c);
                                       System.debug('Start: ' + otl.Inverter_Configuration__r.Start_Date__c);
                                       System.debug('End: ' + otl.Inverter_Configuration__r.End_Date__c);
                                       if(otl.Inverter_Configuration__r.Start_Date__c > Date.today() || otl.Inverter_Configuration__r.End_Date__c < Date.today()) {
                                           System.debug('Start: ' + otl.Inverter_Configuration__r.Start_Date__c);
                                           System.debug('End: ' + otl.Inverter_Configuration__r.End_Date__c);
                                           templateSet.remove(t);
                                       }
                                } else if(inverters.containsKey(otl.Inverter_Configuration__c)
                                          && inverters.get(otl.Inverter_Configuration__c).Inverter_Manufacturer__c != t.Inverter_Manufacturer__c) {
                                              System.debug('Not a match on manufacturer');
                                              templateSet.remove(t);
                                          }
                                else {
                                    if(!inverters.containsKey(otl.Inverter_Configuration__c)) {
                                        System.debug('INVERTER NOT FOUND');
                                        templateSet.remove(t);
                                    }
                                }
                            }
                        }
                    }
                }
            }

            //Return out if nothing is left
            if(templateSet.isEmpty())
                return null;

            templates.clear();
            templates.addAll(templateSet);
            System.debug('TEMPLATES AFTER: ' + templates.size() + ' ' + templates);

            hasTemplates = true;
            count = templates.size();
            hasPrevious = false;
            pageNo = 1;
            Integer maxListSize = Math.min(5, templates.size());
            for(integer i = 0; i < maxListSize; i++)
                tempTemplateList.add(templates[i]);
            if(tempTemplateList.size() < 5) {
                hasNext = false;
            } else
                hasNext = true;
            return null;

        } catch(Exception e) {
            System.debug('template exception: ' + e);
            return null;
        }

        return null;
    }

    //Pagination
    public void Previous() {
        hasNext = true;
        tempTemplateList.clear();
        if(pageNo != 1) {
            pageNo  = pageNo - 1;
            if(pageNo == 1)
                hasPrevious = false;
            for(integer i = (pageNo -1) * 5; i < (pageNo * 5); i++) {
                tempTemplateList.add(templates[i]);
            }
        }
        else {
            hasPrevious = false;
            for(integer i = (pageNo -1) * 5; i < (pageNo * 5); i++) {
                tempTemplateList.add(templates[i]);
            }
        }
    }

    public void Next() {
        pageNo  = pageNo + 1;
        Integer pgNo;
        tempTemplateList.clear();

        if(math.mod(templates.size(), 5) == 0 ) {
            pgNo = templates.size()/5;
        }
        else
            pgNo = (templates.size()/5) + 1;

        if(pageNo == pgNo) {
            hasNext = false;
            for(integer i = (pageNo -1) * 5; i < templates.size(); i++) {
                tempTemplateList .add(templates[i]);
            }
        }
        else {
            for(integer i = (pageNo -1) * 5; i < (pageNo * 5); i++) {
                tempTemplateList.add(templates[i]);
            }
        }
        hasPrevious = true;
    }

    //#126052379
    public String selectedTemplateId {get;set;}
    public String hiddenTemplateId {get;set;}

    public PageReference applyTemplate() {

        String temp = ApexPages.currentPage().getParameters().get('selectedTemplateId');
        System.debug('TEMP PARAM: ' + temp);
        System.debug('HIDDEN: ' + hiddenTemplateId);
        if(String.isBlank(temp))
            return null; //prolly should throw error here...

        try {

            Order_Template__c selectedTemplate = [SELECT Id, Number_Of_Systems__c, Module_Quantity__c, Racking_Opt_Out__c, Monitoring_Opt_Out__c,
                                                 Racking_Type__c, Module_Configuration__c, Inverter_Manufacturer__c,
                                                (Select Id, Inverter_Configuration__c, Inverter_Configuration__r.Item__r.Item_Id__c, Quantity__c
                                                 FROM Order_Template_Lines__r
                                                 WHERE Inverter_Configuration__c != NULL)
                                          FROM Order_Template__c
                                          WHERE Id =: temp];
            System.debug('selectedTemplate: ' + selectedTemplate);

            if(selectedTemplate == null)
                return null;

            //Set PO values
            purchaseOrder.Number_of_Systems__c = selectedTemplate.Number_of_Systems__c;
            purchaseOrder.Module_Quantity__c = selectedTemplate.Module_Quantity__c;
            purchaseOrder.Racking_Opt_Out__c = selectedTemplate.Racking_Opt_Out__c;
            purchaseOrder.Monitoring_Opt_Out__c = selectedTemplate.Monitoring_Opt_Out__c;
            purchaseOrder.Racking_Type__c = selectedTemplate.Racking_Type__c;

            //Set module value
            selectedModuleTypeIdentifier = selectedTemplate.Module_Configuration__c;

            //build controller manufacturers
            buildManufacturers();

            //set selected manufacturer controller value
            selectedManufacturer = selectedTemplate.Inverter_Manufacturer__c;

            //build inverter options in the controller
            buildInverterTypes();

            //reset the order lines and add the selected lines
            orderLines = new List<Purchase_Order_Line__c>();

            for(Order_Template_Line__c line : selectedTemplate.Order_Template_Lines__r) {
                orderLines.add(new Purchase_Order_Line__c(Quantity__c = line.Quantity__c, Item_ID__c = line.Inverter_Configuration__r.Item__r.Item_Id__c));
            }

            //do calculations
            calculateInverterCapacity();
            calculateRacking();

        } catch(Exception e) {
            System.debug(LoggingLevel.ERROR, 'ERROR APPLYING TEMPLATE: ' + e);
        }

        return null;

    }

    public Boolean templateSuccess {get;set;}
    public PageReference saveTemplate() {

        templateSuccess = true;
        template.Account__c = currentUser.Contact.AccountId;
        template.Number_of_Systems__c = purchaseOrder.Number_of_Systems__c;
        template.Module_Quantity__c = purchaseOrder.Module_Quantity__c;
        template.Racking_Opt_Out__c = purchaseOrder.Racking_Opt_Out__c;
        template.Monitoring_Opt_Out__c = purchaseOrder.Monitoring_Opt_Out__c;
        template.Racking_Type__c = purchaseOrder.Racking_Type__c;
        template.Module_Configuration__c = selectedModuleTypeIdentifier;
        template.Inverter_Manufacturer__c = selectedManufacturer;
        template.Active__c = true;

        try {
            Database.SaveResult result = Database.insert(template);
            Id templateId = result.getId();

            try {
                List<Order_Template_Line__c> templateLines = new List<Order_Template_Line__c>();
                if(orderLines != null && !orderLines.isEmpty()) {
                    for(Purchase_Order_Line__c l : orderLines) {
                        if(l.Quantity__c != null && l.Quantity__c > 0) {
                            for(Inverter_Configuration__c i : inverterData.values()) {
                                if(i.Item__r.Item_Id__c == l.Item_Id__c) {
                                    templateLines.add(new Order_Template_Line__c(Order_Template__c = templateId, Inverter_Configuration__c = i.Id, Quantity__c = l.Quantity__c));
                                }
                            }
                        }
                    }
                }
                if(!templateLines.isEmpty())
                    insert templateLines;
            } catch(Exception e2) {
                System.debug('Template Line Failure: ' + e2);
                templateSuccess = false;
                delete [Select Id FROM Order_Template__c WHERE Id =: templateId];
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error saving template lines: ' + e2.getMessage());
                ApexPages.addMessage(errorMsg);
                return null;
            }

        } catch(Exception e) {
            templateSuccess = false;
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error saving template: ' + e.getMessage());
            ApexPages.addMessage(errorMsg);
            return null;
        }

        return null;
    }

    /* DML & Utility Methods
     * initOrderLines() - create blank order line for configuration table
     * saveFromShipping() - upsert purchase order record and transition from shipping to config page
     * saveFromOrderConfig() - upsert purchase order record and transition from config page to final confirmation
     * submitOrder()
     */
    public void initOrderLines() {
        for(integer i = 0; i < 1; i++) {
            orderLines.add(new Purchase_Order_Line__c(Item_ID__c = '', Quantity__c = 1));
        }
    }

    public Boolean validateSystemsCalculations() {
        Decimal systemSize = getSystemSize();

        Boolean isError = false;

        //Number of systems validation
        if(purchaseOrder.Number_of_Systems__c == null || purchaseOrder.Number_of_Systems__c < 1) {
            isError = true;
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.System_Count_Error);
            ApexPages.addMessage(errorMsg);
        }

        //No selected module validation
        if(selectedModuleTypeIdentifier == null) {
            isError = true;
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.Module_Quantity_Error);
            ApexPages.addMessage(errorMsg);
        }

        //Racking validation
        if(!purchaseOrder.Racking_Opt_Out__c && purchaseOrder.Racking_Type__c == null) {
            isError = true;
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.Racking_Type_Validation);
            ApexPages.addMessage(errorMsg);
        }

        //DC validations
        if(configurators != null && configurators.get(selectedModuleTypeIdentifier) != null && configurators.get(selectedModuleTypeIdentifier).Current_Type__c != 'AC') {

            if(selectedManufacturer == null) {
                isError = true;
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.Inverter_Qty_Validation);
                ApexPages.addMessage(errorMsg);
            }

            if(orderLines == null || orderLines.isEmpty()) {
                isError = true;
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.Inverter_Qty_Validation);
                ApexPages.addMessage(errorMsg);
            }

            if(orderLines != null && !orderLines.isEmpty()) {
                Decimal inverterQty = 0;
                for(Purchase_Order_Line__c oline : orderLines) {
                    if(oline.Quantity__c != null && oline.Quantity__c != 0 && oline.Item_ID__c != null && oline.Item_ID__c != '')
                        inverterQty += oline.Quantity__c;
                }
                if(inverterQty == 0) {
                    isError = true;
                    ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.Inverter_Qty_Validation);
                    ApexPages.addMessage(errorMsg);
                } else if (purchaseOrder.Number_of_Systems__c > inverterQty) {
                    isError = true;
                    ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.Max_System_Count_Validation);
                    ApexPages.addMessage(errorMsg);
                }
            }

            //#116005357
            for(OrderAppUtility.RatioWrapper w : flexiRatios) {
                if(purchaseOrder.System_Size__c <= w.upperLimit && purchaseOrder.System_Size__c >= w.lowerLimit) {
                    if(invModuleRatio > w.ratioLimit) {
                        isError = true;
                        ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.Inv_Mod_Ratio_Validation);
                        ApexPages.addMessage(errorMsg);
                    }
                }
            }
        }

        //AC Validations
        if(configurators != null && configurators.get(selectedModuleTypeIdentifier) != null && configurators.get(selectedModuleTypeIdentifier).Current_Type__c == 'AC') {
            //number of systems validation
            if(purchaseOrder.System_Size__c != null && purchaseOrder.Number_of_Systems__c != null) {
                Decimal avgSystemSize = Decimal.valueOf(Label.Average_System_Size);
                Decimal maxSystems = purchaseOrder.System_Size__c.divide(avgSystemSize,0,System.RoundingMode.UP);

                if(purchaseOrder.Number_of_Systems__c > maxSystems) {
                    isError = true;
                    ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, (Label.AC_Validation_part_1 + ' ' + maxSystems + ' ' + Label.AC_Validation_part_2));
                    ApexPages.addMessage(errorMsg);
                }
            }
        }

        //#116005357 - HI STORAGE VALIDATIONS
        if(purchaseOrder.Order_Type__c == storageBundle) {
            if(String.isBlank(selectedStorageId)) {
                isError = true;
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, (Label.Storage_Item_Required_Validation));
                ApexPages.addMessage(errorMsg);
            }

            if(purchaseOrder.Storage_Quantity__c == null) {
                isError = true;
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, (Label.Storage_Quantity_Validation));
                ApexPages.addMessage(errorMsg);
            }

            if(purchaseOrder.System_Size__c < Integer.valueOf(Label.Min_Storage_System_Size))  {
                 isError = true;
                 ApexPages.message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, (Label.Storage_System_Size_Validation + ' ' + Label.Min_Storage_System_Size + ' kW.'));
                 ApexPages.addMessage(errorMsg);
            }
        }

        System.debug('end validations isError: ' + isError);
        return isError;
    }

    public Boolean validateAlaCarteQuantities() {
        Boolean isError = false;
        if(alacarteController != null && alacarteController.selProductItems != null && alacarteController.selProductItems.size() > 0) {
            for(AlaCarteController.PriceItemWrapper w : alacarteController.selProductItems) {
                if(w.error != null) {
                   isError = true;
                   ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.A_La_Carte_Qty_Validation);
                   ApexPages.addMessage(errorMsg);
                    break;
                }
            }
        }
        else
            return isError;
        return isError;
    }

    public PageReference saveFromShipping() {

        if(purchaseOrder.Name == null) {
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.POWizardValidationErrorRequiredPONumber);
            ApexPages.addMessage(errorMsg);
        }

        if(!String.isBlank(reqDeliveryDate)){
            String[] crdSplit = reqDeliveryDate.split('/');
             Date inputDate = Date.newInstance(Integer.valueOf(crdSplit[2]),Integer.valueOf(crdSplit[0]),Integer.valueOf(crdSplit[1]));
            purchaseOrder.Requested_Delivery_Date__c = inputDate;
        }

        if(purchaseOrder.Requested_Delivery_Date__c == null) {
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.POWizardValidationErrorRequiredDeliveryDate);
            ApexPages.addMessage(errorMsg);
        }

        if(ApexPages.hasMessages()) return null;

        try {
            //R.Alega - Case 00675662 - Restrict duplicate PO Number for current Partner logged in only and not across all PO.
            for(Purchase_Order__c po : [SELECT Name FROM Purchase_Order__c
                                        WHERE Name != null AND Name =: purchaseOrder.Name
                                        AND Id !=: purchaseOrder.Id
                                        AND Dealer_Account__c =: currentUser.Contact.AccountId]) {
                if(po.Name == purchaseOrder.Name) {
                    ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.POWizardDuplicatePONumber);
                    ApexPages.addMessage(errorMsg);
                    break;
                }
            }
            if(ApexPages.hasMessages()) return null;

            if(purchaseOrder.Order_Status__c == null)
                purchaseOrder.Order_Status__c = 'New';
            if(bts != null && purchaseOrder.Bill_to_Site__c == null)
                purchaseOrder.Bill_to_Site__c = bts.Id;

            //set the sts to the sts attached to the record, used when creating new site record
            //clone if opportunity site, attach to partner, record type installation site - fix for failing opp sites in oracle
            try {
                Id installationSiteId = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Ship_to_Site__c.sobjectType).get('Installation_Site');
                Id opportunitySiteId = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Ship_to_Site__c.sObjectType).get('Opportunity');
                if(purchaseOrder.Ship_to_Site__c != null) {
                    sts = [SELECT Id, RecordTypeId, Address__c, Address1__c, Address2__c, Address3__c, City__c, State__c, Country__c, Zip__c,
                                    Oracle_County__c, Dealer_Account__c, IsDuplicate__c, IsDuplicateId__c, DeliverySiteType__c, DeliveryTimeEnd__c,
                                    DeliveryTimeStart__c, DriverAssist__c, DropTrailer__c, LiftGatePalletJack__c, SpecialEquipment__c
                           FROM Ship_To_Site__c
                           WHERE Id =: purchaseOrder.Ship_To_Site__c];

                    if(sts.RecordTypeId == opportunitySiteId) {
                        Ship_to_Site__c newInstallSite = sts.clone(false, true, false, false);
                        newInstallSite.Dealer_Account__c = currentUser.Contact.AccountId;
                        newInstallSite.RecordTypeId = installationSiteId;
                        Database.SaveResult res = Database.insert(newInstallSite);
                        Id newStsId = res.getId();
                        purchaseOrder.Ship_to_Site__c = newStsId;
                        // #127348167
                        OrderAppUtility.saveShippingSiteToOracle(newStsId);
                        sts = [SELECT Id, RecordTypeId, Address__c, Address1__c, Address2__c, Address3__c, City__c, State__c, Country__c, Zip__c,
                                    Oracle_County__c, Dealer_Account__c, IsDuplicate__c, IsDuplicateId__c, DeliverySiteType__c, DeliveryTimeEnd__c,
                                    DeliveryTimeStart__c, DriverAssist__c, DropTrailer__c, LiftGatePalletJack__c, SpecialEquipment__c
                                FROM Ship_To_Site__c
                                WHERE Id =: purchaseOrder.Ship_to_Site__c];
                    }

                    // make sure sts isn't a duplicate
                    if(sts.IsDuplicate__c) {
                        fixDuplicateSTS();
                    }
                }

            } catch(Exception e) {}

            //upsert record - insert on first pass, but update/upsert if page is revisited
            upsert purchaseOrder;

            // #133369091
            // check to see if ship to contact has oracle id
            if(String.isNotBlank(purchaseOrder.Ship_To_Contact__c)) {
                try {
                   shipContact = [SELECT Id, Name, Phone, FirstName, LastName, Email, MobilePhone, Primary__c, Oracle_Contact_id__c, Account.Oracle_Account_Number__c FROM Contact WHERE Id =: purchaseOrder.Ship_To_Contact__c];

                    if(String.isBlank(shipContact.Oracle_Contact_id__c) && isRealTimeOrder) {
                        String stc = JSON.serialize(shipContact);
                        System.debug('ship to contact: ' + stc);
                        OracleOrderUtility.createOracleContact(stc, 'SHIP_TO', purchaseOrder.Id);
                    }
                } catch(Exception e2) {
                    SpectrumDebugUtility.createExceptionLog(e2.getMessage(), e2.getStackTraceString(), 'SO Create Oracle Contact Error', purchaseOrder.Id);
                }
            }

            if(purchaseOrder.Order_Type__c == alaCarte) {
                return Page.OrderAlaCarteConfiguration;
            }
            else if(purchaseOrder.Order_Type__c == equinox) {
                purchaseOrder.Monitoring_Quantity__c = 0; //resetting if ordering type is changed to equinox from another
                return Page.OrderEquinoxConfiguration;
            }
            //#116005357
            else if(purchaseOrder.Order_Type__c == storageBundle) {
                getFlexiRatios();
                return Page.OrderStorageConfiguration;
            }
            else {
                getFlexiRatios();
                return Page.OrderConfiguration;
            }
        } catch(Exception e) {
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(errorMsg);
        }
        return null;
    }

    public PageReference saveFromOrderConfig() {

        if(purchaseOrder.Order_Type__c != alacarte && purchaseOrder.Order_Type__c != equinox) {
            if(configurators != null && selectedModuleTypeIdentifier != null && configurators.containsKey(selectedModuleTypeIdentifier))
                purchaseOrder.Module_Type__c = configurators.get(selectedModuleTypeIdentifier).Name;

            if(purchaseOrder.Number_Of_Systems__c == null) {
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.Number_of_Systems_Validation);
                ApexPages.addMessage(errorMsg);
            }
            if(purchaseOrder.Module_Type__c == null || purchaseOrder.Module_Quantity__c == null) {
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.Min_Module_Qty_Validation);
                ApexPages.addMessage(errorMsg);
            }
            if(!purchaseOrder.Racking_Opt_Out__c && purchaseOrder.Racking_Type__c == null) {
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.Racking_Type_Validation);
                ApexPages.addMessage(errorMsg);
            }
        }

        if(returnLines == null || returnLines.isEmpty()) {
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.Priced_Item_Validation);
            ApexPages.addMessage(errorMsg);
        }
        if(ApexPages.hasMessages()) return null;

        try {
            if(String.isNotBlank(purchaseOrder.Ship_to_Site__c)) {
                try {
                    sts = [SELECT Id, RecordTypeId, Address__c, Address1__c, Address2__c, Address3__c, City__c, State__c, Country__c, Zip__c,
                                Oracle_County__c, Dealer_Account__c, IsDuplicate__c, IsDuplicateId__c, DeliverySiteType__c, DeliveryTimeEnd__c,
                                DeliveryTimeStart__c, DriverAssist__c, DropTrailer__c, LiftGatePalletJack__c, SpecialEquipment__c
                            FROM Ship_To_Site__c
                            WHERE Id =: purchaseOrder.Ship_to_Site__c];

                    bts = [SELECT Id, Address1__c, City__c, State__c, Zip__c FROM Bill_To_Site__c WHERE Id =: purchaseOrder.Bill_to_Site__c];
                } catch(Exception e) {
                    System.debug('STS ERROR: ' + e.getMessage());
                }
            }
            // make sure sts isn't a duplicate
            if(sts.IsDuplicate__c) {
                fixDuplicateSTS();
            }
            upsert purchaseOrder;

            if(String.isNotBlank(purchaseOrder.Ship_To_Contact__c)) {
                try {
                    // #114709951
                    // shipContactName = [SELECT Name FROM Contact WHERE Id =: purchaseOrder.Ship_To_Contact__c].Name;
                   shipContact = [SELECT Name, Phone FROM Contact WHERE Id =: purchaseOrder.Ship_To_Contact__c];
                } catch(Exception e2) {
                    System.debug('CONTACT NAME ERROR: ' + e2.getMessage());
                }
            }
            return Page.OrderFinalConfirmation;
        } catch(Exception e) {
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(errorMsg);
        }
        return null;
    }


    //Submit the order - final page
    //#121852503 - Remove Ok to Ship
    // #114921295 - removed ship to method validation - 07/10/2016
    public PageReference submitOrder() {

        if(purchaseOrder.Bill_to_Site__c != null && purchaseOrder.Ship_to_Site__c != null &&  purchaseOrder.Dealer_Account__c != null && purchaseOrder.Accept_Terms__c) {

            if(purchaseOrder.Order_Status__c != null && purchaseOrder.Order_Status__c == 'New')
                purchaseOrder.PO_Submit_Date__c = Datetime.valueOfGMT(string.valueof(Datetime.now()));

            // #128988357 - get the interface status from the custom metadata object to turn on/off real time ordering (SOA will see this order if it's set to New)
            purchaseOrder.Interface_Status__c = [SELECT Interface_Status__c FROM OracleRealTimeCashOrderOnOffSwitch__mdt WHERE DeveloperName = 'Default' LIMIT 1].Interface_Status__c;

            if(String.isNotBlank(purchaseOrder.Interface_Status__c)) {
                //Updating Interface Status to New and Order Status to submitted to kick off SOA integration when the order is Submitted.
                purchaseOrder.Order_Status__c = 'Submitted';
            }

            try {
                List<Purchase_Order_Line__c> linesToMake = new List<Purchase_Order_Line__c>();
                Integer i=1;

                Set<String> orcItems = new Set<String>();
                if(returnLines != null && returnLines.size() > 0) {
                    for(ReturnItem itm : returnLines) {
                        orcItems.add(itm.ordered_item);
                    }

                    Map<String, Id> orcIdMap = new Map<String, Id>();
                    for(Item__c item : [SELECT Id, Item_Id__c FROM Item__c WHERE Item_Id__c IN: orcItems]) {
                        orcIdMap.put(item.Item_Id__c, item.Id);
                    }

                    for(ReturnItem itemWrap : returnLines){
                        Purchase_Order_Line__c l = new Purchase_Order_Line__c();
                        l.Purchase_Order__c = purchaseOrder.Id;
                        l.Order_Line_Number__c = String.valueof(i++);
                        l.Item_Description__c = itemWrap.item_description;
                        l.Item_ID__c = itemWrap.ordered_item;
                        l.Oracle_Item_ID__c = orcIdMap.get(itemWrap.ordered_item);//sangita added for OrderIntegration service
                        l.Quantity__c = Integer.valueOf(itemWrap.ordered_quantity);
                        l.smartpack_item__c= itemwrap.product_line_type=='Bundle'?true:false;//sangita added


                        linesToMake.add(l);
                    }
                }
                insert linesToMake;
            } catch(Exception le) {
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.Error, le.getMessage());
                ApexPages.addMessage(errorMsg);
            }

            try {
                sts = [SELECT Id, RecordTypeId, Address__c, Address1__c, Address2__c, Address3__c, City__c, State__c, Country__c, Zip__c,
                            Oracle_County__c, Dealer_Account__c, IsDuplicate__c, IsDuplicateId__c, DeliverySiteType__c, DeliveryTimeEnd__c,
                            DeliveryTimeStart__c, DriverAssist__c, DropTrailer__c, LiftGatePalletJack__c, SpecialEquipment__c
                        FROM Ship_To_Site__c
                        WHERE Id =: purchaseOrder.Ship_to_Site__c];
                // make sure sts isn't a duplicate
                if(sts.IsDuplicate__c) {
                    fixDuplicateSTS();
                }

                // #130249379
                String si = '';
                // check to see if special instructions has input
                if(String.isNotBlank(purchaseOrder.Special_Instructions__c) && purchaseOrder.Special_Instructions__c.contains('null')) {
                    purchaseOrder.Special_Instructions__c = null;
                }
                if(String.isBlank(purchaseOrder.Special_Instructions__c) && shipContact != null && String.isNotBlank(shipContact.Name)) {
                    purchaseOrder.Special_Instructions__c = '*** Contact - ' + shipContact.Name + ' ***';
                }
                if(String.isNotBlank(purchaseOrder.Special_Instructions__c)) {
                    si = purchaseOrder.Special_Instructions__c.escapeHtml4();
                }
                // check if delivery info is set on sts
                if(String.isNotBlank(sts.DeliveryTimeStart__c) || String.isNotBlank(sts.DeliveryTimeEnd__c) || String.isNotBlank(sts.DeliverySiteType__c) || String.isNotBlank(sts.DriverAssist__c) || String.isNotBlank(sts.DropTrailer__c) || String.isNotBlank(sts.LiftGatePalletJack__c) || String.isNotBlank(sts.SpecialEquipment__c)) {

                    String di = OrderAppUtility.createSpecialInstructionString(sts.DeliveryTimeStart__c, sts.DeliveryTimeEnd__c, sts.DeliverySiteType__c, sts.DriverAssist__c, sts.DropTrailer__c, sts.LiftGatePalletJack__c, sts.SpecialEquipment__c);

                    if(String.isNotBlank(si) && si.containsNone('|')) {
                        purchaseOrder.Special_Instructions__c = di + ' | ' + si;
                    } else if(String.isNotBlank(si) && si.contains('|')) {
                        purchaseOrder.Special_Instructions__c = si;
                    } else purchaseOrder.Special_Instructions__c = di;
                }

                upsert purchaseOrder;

            } catch(exception e) {
                System.debug('po submit error: ' + e.getMessage());
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.Error, e.getMessage());
                ApexPages.addMessage(errorMsg);
            }
            PageReference pg = new PageReference('/apex/OrderSubmissionDetails?POID='+purchaseOrder.Id);
            return pg.setRedirect(true);
        } else {
            if(purchaseOrder.Dealer_Account__c == null){
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardValidationErrorRequiredDealerAcc);
                ApexPages.addMessage(errorMsg);
            }
            if(purchaseOrder.Name == null){
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardValidationErrorRequiredPONumber);
                ApexPages.addMessage(errorMsg);
            }
            if(purchaseOrder.Bill_to_Site__c == null){
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardValidationErrorRequiredBillToSite);
                ApexPages.addMessage(errorMsg);
            }

            if(purchaseOrder.Ship_to_Site__c == null){
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardValidationErrorRequiredShipsiteAddress);
                ApexPages.addMessage(errorMsg);
            }
            if(!purchaseOrder.Accept_Terms__c){
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardTnC);
                ApexPages.addMessage(errorMsg);
            }
            purchaseOrder.Order_Wizard_Step__c='Step 4';
            return null;
        }
    }

    /* Callout methods
     * generateLogging(String service, String outboundReq, String inboundRes) - Spectrum logging of callouts
     * doCallout() - the callout
     * buildRepsonseList(String resultString) - parse response
     * getPayloadJSON() - build the callout string
     * ReturnItem - custom response wrapper class
     */

    private void generateLogging(String service, String outboundReq, String inboundRes) {
        try {
            Sunpower_Spectrum_Debug_Log__c log = new Sunpower_Spectrum_Debug_Log__c();
            log.JSON_Payload__c = outboundReq.length() > 131072 ? outboundReq.left(131071) : outboundReq;
            log.Response__c = inboundRes.length() > 131072 ? inboundRes.left(131071) : inboundRes;
            log.Service__c = service;
            log.Purchase_Order__c = purchaseOrder.Id;

            insert log;
        } catch (Exception e) {}
    }

    public PageReference doCallout(){
        //Do systems validation before calling out
        Boolean isError = false;

        if(purchaseOrder.Order_Type__c != alaCarte && purchaseOrder.Order_Type__c != equinox) {

            if(validateSystemsCalculations() == true) return null;

            calculateRacking();

            if(configurators.get(selectedModuleTypeIdentifier).Current_Type__c == 'AC') {//build AC items

                if(orderLines != null && !orderLines.isEmpty())
                    orderLines.clear();

                if(purchaseOrder.Monitoring_Opt_out__c) {
                    if(monitoringLines != null && !monitoringLines.isEmpty()) {
                        monitoringLines.clear();
                    }
                }
                else {
                    getMonitoringForAC();
                }

            } else
                getMonitoring();

        }

        //validate ala carte quantities for all order types
        if(validateAlaCarteQuantities() == true) return null;

        //build disconnect items for items in list being priced
        buildDisconnects();

        //#116005357
        if(purchaseOrder.Order_Type__c == storageBundle && String.isNotBlank(selectedStorageId))
            buildStorageItems();

        //TODO: error handling
        System.debug('calling out!');
        String url = 'callout:PricingAPI';
        String reqBody = getPayloadJSON();
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setHeader('content-type', 'application/json');
        req.setTimeout(110000);
        req.setBody(reqBody);
        try {
            HttpResponse res = h.send(req);

            try {
                generateLogging('Pricing API', (String.valueOf(req) + req.getBody()), (String.valueOf(res) + res.getBody()));
            } catch (Exception e) {}

            if(res.getStatusCode() != 200) {
                String temp = res.getBody().length() > 32000 ? res.getBody().substring(0, 32000) : res.getBody();
                generateExceptionLog(res.getStatusCode() + res.getStatus(), temp);
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.Cash_Orders_API_Connection_Error);//TODO replace
                ApexPages.addMessage(errorMsg);
            }
            else {
                buildRepsonseList(res.getBody());
            }

        }
        catch(CalloutException ce) {
            generateExceptionLog(ce.getMessage(), ce.getStackTraceString());
            if(isCalloutError != null && isCalloutError == true) {
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, errorFromORC);//TODO: replace
                ApexPages.addMessage(errorMsg);
            } else {
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.Cash_Orders_API_Connection_Error);
                ApexPages.addMessage(errorMsg);
            }
        }

        catch(Exception e) {
            generateExceptionLog(e.getMessage(), e.getStackTraceString());
            if(isCalloutError != null && isCalloutError == true) {
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, errorFromORC);
                ApexPages.addMessage(errorMsg);
            } else {
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.Cash_Orders_General_Exception);
                ApexPages.addMessage(errorMsg);
            }
        }
        return null;
    }

    public void generateExceptionLog(String message, String stackTrace) {
        try {
            Exception_Log__c exLog = new Exception_Log__c();
            exLog.Purchase_Order__c = purchaseOrder.Id;
            exLog.Stack_Trace__c = stackTrace;
            exLog.Error_Message__c = message;
            insert exLog;

        } catch (Exception e) { System.debug('Exception logging failure!'); }
    }

    public void buildRepsonseList(String resultString){

        isCalloutError = false;
        errorFromORC = '';
        returnLines = new List<ReturnItem>();
        JSONParser statusParser = JSON.createParser(resultString);
        while(statusParser.nextToken() != null){
            if(statusParser.getCurrentName() == 'sales_order') {
                while(statusParser.nextToken() != null) {
                    if(statusParser.getCurrentName() == 'status') {
                        System.debug(statusParser.getText());
                        if(statusParser.getText() == 'E' || statusParser.getText() == '' || statusParser.getText() == null) {
                            isCalloutError = true;
                        }
                    }
                    if(statusParser.getCurrentName() == 'status_message') {
                        JSONToken nextToken = statusParser.nextToken();
                        System.debug('next: ' + nextToken);
                        errorFromORC = statusParser.getText();
                        if(errorFromORC == null || String.isBlank(errorFromORC))
                            errorFromOrc = Label.Cash_Orders_API_Connection_Error;
                        System.debug('ORC ERROR: ' + errorFromORC);
                        if(isCalloutError == true) Integer x = 1/0;
                    }
                }
            }
        }

        JSONParser parser = JSON.createParser(resultString);
        while(parser.nextToken() != null){
            if(parser.getCurrentName() == 'order_line' && parser.getCurrentToken() == JSONToken.FIELD_NAME){

                JSONToken nextToken = parser.nextToken();
                System.debug(nextToken);
                if(nextToken == JSONToken.START_ARRAY){
                    System.debug('MORE THAN ONE ITEM');
                    returnLines = (List<ReturnItem>) parser.readValueAs(List<ReturnItem>.class);
                    System.debug(returnLines);
                }else if(nextToken == JSONToken.START_OBJECT){
                    System.debug('ONLY ONE ITEM');
                    ReturnItem item = (ReturnItem) parser.readValueAs(ReturnItem.class);
                    returnLines.add(item);
                    System.debug(item);
                }
            }else if(parser.getCurrentName() == 'order_total' && parser.getCurrentToken() == JSONToken.FIELD_NAME){
                parser.nextToken();
                totalPriceFormatted = getFormatted(parser.getText());
            }
        }
        //Set proper decimal value for prices
        for(ReturnItem i: returnLines){
            i.unit_priceFORMATTED = getFormatted(i.adjusted_unit_price);
            i.extended_priceFORMATTED = getFormatted(i.extended_price);
        }
    }

    //this will cause some issues with input strings with more than 2 decimal places.  Dealing with currency so hopefully not an issue
    public String getFormatted(STring str){
        Decimal d = (str == '' ? 0.00 : Decimal.valueOf(str));
        String s;
        if(d < 0){
            s = (d - 0.001).format();
        }else{
            s = (d + 0.001).format();
        }
        return s.substring(0, s.length()-1);
    }

    public class ReturnItem {
        public String lineNumber {get; set;}
        public String item_description {get; set;}
        public String ordered_item {get; set;}
        public String ordered_quantity {get; set;}
        public String adjusted_unit_price {get; set;}
        public String unit_priceFORMATTED {get; set;}
        public String extended_price {get; set;}
        public String extended_priceFORMATTED {get; set;}
        public Decimal unit_priceDEC {get; set;}
        public Decimal extended_priceDEC {get; set;}
        public String product_line_type {get;set;}
    }

    public String getPayloadJSON(){

        System.debug('building Payload');

        purchaseOrder.Inverter_Manufacturer__c = selectedManufacturer;

        String systemCount = String.valueOf(purchaseOrder.Number_of_Systems__c);
        if(purchaseOrder.Order_Type__c == alaCarte) {
            systemCount = '0';
        }
        String rackingOptOut = 'N';
        if(purchaseOrder.Racking_Opt_Out__c)
            rackingOptOut = 'Y';

        //Udpated - PT ID #114753873
        String monitoringOptOut = 'N';
        if(blockMonitoringOptOut) {
            purchaseOrder.Monitoring_Opt_Out__c = false;
            purchaseOrder.Monitoring_Quantity__c = purchaseOrder.Number_of_Systems__c;
        } else if(purchaseOrder.Order_Type__c == equinox) {
            purchaseOrder.Monitoring_Opt_Out__c = false;
        } else if(purchaseOrder.Monitoring_Opt_out__c || purchaseOrder.Monitoring_Quantity__c == null || purchaseOrder.Monitoring_Quantity__c == 0) {
            monitoringOptOut = 'Y';
        }

        //#116005357
        if(purchaseOrder.Order_Type__c == storageBundle && String.isNotBlank(selectedStorageId)) {
            purchaseOrder.Storage__c = storageMap.get(selectedStorageId).Item__r.Description__c == null ? '' : storageMap.get(selectedStorageId).Item__r.Description__c;
        }

        String transactionUUID = purchaseOrder.Id == null ? OrderAppUtility.generateGUID() : purchaseOrder.Id;

        String orderLinesString = '';

        //Systems items
        if(purchaseOrder.Order_Type__c != null && purchaseOrder.Order_Type__c != alaCarte) {
            //module line
            orderLinesString += '{"ordered_item":"'+configurators.get(selectedModuleTypeIdentifier).Item__r.Item_Id__c+'","ordered_quantity":"'+purchaseOrder.Module_Quantity__c+'","product_line_type":"Bundle"},';

            //Inverters
            if(purchaseOrder.Order_Type__c != equinox) {
                if(orderLines != null && orderLines.size() > 0) {
                    for(Purchase_Order_Line__c invLine : orderLines) {
                        orderLinesString += '{"ordered_item":"'+invLine.Item_ID__c+'","ordered_quantity":"'+invLine.Quantity__c+'","product_line_type":"Bundle"},';
                    }
                }
            }

            //monitoring
            if(monitoringLines != null && purchaseOrder.Monitoring_Quantity__c != null && purchaseOrder.Monitoring_Quantity__c > 0) {
                for(Purchase_Order_Line__c poLine : monitoringLines) {
                    if(poLine.Quantity__c != null && poLine.Quantity__c > 0 && poLine.Item_ID__c != null)
                        orderLinesString += '{"ordered_item":"'+poLine.Item_ID__c+'","ordered_quantity":"'+poLine.Quantity__c+'","product_line_type":"Bundle"},';
                }
            }

            //racking line
            if(!purchaseOrder.Racking_Opt_Out__c) {
                calculateRacking();//recalculate the racking qty and update lines
                for(Purchase_Order_Line__c rackingOrderLine : rackingLines) //updated PT ID #114754241
                    orderLinesString += '{"ordered_item":"'+rackingOrderLine.Item_Id__c+'","ordered_quantity":"'+rackingOrderLine.Quantity__c+'","product_line_type":"Bundle"},';
            }

            //#116005357
            if(purchaseOrder.Order_Type__c == storageBundle && storageLines != null && !storageLines.isEmpty()) {
                for(Purchase_Order_Line__c storageItemLine : storageLines) {
                    orderLinesString += '{"ordered_item":"'+storageItemLine.Item_ID__c+'","ordered_quantity":"'+storageItemLine.Quantity__c+'","product_line_type":"Bundle"},';
                }
            }

        }

        //disconnect items
        if(disconnectLines != null && !disconnectLines.isEmpty()) {
            String lineType = 'Bundle';

            for(Purchase_Order_Line__c dcLine : disconnectLines) {
                if(dcLine.Item_Type__c == 'Ala Carte')
                    lineType = 'A La Carte';
                orderLinesString += '{"ordered_item":"'+dcLine.Item_ID__c+'","ordered_quantity":"'+dcLine.Quantity__c+'","product_line_type":"' + lineType+ '"},';
            }
        }

        //ala carte items
        if(alacarteController != null && alacarteController.selProductItems != null && alacarteController.selProductItems.size() > 0) {
            for(AlaCarteController.PriceItemWrapper itemWrap: alacarteController.selProductItems){
                orderLinesString += '{"ordered_item":"'+itemWrap.itemID+'","ordered_quantity":"'+itemWrap.Qty+'","product_line_type":"A La Carte"},';
            }
        }

        String finalString = orderLinesString.removeEnd(',');

        String payload = '{"pricing_order_request":{';
        payload +=          '"message_header":{"source_system_id":"SFDC","transaction_id":"' + transactionUUID + '"},';//transaction id replace with po name
        payload +=          '"sales_order":{';
        payload +=              '"order_header":{';
        payload +=                  '"cust_account_number":"' + currentUser.Contact.Account.Oracle_Account_Number__c + '",';//replace with orc acct # from user/contact/account
        payload +=                  '"country":"' + currentUser.Contact.Country_Domain__c.substringAfterLast('-').toUpperCase() + '",';//substring user/contact/account country domain
        payload +=                  '"sales_type":"PURCHASE",';
        payload +=                  '"channel_type":"RVAR",';
        payload +=                  '"inverter_type":"' + purchaseOrder.Inverter_Manufacturer__c + '",';
        payload +=                  '"ship_to_state_code":"' + sts.State__c + '",';//Ship to site state
        payload +=                  '"system_count":"'+systemCount+'",';
        payload +=                  '"racking_opt_out":"'+rackingOptOut+'",';//needs to be dynamic
        payload +=                  '"monitoring_opt_out":"'+monitoringOptOut+'"';//needs to be dynamic
        payload +=              '},';
        payload +=              '"order_lines":{"order_line":['+finalString+']}}}}';

        return payload;
    }


    //Method added per specification of Pivitol Tracker ID# ##114754041
    public PageReference savePDF() {

        PageReference pdf = Page.SystemsOrderPDF;
        Blob body;

        try {
            body = pdf.getContentAsPDF();
        } catch(Exception e) {
            body = Blob.valueOf('PDF Generation Error');
        }

        return pdf;
    }

    public PageReference fixDuplicateSTS() {
        purchaseOrder.Ship_to_Site__c = sts.IsDuplicateId__c;
        // get the delivery instructions from the duplicate site and apply to the old one (if it has values)
        if(String.isNotBlank(sts.DeliveryTimeStart__c) || String.isNotBlank(sts.DeliveryTimeEnd__c) || String.isNotBlank(sts.DeliverySiteType__c) || String.isNotBlank(sts.DriverAssist__c) || String.isNotBlank(sts.DropTrailer__c) || String.isNotBlank(sts.LiftGatePalletJack__c) || String.isNotBlank(sts.SpecialEquipment__c)) {
            Ship_to_Site__c originalSTS = new Ship_To_Site__c();
            originalSTS.Id = purchaseOrder.Ship_to_Site__c;
            originalSTS.DeliveryTimeStart__c = sts.DeliveryTimeStart__c;
            originalSTS.DeliveryTimeEnd__c = sts.DeliveryTimeEnd__c;
            originalSTS.DeliverySiteType__c = sts.DeliverySiteType__c;
            originalSTS.DriverAssist__c = sts.DriverAssist__c;
            originalSTS.DropTrailer__c = sts.DropTrailer__c;
            originalSTS.LiftGatePalletJack__c = sts.LiftGatePalletJack__c;
            originalSTS.SpecialEquipment__c = sts.SpecialEquipment__c;
            update originalSTS;
        }

        // delete the duplicate site
        delete sts;
        // reset sts var
        sts = [SELECT Id, RecordTypeId, Address__c, Address1__c, Address2__c, Address3__c, City__c, State__c, Country__c, Zip__c,
                    Oracle_County__c, Dealer_Account__c, IsDuplicate__c, IsDuplicateId__c, DeliverySiteType__c, DeliveryTimeEnd__c,
                    DeliveryTimeStart__c, DriverAssist__c, DropTrailer__c, LiftGatePalletJack__c, SpecialEquipment__c
                FROM Ship_To_Site__c
                WHERE Id =: purchaseOrder.Ship_To_Site__c];
        return null;
    }

    // start #130249379
    @RemoteAction
    public static Map<String, List<String>> getDeliveryServicesSelectOptions() {
        return OrderAppUtility.getDeliveryServicesSelectOptions();
    }

    @RemoteAction
    public static Boolean updateDeliveryDetails(String recordString) {
        Boolean result = false;
        try {
            Ship_To_Site__c sts = (Ship_To_Site__c)JSON.deserialize(recordString, Ship_To_Site__c.class);
            update sts;
            result = true;
        } catch(Exception e) {
            System.debug('Error updating delivery details: ' + e.getMessage());
        }
        return result;
    }
    // end #130249379
   @RemoteAction
    public static OracleOrderUtility.CRDDatesResponse getCRDDates(string zipCode){
        return OracleOrderUtility.CRDCalloutRequest('US',zipCode);
    }
}