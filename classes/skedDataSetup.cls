public class skedDataSetup {
    
    public static boolean skeduloBookingSettingsSetup = FALSE;
    public static boolean skeduloApiSettingsSetup = FALSE;
    
    public static void setupSkeduloApiSettings() {
        if (skeduloApiSettingsSetup == TRUE) {
            return;
        } else {
            skeduloApiSettingsSetup = TRUE;
        }
        Skedulo_API_Setting__c skedApiSetting = Skedulo_API_Setting__c.getOrgDefaults();
        skedApiSetting.API_Token__c = 'apitoken';
        
        upsert skedApiSetting;
    }
    
    public static void setupSkeduloBookingSettings() {
        if (skeduloBookingSettingsSetup == TRUE) {
            return;
        } else {
            skeduloBookingSettingsSetup = TRUE;
        }
        sked_Booking_Setting__c bookingSetting = sked_Booking_Setting__c.getOrgDefaults();
        upsert bookingSetting;
    }
    
    public static Map<string, sObject> setupCommonTestData(string jobType) {
        setupSkeduloApiSettings();
        setupSkeduloBookingSettings();
        string timezoneSidId = UserInfo.getTimeZone().getId();
        Date startDate = system.today().toStartOfWeek();
        DateTime startTime = DateTime.newInstance(startDate, time.newInstance(0, 0, 0, 0));
        DateTime todayDt = DateTime.newInstance(system.today(), time.newInstance(0, 0, 0, 0));
        Date endDate = startDate.addDays(14);
        
        Map<string, sObject> mapTestData = new Map<string, sObject>();
        
        List<sObject> firstList = new List<sObject>();
        /***********************************************************SPRI Template Project****************************************************************/
        Residential_Project__c spriTemplateProject = new Residential_Project__c(
            Name = 'SPRI - Template',
            RecordTypeId = Schema.SObjectType.Residential_Project__c.getRecordTypeInfosByName().get('Project Template').getRecordTypeId()
        );
        firstList.add(spriTemplateProject);
        mapTestData.put('spriTemplateProject', spriTemplateProject);
        
        /***********************************************************Test Account****************************************************************/
        Account testAccount = new Account(
            Name = 'Gary Geller',
            Type = 'Home Owner',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Residential Customer').getRecordTypeId(),
            BillingStreet = '1136 Clear Water Creek Blvd',
            BillingCity = 'Manteca',
            BillingState = 'CA',
            BillingPostalCode = '95336',
            BillingCountry = 'United States',
            BillingLatitude = 37.832798900000000,
            BillingLongitude = -121.233378400000000,
            ShippingStreet = '1136 Clear Water Creek Blvd',
            ShippingCity = 'Manteca',
            ShippingState = 'CA',
            ShippingPostalCode = '95336',
            ShippingCountry = 'United States',
            Phone = '(209) 679-9154',
            AccountNumber = 'CKDRTYAAV',
            Rating = 'C',
            CurrencyIsoCode = 'USD',
            ACBParanet_ID__c = 'CKDRTYAAV',
            Integration_ID__c = 'CKDRTYAAV',
            Participate_in_Customer_Survey__c = true,
            Review_Cycle__c = 'Monthly',
            Status__c = 'Active',
            Theater__c = 'North America',
            Online_Order_Access__c = false,
            Oracle_Operating_Unit__c = 'SPEB OU',
            Lead_Qualification_Notes__c = 'PHONE Appointment set for 9/12 at 12:00 PM. Has received a few quotes, didn\'t want to set up a home appt with us. ',
            Business_Unit__c = 'RLC',
            HD_Lead_Status__c = 'Appointment Confirmed',
            Send_PDF_Notification__c = true,
            Subscription_Date__c = startTime,
            Oracle_Customer_Classification__c = 'LEASE_CUSTOMER',
            Oracle_Account_Type__c = 'R',
            Oracle_Order_Type__c = 'SPEB RVAR Lease 2',
            Oracle_Sales_Channel__c = 'RVAR LEASE',
            Oracle_County__c = 'San Joaquin',
            Oracle_Payment_Terms__c = '45 NET',
            Oracle_Shipping_County__c = 'San Joaquin',
            Credit_Check_status__c = 'Pending - Application Sent',
            Credit_Check_submission_Date__c = startDate.addDays(1),
            Lat__c = 37.8327989000,
            Lead_Flow_opt_out__c = true,
            Filing_Status__c = 'Single',
            Income__c = 100000,
            Credit_Customer_ID__c = '5971468',
            Credit_Customer_Number__c = '1027203',
            Dealer_Score_Total__c = 0,
            Geolocation__Latitude__s = 37.8327989,
            Geolocation__Longitude__s = -121.2333784,
            Interface_Status__c = 'New',
            Maximum_cell_temperature__c = '70',
            Minimum_cell_temperature__c = '-10',
            Protected_Area__c = 'No'
        );
        firstList.add(testAccount);
        mapTestData.put('testAccount', testAccount);
        
        /***********************************************************Partner Accounts****************************************************************/
        Account anaheimPartnerAccount = new Account(
            Name = 'SPD Self Installation (Anaheim)',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId(),
            BillingStreet = '825 N Shepard',
            BillingCity = 'Anaheim',
            BillingState = 'CA',
            BillingPostalCode = '92806',
            BillingCountry = 'United States',
            ShippingStreet = '825 N Shepard',
            ShippingCity = 'Anaheim',
            ShippingState = 'CA',
            ShippingPostalCode = '92806',
            ShippingCountry = 'United States',
            CurrencyIsoCode = 'USD',
            Review_Cycle__c = 'Monthly',
            Executives_view_all_Opportunities__c = true,
            Send_PDF_Notification__c = true,
            Lease_Status_Email_Opt_Out__c = 'No',
            Maximum_cell_temperature__c = '70',
            Minimum_cell_temperature__c = '-10'
        );
        firstList.add(anaheimPartnerAccount);
        mapTestData.put('anaheimPartnerAccount', anaheimPartnerAccount);
        
        Account fremontPartnerAccount = new Account(
            Name = 'SPD Self Installation (Fremont)',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId(),
            BillingStreet = '4443 Enterprise St.',
            BillingCity = 'Fremont',
            BillingState = 'CA',
            BillingPostalCode = '94538',
            BillingCountry = 'United States',
            ShippingStreet = '4443 Enterprise St.',
            ShippingCity = 'Fremont',
            ShippingState = 'CA',
            ShippingPostalCode = '94538',
            ShippingCountry = 'United States',
            CurrencyIsoCode = 'USD',
            Review_Cycle__c = 'Monthly',
            Executives_view_all_Opportunities__c = true,
            Send_PDF_Notification__c = true,
            Lease_Status_Email_Opt_Out__c = 'No',
            Maximum_cell_temperature__c = '70',
            Minimum_cell_temperature__c = '-10'
        );
        firstList.add(fremontPartnerAccount);
        mapTestData.put('fremontPartnerAccount', fremontPartnerAccount);
        
        Account nothLaPartnerAccount = new Account(
            Name = 'SPD Self Installation (North L.A.)',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId(),
            ParentId = null,
            BillingStreet = '1414 Harbour Way South',
            BillingCity = 'Richmond',
            BillingState = 'CA',
            BillingPostalCode = '94804',
            BillingCountry = 'United States',
            ShippingStreet = '12228 Sherman Way',
            ShippingCity = 'North Hollywood',
            ShippingState = 'CA',
            ShippingPostalCode = '91605',
            ShippingCountry = 'United States',
            CurrencyIsoCode = 'USD',
            Review_Cycle__c = 'Monthly',
            Executives_view_all_Opportunities__c = true,
            Send_PDF_Notification__c = true,
            Dealer_Locator_Phone__c = '(505) 400-3036',
            Lease_Status_Email_Opt_Out__c = 'No',
            Interface_Status__c = 'New',
            Maximum_cell_temperature__c = '70',
            Minimum_cell_temperature__c = '-10'
        );
        firstList.add(nothLaPartnerAccount);
        mapTestData.put('nothLaPartnerAccount', nothLaPartnerAccount);
        
        /***********************************************************Skedulo Regions****************************************************************/
        sked__Region__c anaheimRegion = new sked__Region__c(
            Name = 'SPD Self Installation (Anaheim)',
            sked__Location__Latitude__s = 33.84982300,
            sked__Location__Longitude__s = -117.85274200,
            sked__Timezone__c = timezoneSidId,
            sked__Country_Code__c = 'US'
        );
        firstList.add(anaheimRegion);
        mapTestData.put('anaheimRegion', anaheimRegion);
        
        sked__Region__c fremontRegion = new sked__Region__c(
            Name = 'SPD Self Installation (Fremont)',
            sked__Location__Latitude__s = 37.50267600,
            sked__Location__Longitude__s = -121.95883300,
            sked__Timezone__c = timezoneSidId,
            sked__Country_Code__c = 'US'
        );
        firstList.add(fremontRegion);
        mapTestData.put('fremontRegion', fremontRegion);
        
        sked__Region__c northLaRegion = new sked__Region__c(
            Name = 'SPD Self Installation (North L.A.)',
            sked__Location__Latitude__s = 37.91086500,
            sked__Location__Longitude__s = -122.35834300,
            sked__Timezone__c = timezoneSidId,
            sked__Country_Code__c = 'US'
        );
        firstList.add(northLaRegion);
        mapTestData.put('northLaRegion', northLaRegion);
        
        /*********************************************************Tag**************************************************/
        sked__Tag__c tagQualityControl = new sked__Tag__c(
            Name = 'Quality Control',
            sked__Type__c = 'Skill',
            sked__Classification__c = 'Global'
        );
        firstList.add(tagQualityControl);
        mapTestData.put('tagQualityControl', tagQualityControl);
        
        /***********************************************************Availability Template****************************************************************/
        sked__Availability_Template__c availabilityTemplate = new sked__Availability_Template__c();
        firstList.add(availabilityTemplate);
        
        /*********************************************************Holidays**************************************************/
        sked__Holiday__c globalHoliday = new sked__Holiday__c(
            Name = 'Global Holidays',
            sked__Start_Date__c = system.today().addDays(1),
            sked__End_Date__c = system.today().addDays(1),
            sked__Global__c = true
        );
        firstList.add(globalHoliday);
        
        sked__Holiday__c anaheimHoliday = new sked__Holiday__c(
            Name = 'Anaheim Holidays',
            sked__Start_Date__c = system.today().addDays(1),
            sked__End_Date__c = system.today().addDays(1),
            sked__Global__c = false
        );
        firstList.add(anaheimHoliday);
        
        insert firstList;
        List<sObject> secondList = new List<sObject>();
        /*********************************************************Region holidays**************************************************/
        sked__Holiday_Region__c anaheimRegionHoliday = new sked__Holiday_Region__c(
            sked__Holiday__c = anaheimHoliday.Id,
            sked__Region__c = anaheimRegion.Id
        );
        secondList.add(anaheimRegionHoliday);
        /***********************************************************Resource****************************************************************/
        sked__Resource__c siteSurveyor1 = new sked__Resource__c(
            Name = 'Site Surveyor 1',
            sked__Category__c = 'Site Surveyor',
            sked__Home_Address__c = '625 El Camino Real, Palo Alto, CA 94301',
            sked__GeoLocation__Latitude__s = 37.440332,
            sked__GeoLocation__Longitude__s = -122.163379,
            sked__Resource_Type__c = 'Person',
            sked__Primary_Region__c = anaheimRegion.Id,
            sked__Notification_Type__c = 'push',
            sked__Country_Code__c = 'US',
            sked__Is_Active__c = true
        );
        secondList.add(siteSurveyor1);
        mapTestData.put('siteSurveyor1', siteSurveyor1);
        
        sked__Resource__c inspector1 = new sked__Resource__c(
            Name = 'Inspector 1',
            sked__Category__c = 'Inspector',
            sked__Home_Address__c = '200 El Camino Real, Palo Alto, CA 94301',
            sked__GeoLocation__Latitude__s = 37.443542,
            sked__GeoLocation__Longitude__s = -122.167506,
            sked__Resource_Type__c = 'Person',
            sked__Primary_Region__c = anaheimRegion.Id,
            sked__Notification_Type__c = 'push',
            sked__Country_Code__c = 'US',
            sked__Is_Active__c = true
        );
        secondList.add(inspector1);
        mapTestData.put('inspector1', inspector1);
        
        sked__Resource__c installer1 = new sked__Resource__c(
            Name = 'Installer 1',
            sked__Category__c = 'Installation Technician',
            sked__Home_Address__c = '200 El Camino Real, Palo Alto, CA 94301',
            sked__GeoLocation__Latitude__s = 37.443542,
            sked__GeoLocation__Longitude__s = -122.167506,
            sked__Resource_Type__c = 'Person',
            sked__Primary_Region__c = anaheimRegion.Id,
            sked__Notification_Type__c = 'push',
            sked__Country_Code__c = 'US',
            sked__Is_Active__c = true
        );
        secondList.add(installer1);
        mapTestData.put('installer1', installer1);
        /***********************************************************Availability Template Entry****************************************************************/
        sked__Availability_Template_Entry__c monEntry = new sked__Availability_Template_Entry__c(sked__Availability_Template__c = availabilityTemplate.Id, sked__Weekday__c = 'MON', sked__Start_Time__c = 700, sked__Finish_Time__c = 1800, sked__Is_Available__c = true);
        secondList.add(monEntry);
        sked__Availability_Template_Entry__c tueEntry = new sked__Availability_Template_Entry__c(sked__Availability_Template__c = availabilityTemplate.Id, sked__Weekday__c = 'TUE', sked__Start_Time__c = 700, sked__Finish_Time__c = 1800, sked__Is_Available__c = true);
        secondList.add(tueEntry);
        sked__Availability_Template_Entry__c wedEntry = new sked__Availability_Template_Entry__c(sked__Availability_Template__c = availabilityTemplate.Id, sked__Weekday__c = 'WED', sked__Start_Time__c = 700, sked__Finish_Time__c = 1800, sked__Is_Available__c = true);
        secondList.add(wedEntry);
        sked__Availability_Template_Entry__c thuEntry = new sked__Availability_Template_Entry__c(sked__Availability_Template__c = availabilityTemplate.Id, sked__Weekday__c = 'THU', sked__Start_Time__c = 700, sked__Finish_Time__c = 1800, sked__Is_Available__c = true);
        secondList.add(thuEntry);
        sked__Availability_Template_Entry__c friEntry = new sked__Availability_Template_Entry__c(sked__Availability_Template__c = availabilityTemplate.Id, sked__Weekday__c = 'FRI', sked__Start_Time__c = 700, sked__Finish_Time__c = 1800, sked__Is_Available__c = true);
        secondList.add(friEntry);
        sked__Availability_Template_Entry__c satEntry = new sked__Availability_Template_Entry__c(sked__Availability_Template__c = availabilityTemplate.Id, sked__Weekday__c = 'SAT', sked__Start_Time__c = 700, sked__Finish_Time__c = 1800, sked__Is_Available__c = true);
        secondList.add(satEntry);
        sked__Availability_Template_Entry__c sunEntry = new sked__Availability_Template_Entry__c(sked__Availability_Template__c = availabilityTemplate.Id, sked__Weekday__c = 'SUN', sked__Start_Time__c = 700, sked__Finish_Time__c = 1800, sked__Is_Available__c = true);
        secondList.add(sunEntry);
        
        /***********************************************************Contact****************************************************************/
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            AccountId = testAccount.Id
        );
        secondList.add(testContact);
        mapTestData.put('testContact', testContact);
        /***********************************************************SPRI Template Project's Task****************************************************************/
        setupProjectTask(jobType, mapTestData, secondList, spriTemplateProject);
        
        /***********************************************************Opportunity****************************************************************/
        Opportunity testOpportunity = new Opportunity(
            AccountId = testAccount.Id,
            RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Home Owner').getRecordTypeId(),
            Name = 'Gary Geller',
            Description = 'Lot Number: 71 Phase 1, Plan Type: 1C, Co-buyer Name: , Co-buyer Email: , Notes:,',
            StageName = 'Contract Signed',
            Amount = 30607.50,
            CloseDate = startDate,
            Type = 'Residential',
            LeadSource = 'New Homes - Builder',
            ForecastCategoryName = 'Closed',
            CurrencyIsoCode = 'USD',
            Auto_Assignment__c = true,
            Customer_Satisfaction_survey_opt_in__c = true,
            Opportunity_Status__c = 'Closed Won',
            System_Size_KwP__c = 4.020,
            Homes_Built_per_year__c = '< 500',
            Mounting_System__c = 'Other',
            Number_of_Sites_to_Install_Solar__c = '< 25',
            Number_of_States__c = '1',
            Roof_Material__c = 'Asphalt Shingle',
            Roof_Type__c = 'Flat Roofs',
            Theater__c = 'North America',
            Lead_Manufacturer__c = 'SunPower',
            Closed_Text__c = 1,
            Average_Monthly_Electricity_Bill__c = 'None',
            Business_Unit__c = 'RLC',
            Projected_Delivery_Date__c = endDate,
            Lead_Type__c = 'Residential',
            SP_Week__c = 23,
            Lead_SP_Week__c = 23,
            Opportunity_CreatedDate_Text__c = '20160531',
            Project_Stage__c = 'New Prospect',
            Closed_Won_Date__c = startDate,
            Contract_Type__c = 'Lease',
            Lead_Qualification_Notes__c = 'NHEC_6/17/16: Has a sister that lives in Vegas that has solar.',
            Lease__c = true,
            Web_Lead_Source__c = 'Direct Entry',
            RLC_Type__c = 'Residential',
            Converted_Lead_Record_Type__c = 'Residential',
            Appointment_Date_Time__c = startTime.addDays(3).addHours(10),
            Campaign_Source_Date__c = startTime.addDays(3).addHours(10),
            Module_Model_Number__c = '335W AC (SPR-X21-335-BLK-C-AC)',
            Module_Quantity__c = 12,
            Consultation_Type__c = 'Online',
            Approved_to_Send_PSR__c = 'No',
            Credit_Application_ID__c = '7974982',
            Credit_Application_Number__c = '709859',
            Credit_Application_Status__c = 'Conditionally Approved',
            Pass_SLA__c = 'Fail',
            SFDC_Timely_Update_Stages__c = 'New Opportunity;Visit Completed;Contract Signed;Verbal Commitment;Disqualified Sales',
            Dealer_Assignment_Date__c = startTime.addDays(3).addHours(10),
            Meeting_Link__c = 'www.clearslide.com/kevin.cool',
            Appointment_Time__c = '10:00 AM',
            Appointment_Date__c = startDate.addDays(3),
            SyncWithSpectrum__c = 'Update',
            Solar_Advisor_Notes_For_EC__c = '5/31/2016 KR Final design appt has not yet been scheduled.',
            New_Residential_Opps_Notification__c = true,
            Primary_Res_Opp_Recip_Email__c = 'solaradvisors@sunpower.com'
        );
        secondList.add(testOpportunity);
        mapTestData.put('testOpportunity', testOpportunity);
        
        insert secondList;
        List<sObject> thirdList = new List<sObject>();
        /*********************************************************Resource Tags**************************************************/
        sked__Resource_Tag__c siteSurveyor1_qualityControl = new sked__Resource_Tag__c(
            sked__Resource__c = siteSurveyor1.Id,
            sked__Tag__c = tagQualityControl.Id
        );
        thirdList.add(siteSurveyor1_qualityControl);
        /***********************************************************Resource's Events****************************************************************/
        sked__Availability__c siteSurveyor1Avail1 = new sked__Availability__c(
            sked__Start__c = todayDt.addDays(1).addHours(9),
            sked__Finish__c = todayDt.addDays(1).addHours(10),
            sked__Is_Available__c = FALSE,
            sked__Resource__c = siteSurveyor1.Id,
            sked__Status__c = 'Approved'
        );
        thirdList.add(siteSurveyor1Avail1);
        
        sked__Availability__c siteSurveyor1Avail2 = new sked__Availability__c(
            sked__Start__c = todayDt.addDays(1).addHours(9),
            sked__Finish__c = todayDt.addDays(1).addHours(10),
            sked__Is_Available__c = TRUE,
            sked__Resource__c = siteSurveyor1.Id,
            sked__Status__c = 'Approved'
        );
        thirdList.add(siteSurveyor1Avail2);
        
        sked__Activity__c siteSurveyor1Activity = new sked__Activity__c(
            sked__Start__c = todayDt.addDays(1).addHours(9),
            sked__End__c = todayDt.addDays(1).addHours(10),
            sked__Address__c = siteSurveyor1.sked__Home_Address__c,
            sked__GeoLocation__Latitude__s = siteSurveyor1.sked__GeoLocation__Latitude__s,
            sked__GeoLocation__Longitude__s = siteSurveyor1.sked__GeoLocation__Longitude__s,
            sked__Resource__c = siteSurveyor1.Id
        );
        thirdList.add(siteSurveyor1Activity);
        /***********************************************************Availability Template Resource****************************************************************/
        sked__Availability_Template_Resource__c avaiTempSiteSurveyor1 = new sked__Availability_Template_Resource__c(sked__Availability_Template__c = availabilityTemplate.Id, sked__Resource__c = siteSurveyor1.Id);
        thirdList.add(avaiTempSiteSurveyor1);
        sked__Availability_Template_Resource__c avaiTempInspector1 = new sked__Availability_Template_Resource__c(sked__Availability_Template__c = availabilityTemplate.Id, sked__Resource__c = inspector1.Id);
        thirdList.add(avaiTempInspector1);
        sked__Availability_Template_Resource__c avaiTempInstaller1 = new sked__Availability_Template_Resource__c(sked__Availability_Template__c = availabilityTemplate.Id, sked__Resource__c = installer1.Id);
        thirdList.add(avaiTempInstaller1);
        /***********************************************************Quote****************************************************************/
        Quote testQuote = new Quote(
            Name = 'Gary Geller',
            RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('Proposal Quote').getRecordTypeId(),
            OpportunityId = testOpportunity.Id,
            Status = 'Draft',
            LineItemsFromOpp__c = true,
            Module_Type__c = 'PL-PLT-63L-BLK-U',
            Price_Approval__c = true,
            Quote_Steps__c = 'Binding Offer',
            Quote_type__c = 'TPS Quote',
            Start_Date__c = startDate,
            IsSendApprovaltoSalesAnalyst__c = true,
            Construction__c = 12126.00,
            Customer_Electric_Utility__c = 'Consolidated Edison',
            Customer_Rate_Name__c = 'NY_CONSOLIDATED_R',
            Lease_Doc_Created__c = true,
            Module_Quantity__c = 5,
            Temp_Contact_1__c = 'Gary Geller',
            Date__c = '2016-10-28',
            Dealer_Fees__c = 20210.00,
            Dealer_Installer__c = 'Riley Stock',
            Description__c = '345\'s final',
            Doc_out_for_signature__c = true,
            Early_Buyout_Option_Date__c = '10/1/2023',
            First_Monthly_Payment_Base_Amount__c = 165.65,
            First_Monthly_Payment_Estimated_Payment__c = 165.65,
            First_Monthly_Payment__c = 158.15,
            Interconnect__c = 4042.00,
            Inverter_Model_2__c = 'Microinverter-96 Cells (Model GEN 2.2-HV-208/240V)',
            Inverter_Model__c = 'Microinverter-96 Cells (Model GEN 2.2-HV-208/240V)',
            Inverter_Quantity_2__c = 10,
            Inverter_Quantity__c = 16,
            Lease_Doc_Signed__c = true,
            Lease_Doc_Terminated__c = true,
            Module_Brand__c = 'SunPower',
            Module__c = 'SPR-X21-345-C-AC',
            Monitoring_System_Option__c = 'SunPower PVS5 Production Monitoring',
            Monthly_Power_Bill_After_Solar__c = '16.565',
            Monthly_Power_Bill_Before_Solar__c = '119',
            Mounting_Option__c = 'InvisiMount',
            Oracle_Vendor_email_field_value__c = 'corina@thesolarprogram.com',
            Origination__c = 4042.00,
            Power_Used_Before_Solar_kWh_year__c = '11188.99991',
            Proposed_Electric_Utility__c = 'Consolidated Edison',
            Proposed_Rate_Name__c = '_NM_NY_CONSOLIDATED_R',
            Quote_Inverter_Values__c = 'Sunpower- GEN 2.2-HV-208/240V(26)',
            Racking_Quantity__c = '5',
            Scenario_Index__c = 1,
            Solar_Rebate_Amount__c = 4485.00,
            System_Cost__c = 38150.00,
            The_Endo_Box__c = false,
            Total_Monthly_Payments__c = 37956.36,
            Original_Lease_doc_Date__c = startDate.addDays(1),
            Lease_doc_Signed_Date__c = startDate.addDays(2),
            Lease_doc_Created_Date__c = startDate.addDays(3),
            Lease_doc_Sent_out_for_Signature__c = startDate.addDays(4),
            Consolidated_Lease_Number_Dup__c = '1033650',
            System_Production_Year_1__c = 11189.00,
            Lessor__c = 'SunPower Capital, LLC',
            Sent_Welcome_Email__c = true,
            Annual_Usage__c = 11189,
            Auto_Driving_Reduction__c = 7797.332808,
            CO2_Emissions_Reduction__c = 6497.7773,
            Current_Rate__c = 'NY_CONSOLIDATED_R',
            Design_Factor__c = 'Automatic',
            Down_Payment__c = 0.00,
            Elapsed_Time__c = '19.15s',
            End_Date__c = endDate,
            Incentives_detail_1__c = 'NYSERDA PV EPBB (ConEd Res.) (Block 6), 90% DF',
            Incentives_detail_1_amt__c = 4485,
            Incentives_detail_2__c = 'Federal PV Tax Credit (Res.)',
            Incentives_detail_2_amt__c = 11694.9,
            InstallDate__c = 'July 2016',
            Inv_0_Layout_0_ModuleCountPerString__c = 1,
            Inv_0_Layout_0_ParallelStringsCount__c = 16,
            Inverter_0_Layout_0_AxisTiltAngle__c = '23',
            Inverter_0_Layout_0_Shading_Month_10__c = '0',
            Inverter_0_Layout_0_Shading_Month_11__c = '0.01',
            Inverter_0_Layout_0_Shading_Month_12__c = '0.06',
            Inverter_0_Layout_0_Shading_Month_1__c = '0.03',
            Inverter_0_Layout_0_Shading_Month_2__c = '0',
            Inverter_0_Layout_0_Shading_Month_3__c = '0',
            Inverter_0_Layout_0_Shading_Month_4__c = '0',
            Inverter_0_Layout_0_Shading_Month_5__c = '0',
            Inverter_0_Layout_0_Shading_Month_6__c = '0.01',
            Inverter_0_Layout_0_Shading_Month_7__c = '0',
            Inverter_0_Layout_0_Shading_Month_8__c = '0',
            Inverter_0_Layout_0_Shading_Month_9__c = '0',
            Inverter_0_Layout_0_StandardPVModuleId__c = 658,
            Inverter_0_Layout_0_SystemAzimuth__c = 345,
            Inverter_0_StandarInverterId__c = 1052,
            Inverter_Manufacturer_Roof1__c = 'Sunpower',
            Inverter_Manufacturer_Roof2__c = 'Sunpower',
            Isnew__c = true,
            Latitude__c = '40.508858',
            Longitude__c = '-74.24174',
            Modules_Per_String_Roof1__c = 1,
            Modules_Per_String_Roof2__c = 1,
            Modules__c = '327W (Model SPR-245NE-WHT-D)',
            Monitoring_System__c = 'PVS5 Production Monitoring',
            Mounting_Description__c = 'InvisiMount_TM',
            Not_An_Historical_Quote__c = true,
            Optional_Incentives__c = 'Use None',
            QuoteType__c = 'Lease',
            REC_Life_Years__c = 0,
            REC_Value_kWh__c = 0.000,
            Recalculate__c = '1',
            Status__c = 'Ok',
            System_Model__c = '345W (Model SPR-X21-345-C-AC)',
            Target_Implied_Rate__c = 0,
            Total_Energy__c = 11511,
            Total_Parallel_Strings_Roof1__c = 16,
            Total_Parallel_Strings_Roof2__c = 10,
            Trees_Planted__c = 0.502250144714876033057851239669421,
            Total_Energy_Test__c = 11511,
            Adder_Fee__c = 0.00,
            Create_TPS_PO__c = false,
            DRIP_Fee__c = 4100.00,
            IP_Fee__c = 6540.429,
            TPS_Fee__c = 6517.00,
            Credit_Bureau__c = 'Loanpath',
            Proposal_Prep_by__c = 'Corina Loayza',
            Sector__c = 'Residential'
        );
        thirdList.add(testQuote);
        mapTestData.put('testQuote', testQuote);
        
        insert thirdList;
        List<sObject> forthList = new List<sObject>();
        /***********************************************************Residential Project****************************************************************/
        Residential_Project__c testProject = new Residential_Project__c(
            Name = 'Test Residential Project',
            CurrencyIsoCode = 'USD',
            RecordTypeId = Schema.SObjectType.Residential_Project__c.getRecordTypeInfosByName().get('SPD').getRecordTypeId(),
            Account__c = testAccount.Id,
            AHJ_Specific_Equipment__c = '1',
            Battery_Storage_System_Details__c = 'td test',
            Battery_Storage__c = 'Yes',
            Can_solar_breaker_be_installed_in_MSP__c = 'Yes',
            Consumption_Monitoring_Compatible__c = 'TBD',
            HOA_Contact_Number__c = 'TEST-HOA-004',
            HOA_Name__c = 'HOA',
            Homeowner_Utility_Account_No__c = '1',
            Homeowner_Utility_Meter_No__c = '1',
            Installation_Type__c = 'Comp Shingle',
            Main_Breaker_Location__c = 'Top',
            Main_Breaker_Rating_Amps__c = '100',
            Main_Service_Panel_Location__c = 'Exterior Wall',
            Main_Service_Panel_Manufacturer__c = 'Bryant',
            Multi_Level_Home__c = 'Single',
            Opportunity__c = testOpportunity.Id,
            Other_Main_Breaker_Location__c = '1',
            Other_Main_Service_Panel_Location__c = '1',
            Other_Main_Service_Panel_Manufacturer__c = '1',
            Primary_Contact__c = testContact.Id,
            Priority__c = 'Normal',
            Quote__c = testQuote.Id,
            Sales_Order_Number__c = 'TEST-002',
            Smart_Thermostat__c = 'Yes',
            Status__c = 'Active',
            Thermostat_Manufacturer__c = 'ecobee',
            Yard_Sign_Approved__c = true,
            HOA__c = 'Yes',
            Installation_Partner__c = anaheimPartnerAccount.Id,
            Opportunity_Owner_Email__c = 'expertservice@skedulo.com',
            Project_Template__c = spriTemplateProject.Id,
            System_Adders__c = 'IP-Flat Roof',
            EV_Charger_Available__c = 'Yes' 
        );
        forthList.add(testProject);
        mapTestData.put('testProject', testProject);
        
        insert forthList;
        List<sObject> remains = new List<sObject>();
        /***********************************************************Project Team Member****************************************************************/
        Project_Team_Member__c teamMember = new Project_Team_Member__c(
            Residential_Project__c = testProject.Id,
            User__c = UserInfo.getUserId(),
            Role__c = 'Regional Operations Manager'
        );
        remains.add(teamMember);
        insert remains;
        
        return mapTestData;
    }
    
    public static void setupProjectTask(string jobType, Map<string, sObject> mapTestData, List<sObject> secondList, Residential_Project__c spriTemplateProject) {
        if (jobType == skedConstants.JOB_TYPE_SITE_SURVEY) {
            Project_Task__c projectTask1 = new Project_Task__c(
                Name = 'Schedule Site Survey',
                RecordTypeId = Schema.SObjectType.Project_Task__c.getRecordTypeInfosByName().get('Task Template').getRecordTypeId(),
                Residential_Project__c = spriTemplateProject.Id,
                Critical_Path__c = true,
                Document_Required__c = false,
                Milestone__c = 'Project Intake',
                Order__c = 1,
                Project_Priority__c = 'Normal',
                Role_Assignment__c = 'Project Coordinator',
                SLA_Days__c = 1,
                Status__c = 'Not Started',
                Rework_Category__c = 'Incomplete Site Survey'
            );
            secondList.add(projectTask1);
            
            Project_Task__c projectTask2 = new Project_Task__c(
                Name = 'Perform Site Survey',
                RecordTypeId = Schema.SObjectType.Project_Task__c.getRecordTypeInfosByName().get('Task Template').getRecordTypeId(),
                Residential_Project__c = spriTemplateProject.Id,
                Critical_Path__c = true,
                Description__c = 'Site Surveyor conducts site survey at Homeowner site and submits site survey documentation to Site Survey task record.',
                Document_Required__c = false,
                Milestone__c = 'Site Survey',
                Order__c = 2,
                Project_Priority__c = 'Normal',
                Role_Assignment__c = 'Site Surveyor',
                SLA_Days__c = 5,
                Status__c = 'Not Started',
                Rework_Category__c = 'Incomplete Site Survey'
            );
            secondList.add(projectTask2);
        }
        else if (jobType == skedConstants.JOB_TYPE_INSTALLATION) {
            Project_Task__c projectTask3 = new Project_Task__c(
                Name = 'Schedule Install with Homeowner',
                RecordTypeId = Schema.SObjectType.Project_Task__c.getRecordTypeInfosByName().get('Task Template').getRecordTypeId(),
                Residential_Project__c = spriTemplateProject.Id,
                Critical_Path__c = true,
                Document_Required__c = false,
                Milestone__c = 'Installation',
                Order__c = 1,
                Project_Priority__c = 'Normal',
                Role_Assignment__c = 'Project Coordinator',
                SLA_Days__c = 1,
                Status__c = 'Not Started',
                Rework_Category__c = 'Incomplete Site Survey'
            );
            secondList.add(projectTask3);
            
            Project_Task__c projectTask4 = new Project_Task__c(
                Name = 'System Installation Start',
                RecordTypeId = Schema.SObjectType.Project_Task__c.getRecordTypeInfosByName().get('Task Template').getRecordTypeId(),
                Residential_Project__c = spriTemplateProject.Id,
                Critical_Path__c = true,
                Document_Required__c = false,
                Milestone__c = 'Installation',
                Order__c = 2,
                Project_Priority__c = 'Normal',
                Role_Assignment__c = 'Regional Operations Manager',
                Status__c = 'Not Started',
                Rework_Category__c = 'Incomplete Site Survey'
            );
            secondList.add(projectTask4);
            
            Project_Task__c projectTask5 = new Project_Task__c(
                Name = 'System Installation Complete',
                RecordTypeId = Schema.SObjectType.Project_Task__c.getRecordTypeInfosByName().get('Task Template').getRecordTypeId(),
                Residential_Project__c = spriTemplateProject.Id,
                Critical_Path__c = true,
                Document_Required__c = false,
                Milestone__c = 'Installation',
                Order__c = 3,
                Project_Priority__c = 'Normal',
                Role_Assignment__c = 'Regional Operations Manager',
                SLA_Days__c = 1,
                Status__c = 'Not Started',
                Rework_Category__c = 'Incomplete Site Survey'
            );
            secondList.add(projectTask5);
        }
        else if (jobType == skedConstants.JOB_TYPE_INSPECTION) {
            Project_Task__c projectTask6 = new Project_Task__c(
                Name = 'Schedule Inspection',
                RecordTypeId = Schema.SObjectType.Project_Task__c.getRecordTypeInfosByName().get('Task Template').getRecordTypeId(),
                Residential_Project__c = spriTemplateProject.Id,
                Critical_Path__c = true,
                Document_Required__c = false,
                Milestone__c = 'Inspection',
                Order__c = 1,
                Project_Priority__c = 'Normal',
                Role_Assignment__c = 'Inspection Coordinator',
                SLA_Days__c = 1,
                Status__c = 'Not Started',
                Rework_Category__c = 'Incomplete Site Survey'
            );
            secondList.add(projectTask6);
            
            Project_Task__c projectTask7 = new Project_Task__c(
                Name = 'Complete Inspection',
                RecordTypeId = Schema.SObjectType.Project_Task__c.getRecordTypeInfosByName().get('Task Template').getRecordTypeId(),
                Residential_Project__c = spriTemplateProject.Id,
                Critical_Path__c = true,
                Document_Required__c = false,
                Milestone__c = 'Inspection',
                Order__c = 2,
                Project_Priority__c = 'Normal',
                Role_Assignment__c = 'Inspection Coordinator',
                SLA_Days__c = 2,
                Status__c = 'Not Started',
                Rework_Category__c = 'Incomplete Site Survey'
            );
            secondList.add(projectTask7);
        }
    }
    
    public static Map<string, sObject> setupSkeduloApiTestData() {
        Date startDate = system.today().toStartOfWeek();
        DateTime todayDt = DateTime.newInstance(system.today(), time.newInstance(0, 0, 0, 0));
        Date endDate = startDate.addDays(14);
        
        Map<string, sObject> mapTestData = skedDataSetup.setupCommonTestData(skedConstants.JOB_TYPE_SITE_SURVEY);
        Residential_Project__c testProject = (Residential_Project__c)mapTestData.get('testProject');
        Account testAccount = (Account)mapTestData.get('testAccount');
        sked__Resource__c siteSurveyor1 = (sked__Resource__c)mapTestData.get('siteSurveyor1');
        sked__Region__c anaheimRegion = (sked__Region__c)mapTestData.get('anaheimRegion');
        
        sked__Job__c job = new sked__Job__c(
            Residential_Project__c = testProject.Id,
            sked__Region__c = anaheimRegion.Id,
            sked__Account__c = testAccount.Id,
            sked__Address__c = '77 Rio Robles, San Jose, CA 95134, USA',
            sked__GeoLocation__Latitude__s = 37.4050308,
            sked__GeoLocation__Longitude__s = -121.9466052,
            sked__Type__c = skedConstants.JOB_TYPE_SITE_SURVEY,
            sked__Start__c = todayDt.addDays(1).addHours(9),
            sked__Finish__c = todayDt.addDays(1).addHours(11),
            sked__Duration__c = 120,
            sked__Job_Status__c = skedConstants.JOB_STATUS_PENDING_DISPATCH
        );
        insert job;
            
        sked__Job_Allocation__c jobAlloc = new sked__Job_Allocation__c(
        	sked__Status__c = skedConstants.JOB_ALLOCATION_STATUS_PENDING_DISPATCH,
            sked__Job__c = job.Id,
            sked__Resource__c = siteSurveyor1.Id
        );
        insert jobAlloc;
        
        testProject.Scheduled_Site_Survey_Date__c = todayDt.addDays(1).addHours(9);
        update testProject;
        
        return mapTestData;
    }
    
}