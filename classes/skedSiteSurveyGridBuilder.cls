global virtual class skedSiteSurveyGridBuilder extends skedGridBuilderBase {
    
    public skedSiteSurveyGridBuilder() {
        super();
    }
    
    protected override bookingGridModel initializeGrid() {
        bookingGridModel bookingGrid = new bookingGridModel();
        string timezoneSidId = this.params.timezoneSidId;
        
        List<integer> startTimeInMinuteList = getStartTimeInMinuteList();
        
        Date tempDate = this.startDate;
        while (tempDate < this.endDate) {
            DateTime dateslotStart = DateTime.newInstance(tempDate, time.newInstance(0, 0, 0, 0));
            dateslotStart = skedUtils.ConvertBetweenTimezones(dateslotStart, timezoneSidId, UserInfo.getTimeZone().getID());
            
            groupSlotModel dateslot = new groupSlotModel();
            dateslot.label = dateslotStart.format('EEE MM/dd', timezoneSidId);
            
            bookingGrid.groups.add(dateslot);
            
            for (integer i = 0; i < startTimeInMinuteList.size(); i++) {
                integer startTimeInMinute = startTimeInMinuteList.get(i);
                DateTime timeslotStart = skedUtils.addMinutes(dateslotStart, startTimeInMinute, timezoneSidId);
                slotModel timeslot = new slotModel();
                timeslot.slotKey = Json.serialize(timeslotStart);
                timeslot.startTimeValue = timeslotStart;
                timeslot.endTimeValue = timeslot.startTimeValue.addMinutes(params.duration);
                timeslot.label = timeslot.startTimeValue.format('h:mm a', timezoneSidId);
                timeslot.duration = params.duration;
                dateslot.slots.add(timeslot);
                
                bookingGrid.mapSlot.put(timeslot.slotKey, timeslot);
            }
            tempDate = tempDate.addDays(1);
        }
        
        return bookingGrid;
    }
    
    protected override skedModels.job preparePossibleJob(slotModel slot) {
        Location jobLocation = Location.newInstance(this.params.jobLocationLat, this.params.jobLocationLong);
        skedModels.job job = new skedModels.job();
        job.allDay = true;
        job.start = slot.startTimeValue;
        job.finish = slot.startTimeValue.addMinutes(slot.duration);
        job.geoLocation = jobLocation;
        job.allDay = false;
        return job;
    }
    
    protected virtual List<integer> getStartTimeInMinuteList() {
        List<string> predefinedTimeslotList = bookingSetting.Site_Survey_Predefined_timeslots__c.split(';');
        List<integer> startTimeInMinuteList = new List<integer>();
        for (string predefinedTimeslot : predefinedTimeslotList) {
            integer startTimeValue = integer.valueOf(predefinedTimeslot);
            integer startTimeInMinute = skedUtils.ConvertTimeNumberToMinutes(startTimeValue);
            startTimeInMinuteList.add(startTimeInMinute);
        }
        return startTimeInMinuteList;
    }
    
}