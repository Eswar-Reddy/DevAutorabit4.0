/*
* ShippingSiteComponentController - controller for shipping site component,
* can be shared with other components via ComponentControllerBase,
* reusable component for consistency, inserts record by record type based on input selects/JS/JSON/RemoteAction
* SFDC Release - https://na29.salesforce.com/a5B34000000xp2Y
*
* Pivotal Tracker Updates:
* ID #115992845 - Refine New Shipping Address Behavior - 3/22/16
* ID #127348167 - Create Shipping Site & route to Oracle
*
*
*
*
*
*/

global class ShippingSiteComponentController extends ComponentControllerBase {

    global Ship_To_Site__c componentSite {get;set;}

    global List<SelectOption> getCountryCodes() {
        return OrderAppUtility.getCountryCodes();
    }

    global ShippingSiteComponentController() {
        componentSite = new Ship_To_Site__c();
    }

    global PageReference compControllerTest2(){
        return null;
    }

    @RemoteAction
    global static ResultMessage saveShippingSite(String recordString, String recordType) {
        Ship_To_Site__c sts = (Ship_To_Site__c)JSON.deserialize(recordString, Ship_To_Site__c.class);
        if(recordType == 'Dealer Warehouse') {
            sts.RecordTypeId = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Ship_to_Site__c.sobjectType).get('Dealer_Warehouse');
            sts.Type__c = 'Dealer Warehouse';
        } else if(recordType == 'Installation Site') {
            sts.RecordTypeId = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Ship_to_Site__c.sobjectType).get('Installation_Site');
        }

        List<Vertex_Address_Validation__c> vertex = new List<Vertex_Address_Validation__c>([SELECT geo_county__c, Geo_City__c, geo_postal_code__c FROM Vertex_Address_Validation__c WHERE geo_postal_code__c =: sts.Zip__c ]);

        if(!vertex.isEmpty()) {
            if(vertex.size() == 1)
                sts.Oracle_County__c = vertex[0].Geo_county__c;
            else {
                for(Vertex_Address_validation__c v : vertex) {
                    if(v.Geo_City__c == sts.City__c) {
                        sts.Oracle_County__c = v.Geo_County__c;
                        break;
                    }
                }
            }
        }

        ResultMessage result = new ResultMessage();
        result.success = true;

        try{
            insert sts;
            result.payloadMap.put('savedRecord', sts);
            // #127348167
            OrderAppUtility.saveShippingSiteToOracle(String.valueOf(sts.Id));
        }catch (Exception e) {
            result.success = false;
            result.payload.add(e);
        }
        return result;
    }
}