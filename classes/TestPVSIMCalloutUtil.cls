/*** Class added in Sunpower TPO Phase 1 -- 20/10/2013, to cover PVSIMCalloutUtil class ***/
//@isTest(seeAllData = true)
public class TestPVSIMCalloutUtil{/*
    static testMethod void TestPvsimCallout(){
        Opportunity newOpportunity;
        Quote newQuote;
        newOpportunity = [Select Id from Opportunity Where name='Test Class DO NOT TOUCH'];
        newQuote = TestUtils.createQuotes( 1, 'Quick Quote Test ', newOpportunity.Id, false).get(0);
        newQuote.System_Model__c = 'SPR-245NE-WHT (IN-ROOF SL)';
        newQuote.Inverter_Model_Roof1__c ='SPR-600P-TL1-EU';
        newQuote.Inverter_Model__c='model1';
        newQuote.Inverter_Model_Roof2__c='roof2';
        newQuote.Inverter_Model_2__c='model2';
        newQuote.Inverter_Model_Roof3__c='roof3';
        newQuote.Inverter_Model_3__c='model3';
        newQuote.Inverter_Model_Roof4__c='roof4';
        newQuote.Inverter_Model_4__c='model4';
        insert newQuote;
        
        Roof_Details__c roof1 = new Roof_Details__c();
        roof1.Description__c = 'abc';
        roof1.Jan__c = 99.0;
        roof1.Feb__c = 99.0;
        roof1.Mar__c = 99.0;
        roof1.Apr__c = 99.0;
        roof1.May__c = 99.0;
        roof1.Jun__c = 99.0;
        roof1.Jul__c = 99.0;
        roof1.Aug__c = 99.0;
        roof1.Sep__c = 99.0;
        roof1.Oct__c = 99.0;
        roof1.Nov__c = 99.0;
        roof1.Dec__c = 99.0;
        insert roof1;
        
        Roof_Details__c roof2 = new Roof_Details__c();
        roof2.Description__c = 'xyz';
        roof2.Direction__c = 0.0;
        roof2.Pitch__c = '15';
        roof2.Jan__c = 99.0;
        roof2.Feb__c = 99.0;
        roof2.Mar__c = 99.0;
        roof2.Apr__c = 99.0;
        roof2.May__c = 99.0;
        roof2.Jun__c = 99.0;
        roof2.Jul__c = 99.0;
        roof2.Aug__c = 99.0;
        roof2.Sep__c = 99.0;
        roof2.Oct__c = 99.0;
        roof2.Nov__c = 99.0;
        roof2.Dec__c = 99.0;
        insert roof2;
        
        List<Roof_Details__c> roofs = new list<Roof_Details__c>();
        roofs = [select id,Jan__c,Feb__c,Mar__c,Apr__c,May__c,Jun__c,Jul__c,Aug__c,Sep__c,Oct__c,Nov__c,Dec__c from Roof_Details__c where description__c ='xyz'];
        
        list<string> lst_ShadingData = new list<string>();
            for(Roof_Details__c roo : roofs){
                lst_ShadingData.add(String.valueOf(1-(roo.jan__c/100)));
                lst_ShadingData.add(String.valueOf(1-(roo.feb__c/100)));
                lst_ShadingData.add(String.valueOf(1-(roo.mar__c/100)));
                lst_ShadingData.add(String.valueOf(1-(roo.apr__c/100)));
                lst_ShadingData.add(String.valueOf(1-(roo.may__c/100)));
                lst_ShadingData.add(String.valueOf(1-(roo.jun__c/100)));
                lst_ShadingData.add(String.valueOf(1-(roo.jul__c/100)));
                lst_ShadingData.add(String.valueOf(1-(roo.aug__c/100)));
                lst_ShadingData.add(String.valueOf(1-(roo.sep__c/100)));
                lst_ShadingData.add(String.valueOf(1-(roo.oct__c/100)));
                lst_ShadingData.add(String.valueOf(1-(roo.nov__c/100)));
                lst_ShadingData.add(String.valueOf(1-(roo.dec__c/100)));
            }
        TPO_PVsimIntegration tpo = new TPO_PVsimIntegration();
        TPO_PVsimIntegration.ArrayOfMonthlyShadingData shadingdata = new TPO_PVsimIntegration.ArrayOfMonthlyShadingData();
        PVSIMCalloutUtil pcu = new PVSIMCalloutUtil();
        PVSIMCalloutUtil.putIdsAndShadingValues(roofs);
        PVSIMCalloutUtil.createEnergyOutput(); 
        PVSIMCalloutUtil.createShadingDataForRoof(lst_ShadingData);
        PVSIMCalloutUtil.createLayoutData(roof2, shadingData, 1, newQuote.id, 1, 1);
        PVSIMCalloutUtil.getMapOfRoofToPVSIMNum(newQuote.id);
        PVSIMCalloutUtil.createLayoutData(roof2, shadingData, 1, newQuote.id, 1, 2);
        PVSIMCalloutUtil.createLayoutData(roof2, shadingData, 1, newQuote.id, 2, 1);
        PVSIMCalloutUtil.createLayoutData(roof2, shadingData, 1, newQuote.id, 2, 2);
        PVSIMCalloutUtil.createLayoutData(roof2, shadingData, 2, newQuote.id, 1, 1);
        PVSIMCalloutUtil.createLayoutData(roof2, shadingData, 2, newQuote.id, 1, 2);
        PVSIMCalloutUtil.createLayoutData(roof2, shadingData, 2, newQuote.id, 2, 1);
        PVSIMCalloutUtil.createLayoutData(roof2, shadingData, 2, newQuote.id, 2, 2);
        PVSIMCalloutUtil.createLayoutData(roof2, shadingData, 3, newQuote.id, 1, 1);
        PVSIMCalloutUtil.createLayoutData(roof2, shadingData, 3, newQuote.id, 1, 2);
        PVSIMCalloutUtil.createLayoutData(roof2, shadingData, 3, newQuote.id, 2, 1);
        PVSIMCalloutUtil.createLayoutData(roof2, shadingData, 3, newQuote.id, 2, 2);
        PVSIMCalloutUtil.createLayoutData(roof2, shadingData, 4, newQuote.id, 1, 1);
        PVSIMCalloutUtil.createLayoutData(roof2, shadingData, 4, newQuote.id, 1, 2);
        PVSIMCalloutUtil.createLayoutData(roof2, shadingData, 4, newQuote.id, 2, 1);
        PVSIMCalloutUtil.createLayoutData(roof2, shadingData, 4, newQuote.id, 2, 2);
        //PVSIMCalloutUtil.getPVSIMNumberForRoofId('abc');
    }*/
}