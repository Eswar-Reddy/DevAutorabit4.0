@isTest//Test Class for EncryptionUtil Class
public class EncryptionUtilTest {
    
    static testmethod void testEncryptionUtil1(){
        String secretKey = Label.DynamicProposalSecretKey;
        Blob cryptoKey = EncodingUtil.base64Decode(secretKey);
        
        String toencryptString = '$0l@r%p0w3r+=&!@#$%^&*()_-+=,.?/:;"';
        
        String encryptedString = EncryptionUtil.encryptString(toencryptString, secretKey);
        
        String decryptedString = EncryptionUtil.decryptString(encryptedString, secretKey);
        
        System.assertEquals(toencryptString, decryptedString);
    }
    
    //Test Exceptions
    static testmethod void testEncryptionUtil2(){
        String secretKey = Label.DynamicProposalSecretKey;
        Blob cryptoKey = EncodingUtil.base64Decode(secretKey);
        
        String toencryptString = '$0l@r%p0w3r+=&!@#$%^&*()_-+=,.?/:;"';
        
        String encryptedString = EncryptionUtil.encryptString(toencryptString, 'secretKey');
        
        String decryptedString = EncryptionUtil.decryptString('encrypted String', secretKey);
        
    }
    
    //Test Nulls
    static testmethod void testEncryptionUtil3(){
        String secretKey = Label.DynamicProposalSecretKey;
        Blob cryptoKey = EncodingUtil.base64Decode(secretKey);
        
        String encryptedString = EncryptionUtil.encryptString(null, 'secretKey');
        
        String decryptedString = EncryptionUtil.decryptString(null, secretKey);
        
    }
}