global class skedInstallationGridBuilder extends skedGridBuilderBase {

    public skedInstallationGridBuilder() {
        super();
    }
    
    protected override bookingGridModel initializeGrid() {
        Map<string, Set<Date>> mapHoliday = skedUtils.getHolidays();
        if (mapHoliday.containsKey('global')) {
            Set<Date> globalHolidays = mapHoliday.get('global');
            this.holidays.addAll(globalHolidays);
        }
        if (mapHoliday.containsKey(params.regionId)) {
            Set<Date> regionHolidays = mapHoliday.get(params.regionId);
            this.holidays.addAll(regionHolidays);
        }
        
        bookingGridModel bookingGrid = new bookingGridModel();
        string timezoneSidId = this.params.timezoneSidId;
        
        Date firstDate = startDate;
        Date lastDate = endDate;
        
        DateTime startDt = skedUtils.GetStartOfDate(params.startDateIso, timezoneSidId);
        DateTime endDt = skedUtils.GetStartOfDate(params.endDateIso, timezoneSidId);
        DateTime firstDateStart = startDt;
        DateTime lastDateStart = endDt;
        
        string firstDateWeekday = firstDateStart.format('EEE', timezoneSidId).toLowerCase();
        if (firstDateWeekday != 'sun') {
            while (firstDateWeekday != 'sun') {
                firstDateStart = skedUtils.addDays(firstDateStart, -1, timezoneSidId);
                firstDate = firstDate.addDays(-1);
                firstDateWeekday = firstDateStart.format('EEE', timezoneSidId).toLowerCase();
            }
        }
        
        string lastDateWeekday = lastDateStart.format('EEE', timezoneSidId).toLowerCase();
        if (lastDateWeekday != 'sat') {
            while (lastDateWeekday != 'sat') {
                lastDateStart = skedUtils.addDays(lastDateStart, 1, timezoneSidId);
                lastDate = lastDate.addDays(1);
                lastDateWeekday = lastDateStart.format('EEE', timezoneSidId).toLowerCase();
            }
        }
        integer totalDays = firstDate.daysBetween(lastDate) + 1;
        integer totalWeeks = totalDays / 7;
        
        Map<integer, groupSlotModel> mapGroup = new Map<integer, groupSlotModel>();
        for (integer i = 1; i <= totalWeeks; i++) {
            groupSlotModel groupItem = new groupSlotModel();
            bookingGrid.groups.add(groupItem);
            mapGroup.put(i, groupItem);
        }
        
        for (integer i = 0; i < totalDays; i++) {
            integer week = integer.valueOf(i / 7) + 1;
            groupSlotModel groupItem = mapGroup.get(week);
            
            slotModel slot = new slotModel();
            slot.startTimeValue = skedUtils.addDays(firstDateStart, i, timezoneSidId);
            slot.endTimeValue = skedUtils.addDays(slot.startTimeValue, 1, timezoneSidId);
            slot.label = slot.startTimeValue.format('d', timezoneSidId);
            DateTime jobStart = skedUtils.addMinutes(slot.startTimeValue, startWorkingTimeInMinute, timezoneSidId);
            slot.slotKey = Json.serialize(jobStart);
            slot.duration = this.params.duration;
            slot.isAvailable = false;
            
            Date tempDate = firstDate.addDays(i);
            slot.outOfRange = tempDate < startDate || tempDate > endDate;
            slot.isHoliday = this.holidays.contains(tempDate);
            
            groupItem.slots.add(slot);
            bookingGrid.mapSlot.put(slot.slotKey, slot);
        }
        
        return bookingGrid;
    }
    
    protected override skedModels.job preparePossibleJob(slotModel slot) {
        string slotWeekday = slot.startTimeValue.format('EEE', this.params.timezoneSidId).toLowerCase();
        if ((slotWeekday == 'sat' && this.params.skipSaturdays) || (slotWeekday == 'sun' && this.params.skipSundays) || (holidays.contains(slot.startTimeValue.date()) && this.params.skipHolidays)) {
            return null;
        }
        
        Location jobLocation = Location.newInstance(this.params.jobLocationLat, this.params.jobLocationLong);
        skedModels.job job = new skedModels.job();
        job.allDay = true;
        job.start = skedUtils.addMinutes(slot.startTimeValue, startWorkingTimeInMinute, this.params.timezoneSidId);
        job.finish = skedUtils.addMinutes(slot.startTimeValue, endWorkingTimeInMinute, this.params.timezoneSidId);
        job.geoLocation = jobLocation;
        job.allDay = true;
        skedInstallationGridBuilder.getFollowups(job, slot.duration, this.holidays, this.params.skipHolidays, this.params.skipSaturdays, this.params.skipSundays, this.params.timezoneSidId);
        
        return job;
    }
    
    public static void getFollowups(skedModels.job job, integer total, Set<Date> holidays, boolean skipHolidays, boolean skipSaturdays, boolean skipSundays, string timezoneSidId) {
        job.followups = new List<skedModels.job>();
        integer count = 1;
        integer temp = 1;
        while (count < total) {
            boolean validDate = false;
            while (!validDate) {
                DateTime followupStart = skedUtils.addDays(job.start, temp, timezoneSidId);
                string followupWeekday = followupStart.format('EEE', timezoneSidId).toLowerCase();
                if ((followupWeekday == 'sat' && skipSaturdays)
                    || (followupWeekday == 'sun' && skipSundays)
                    || (holidays.contains(followupStart.date()) && skipHolidays)) {
                        temp++;
                    }
                else {
                    validDate = true;
                }
            }
            skedModels.job followup = job.clone();
            followup.start = skedUtils.addDays(job.start, temp, timezoneSidId);
            followup.finish = skedUtils.addDays(job.finish, temp, timezoneSidId);
            job.followups.add(followup);
            
            temp++;
            count++;
        }
    }
    
}