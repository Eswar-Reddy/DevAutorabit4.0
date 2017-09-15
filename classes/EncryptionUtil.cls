/**
* Created by chaitoo on 2/28/17.
*/

public with sharing class EncryptionUtil {
    
    //Encrypt and Base64Encode given String
    public static String encryptString(String toencryptString,String secretKey){
        if(toencryptString!=null){
            System.debug('toencryptString----->'+toencryptString);
            try{
                Blob cryptoKey = EncodingUtil.base64Decode(secretKey);
                
                Blob encryptedData = Crypto.encryptWithManagedIV('AES128', cryptoKey, Blob.valueOf(toencryptString));
                String base64encryptedData = EncodingUtil.base64Encode(encryptedData);
                String hexbase64encryptedData = EncodingUtil.convertToHex(Blob.valueOf(base64encryptedData));
                return hexbase64encryptedData;//EncodingUtil.urlEncode(toencryptString, 'UTF-8');
                
            }catch(Exception e){
                return null;
            } 
        }
        else
            return null;
    }
    
    public static String decryptString(String todecryptString, String secretKey){
        if(todecryptString!=null){
            System.debug('todecryptString----->'+todecryptString);
            try{
                Blob cryptoKey = EncodingUtil.base64Decode(secretKey);
                
                Blob unhextodecryptString = EncodingUtil.convertFromHex(todecryptString);
                //String urldecodedtodecryptString = EncodingUtil.urlDecode(todecryptString, 'UTF-8');
                Blob base64DecodedUsername = EncodingUtil.base64Decode(unhextodecryptString.toString());
                Blob decryptedData = Crypto.decryptWithManagedIV('AES128', cryptoKey, base64DecodedUsername);
                return decryptedData.toString();
                
            }catch(Exception e){
                System.debug('----->'+e.getMessage());
                return null;
            }
            
        }
        else
            return null;
    }
    
    
}