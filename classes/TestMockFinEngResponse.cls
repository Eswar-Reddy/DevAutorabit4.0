global class TestMockFinEngResponse implements HttpCalloutMock {
   global HTTPResponse respond(HTTPRequest req) {   
        
        string sfakeFinEngResponse  = '<?xml version="1.0" encoding="utf-8"?><abc><batchoutput id="1"><output name="Down Payment"><value>6000.0</value></output><output name="Rent Payments"><value>176.040991613</value><value>176.040991613</value><value>176.040991613</value><value>176.040991613</value><value>176.040991613</value><value>176.040991613</value><value>176.040991613</value><value>176.040991613</value><value>176.040991613</value><value>176.040991613</value><value>176.040991613</value><value>176.040991613</value><value>176.040991613</value><value>176.040991613</value><value>176.040991613</value><value>176.040991613</value><value>176.040991613</value><value>176.040991613</value><value>176.040991613</value><value>176.040991613</value></output><output name="Termination Values"><value>-1</value><value>-1</value><value>-1</value><value>-1</value><value>-1</value><value>-1</value><value>-1</value><value>-1</value><value>-1</value><value>-1</value><value>-1</value><value>-1</value><value>-1</value><value>-1</value><value>-1</value><value>-1</value><value>-1</value><value>-1</value><value>-1</value><value>-1</value></output><output name="Dealer Fee"><value>25536.0</value></output><output name="Total Contract Price"><value>42754.4212445</value></output><output name="Cost of Financing"><value>4410.53054934</value></output><output name="Financed Amount"><value>36754.4212445</value></output><output name="CoPayment"><value>6000.0</value></output><output name="CoPay Indicator"><value>False</value></output><output name="Equip and Install Value"><value>38343.8906952</value></output></batchoutput></abc>';        
        HttpResponse hResquest = new HttpResponse();
        hResquest.setHeader('Content-Type', 'application/xml');
        hResquest.setBody(sfakeFinEngResponse); 
       
        return hResquest;
       
   }
}