global class S3UploadController {
	public AWSKeys creds {get; private set;}
	public String secret {get {return creds.secret;} private set;}
	public String key {get {return creds.key;} private set;}
	public String bucket {get {return creds.bucketname;} private set;}
	public String guid {get {return OracleOrderUtility.generateGUID();}}
	public DocObject doc {get; set;}
	public String redirectURL {get {return URL.getSalesforceBaseUrl().toExternalForm() + '/' + redirectId;} private set;}
	public String redirectId;

	// THESE ARE Ver 2 VARS
	public String isoExpire {get {return Datetime.now().addDays(1).formatGmt('YYYY-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');}}

	// THESE ARE Ver 4 VARS - rolling back to ver 2 due to issues getting v4 working
	//public String isoExpire {get {return Datetime.now().addDays(1).formatGmt('YYYYMMdd\'T\'HHmmss\'Z\'');}}
	//public String isoDate {get {return Datetime.now().formatGmt('YYYYMMdd');}}
	//public String isoDateTime {get {return isoDate + 'T120000Z';}}
	//public String path {get {return key + '/' + isoDate + '/us-west-2/s3/aws4_request';}}

	// THIS IS THE Ver 4 POLICY - rolling back to ver 2 due to issues getting v4 working
	//private String policy {get {return '{"expiration": "' + isoExpire + '", "conditions": [{"bucket": "' + bucket + '"}, ["starts-with", "$key", ""], {"acl": "public-read"}, {"x-amz-credential": "' + path + '"}, {"x-amz-algorithm": "AWS4-HMAC-SHA256"}, {"x-amz-date": "' + isoDateTime + '"}]}';}}

	// THIS IS THE Ver 2 POLICY
	private String policy {get {return '{"expiration": "'+ isoExpire +'", "conditions": [{"bucket": "'+ bucket +'"}, {"acl": "public-read"}, ["starts-with", "$key", ""], {"success_action_redirect": "' + redirectURL + '"}]}';}}

	global S3UploadController() {
		creds = new AWSKeys('JC_AWS_S3');
		redirectId = ApexPages.currentPage().getParameters().get('redirectId');
		if(redirectId == null) redirectId = '';
	}

	global String getPolicy() {
		return EncodingUtil.base64Encode(Blob.valueOf(policy));
	}

	global String getSignedPolicy() {
		// THIS IS THE Ver 2 SIGNATURE
		Blob sKey = Crypto.generateMac('hmacSHA1', Blob.valueOf(getPolicy()) , Blob.valueOf(secret));
		return EncodingUtil.base64Encode(sKey);

		// THIS IS THE Ver 4 SIGNATURE - rolling back to ver 2 due to issues getting v4 working
		//Blob skey = Blob.valueof('AWS4' + secret);
		//Blob dateKey = Crypto.generateMac('hmacSHA256', Blob.valueof(isoDate), skey);
		//Blob dateRKey = Crypto.generateMac('hmacSHA256', Blob.valueOf('us-west-2'), dateKey);
		//Blob dateKSKey = Crypto.generateMac('hmacSHA256', Blob.valueOf('S3'), dateRKey);
		//Blob signKey = Crypto.generateMac('hmacSHA256', Blob.valueOf('aws4_request'), dateKSKey);
		//Blob signature = Crypto.generateMac('hmacSHA256', Blob.valueOf(policy), signKey);
		//return EncodingUtil.convertToHex(signature);
	}

	@RemoteAction
	global static void updateDocument(Id docId, String name, String nameField, String link, String linkField) {
		try {
			sObject sObj = docId.getSObjectType().newSObject(docId);
			sObj.Id = docId;
			sObj.put(nameField, name);
			sObj.put(linkField, link);
			update sObj;
		}
		catch(Exception e) {
			ExLog.log(e);
		}
	}
}