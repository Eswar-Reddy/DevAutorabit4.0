public with sharing class CreateEditExtensionController {

    public Opportunity Opportunity{get;set;}
    public Account Account{get;set;}
    public Contact Contact{get;set;}
    public Document__c Document{get;set;}
    public echosign_dev1__SIGN_Agreement__c Agreement{get;set;}
    public Task Task{get;set;}
    public Event Event{get;set;}
    public Project_Task__c projTask{get;set;}

    private String sObjectType;
    private String sObjectRecordType;
    private String Title;
    private String Subtitle;
    private Set<String> allFields;
    private transient Component.Apex.Form Form;

    private Map<String, sObjectField> schemaFields;


    public CreateEditExtensionController(ApexPages.StandardController standardControllerRec) {
        Opportunity = new Opportunity();
        Account = new Account();
        Contact  = new Contact();
        Document = new Document__c();
        Agreement = new echosign_dev1__SIGN_Agreement__c();
        Task = new Task();
        Event = new Event();
        projTask = new Project_Task__c();

        allFields = new Set<String>();

        //Small bug with the "addFields" method of Salesforce and this is
        //the only way I found to find from where object the request comes from.
        //sObjectType = ApexPages.currentPage().getUrl().toLowerCase().split('/apex/ac')[1].split('\\?')[0];
        String recordId = ApexPages.currentPage().getParameters().get('id');
        sObjectType = recordId == null ? ApexPages.currentPage().getParameters().get('objecttype') : String.valueOf(Id.valueOf(recordId).getSObjectType());

        //we describe the object and put all fields in this variable.
        schemaFields = Schema.getGlobalDescribe().get(sObjectType).getDescribe().fields.getMap();
        Set<String> FieldssObject = new Set<String>(schemaFields.keySet());

        //we add all available fields so that we don't get an error.
        //standardControllerRec.addFields(new list<String>(FieldssObject));
        //standardControllerRec.addFields(new list<String>{'RecordTypeId'});
        String myId = standardControllerRec.getId();

        sObject mySObject;
        if(myId!=null){
            mySObject = database.query('select '+ String.join(new list<String>(FieldssObject), ',') +' from ' + sObjectType + ' where Id=:myId');
        }

        sObjectRecordType = null;

        //in case we have the recordtype in the url.
        //happens when the user goes through the creation wizard (like for account)
        if(ApexPages.currentPage().getParameters().containsKey('RecordType')) {
            sObjectRecordType = ApexPages.currentPage().getParameters().get('RecordType');
        }
        else if(FieldssObject.contains('recordtypeid') && mySObject!=null){
            //if this wasn't successful, maybe we can get the recordtypeid for an existing record.
            sObjectRecordType = (String)mySObject.get('recordtypeid');
        }
        //last else: would be in case the record doesn't have any recordtype.

        //we have just one page for edition and creation. Therefore we need that the labels are a bit
        //dynamic.


        Title = Schema.getGlobalDescribe().get(sObjectType).getDescribe().getLabel() + ' edit';

        if(mySObject==null||mySObject.Id==null){
            //clicked on create
            Subtitle = 'New ' + Schema.getGlobalDescribe().get(sObjectType).getDescribe().getLabel();
        }
        else {
            //object edit
            String label = Schema.getGlobalDescribe().get(sObjectType).getDescribe().getLabel();
            Subtitle = ((Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(mySObject))).containsKey('name') ? (String)mySObject.get('name') : label;
        }

        getForm();

        if(!Test.isRunningTest()){
            //internal server error, if the test goes here...
            standardControllerRec.addFields(new list<String>(allFields));
        }

        //workaround for setting correctly the recordtype if the user clicks on the link
        //"change recordtype" in the read-only layout mode.
        //We don't need to make that on other objects which don't have a recordtype
        SObject sObj = standardControllerRec.getRecord();
        Set<String> objectFields = standardControllerRec.getRecord().getSObjectType().getDescribe().fields.getMap().keySet();
        for(String s : objectFields) {
            System.debug(s);
        }
        
        for(String s : ApexPages.currentPage().getParameters().keySet()) {
            if(ApexPages.currentPage().getParameters().get(s) != null && objectFields.contains(s.toLowerCase())) {
                sObj.put(s, ApexPages.currentPage().getParameters().get(s));
                System.debug(sObj.get(s));
            }
        }

        if(sObjectType=='Opportunity'){
            Opportunity = (Opportunity)sObj;
        }
        else if(sObjectType=='Account'){
            Account = (Account)sObj;
        }
        else if(sObjectType=='Contact'){
            Contact = (Contact)sObj;
        }
        else if(sObjectType=='Document__c'){
            Document = (Document__c)sObj;
        }
        else if(sObjectType=='echosign_dev1__SIGN_Agreement__c'){
            Agreement = (echosign_dev1__SIGN_Agreement__c)sObj;
        }
        else if(sObjectType=='Task'){
            Task = (Task)sObj;
        }
        else if(sObjectType=='Event'){
            Event = (Event)sObj;
        }
        else if(sObjectType=='Project_Task__c'){
            projTask = (Project_Task__c)sObj;
        }
        //else {

        //}

        if(ApexPages.currentPage().getParameters().containsKey('RecordType')) {
            //We may need to write the recordtype if it's present as url parameter
            Opportunity.RecordTypeId = ApexPages.currentPage().getParameters().get('RecordType');
            Account.RecordTypeId = ApexPages.currentPage().getParameters().get('RecordType');
            Contact.RecordTypeId = ApexPages.currentPage().getParameters().get('RecordType');
            projTask.RecordTypeId = ApexPages.currentPage().getParameters().get('RecordType');
        }

        if(sObjectType == 'Contact' && ApexPages.currentPage().getParameters().containsKey('accid')) {
            Contact.AccountId = ApexPages.currentPage().getParameters().get('accid');
            //Contact.MailingStreet = ApexPages.currentPage().getParameters().get('MailingStreet');
            System.debug(Contact.MailingStreet);
        }

        if(ApexPages.currentPage().getParameters().containsKey('Opportunity__c')) {
            try
            {
                Document.Opportunity__c = ApexPages.currentPage().getParameters().get('Opportunity__c');
                Agreement.Opportunity__c = ApexPages.currentPage().getParameters().get('Opportunity__c');
            }
            catch(Exception ignore)
            {}
        }

        if(ApexPages.currentPage().getParameters().containsKey('Account__c')) {
            try
            {
                Document.Account__c = ApexPages.currentPage().getParameters().get('Account__c');
                Agreement.Account__c = ApexPages.currentPage().getParameters().get('Account__c');
            }
            catch(Exception ignore)
            {}
        }

        if(sObjectType == 'Task') {
            Task.WhatId = ApexPages.currentPage().getParameters().containsKey('what_id') ? ApexPages.currentPage().getParameters().get('what_id') : Task.WhatId;
            Task.Status = ApexPages.currentPage().getParameters().containsKey('close')
                && ApexPages.currentPage().getParameters().get('close') == '1'
                ? 'Completed'
                : Task.Status;
        }

        if(sObjectType == 'Event') {
            Event.WhatId = ApexPages.currentPage().getParameters().containsKey('what_id') ? ApexPages.currentPage().getParameters().get('what_id') : Event.WhatId;
        }

        if(sObjectType == 'Project_Task__c') 
        {
            projTask.Task_Type__c = ApexPages.currentPage().getParameters().get('Task_Type__c');
            if(projTask.Residential_Project__c == null) {
                projTask.Residential_Project__c = ApexPages.currentPage().getParameters().get('Residential_Project__c');
            }
            projTask.Status__c = ApexPages.currentPage().getParameters().get('Status__c');
            projTask.Parent_Task__c = ApexPages.currentPage().getParameters().get('Parent_Task__c');
        }
    }

    public list<SelectOption> getSalutation() {
        list<SelectOption> items = new list<SelectOption>();

        for(Schema.PicklistEntry picklist:Schema.getGlobalDescribe().get('Contact').getDescribe().fields.getMap().get('Salutation').getDescribe().getPickListValues()) {
            items.add(new SelectOption(picklist.getLabel(), picklist.getValue()));
        }

        return items;
    }

    public Component.Apex.Form getForm() {
        // we query the layout and rebuild it as it is in the standard interface. There shouldn't be any
        // difference between the standard layout and this layout.
        //The only method to achieve that is by using the Soap Resources.
        //For that we make a request on the Soap Partner endpoint.

        if(Form==null){
            Form = new Component.Apex.Form();
            Form.id = 'form';
            Set<String> rerenderFields = new Set<String>();
            Set<String> controllerFields = new Set<String>();
            Component.Apex.sectionHeader sectionHeader = new Component.Apex.sectionHeader();
            sectionHeader.subtitle = subtitle;
            sectionHeader.title = title;
            Form.childComponents.add(sectionHeader);

            Component.Apex.pageBlock pageBlock = new Component.Apex.pageBlock();
            pageBlock.id = 'pageBlock';
            pageBlock.mode = 'edit';
            pageBlock.title = title;

            Component.Apex.pageBlockSection pBS;
            Component.Apex.InputField inputField;
            Component.Apex.OutputField outputField;
            Component.Apex.InputText inputText;
            Component.Apex.InputHidden inputHidden;
            Component.Apex.Selectlist selectlist;
            Component.Apex.SelectOptions selectOptions;

            sobjectPartnerSoapSforceCom.Soap handler = HandlerMetadataInit();
            sobjectPartnerSoapSforceCom.DescribeLayoutResult LayoutResult = null;

            if(Test.isRunningTest()) // create a test layout so the test class can actually test some of the code below
            {
                LayoutResult = new sobjectPartnerSoapSforceCom.DescribeLayoutResult();
                sobjectPartnerSoapSforceCom.DescribeLayout[] layouts = new sobjectPartnerSoapSforceCom.DescribeLayout[1];
                layouts[0] = new sobjectPartnerSoapSforceCom.DescribeLayout();

                sobjectPartnerSoapSforceCom.DescribeLayoutSection[] sections = new sobjectPartnerSoapSforceCom.DescribeLayoutSection[1];
                sections[0] = new sobjectPartnerSoapSforceCom.DescribeLayoutSection();
                sections[0].columns = 2;
                sections[0].rows = 1;
                sections[0].heading = 'Test Heading';

                sobjectPartnerSoapSforceCom.DescribeLayoutComponent[] comps = new sobjectPartnerSoapSforceCom.DescribeLayoutComponent[1];
                comps[0] = new sobjectPartnerSoapSforceCom.DescribeLayoutComponent();
                comps[0].value = 'LastName';
                comps[0].displayLines = 1;

                sobjectPartnerSoapSforceCom.DescribeLayoutItem[] items = new sobjectPartnerSoapSforceCom.DescribeLayoutItem[1];
                items[0] = new sobjectPartnerSoapSforceCom.DescribeLayoutItem();
                items[0].label = 'Name';
                items[0].layoutComponents = comps;
                items[0].required = false;
                items[0].editable = true;

                sobjectPartnerSoapSforceCom.DescribeLayoutRow[] rows = new sobjectPartnerSoapSforceCom.DescribeLayoutRow[1];
                rows[0] = new sobjectPartnerSoapSforceCom.DescribeLayoutRow();
                rows[0].numItems = 1;
                rows[0].layoutItems = items;

                sections[0].layoutRows = rows;
                layouts[0].editLayoutSections = sections;
                LayoutResult.layouts = layouts;
            }
            else
            {
                //if running test, we can't make a callout, so this won't work.
                //sObjectRecordType is the recordtype of the sobject. If the sobject has no recordtype, then it's null and it's still fine.
                LayoutResult = handler.describeLayout(sObjectType, new list<String>{sObjectRecordType});

            }

            if(LayoutResult != null) {
                //we take the first one because we queried only one recordtype.
                for(sobjectPartnerSoapSforceCom.DescribeLayoutSection LayoutSection:LayoutResult.Layouts.get(0).editLayoutSections) {
                    //the different sections.
                    pBS = new Component.Apex.pageBlockSection(
                        columns = LayoutSection.columns
                    );

                    if(LayoutSection.useHeading==true) {
                        pBS.title = LayoutSection.heading;
                    }

                    for(sobjectPartnerSoapSforceCom.DescribeLayoutRow layoutRow:LayoutSection.layoutRows) {
                        for(sobjectPartnerSoapSforceCom.DescribeLayoutItem layoutItem:layoutRow.layoutItems) {
                           if(layoutItem.layoutComponents!=null){
                                //here the fields.
                                for(sobjectPartnerSoapSforceCom.DescribeLayoutComponent layoutComponent:layoutItem.layoutComponents){


                                    if(layoutComponent.value == null || layoutComponent.value == '\n' || layoutComponent.value == ',' || layoutComponent.value == ' '){
                                        continue;
                                    }
                                    if(layoutComponent.value=='OwnerId' || layoutComponent.value=='RecordTypeId' ){
                                        //The user shouldn't change the OwnerId/RecordType this way.
                                    }
                                    else if(sObjectType=='account' && (layoutComponent.value=='LastName' || layoutComponent.value=='FirstName' )) {
                                        inputText = new Component.Apex.InputText(
                                            id = layoutComponent.value
                                        );
                                        inputText.expressions.value = '{!'+sObjectType+'.' + layoutComponent.value + '}';

                                        pBS.childComponents.add(inputText);
                                        allFields.add(layoutComponent.value);
                                        rerenderFields.add(layoutComponent.value);
                                    }
                                    else if(sObjectType=='account' && layoutComponent.value=='Salutation'){
                                        selectlist = new Component.Apex.Selectlist(
                                            size = 1,
                                            multiselect = false
                                        );
                                        selectlist.expressions.value = '{!'+sObjectType+'.' + layoutComponent.value + '}';

                                        selectOptions = new Component.Apex.SelectOptions();
                                        selectOptions.expressions.value = '{!Salutation}';
                                        selectlist.childComponents.add(selectOptions);
                                        rerenderFields.add(layoutComponent.value);
                                        pBS.childComponents.add(selectlist);
                                    }
                                    else if (layoutitem.editable == false && layoutComponent.value != null) {
                                        outputField = new Component.Apex.outputField(
                                            id = layoutComponent.value
                                        );
                                        outputField.expressions.value = '{!'+sObjectType+'.' + layoutComponent.value + '}';
                                        pBS.childComponents.add(outputField);
                                        allFields.add(layoutComponent.value);
                                    }
                                    else if(layoutComponent.value!=null ){
                                        inputField = new Component.Apex.InputField(
                                            required = layoutItem.required,
                                            id = layoutComponent.value
                                        );
                                        inputField.expressions.value = '{!'+sObjectType+'.' + layoutComponent.value + '}';

                                        pBS.childComponents.add(inputField);
                                        allFields.add(layoutComponent.value);

                                        //we store the controller fields, because we shouldn't rerender them - causing a bug...
                                        //rerendering a controlled fields makes the value disappear
                                        if(schemaFields.get(layoutComponent.value) != null){
                                            if(schemaFields.get(layoutComponent.value).getDescribe().isDependentPicklist()){
                                                controllerFields.add(schemaFields.get(layoutComponent.value).getDescribe().getController().getDescribe().getName() );
                                            }
                                        }
                                    }
                                }
                            }
                            else {
                                //small workaround for adding empty fields when the layout require it
                                //in order to reproduce to 100% the standard layout.
                                pBS.childComponents.add(new Component.Apex.OutputText());
                            }

                        }
                    }
                    pageBlock.childComponents.add(pBS);
                }
            }
            
            Component.Apex.pageBlockButtons pageBlockButtons = new Component.Apex.pageBlockButtons();

            Component.Apex.commandButton commandButton = new Component.Apex.commandButton();
            commandButton.expressions.action = '{!save}';
            commandButton.id='saveBtn';
            commandButton.expressions.value = '{!$label.site.save}';
            commandButton.onclick = 'fnSaveValuesAndCheck();';
            commandButton.oncomplete = 'fnLoadInputValues();';
            rerenderFields.add('pageMessage');

            //we remove the controller fields from the rerenderFields
            rerenderFields.removeAll(controllerFields);

            commandButton.rerender = rerenderFields;
            pageBlockButtons.childComponents.add(commandButton);

            commandButton = new Component.Apex.commandButton();
            commandButton.expressions.action = '{!cancel}';
            commandButton.id='cancelBtn';
            commandButton.expressions.value = '{!$label.site.cancel}';
            commandButton.immediate = true;
            pageBlockButtons.childComponents.add(commandButton);

            pageBlock.childComponents.add(pageBlockButtons);

            Form.childComponents.add(pageBlock);
        }

        return Form;
    }

    public static sobjectPartnerSoapSforceCom.Soap handlerMetadataInit() {
        //here the authentication to the soap partner.
        //we build something quite dynamic which does not depend on any url (like cs17.salesforce.com)
        //therefore, should work for production like for sandbox, however the remote site settings
        //needs to be updated in Salesforce in Order to allow this outbound communication.
		String SoapEndpoint = Label.SoapURL;
        sobjectPartnerSoapSforceCom.Soap handler = new sobjectPartnerSoapSforceCom.Soap();

        // handler.endpoint_x = 'https://' + System.URL.getSalesforceBaseURL().getHost().split('\\.')[1]  + '-api.salesforce.com/services/Soap/u/27.0/' + UserInfo.getOrganizationId();
        handler.endpoint_x = SoapEndpoint;

        sobjectPartnerSoapSforceCom.SessionHeader_element sessionHeader = new sobjectPartnerSoapSforceCom.SessionHeader_element();
        sessionHeader.sessionId = UserInfo.getSessionId();
        handler.SessionHeader = sessionHeader;
        return handler;
    }

}