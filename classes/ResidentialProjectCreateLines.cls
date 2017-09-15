global without sharing class ResidentialProjectCreateLines {
	// this is used to create standard lines for the project based on the selected configurations
    // these lines are used in the order creation process (Purchase Order)
    webservice static String createStandardLineItemsForProject(Id projectId) {
        String result = 'Initializing';
        try {
			// check to make sure the user has right to create lines
            if(!ResidentialProjectValidationUtility.canCreate(projectId, 'StandardLineItem__c')) {
                SObjectException e = new SObjectException();
                e.setMessage('You do not have rights to create a material lines for this project because you are not assigned to proper team member role.');
                throw e;
            }

            List<StandardLineItem__c> lines = new List<StandardLineItem__c>();
            for(Residential_Project__c rp : [SELECT Module_Configuration__c, Number_of_Panels__c, Inverter_Configuration__c, Inverter_Quantity__c, Storage_Configuration__c, MonitoringIncluded__c, Mounting_Type__c, Module_Configuration__r.Item__r.Module_Width__c FROM Residential_Project__c WHERE Id = :projectId]) {

                // create module line
                if(String.isNotBlank(rp.Module_Configuration__c) && rp.Number_of_Panels__c > 0) {
                    for(Module_Configuration__c module : [SELECT Item__c FROM Module_Configuration__c WHERE Id = :rp.Module_Configuration__c]) {
                        if(String.isNotBlank(module.Item__c)) {
                            lines.add(createStandardLineItem(projectId, module.Item__c, Integer.valueOf(rp.Number_of_Panels__c)));
                        }
                    }
                }
                // create inverter line
                if(String.isNotBlank(rp.Inverter_Configuration__c) && rp.Inverter_Quantity__c > 0) {
                    for(Inverter_Configuration__c inverter : [SELECT Item__c, Monitoring__c FROM Inverter_Configuration__c WHERE Id = :rp.Inverter_Configuration__c]) {
                        if(String.isNotBlank(inverter.Item__c)) {
                            lines.add(createStandardLineItem(projectId, inverter.Item__c, Integer.valueOf(rp.Inverter_Quantity__c)));

                            // check/create monitoring
                            if(rp.MonitoringIncluded__c == 'Yes') {
                                for(Monitoring_Item_junction__c mon : [SELECT Item__c FROM Monitoring_Item_junction__c WHERE Monitoring_Configuration__c = :inverter.Monitoring__c]) {
                                    if(String.isNotBlank(mon.Item__c)) {
                                        lines.add(createStandardLineItem(projectId, mon.Item__c, 1));
                                    }
                                }
                            }
                        }
                    }
                }
                // create racking lines
                if(String.isNotBlank(rp.Mounting_Type__c) && rp.Number_of_Panels__c > 0) {
                    String mountingType = rp.Mounting_Type__c;
                    // get the items
                    Map<Id, Racking_Item_Junction__c> rackingItems = ProductConfigurationUtility.fetchRackingByModule(rp.Module_Configuration__c, mountingType);
                    // check items
                    if(!rackingItems.isEmpty()) {
                        // racking item junction for solarmount
                        Racking_Item_Junction__c selectedRacking;
                        // create map for items
                        Map<String, Id> itemIds = new Map<String, Id>();
                        for(Racking_Item_Junction__c rij : rackingItems.values()) {
                            itemIds.put(rij.Item__r.Item_Id__c, rij.Item__c);
                            selectedRacking = rij;
                        }
                        // get racking lines
                        RackingCalculationUtility rcu = new RackingCalculationUtility();
                        if(mountingType == 'InvisiMount') {
                            Map<String, Integer> items = rcu.calculateInvisimount(rackingItems, rp.Number_of_Panels__c);
                            // create lines for project
                            for(String kit : items.keySet()) {
                                lines.add(createStandardLineItem(projectId, itemIds.get(kit), items.get(kit)));
                            }
                        } else if(mountingType == 'SolarMount') {
                            Purchase_Order_Line__c poLine = rcu.calculateSolarmount(selectedRacking, rp.Number_of_Panels__c, rp.Module_Configuration__r.Item__r.Module_Width__c);
                            lines.add(createStandardLineItem(projectId, poLine.Oracle_Item_ID__c, Integer.valueOf(poLine.Quantity__c)));
                        }
                    }
                }
                // create storage line
                if(String.isNotBlank(rp.Storage_Configuration__c)) {
                    for(Storage_Configuration__c sc : [SELECT Item__c FROM Storage_Configuration__c WHERE Id = :rp.Storage_Configuration__c]) {
                        lines.add(createStandardLineItem(projectId, sc.Item__c, 1));
                    }
                }
            }
            if(lines.size() > 0) {
                insert lines;
            }
            result = String.valueOf(lines.size()) + ' Line(s) Created';
        }
        catch(Exception e) {
            SpectrumDebugUtility.createExceptionLog(e.getMessage(), e.getStackTraceString(), 'Create Lines for Project Error', projectId);
            result = e.getMessage() + ' - ' + e.getStackTraceString();
        }
        return result;
    }

    private static StandardLineItem__c createStandardLineItem(Id projectId, Id itemId, Integer qty) {
        StandardLineItem__c sli = new StandardLineItem__c();
        sli.Residential_Project__c = projectId;
        sli.Item__c = itemId;
        sli.Quantity__c = qty;
        return sli;
    }
}