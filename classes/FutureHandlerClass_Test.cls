@isTest(SeeAllData=true)
public class FutureHandlerClass_Test {
    static testMethod void FutureHandlerClassTest()
    {        
        Map<String, Id> mRTusr = new Map<String, Id>();
        for(user rt : [SELECT id, name FROM user WHERE Name = 'Chris Mahoney']) // Amit Saha
            mRTusr.put(rt.Name, rt.Id);
            
        Account acc = new Account();  
            acc.Name = 'Test Act111';
            acc.CurrencyIsoCode = 'USD';
            acc.BillingStreet = '10 Main Rd.';
            acc.BillingState = 'NY';
            acc.BillingCity = 'New York';
            acc.BillingCountry = 'United States';
            acc.BillingPostalCode = '31349';
            acc.ShippingStreet = 'The Landmark @ One Market, Suite 300';
            acc.ShippingState = 'CA';
            acc.ShippingCity = 'San Francisco';
            acc.ShippingCountry = 'United States';
            acc.ShippingPostalCode = '94105';
            acc.x_Account_Owner__c = mRTusr.get('Chris Mahoney');        
        Insert acc;

        Contact con = new Contact();
            con.accountid = acc.id;
            con.LastName = 'TestLastName' ;
            con.Email = 'contactTestEmail@test.com';
            con.LMS_Job_ID__c = 'Sales';
        Insert con;         
        
        opportunity Opp = new opportunity();
            Opp.Name = 'Test Opp';
            Opp.accountid = acc.id;
            Opp.CurrencyIsoCode = 'USD';
            opp.StageName = '12% - Qualified Opportunity';
            opp.Reason_Won_Lost__c = 'Other';
            opp.Reason_Won_Lost_comments__c = 'Test';
            opp.CloseDate = date.newInstance(2012, 5, 12);
        Insert Opp;      

        Quote_Summary__c QS = new Quote_Summary__c();
            QS.opportunity__c = Opp.id;
            QS.Lease_Doc_Signed__c = True;
        Insert Qs;        

        //List<Quote> lstQ =  new List<Quote>();
        Quote Q = new Quote();
            Q.Opportunityid = Opp.id;
            Q.account__c = acc.id;
            Q.Quote_Summary__c = Qs.id;
            Q.Name = 'Test Qte' ; 
            Q.Oracle_Vendor_email_field_value__c = 'test@test.com';
            //Q.TestPSR_Email__c = 'test2@test2.com';
            Q.Primary_PSR_Email_Id__c = 'test3@test3.com';
            Q.Inverter_Brand__c = 'SunPower';
            Q.Inverter_Model__c = 'SPR-5000m (240V)';
            Q.Inverter_Quantity__c = 1;
            Q.Inverter_Brand_2__c = 'SunPower 2';
            Q.Inverter_Model_2__c = 'SPR-5000m (241V)';
            Q.Inverter_Quantity_2__c = 2;
            Q.Trigger_Checkbox__c = false;
            Q.Send_Lien_Waiver_Agreement__c = false;
            Q.Inverter_Brand_3__c = 'SunPower 3';
            Q.Inverter_Model_3__c = 'SPR-5000m (242V)';
            Q.Inverter_Quantity_3__c = 3;
            Q.Inverter_Brand_4__c = 'SunPower 4';
            Q.Inverter_Model_4__c = 'SPR-5000m (243V)';
            Q.Inverter_Quantity_4__c = 4;
            Q.Quote_Inverter_Values__c = 'SunPower-SPR-5000m (240V) 1';
            Q.Temp_Contact_1__c = con.id;
            Q.Temp_Contact_2__c = con.id; 
            Q.Dealer_Fees__c = 500;
            Q.Is_Locked__c = False;
            Q.Lease_Doc_Signed__c = false;
            Q.Dealer_Fees__c = 300;        
            //Q.Is_Locked__c = True;
            Q.Lease_Doc_Signed__c = True;
            Q.Quote_type__c = 'Residential Lease Quotation';
            Q.Doc_out_for_signature__c = false;    
        insert Q;

        List<echosign_dev1__SIGN_Agreement__c> lstA = new List<echosign_dev1__SIGN_Agreement__c>(); 
    
        echosign_dev1__SIGN_Agreement__c agreement = new echosign_dev1__SIGN_Agreement__c();
            agreement.name = 'Lease Test';
            agreement.echosign_dev1__Status__c = 'Draft';
            agreement.quote__c = Q.Id;
            agreement.Account__c = acc.Id;
            agreement.OwnerId = mRTusr.get('Chris Mahoney');
            agreement.Approved__c = false;
            agreement.RecordTypeId = Lease_2_1_PO_Creation__c.getValues('Counter Signature Info').Lien_Waiver_Id__c;
            agreement.echosign_dev1__Recipient__c = '00380000019YXbE';
            agreement.echosign_dev1__Recipient2__c = '00380000019YXbE';
        lstA.add(agreement);

        if(!lstA.ISeMPTY()){
            insert lstA;
                //lstA[0].Approved__c = true;
                lstA[0].Approved__c = true; 
            update lstA;
        }
        
        List<LeasePayment__c> lstLP = new List<LeasePayment__c>();
        LeasePayment__c LP = new LeasePayment__c();
            LP.Name = 'Test Lease Payment';
            LP.Account__c = acc.Id;
            LP.Uncond_Fin_LW_Rcvd__c = Date.Today();
        lstLP.add(LP);
        
        if(!lstLP.isEmpty()){
            insert lstLP;
            
            if(lstA[0].Approved__c == true && lstA[0].Lease_Number__c == lstLP[0].Lease__c)
                lstLP[0].Uncond_Fin_LW_Rcvd__c = lstA[0].echosign_dev1__DateSignedDate__c;
            update lstLP;
        }
        
    }
}