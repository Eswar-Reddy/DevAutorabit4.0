//Mosiac API Calls
public class Mosaic_API_CallHandler{

    public static Loan_Callout_Settings__c mcs = Loan_Callout_Settings__c.getInstance('Mosaic');
    public static Contact cont = new Contact();
    public static Boolean isUserCreated = false;
    //***************************GET MOSAIC ACCESS TOKEN************************
    public static String getMosaicAccessToken(){
            try{
                String endPointURL = mcs.Endpoint_URL__c+'/api/v1/access-token';
                String clientSecret = mcs.Client_Secret__c;
                String clientId = mcs.Client_Id__c;
                String grantType = mcs.Grant_Type__c;
                
                
                String authString ='?client_id='+clientId+'&client_secret='+clientSecret+'&grant_type='+grantType;    
                
                Httprequest request = new HttpRequest();
                Http http = new Http();
                request.setMethod('POST');
                request.setEndpoint(endPointURL+authString);
                System.debug('requestEndpoint----->'+request.getEndpoint());
                HttpResponse response = http.send(request);
                System.debug('response----->'+response.getBody());
                Map<String,Object> data = (Map<String,Object>)JSON.deserializeUntyped(response.getBody());
                String accessToken = (String)data.get('access_token');
                return accessToken;
                
            }catch(Exception e){
                System.debug('Error::'+e.getMessage());
                return null;
            }
    }
    
    //***********************************CREATE OPPORTUNITY****************************************
    public static MosaicJSONUtil.MosaicResponse mosaic_Create_Opportunity(Contact con){
        system.debug('User Email:'+userinfo.getUserEmail());
        cont = con;
        MosaicJSONUtil.Address addr = new MosaicJSONUtil.Address(con.MailingStreet,'',con.MailingCity,con.MailingState,con.MailingPostalCode);
        MosaicJSONUtil.Opportunity opp = new MosaicJSONUtil.Opportunity(con.FirstName,con.LastName,con.Phone.replaceAll('\\D',''),con.Email,addr,userinfo.getUserEmail(),null);
        System.debug('opp ----->'+opp);
        
        String JSONString = JSON.serialize(opp);
        System.debug('JSONString ----->'+JSONString);
        String endPointURL = mcs.Endpoint_URL__c + '/api/v1/opportunities';
        String authorizationHeader = 'Bearer ' + getMosaicAccessToken();

        Httprequest request = new HttpRequest();
        Http http = new Http();
        request.setMethod('POST');
        request.setEndpoint(endPointURL);
        request.setHeader('Content-Type', 'application/json');
        // Header info with remote server user name and password
        request.setHeader('Authorization', authorizationHeader);
        // timeout in milliseconds       
        request.setTimeout(120000); 
        request.setBody(JSONString);          
        //Making call to external REST API
        HttpResponse response = http.send(request);
        //System.debug('requestBody: '+request.getBody());
        System.debug('responseBody: '+response.getBody());
        
        String JsonResponse = response.getBody();
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,JsonResponse));
        MosaicJSONUtil.MosaicResponse mosResp = new MosaicJSONUtil.MosaicResponse();
        
        if(response.getStatusCode()==200){
            MosaicJSONUtil.Opportunity resopp =
                (MosaicJSONUtil.Opportunity)JSON.deserialize(JsonResponse, MosaicJSONUtil.Opportunity.class);
            mosResp.opp = resopp;
            mosResp.successful = true;
        }
        else{
            mosResp.successful = false;
            mosResp.responsebody = response.getBody();
            mosaic_CreateLogin();

        }
        mosResp.request = request;
        mosResp.response = response;
        return mosResp;       
    }
    
    public Static void mosaic_CreateLogin(){
        User u = [Select id, FirstName, LastName, Phone from User where id =: userinfo.getUserId()];
        system.debug('u---->'+u);
        MosaicJSONUtil.createLogin cLogin = new MosaicJSONUtil.createLogin(userinfo.getFirstName(),userinfo.getLastName(),u.Phone!=null?u.Phone.replaceAll('\\D',''):'8007867693',userinfo.getUserEmail(),null,'NOTIFICATIONS_ONLY',null);
        System.debug('cLogin ----->'+cLogin);
        
        String JSONString = JSON.serialize(cLogin);
        System.debug('JSONString ----->'+JSONString);
        String endPointURL = mcs.Endpoint_URL__c + '/api/v1/logins';
        String authorizationHeader = 'Bearer ' + getMosaicAccessToken();

        Httprequest request = new HttpRequest();
        Http http = new Http();
        request.setMethod('POST');
        request.setEndpoint(endPointURL);
        request.setHeader('Content-Type', 'application/json');
        // Header info with remote server user name and password
        request.setHeader('Authorization', authorizationHeader);
        // timeout in milliseconds       
        request.setTimeout(120000); 
        request.setBody(JSONString);          
        //Making call to external REST API
        HttpResponse response = http.send(request);
        //System.debug('requestBody: '+request.getBody());
        System.debug('responseBody: '+response.getBody());
        String JsonResponse = response.getBody();
        if(response.getStatusCode()==200){
            isUserCreated = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'A User Has been Created in Mosaic.Please resubmit the Credit Check Application.'));
        }
        else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,JsonResponse));

        }    
    }
    //***********************************UPDATE OPPORTUNITY****************************************
    public static MosaicJSONUtil.MosaicResponse mosaic_Update_Opportunity(Credit_Check_Request__c cca,Quote qt,Quote_Summary__c qs,Credit_Product__c cp){
        MosaicJSONUtil.Address addr = new MosaicJSONUtil.Address(cca.Street__c,cca.Street2__c,cca.City__c,cca.State__c,cca.Zip__c);
        System_Production__c sp = [select id,Monthly_Electric_Bill_Without_PV_year1__c from System_Production__c where Quote__c = :qt.Id];
        String inverterManufacturer = qt.Inverter_Manufacturer_Roof1__c=='PowerOne'?'ABB':qt.Inverter_Manufacturer_Roof1__c=='Sunpower'?'SunPower':qt.Inverter_Manufacturer_Roof1__c;
        
        MosaicJSONUtil.SolarSystem slrSys = new MosaicJSONUtil.SolarSystem(Double.valueOf(sp.Monthly_Electric_Bill_Without_PV_year1__c), Double.valueOf(qt.Monthly_Power_Bill_After_Solar__c),Integer.valueOf(qt.System_Production_Year_1__c),Double.valueOf(qt.Maximum_Rated_Capacity__c),'SunPower '+qt.System_model__c,inverterManufacturer+' '+qt.Inverter_Model__c,Double.valueOf(qt.Financed_Amount__c), String.valueOf(Datetime.now().format('yyyy-MM-dd')), qt.Consolidated_Lease_Number__c ,String.valueOf(Datetime.now().format('yyyy-MM-dd')),'NONE',cp.Product_Display_Name__c, Double.valueOf(qt.Total_Contract_Price__c));
        MosaicJSONUtil.Opportunity opp = new MosaicJSONUtil.Opportunity(cca.First_Name__c,cca.Last_Name__c,cca.Phone__c.replaceAll('\\D',''),cca.Email__c,addr,mcs.SalesRepEmail__c,slrSys);
        
        System.debug('oppSS ----->'+opp);
        System.debug('slrSys ----->'+slrSys);
        String JSONString = JSON.serialize(opp);
        System.debug('JSONString ----->'+JSONString);
        String endPointURL = mcs.Endpoint_URL__c + '/api/v1/opportunities/';
        String authorizationHeader = 'Bearer ' + getMosaicAccessToken();

        Httprequest request = new HttpRequest();
        Http http = new Http();
        request.setMethod('PUT');
        request.setEndpoint(endPointURL+cca.Application_Id__c);
        request.setHeader('Content-Type', 'application/json');
        // Header info with remote server user name and password
        request.setHeader('Authorization', authorizationHeader);
        // timeout in milliseconds 
        request.setTimeout(120000);
        request.setBody(JSONString);
        System.debug('requestBody: '+request.getBody());
        
        //Making call to external REST API
        HttpResponse response = http.send(request);
        
        System.debug('responseBody: '+response.getBody());
        
        String JsonResponse = response.getBody();
        MosaicJSONUtil.MosaicResponse mosResp = new MosaicJSONUtil.MosaicResponse();
        
        if(response.getStatusCode()==200){
            MosaicJSONUtil.Opportunity resopp =
                (MosaicJSONUtil.Opportunity)JSON.deserialize(JsonResponse, MosaicJSONUtil.Opportunity.class);
            mosResp.opp = resopp;
            mosResp.successful = true;
        }
        else{
            mosResp.successful = false;
            mosResp.responsebody = response.getBody();
        }
        mosResp.request = request;
        mosResp.response = response;
        return mosResp;       
    } 
    
    
    //***********************************SEND CREDIT CHECK****************************************
    public static MosaicJSONUtil.MosaicResponse mosaic_Send_Credit_Application(String oppId){
        String endPointURL = mcs.Endpoint_URL__c+'/api/v1/opportunities/'+oppId+'/send-credit-application';
        String authorizationHeader = 'Bearer ' + getMosaicAccessToken();

        Httprequest request = new HttpRequest();
        Http http = new Http();

        request.setMethod('POST');
        request.setEndpoint(endPointURL);
        request.setHeader('Authorization', authorizationHeader);    
        request.setTimeout(120000);  
        
        HttpResponse response = http.send(request);
        
        System.debug('responseBody: '+response.getBody());
        
        String JsonResponse = response.getBody();
        
        MosaicJSONUtil.MosaicResponse mosResp = new MosaicJSONUtil.MosaicResponse();       
        
        if(response.getStatusCode()==200){
            mosResp.successful=true;
        }
        else{
            mosResp.successful=false;
            mosResp.responsebody = response.getBody();
        }
        mosResp.request = request;
        mosResp.response = response;
        return mosResp;
    }
    
    
    //***********************************SEND LENDING AGREEMENT****************************************
    public static MosaicJSONUtil.MosaicResponse mosaic_Send_Loan_Agreement(String oppId){
        String endPointURL = mcs.Endpoint_URL__c+'/api/v1/opportunities/'+oppId+'/send-loan-agreement';
        String authorizationHeader = 'Bearer ' + getMosaicAccessToken();
        
        Httprequest request = new HttpRequest();
        Http http = new Http();
        
        request.setMethod('POST');
        request.setEndpoint(endPointURL);
        request.setHeader('Authorization', authorizationHeader);    
        request.setTimeout(120000);  
        
        HttpResponse response = http.send(request);
        
        System.debug('responseBody: '+response.getBody());
        
        String JsonResponse = response.getBody();
        
        MosaicJSONUtil.MosaicResponse mosResp = new MosaicJSONUtil.MosaicResponse();       
        
        if(response.getStatusCode()==200){
            mosResp.successful=true;
        }
        else{
            mosResp.successful=false;
            mosResp.responsebody=response.getBody();
        }
        mosResp.request = request;
        mosResp.response = response;
        return mosResp;
    }
    
    
    //*****************************UPLOAD DOCUMENT*****************************
    public static MosaicJSONUtil.MosaicResponse mosaic_Upload_Document(String oppId, String documentType, Attachment att){
        
        if(att!=null){
            String authorizationHeader = 'Bearer ' + getMosaicAccessToken();
            String file_name=att.name;
            Blob file_body = att.Body;
            String endPointURL = mcs.Endpoint_URL__c+'/api/v1/opportunities/'+oppId+'/documents/'+documentType;
            // Repost of code  with fix for file corruption issue
            // Orignal code postings and explanations
            // http://enreeco.blogspot.in/2013/01/salesforce-apex-post-mutipartform-data.html
            // http://salesforce.stackexchange.com/questions/24108/post-multipart-without-base64-encoding-the-body
            // Additional changes commented GW: that fix issue with occasional corruption of files
            String boundary = '----------------------------741e90d31eff';
            String header = '--'+boundary+'\nContent-Disposition: form-data; name="file"; filename="'+file_name+'";\nContent-Type: application/octet-stream';
            // GW: Do not prepend footer with \r\n, you'll see why in a moment
            // String footer = '\r\n--'+boundary+'--'; 
            String footer = '--'+boundary+'--';             
            String headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\r\n\r\n'));
            while(headerEncoded.endsWith('='))
            {
                header+=' ';
                headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\r\n\r\n'));
            }
            String bodyEncoded = EncodingUtil.base64Encode(file_body);
            // GW: Do not encode footer yet
            // String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
            
            Blob bodyBlob = null;
            String last4Bytes = bodyEncoded.substring(bodyEncoded.length()-4,bodyEncoded.length());
            
            // GW:Get rid of padding without corrupting data
            if(last4Bytes.endsWith('==')) {
                // The '==' sequence indicates that the last group contained only one 8 bit byte
                // 8 digit binary representation of CR is 00001101
                // 8 digit binary representation of LF is 00001010
                // Stitch them together and then from the right split them into 6 bit chunks
                // 0000110100001010 becomes 0000 110100 001010
                // Note the first 4 bits 0000 are identical to the padding used to encode the
                // second original 6 bit chunk, this is handy it means we can hard code the response in
                // The decimal values of 110100 001010 are 52 10
                // The base64 mapping values of 52 10 are 0 K
                // See http://en.wikipedia.org/wiki/Base64 for base64 mapping table
                // Therefore, we replace == with 0K
                // Note: if using \n\n instead of \r\n replace == with 'oK'
                last4Bytes = last4Bytes.substring(0,2) + '0K';
                bodyEncoded = bodyEncoded.substring(0,bodyEncoded.length()-4) + last4Bytes;
                // We have appended the \r\n to the Blob, so leave footer as it is.
                String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
                bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);
            } else if(last4Bytes.endsWith('=')) {
                // '=' indicates that encoded data already contained two out of 3x 8 bit bytes
                // We replace final 8 bit byte with a CR e.g. \r
                // 8 digit binary representation of CR is 00001101
                // Ignore the first 2 bits of 00 001101 they have already been used up as padding
                // for the existing data.
                // The Decimal value of 001101 is 13
                // The base64 value of 13 is N
                // Therefore, we replace = with N
                // Note: if using \n instead of \r replace = with 'K'
                last4Bytes = last4Bytes.substring(0,3) + 'N';
                bodyEncoded = bodyEncoded.substring(0,bodyEncoded.length()-4) + last4Bytes;
                // We have appended the CR e.g. \r, still need to prepend the line feed to the footer
                footer = '\n' + footer;
                String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
                bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);              
            } else {
                // Prepend the CR LF to the footer
                footer = '\r\n' + footer;
                String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
                bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);  
            }
            
            HttpRequest req = new HttpRequest();
            req.setHeader('Authorization', authorizationHeader);
            req.setHeader('Content-Type','multipart/form-data; boundary='+boundary);
            req.setMethod('POST');
            req.setEndpoint(endPointURL);
            req.setBodyAsBlob(bodyBlob);
            req.setTimeout(120000);
            
            Http http = new Http();
            HTTPResponse response = http.send(req);
            System.debug('res----->'+response);
            
            MosaicJSONUtil.MosaicResponse mosResp = new MosaicJSONUtil.MosaicResponse();
            if(response.getStatusCode()==200){
                mosResp.successful=true;
            }
            else{
                mosResp.successful=false;
                mosResp.responsebody=response.getBody();
            }
            mosResp.request = req;
            mosResp.response = response;
            return mosResp;
        }
        return null;
    }

    //***********************************SUBMIT PHOTO PROOF OF INSTALLATION****************************************
    public static MosaicJSONUtil.MosaicResponse mosaic_Submit_Photo_Proof_Installation(String oppId){
        String endPointURL = mcs.Endpoint_URL__c+'/api/v1/opportunities/'+oppId+'/install-complete-photo';
        String authorizationHeader = 'Bearer ' + getMosaicAccessToken();
        
        Httprequest request = new HttpRequest();
        Http http = new Http();
        
        request.setMethod('POST');
        request.setEndpoint(endPointURL);
        request.setHeader('Authorization', authorizationHeader);    
        request.setTimeout(120000);  
        
        HttpResponse response = http.send(request);
        
        System.debug('responseBody: '+response.getBody());
        
        String JsonResponse = response.getBody();
        
        MosaicJSONUtil.MosaicResponse mosResp = new MosaicJSONUtil.MosaicResponse();       
        
        if(response.getStatusCode()==200){
            mosResp.successful=true;
        }
        else{
            mosResp.successful=false;
            mosResp.responsebody=response.getBody();
        }
        mosResp.request = request;
        mosResp.response = response;
        return mosResp;
    }

    //***********************************SUBMIT FOR FINAL REVIEW****************************************
    public static MosaicJSONUtil.MosaicResponse mosaic_Submit_Final_Review(String oppId){
        String endPointURL = mcs.Endpoint_URL__c+'/api/v1/opportunities/'+oppId+'/submit-for-final';
        String authorizationHeader = 'Bearer ' + getMosaicAccessToken();
        
        Httprequest request = new HttpRequest();
        Http http = new Http();
        
        request.setMethod('POST');
        request.setEndpoint(endPointURL);
        request.setHeader('Authorization', authorizationHeader);    
        request.setTimeout(120000);  
        
        HttpResponse response = http.send(request);
        
        System.debug('responseBody: '+response.getBody());
        
        String JsonResponse = response.getBody();
        
        MosaicJSONUtil.MosaicResponse mosResp = new MosaicJSONUtil.MosaicResponse();       
        
        if(response.getStatusCode()==200){
            mosResp.successful=true;
        }
        else{
            mosResp.successful=false;
            mosResp.responsebody=response.getBody();
        }
        mosResp.request = request;
        mosResp.response = response;
        return mosResp;
    }

}