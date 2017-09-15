/**
 * Created by cdevarapalli on 8/1/17.
 */

global class AdhocLDAUtility {

    webService static String adhocCreateLDA(Id agrId) {
        String returnString = null;

        try{
            List<echosign_dev1__SIGN_Agreement__c> agrmntList = new List<echosign_dev1__SIGN_Agreement__c>([SELECT
                    Id,
                    Quote__c,
                    Quote__r.Adhoc_Create_LDA__c,
                    Quote__r.Quote_Summary__r.Id,
                    Quote__r.Quote_Summary__r.Adhoc_Create_LDA__c
            FROM echosign_dev1__SIGN_Agreement__c
            WHERE Quote__c != null and Id =:agrId ]);

            if(agrmntList != null && !agrmntList.isEmpty()){
                List<Quote_Summary__c> qtSummaryList = new List<Quote_Summary__c>([SELECT Id
                                                                                    FROM Quote_Summary__c
                                                                                    WHERE Locked_Scenario__c = :agrmntList[0].Quote__c]);

                Quote qt = new Quote(Id = agrmntList[0].Quote__c, Adhoc_Create_LDA__c = true);
                update qt;

                if(qtSummaryList != null && !qtSummaryList.isEmpty()){
                    qtSummaryList[0].Adhoc_Create_LDA__c = true;
                    update qtSummaryList[0];
                }

                returnString = Label.LDA_Resend_Process_Initiated_Alert;
            }

        }catch (Exception e){
            returnString = e.getMessage();
        }
        return returnString;
    }

}