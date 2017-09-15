public class skedUtils {
    
    public static string TIMESLOT_KEY_FORMAT = 'dd/MM/yyyy hh:mm a';
    public static string DATE_FORMAT = 'yyyy-MM-dd';
    public static string DATE_ISO_FORMAT = '"yyyy-MM-dd"';
    
    public static DateTime GetStartOfDate(string dateIsoString, string timezoneSidId) {
        Date tempDate = (Date)Json.deserialize(dateIsoString, Date.class);
        DateTime result = DateTime.newInstance(tempDate, time.newInstance(0, 0, 0, 0));
        result = skedUtils.ConvertBetweenTimezones(result, timezoneSidId, UserInfo.getTimeZone().getID());
        return result;
    }
    
    public static DateTime GetStartOfDate(DateTime input, string timezoneSidId) {
        String dateIsoString = input.format(DATE_ISO_FORMAT, timezoneSidId);
        return GetStartOfDate(dateIsoString, timezoneSidId);
    }
    
    public static DateTime GetEndOfDate(DateTime input, string timezoneSidId) {
        return GetStartOfDate(input, timezoneSidId).addDays(1);
    }
    
    public static DateTime addMinutes(DateTime inputDt, integer minutes, string timezoneSidId) {
        DateTime result = inputDt.addMinutes(minutes);
        Timezone tz = Timezone.getTimezone(timezoneSidId);
        integer inputDtOffset = tz.getOffset(inputDt) / 60000;
        integer resultOffset = tz.getOffset(result) / 60000;
        
        result = result.addMinutes(inputDtOffset - resultOffset);
        
        return result;
    }
    
    public static DateTime addDays(DateTime inputDt, integer days, string timezoneSidId) {
        DateTime result = inputDt.addDays(days);
        Timezone tz = Timezone.getTimezone(timezoneSidId);
        integer inputDtOffset = tz.getOffset(inputDt) / 60000;
        integer resultOffset = tz.getOffset(result) / 60000;
        
        result = result.addMinutes(inputDtOffset - resultOffset);
        
        return result;
    }
    
    public static DateTime ConvertBetweenTimezones(DateTime input, string fromTimezoneSidId, string toTimezoneSidId) {
        if (fromTimezoneSidId == toTimezoneSidId) {
            return input;
        }
        TimeZone fromTz = Timezone.getTimeZone(fromTimezoneSidId);
        Timezone toTz = Timezone.getTimeZone(toTimezoneSidId);
        integer offsetMinutes = toTz.getOffset(input) - fromTz.getOffset(input);
        offsetMinutes = offsetMinutes / 60000;
        input = input.addMinutes(offsetMinutes);
        return input;
    }
    
    // @param inputTime: 730
    // @result: 730 will be considered as 7 hour and 30 minutes so the result should be 7 * 60 + 30 = 450
    public static integer ConvertTimeNumberToMinutes(integer inputTime) {
        return integer.valueOf(inputTime / 100) * 60 + Math.mod(inputTime, 100);
    }
    
    public static Map<string, Set<Date>> getHolidays() {
        Map<string, Set<Date>> mapHolidays = new Map<string, Set<Date>>();
        
        Date currentDate = system.now().date().addDays(-1);//buffer for different timezone
        
        List<sked__Holiday__c> skedGlobalHolidays = [SELECT Id, sked__Start_Date__c, sked__End_Date__c
                                                     FROM sked__Holiday__c
                                                     WHERE sked__Global__c = TRUE
                                                     AND sked__End_Date__c >= :currentDate];
        List<sked__Holiday_Region__c> skedRegionHolidays = [SELECT Id, sked__Holiday__r.sked__Start_Date__c, sked__Holiday__r.sked__End_Date__c, 
                                                            sked__Region__c, sked__Region__r.Name
                                                            FROM sked__Holiday_Region__c
                                                            WHERE sked__Holiday__r.sked__End_Date__c >= :currentDate];
        
        Set<Date> globalHolidays = new Set<Date>();
        for (sked__Holiday__c globalHoliday : skedGlobalHolidays) {
            Date tempDate = globalHoliday.sked__Start_Date__c;
            while (tempDate <= globalHoliday.sked__End_Date__c) {
                globalHolidays.add(tempDate);
                tempDate = tempDate.addDays(1);
            }
        }
        mapHolidays.put('global', globalHolidays);
        
        for (sked__Holiday_Region__c regionHoliday : skedRegionHolidays) {
            Set<Date> regionHolidays;
            if (mapHolidays.containsKey(regionHoliday.sked__Region__r.Name)) {
                regionHolidays = mapHolidays.get(regionHoliday.sked__Region__r.Name);
            } else {
                regionHolidays = new Set<Date>();
            }
            
            Date tempDate = regionHoliday.sked__Holiday__r.sked__Start_Date__c;
            while (tempDate <= regionHoliday.sked__Holiday__r.sked__End_Date__c) {
                regionHolidays.add(tempDate);
                tempDate = tempDate.addDays(1);
            }
            
            if (!mapHolidays.containsKey(regionHoliday.sked__Region__r.Name)) {
                mapHolidays.put(regionHoliday.sked__Region__c, regionHolidays);
            }
        }
        return mapHolidays;
    }
    
}