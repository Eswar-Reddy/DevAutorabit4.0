/*
* OrderAppUtility - utility class for cash based ordering system
* SFDC Release - https://na29.salesforce.com/a5B34000000xp2Y
*
* Pivotal Tracker Updates:
* ID #116005357 - SolarEdge Storage availability Hawaii (SFDC) - 6/3/2016 updates to Inv/Module ratios
* ID #127348167 - Create Shipping Site & route to Oracle
* ID #130249379 - Structured Shipping Data in order creation (NA)
*
*
*/

global without sharing class OrderAppUtility {

    public static SortDirection SORT_DIR = SortDirection.DESCENDING;
    public enum SortDirection {ASCENDING, DESCENDING}

    public OrderAppUtility() {}

    //Reverse sorting class for ordering of kit sizes
    global class DescSorter implements Comparable {

        public Integer sortingValue {get;set;}
        public String identifier {get;set;}

        global Integer compareTo(Object other) {
            return compareToSize(other);
        }
        Integer compareToSize(Object other) {
            Integer othervalue = ((DescSorter)other).sortingValue;
            if (SORT_DIR == SortDirection.DESCENDING) {
                return 1*(othervalue - this.sortingValue);
            }
            else {
                return Integer.valueOf( 1*(this.sortingValue - othervalue));
            }
        }
    }

    global class RatioWrapper implements Comparable {
        public Integer sortVal {get;set;}
        public Double lowerLimit {get;set;}
        public Double upperLimit {get;set;}
        public Double ratioLimit {get;set;}

        global Integer compareTo(Object other) {
            return compareToSize(other);
        }
        Integer compareToSize(Object other) {
            Integer othervalue = ((RatioWrapper)other).sortVal;

            return Integer.valueOf( 1*(this.sortVal - othervalue));
        }
    }

    // #127348167
    @Future(callout=true)
    public static void saveShippingSiteToOracle(String recId) {
        // set the ship to site Id
        Id stsId = Id.valueOf(recId);
        // get the ship to site record
        Ship_To_Site__c sts = [SELECT Address1__c, Address2__c, City__c, Country__c, Dealer_Account__c, Oracle_County__c, State__c, Zip__c FROM Ship_to_Site__c WHERE Id = :stsId];
        // get the account info for oracle
        Account a = [SELECT Line_of_Business__c, Oracle_Account_Number__c, Oracle_Operating_Unit__c FROM Account WHERE Id = :sts.Dealer_Account__c];
        // figure out the channel type
        String channelType;
        if(a.Line_of_Business__c.toUpperCase() == 'COMBO') {
            channelType = 'RVAR';
        } else {
            channelType = a.Line_of_Business__c.toUpperCase();
        }
        // send new address to Oracle
        ResultMessage saveResult = OracleOrderService.saveShippingSiteToOracle(sts, a.Oracle_Account_Number__c, 'PURCHASE', channelType);
		// insert logs
        if(!saveResult.logs.isEmpty()) {
            SpectrumDebugUtility.generateDebugLog(saveResult.logs);
        }
        // check result
        if(saveResult.success) {
            OracleOrderUtility.checkNewShipToSite(saveResult.message, stsId);
        }
    }

    public static String createSpecialInstructionString(String OSContact, String OSPhone, String partner, String partnerPhone, String truckType, String liftgate, String Forklift, String palletJack, String comments){
        //Example String :: "On-Site Contact: Dylan Rolleri || Phone: (516) 837-3459 ext 12122 || Partner: EmPower Solar || Phone: (516) 837-3459 || Truck Type: Standard || Liftgate: Yes || Forklift: No || Pallet Jack: Yes || Comments: 24-hour pre-call required: Deliver between 8AM and 10AM daily."
        String specialInstructionString  = checkNull(OSContact);
        specialInstructionString         +=    ' || ' + checkNull(OSPhone);
        specialInstructionString         +=    ' || ' + checkNull(partner);
        specialInstructionString         +=    ' || ' + checkNull(partnerPhone);
        specialInstructionString         +=    ' || Truck Type: ' + checkNull(truckType);
        specialInstructionString         +=    ' || Liftgate: ' + checkNull(liftgate);
        specialInstructionString         +=    ' || Pallet Jack: ' + checkNull(palletJack);
        specialInstructionString         +=    ' || ' + checkNull(comments);
        return specialInstructionString;
    }

    public static String generateGUID() {
        Blob b = Crypto.GenerateAESKey(128);
        String h = EncodingUtil.ConvertTohex(b);
        String guid = h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);
        return guid;
    }

    public static void generateLogging(String service, String outboundReq, String inboundRes) {
        try {
            Sunpower_Spectrum_Debug_Log__c log = new Sunpower_Spectrum_Debug_Log__c();
            log.JSON_Payload__c = outboundReq.length() > 131072 ? outboundReq.left(131071) : outboundReq;
            log.Response__c = inboundRes.length() > 131072 ? inboundRes.left(131071) : inboundRes;
            log.Service__c = service;

            insert log;
        } catch (Exception e) {}
    }

    public static List<SelectOption> getCountryCodes() {
        List<SelectOption> countryCodes = new List<SelectOption>();
        for(Country_Reference__c cr : [SELECT CountryCode__c, Country__c FROM Country_Reference__c WHERE CountryCode__c != '' OR CountryCode__c != null ORDER BY Country__c]) {
            countryCodes.add(new SelectOption(cr.CountryCode__c, cr.Country__c));
        }
        return countryCodes;
    }

    // start #130249379
    public static Map<String, List<String>> getDeliveryServicesSelectOptions() {
        Map<String, List<String>> result = new Map<String, List<String>>();

        try {
            List<String> defaults = new List<String>();

            List<String> deliveryTimeStart = new List<String>();
            Schema.DescribeFieldResult dts = Ship_to_Site__c.DeliveryTimeStart__c.getDescribe();
            List<Schema.PicklistEntry> dtsple = dts.getPicklistValues();
            for(Schema.PicklistEntry pl : dtsple) {
                deliveryTimeStart.add(pl.getValue());
                if(pl.isDefaultValue()) {
                    defaults.add(pl.getValue());
                }
            }
            result.put('DeliveryTimeStart', deliveryTimeStart);

            if(defaults.size() != 1) {
                defaults.add('');
            }

            List<String> deliveryTimeEnd = new List<String>();
            Schema.DescribeFieldResult dte = Ship_to_Site__c.DeliveryTimeEnd__c.getDescribe();
            List<Schema.PicklistEntry> dteple = dte.getPicklistValues();
            for(Schema.PicklistEntry pl : dteple) {
                deliveryTimeEnd.add(pl.getValue());
                if(pl.isDefaultValue()) {
                    defaults.add(pl.getValue());
                }
            }
            result.put('DeliveryTimeEnd', deliveryTimeEnd);

            if(defaults.size() != 2) {
                defaults.add('');
            }

            List<String> deliverySiteType = new List<String>();
            Schema.DescribeFieldResult dst = Ship_to_Site__c.DeliverySiteType__c.getDescribe();
            List<Schema.PicklistEntry> dstple = dst.getPicklistValues();
            for(Schema.PicklistEntry pl : dstple) {
                deliverySiteType.add(pl.getValue());
                if(pl.isDefaultValue()) {
                    defaults.add(pl.getValue());
                }
            }
            result.put('DeliverySiteType', deliverySiteType);

            if(defaults.size() != 3) {
                defaults.add('');
            }

            List<String> driverAssist = new List<String>();
            Schema.DescribeFieldResult da = Ship_to_Site__c.DriverAssist__c.getDescribe();
            List<Schema.PicklistEntry> daple = da.getPicklistValues();
            for(Schema.PicklistEntry pl : daple) {
                driverAssist.add(pl.getValue());
                if(pl.isDefaultValue()) {
                    defaults.add(pl.getValue());
                }
            }
            result.put('DriverAssist', driverAssist);

            if(defaults.size() != 4) {
                defaults.add('');
            }

            List<String> dropTrailer = new List<String>();
            Schema.DescribeFieldResult dt = Ship_to_Site__c.DropTrailer__c.getDescribe();
            List<Schema.PicklistEntry> dtple = dt.getPicklistValues();
            for(Schema.PicklistEntry pl : dtple) {
                dropTrailer.add(pl.getValue());
                if(pl.isDefaultValue()) {
                    defaults.add(pl.getValue());
                }
            }
            result.put('DropTrailer', dropTrailer);

            if(defaults.size() != 5) {
                defaults.add('');
            }

            List<String> liftGatePalletJack = new List<String>();
            Schema.DescribeFieldResult lgpj = Ship_to_Site__c.LiftGatePalletJack__c.getDescribe();
            List<Schema.PicklistEntry> lgpjple = lgpj.getPicklistValues();
            for(Schema.PicklistEntry pl : lgpjple) {
                liftGatePalletJack.add(pl.getValue());
                if(pl.isDefaultValue()) {
                    defaults.add(pl.getValue());
                }
            }
            result.put('LiftGatePalletJack', liftGatePalletJack);

            if(defaults.size() != 6) {
                defaults.add('');
            }

            List<String> specialEquipment = new List<String>();
            Schema.DescribeFieldResult se = Ship_to_Site__c.SpecialEquipment__c.getDescribe();
            List<Schema.PicklistEntry> seple = se.getPicklistValues();
            for(Schema.PicklistEntry pl : seple) {
                specialEquipment.add(pl.getValue());
                if(pl.isDefaultValue()) {
                    defaults.add(pl.getValue());
                }
            }
            result.put('SpecialEquipment', specialEquipment);

            if(defaults.size() != 7) {
                defaults.add('');
            }
            result.put('Defaults', defaults);
        } catch(Exception e) {
            SpectrumDebugUtility.createExceptionLog(e.getMessage(), e.getStackTraceString(), 'Get Delivery Services Select Options Error');
        }

        return result;
    }

    public static String createSpecialInstructionString(String deliveryTimeStart, String deliveryTimeEnd, String deliverySiteType, String driverAssist, String dropTrailer, String liftGatePalletJack, String specialEquipment){
        String specialInstructionString;
        try {
            //String dtsLabel = getFieldLabel(Ship_to_Site__c.DeliveryTimeStart__c);
            //String dteLabel = getFieldLabel(Ship_to_Site__c.DeliveryTimeEnd__c);
            //String dstLabel = getFieldLabel(Ship_to_Site__c.DeliverySiteType__c);
            //String daLabel = getFieldLabel(Ship_to_Site__c.DriverAssist__c);
            //String dtLabel = getFieldLabel(Ship_to_Site__c.DropTrailer__c);
            //String lgpjLabel = getFieldLabel(Ship_to_Site__c.LiftGatePalletJack__c);
            //String seLabel = getFieldLabel(Ship_to_Site__c.SpecialEquipment__c);

            specialInstructionString = checkNull(deliveryTimeStart);
            specialInstructionString += '|' + checkNull(deliveryTimeEnd);
            specialInstructionString += '|' + checkNull(deliverySiteType);
            specialInstructionString += '|' + checkNull(driverAssist);
            specialInstructionString += '|' + checkNull(dropTrailer);
            specialInstructionString += '|' + checkNull(liftGatePalletJack);
            specialInstructionString += '|' + checkNull(specialEquipment);
        } catch(Exception e) {
            SpectrumDebugUtility.createExceptionLog(e.getMessage(), e.getStackTraceString(), 'Create Special Instructions Error');
        }
        return specialInstructionString;
    }

    public static String getFieldLabel(SObjectField field) {
        DescribeFieldResult des = field.getDescribe();
        return des.getLabel();
    }
    // end #130249379

    public static String checkNull(String val) {
        if(String.isNotBlank(val)) {
            return val;
        } else return '';
    }	
}