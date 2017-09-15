/*

Handler interface, listing the required methods for implementation

Class:              ITriggerHandler
Date:               03/24/2014
Version:            1
Last Updated:       03/24/2014
    *   Completed
    
////////////////////////////////////////////////////////////////////////////////
*/

global interface ITriggerHandler
{
    Boolean isRunning();
    void startRunning();
    void stopRunning();
    void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, 
        Map<ID, sObject> newMap, Map<ID, sObject> oldMap);
    void start();
    void qualifyReEntryRecords(List<sObject> newList, List<sObject> oldList, 
        Map<ID, sObject> newMap, Map<ID, sObject> oldMap);
    void reEntry();
    void finish(Boolean fromStart);
}