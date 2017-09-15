@RestResource(urlMapping='/DynaForm')
global class DynaFormWebService
{
    public static final String FORM_KEY = 'formId';
    public static final String CALLBACK_KEY = 'callback';
    //TODO: revisit this separator
    public static final String DELIMITER = '\\|';
    
    //cdevarapalli  Case 525759
    public static final String STREET_KEY = 'street';
    public static final String CITY_KEY = 'city';
    public static final String STATE_KEY = 'state';
    public static final String ZIP_KEY = 'zip';
    public static final String COUNTRY_KEY = 'country';
    
    @HttpGet
    global static void getQualification()
    {
        RestContext.response.addHeader('Content-Type', 'application/javascript');
        String callbackName = RestContext.request.params.get( CALLBACK_KEY );
        
        system.debug(' ============> callbackName =========>'+callbackName);
        
        if( String.isBlank( RestContext.request.params.get( FORM_KEY ) ) )
        {
            RestContext.response.responseBody = prepareResponse( JSON.serialize( new Error( ERROR_TYPE.MISSING_FORM_ID ) ), callbackName );
            system.debug('========= RestContext.response.responseBody =========='+RestContext.response.responseBody);
            return;
        }
        
        Id formId;
        try
        {
            formId = (Id)RestContext.request.params.get('formId');
            system.debug(' ========== formId ======'+formId);
        }
        catch( System.StringException ex )
        {
            RestContext.response.responseBody = prepareResponse( JSON.serialize( new Error( ERROR_TYPE.INVALID_FORM_ID ) ), callbackName );
            return;
        }
        
        RestContext.response.responseBody = prepareResponse( JSON.serialize( getQualification( formId ) ), callbackName );
        RestContext.response.statusCode = 200;
        system.debug(' ========== RestContext.response.responseBody ======'+RestContext.response.responseBody);
    }
    
    private static Blob prepareResponse( String responseBody, String callbackName )
    {
        String response = responseBody;
        if( !String.isBlank( callbackName ) )
        {
            response = callbackName + '(' + responseBody + ')';
        }
        return Blob.valueOf( response );
    }
    
    private static Qualification getQualification(Id formId)
    {
        Qualification__c relatedQualification = QualificationServices.getQualificationByFormId( formId );
        Qualification qualification = new Qualification();
        
        if(relatedQualification != null && relatedQualification.Rule_Advance_Logic__c != null)
            qualification.AdvanceLogic = relatedQualification.Rule_Advance_Logic__c; //Vishal :Adding this field in the response 
        
        if( relatedQualification != null )
        {
            for( Qualification_Rule__c qr : relatedQualification.Qualification_Rules__r )
            {
                system.debug('********** rules *******'+qr);
                
                if( !String.isBlank( qr.Accepted_Values__c ) )
                {
                    QualificationField qf = new QualificationField( qr.Eloqua_Field_Name__c, qr.Accepted_Values__c.split(DELIMITER), qr.Disqualified_Reason__c );
                    //TODO: process Field_Type__c
                    qualification.fields.add( qf );
                }
            }
        }
        
        //cdevarapalli  Case 525759
        List<DealerResult> drList = new List<DealerResult>();
        String street = RestContext.request.params.get(STREET_KEY);
        String city = RestContext.request.params.get(CITY_KEY);
        String state = RestContext.request.params.get(STATE_KEY);
        String zipCode = RestContext.request.params.get(ZIP_KEY);
        String country = RestContext.request.params.get(COUNTRY_KEY);
        
        System.debug('street-----'+street);
        System.debug('city-----'+city);
        System.debug('state-----'+state);
        System.debug('zipCode-----'+zipCode);
        System.debug('country-----'+country);
        
        qualification.DealersFound='Default';
        if(street!=null && city!=null && state!=null && zipCode!=null && country!=null){
            drList=DealerUtility.getDealersForDealerLocatorInternal(street,city,state,zipCode,country,40);
            qualification.DealersFound='No';
            qualification.OptedOutDealersFound='No';
            System.debug('drList size -----'+drList.size());
            
            if(!drList.isEmpty()){
                
                List<DealerResult> drListNotOptedOut = new List<DealerResult>();
                List<DealerResult> drListOptedOut = new List<DealerResult>();
                
                for(DealerResult dr:drList){
                    if(dr.LeadFlowOptOut==false){
                        drListNotOptedOut.add(dr);
                    }
                    else if(dr.LeadFlowOptOut==true){
                        drListOptedOut.add(dr);
                    }
                }
                
                if(!drListNotOptedOut.isEmpty()){
                    qualification.DealersFound = Label.OptedInDealersFound;
                    qualification.OptedOutDealersFound = 'No';
                }
                else if(!drListOptedOut.isEmpty()){
                    qualification.DealersFound = Label.OptedOutDealersFound;
                    qualification.OptedOutDealersFound = 'Yes';
                }
            }
        }
        System.debug('DealersFound-----'+qualification.DealersFound);
        return qualification;
    }
    
    global class Qualification
    {
        public List<QualificationField> fields;
        public String AdvanceLogic; //Vishal : Adding this field to get the advance logic from the Qulaification Object 
        
        public Qualification()
        {
            this.fields = new List<QualificationField>();
        }
        public string DealersFound;//cdevarapalli Case 525759
        public string OptedOutDealersFound; //cdevarapalli Case 00600964
    }
    
    global class QualificationField
    {
        public List<String> AUTOOPEN_VALUES = new List<String>{ 'I don\'t know', 'Not Sure', 'Do Not Know', 'Some Shade' };
            public String name;
        public String disqualifiedReason;
        public List<String> acceptedValues;
        
        
        public QualificationField( String name, List<String> acceptedValues, String disqualifiedReason )
        {
            this.name = name;
            this.acceptedValues = acceptedValues;
            this.disqualifiedReason = disqualifiedReason;
        }
    }
    
    global class Error
    {
        public Integer code;
        public String message;
        
        public Error( ERROR_TYPE errorType )
        {
            this.code = errorType == null ? ERROR_TYPE.UNKNOWN.ordinal() : errorType.ordinal();
            this.message = '';
            if( errorType == ERROR_TYPE.INVALID_FORM_ID )
            {
                this.message = 'Invalid Form Id';
            }
            else if( errorType == ERROR_TYPE.MISSING_FORM_ID )
            {
                this.message = 'A Form Id is required';
            }
            else if( errorType == ERROR_TYPE.UNKNOWN
                    || errorType == null )
            {
                this.message = 'An unknown error has occurred';
            }
        }
        
        public Error( ERROR_TYPE errorType, String message )
        {
            this(errorType);
            this.message += '\n' + message;
        }
    }
    
    public enum ERROR_TYPE{
    	INVALID_FORM_ID,
        MISSING_FORM_ID,
        UNKNOWN
    }
}