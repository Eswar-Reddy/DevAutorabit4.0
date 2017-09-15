@isTest
public class TestS3DocumentUploadController {
    
    public static testmethod void t1() {
        Document__c a = new Document__c(Name= 'TestS3DocUpload', File_Type__c ='PDF');
        insert a;
      
        S3DocumentUploadController s3 = new S3DocumentUploadController(
            new ApexPages.StandardController( a ) );
        
        S3_Credentials__c testKey = new S3_Credentials__c(name='test keys',key__c='key',secret__c='secret', OrgId__c='OrgId__c', BucketName__c='BucketName__c');
        insert testKey;

        s3.AWSCredentialName = testKey.name;
        s3.constructor();
        system.debug( s3.secret + ' '+ s3.key ); 
        system.debug( s3.getpolicy() ); 
        system.debug( s3.getSignedPolicy() ); 
        system.debug( s3.getHexPolicy() ); 
        
        PageReference pageRef = Page.S3DocumentUpload;
        pageRef.getParameters().put('urlParam','https://na22.salseforce.com/services/soap/14.0/c/');
        Test.setCurrentPage(pageRef);
        
        s3.save1();
        s3.page2onLoad(); 
        system.debug( s3.getBucketOptions() );
    }
    
    public static testmethod void t2() {
        Document__c a = new Document__c();
        S3DocumentUploadController s3 = new S3DocumentUploadController(new ApexPages.StandardController( a ) );
        //s3.AWSCredentialName = 'bad key name';
        s3.constructor();
    }

}