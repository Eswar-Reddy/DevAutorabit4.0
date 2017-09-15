global class skedInspectionGridBuilder extends skedSiteSurveyGridBuilder {

    public skedInspectionGridBuilder() {
        super();
    }
    
    protected override List<integer> getStartTimeInMinuteList() {
        List<integer> startTimeInMinuteList = new List<integer>();
        integer tempInt = startWorkingTimeInMinute;
        while (tempInt < endWorkingTimeInMinute) {
            startTimeInMinuteList.add(tempInt);
            tempInt += 60;
        }
        return startTimeInMinuteList;
    }
    
}