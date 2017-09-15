public with sharing class TimelineChartData {

    public static final String SLA_RED = 'SLA RED';
    public static final String SLA_YELLOW = 'SLA YELLOW';
    public static final String SLA_GREEN = 'SLA GREEN';
    public static final String SLA_NONE = 'Leases';
    public static final String SELECTED = 'Leases';
    public static final String STAGE = 'Stage';
    public static final String TOTAL = 'Total';

    public static String getJSON(List<String> orderedLeaseStages, Map<String, PartnerTimelineController.StageColumn> stageToStageColumn) {

        GoogleViz gv = buildGoogleViz(orderedLeaseStages, stageToStageColumn);

        return String.escapeSingleQuotes(JSON.serialize(gv));

    }

    public static GoogleViz buildGoogleViz(List<String> orderedLeaseStages, Map<String, PartnerTimelineController.StageColumn> stageToStageColumn) {

        GoogleViz gv = new GoogleViz();
        gv.cols = new List<GoogleViz.col>
        {
            new GoogleViz.Col('col1', STAGE, GoogleViz.COL_STRING),
            new GoogleViz.Col('col4', SLA_NONE, GoogleViz.COL_NUMBER),
            new GoogleViz.Col('col6', SELECTED, GoogleViz.COL_NUMBER),
            new GoogleViz.Col('col2', SLA_RED, GoogleViz.COL_NUMBER),
            new GoogleViz.Col('col3', SLA_YELLOW, GoogleViz.COL_NUMBER),
            new GoogleViz.Col('col7', SLA_GREEN, GoogleViz.COL_NUMBER),
            new GoogleViz.Col('col5', TOTAL, GoogleViz.COL_NUMBER)
        };

        for(String leaseStage : orderedLeaseStages) {
            PartnerTimelineController.StageColumn  stageColumn = stageToStageColumn.get(leaseStage);

            Integer redSLA = 0;
            Integer yellowSLA = 0;
            Integer greenSLA = 0;
            Integer noSLA = 0;
            Integer totalPayments = 0;
            Integer selectColumnValue = -1;
            Boolean foundDefault = false;

            if(stageColumn != null) {
                redSLA = stageColumn.redSLA.size();
                yellowSLA = stageColumn.yellowSLA.size();
                greenSLA = stageColumn.greenSLA.size();
                totalPayments = stageColumn.leasePayments.size();
                noSLA = stageColumn.noSLA.size();

                if(stageColumn.isDefault && !foundDefault) {
                    noSLA = 0;
                    selectColumnValue = stageColumn.noSLA.size();
                    foundDefault = true;
                }
            }

            GoogleViz.row newRow = new GoogleViz.row();
            newRow.addCell(new GoogleViz.cell(leaseStage));
            newRow.addCell(new GoogleViz.cell(noSLA));
            newRow.addCell(new GoogleViz.cell(selectColumnValue));
            newRow.addCell(new GoogleViz.cell(redSLA));
            newRow.addCell(new GoogleViz.cell(yellowSLA));
            newRow.addCell(new GoogleViz.cell(greenSLA));
            newRow.addCell(new GoogleViz.cell(totalPayments));
            gv.addRow(newRow);

        }

        return gv;
    }

}