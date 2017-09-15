public class WarrentyRegistrationCustom 
{
/***** VARIABLE *****/
    private Integer totSize =0;
    private List<String> lstWRIds = new List<String>(); 
    private List<WR> lstWR = new List<WR>();
    
    private Boolean bSelUnsel = false;
    public String strWRId = '';
    public String strAttId= ''; 

    private Map<Id,List<String>> mWRvsLstInfo = new Map<Id,List<String>>(); 
/*** END VARIABLE ***/

/***** PROPERTY *****/
    public boolean propSelUnsel { get { return bSelUnsel; } set { bSelUnsel = value; } }
    public String  propWRId { get { return strWRId; } set { strWRId = value; } }
    public String  propAttId{ get { return strAttId; } set { strAttId = value; } }    

    public Integer propTotal { get { return totSize; } private set; } 
    public String propTotalSize 
    { 
        get { return 'Total attachment size ' + String.valueOf(Decimal.valueOf(totSize).divide(1024,6,RoundingMode.UP).divide(1024,3,RoundingMode.UP)) + ' MB'; } 
        private set; 
    } 
    
    public List<String> propWRIds { get { return lstWRIds; } private set; }

    public List<WR> propLstWR { get { return lstWR; } set { lstWR = value; } } 

    public Boolean porpSucces { get; set; }    
/*** END PROPERTY ***/

/***** CONSTRUCTOR *****/
    public WarrentyRegistrationCustom(ApexPages.StandardController controller) 
    {
        String sIds = ApexPages.currentPage().getParameters().get('ids');
        if(sIds != null && sIds != '' && sIds.contains('-'))
            lstWRIds.addAll(sIds.split('-'));
        else if(sIds != null && sIds != '' && !sIds.contains('-'))
            lstWRIds.add(sIds);   
    }
    
    public void CheckSize()
    {
        if(strWRId != '' && strAttId != '')
        {
            totSize = 0;
            porpSucces = false;
            Integer sizeToAdd = 0;
            Integer sizeToRemove = 0;
            for(WR owr : lstWR)
            {
                if(owr.propSelected)
                    totSize += owr.propAttach.BodyLength;
                if(strWRId == owr.propWR.Id && strAttId == owr.propAttach.Id && bSelUnsel && !owr.propSelected){
                    sizeToAdd += owr.propAttach.BodyLength;
                    owr.propSelected = true;
                }
                if(strWRId == owr.propWR.Id && strAttId == owr.propAttach.Id && !bSelUnsel && owr.propSelected){
                    sizeToRemove += owr.propAttach.BodyLength;
                    owr.propSelected = false;
                }
                
            }
            totSize = totSize + sizeToAdd - sizeToRemove;
        }
    }
/*** END CONSTRUCTOR ***/

/***** FUNCTION *****/
    public PageReference OnInit()
    {
        if(!lstWRIds.isEmpty())
            Process();               
        else
        {
            PageReference pr = new PageReference('/a1U');
            pr.Setredirect(true);
            return pr;
        }
        return null;
    }
    
    public void Process()
    {
        if(!lstWR.isEmpty()) lstWR.clear();
        totSize = 0;
        List<String> lstDesc = new List<String>{'Warranty Certificate', 'warranty certificate', 'WARRANTY CERTIFICATE'};
        Set<String> setAllowedContentType = new Set<String>{'pdf', 'PDF', 'application/pdf'};
        
        for(Warranty_Registration__c wr: [SELECT Warranty_Opportunity__c, Warranty_Number__c, 
                                                 Status__c, Name, Id, 
                                                 Customer_Account_Email__c,
                                                 Customer_SFDC_ID__r.PersonEmail, Customer_SFDC_ID__r.Phone, 
                                                 Customer_SFDC_ID__r.BillingCountry, Customer_SFDC_ID__r.BillingPostalCode, 
                                                 Customer_SFDC_ID__r.BillingState, Customer_SFDC_ID__r.BillingCity, 
                                                 Customer_SFDC_ID__r.BillingStreet,
                                                 Customer_SFDC_ID__r.ShippingCountry, Customer_SFDC_ID__r.ShippingPostalCode, 
                                                 Customer_SFDC_ID__r.ShippingState, Customer_SFDC_ID__r.ShippingCity, 
                                                 Customer_SFDC_ID__r.ShippingStreet,                                                 
                                                 Customer_SFDC_ID__c,                                              
                                                 (SELECT Id, Name, 
                                                         ContentType, BodyLength, 
                                                         Description 
                                                  FROM Attachments 
                                                  WHERE Description IN: lstDesc) 
                                          FROM Warranty_Registration__c  
                                          WHERE id IN: lstWRIds])
        {
            List<Attachment> lstAtt = wr.Attachments;
            for(Attachment att: lstAtt)
            {
                if(att.Name.endsWith('.pdf') || att.Name.endsWith('.PDF') || setAllowedContentType.contains(att.ContentType))
                {
                    lstWR.add(new WR(true, att, wr));
                    totSize += att.BodyLength;
                }
            }
            
            String sAdd = '';
            if(wr.Customer_SFDC_ID__r.BillingStreet != null && wr.Customer_SFDC_ID__r.BillingStreet != '')
                sAdd = wr.Customer_SFDC_ID__r.BillingStreet;
            if(wr.Customer_SFDC_ID__r.BillingCity != null && wr.Customer_SFDC_ID__r.BillingCity != '')
                sAdd = ((sAdd != '') ? (sAdd + ', ') : '') + wr.Customer_SFDC_ID__r.BillingCity;
            if(wr.Customer_SFDC_ID__r.BillingState != null && wr.Customer_SFDC_ID__r.BillingState != '')
                sAdd = ((sAdd != '') ? (sAdd + ', ') : '') + wr.Customer_SFDC_ID__r.BillingState;
            if(wr.Customer_SFDC_ID__r.BillingCountry != null && wr.Customer_SFDC_ID__r.BillingCountry != '')
                sAdd = ((sAdd != '') ? (sAdd + ', ') : '') + wr.Customer_SFDC_ID__r.BillingCountry;
            if(wr.Customer_SFDC_ID__r.BillingPostalCode != null && wr.Customer_SFDC_ID__r.BillingPostalCode != '')
                sAdd = ((sAdd != '') ? (sAdd + ', ') : '') + wr.Customer_SFDC_ID__r.BillingPostalCode;
            
            if(sAdd != '')
            {
                if(wr.Customer_SFDC_ID__r.ShippingStreet != null && wr.Customer_SFDC_ID__r.ShippingStreet != '')
                    sAdd = wr.Customer_SFDC_ID__r.ShippingStreet;
                if(wr.Customer_SFDC_ID__r.ShippingCity != null && wr.Customer_SFDC_ID__r.ShippingCity != '')
                    sAdd = ((sAdd != '') ? (sAdd + ', ') : '') + wr.Customer_SFDC_ID__r.ShippingCity;
                if(wr.Customer_SFDC_ID__r.ShippingState != null && wr.Customer_SFDC_ID__r.ShippingState != '')
                    sAdd = ((sAdd != '') ? (sAdd + ', ') : '') + wr.Customer_SFDC_ID__r.ShippingState;
                if(wr.Customer_SFDC_ID__r.ShippingCountry != null && wr.Customer_SFDC_ID__r.ShippingCountry != '')
                    sAdd = ((sAdd != '') ? (sAdd + ', ') : '') + wr.Customer_SFDC_ID__r.ShippingCountry;
                if(wr.Customer_SFDC_ID__r.ShippingPostalCode != null && wr.Customer_SFDC_ID__r.ShippingPostalCode != '')
                    sAdd = ((sAdd != '') ? (sAdd + ', ') : '') + wr.Customer_SFDC_ID__r.ShippingPostalCode;         
            }
                
            mWRvsLstInfo.put(wr.Id, new List<String>{sAdd, 
                                                     ((wr.Customer_Account_Email__c != null && wr.Customer_Account_Email__c != '') ? wr.Customer_Account_Email__c : '-n/a-'),
                                                     (( wr.Customer_SFDC_ID__r.Phone != null &&  wr.Customer_SFDC_ID__r.Phone != '') ?  wr.Customer_SFDC_ID__r.Phone : '-n/a-')});            
        }   
    }
    
    public Pagereference ContinueWithSend()
    {
        if(!lstWR.isEmpty())
        {
            Map<id, Messaging.EmailFileAttachment> mAttach = new Map<Id, Messaging.EmailFileAttachment>(); 
            Map<Id, String> mPIdvsName = new map<Id, String>();
            Map<Id, Attachment> mapA = new Map<Id, Attachment>([SELECT Id, Name, 
                                                                       ParentId, Parent.Name, 
                                                                       ContentType, BodyLength, 
                                                                       Body, Description 
                                                                FROM Attachment 
                                                                WHERE ParentId IN: lstWRIds]);     
            for(WR owr : lstWR)
            {
                if(owr.propSelected)
                {
                    mPIdvsName.put(mapA.get(owr.propAttach.Id).ParentId, mapA.get(owr.propAttach.Id).Parent.Name);
                    Blob body; //temp Varibale
                     
                    try {
                          body = mapA.get(owr.propAttach.Id).body;
                    } catch (VisualforceException e) {
                          body = Blob.valueOf('Exception Occured while getting file body.');
                    }
                    Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
                        attach.setFileName(owr.propAttach.Name + '.pdf');
                        attach.setContentType('application/pdf');
                        attach.setInline(true);                        
                        attach.Body = body;
                    mAttach.put(mapA.get(owr.propAttach.Id).ParentId, attach);                                                
                }
            }
            if(!mAttach.isEmpty())
            {
                SendMail(mAttach,  mPIdvsName); 
                porpSucces = true;
            } 
        }      
        return null; 
    }

    public void SendMail(Map<Id, Messaging.EmailFileAttachment> mAtt, Map<Id, String> mPvsName)
    {
        List<Messaging.SingleEmailMessage> allEmails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setUseSignature(false);
        mail.setToAddresses(new List<String>{[SELECT id, email FROM user WHERE id=: UserInfo.getUserId()].Email});
        mail.setSubject('Warranty Registration Documents');
        String strBdy = '<table width="100%">';
               strBdy = strBdy + '<tr>';
               strBdy = strBdy + '<td width="100%">Dear ' + UserInfo.getName() + ',</br></br></td>';
               strBdy = strBdy + '</tr>';
               strBdy = strBdy + '<tr>';
               strBdy = strBdy + '<td>This mail is with regard to Warranty Registration documents <b>requested</b>.</td>';
               strBdy = strBdy + '</tr>';
               strBdy = strBdy + '<tr>';
               strBdy = strBdy + '<td>Below mentioned are the details:</br></br></td>';
               strBdy = strBdy + '</tr>';
               strBdy = strBdy + '<tr>';
               strBdy = strBdy + '<td><table><tr><th align="left">S.No.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th><th align="right">Warranty Number</th><th>&nbsp;&nbsp;&nbsp;&nbsp;</th><th align="left">Attachment Name</th><th>&nbsp;&nbsp;&nbsp;&nbsp;</th><th align="left">Customer Address</th><th>&nbsp;&nbsp;&nbsp;&nbsp;</th><th align="left">Customer Email</th><th>&nbsp;&nbsp;&nbsp;&nbsp;</th><th align="left">Customer Phone</th></tr>';
               Integer i=1;
               for(Id parId: mAtt.keySet()){
System.Debug('--parId-- ' + parId + '\n --mWRvsLstInfo.containsKey(parId)-- ' + mWRvsLstInfo.containsKey(parId) + '\n --mWRvsLstInfo.get(parId)-- ' + mWRvsLstInfo.get(parId)); 
System.Debug('--mWRvsLstInfo.get(parId)-- ' + mWRvsLstInfo.get(parId) + '\n--mWRvsLstInfo.get(parId).isEmpty()-- ' + mWRvsLstInfo.get(parId).isEmpty() + '\n--mWRvsLstInfo.get(parId).size()-- ' + mWRvsLstInfo.get(parId).size() + '--(mWRvsLstInfo.get(parId) != null && mWRvsLstInfo.get(parId).isEmpty() && mWRvsLstInfo.get(parId).size()>0)-- ' + (mWRvsLstInfo.get(parId) != null && mWRvsLstInfo.get(parId).isEmpty() && mWRvsLstInfo.get(parId).size()>0));                
                    strBdy = strBdy + '<tr><td align="left">'+ String.valueof(i++) +'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td align="left">' + mPvsName.get(parId) + 
                                      '</td><td>&nbsp;&nbsp;&nbsp;&nbsp;</td><td align="left">' + mAtt.get(parId).getFileName() + 
                                      '</td><td>&nbsp;&nbsp;&nbsp;&nbsp;</td><td align="left">' + ((mWRvsLstInfo.get(parId) != null && !mWRvsLstInfo.get(parId).isEmpty() && mWRvsLstInfo.get(parId).size()>0)? mWRvsLstInfo.get(parId)[0] : '-n/a-') + 
                                      '</td><td>&nbsp;&nbsp;&nbsp;&nbsp;</td><td align="left">' + ((mWRvsLstInfo.get(parId) != null && !mWRvsLstInfo.get(parId).isEmpty() && mWRvsLstInfo.get(parId).size()>1)? mWRvsLstInfo.get(parId)[1] : '-n/a-') + 
                                      '</td><td>&nbsp;&nbsp;&nbsp;&nbsp;</td><td align="left">' + ((mWRvsLstInfo.get(parId) != null && !mWRvsLstInfo.get(parId).isEmpty() && mWRvsLstInfo.get(parId).size()>2)? mWRvsLstInfo.get(parId)[2] : '-n/a-') + 
                                      '</td></tr>';   
               }
               strBdy = strBdy + '</table></td></tr>';                
               strBdy = strBdy + '<tr>';
               strBdy = strBdy + '<td>&nbsp;</td>';
               strBdy = strBdy + '</tr>';
               strBdy = strBdy + '<tr>';
               strBdy = strBdy + '<td></br>Kindly check the attachment of this email for the files requested.</td>';
               strBdy = strBdy + '</tr>';
               strBdy = strBdy + '<tr>';
               strBdy = strBdy + '<td>&nbsp;</td>';
               strBdy = strBdy + '</tr>';                                             
               strBdy = strBdy + '<tr>';
               strBdy = strBdy + '<td></br></br>Thanks,</td>';
               strBdy = strBdy + '</tr>';
               strBdy = strBdy + '<tr>';
               strBdy = strBdy + '<td>Sunpower CRM System</td>';
               strBdy = strBdy + '</tr>';                       
               strBdy = strBdy + '</table>';
        mail.setHtmlBody(strBdy);                      
        mail.setFileAttachments(mAtt.values());
        
        allEmails.add(mail);            

        if(!allEmails.isEmpty())
        {
            List<Warranty_Registration__c> lstWR = new List<Warranty_Registration__c>();
            Messaging.sendEmail(allEmails);// Send the email
            for(Id wrId: mAtt.keySet())
                lstWR.add(new Warranty_Registration__c (id= wrId, 
                                                        Warranty_Certificate_Printed__c= true,
                                                        Certificate_Status__c = 'Downloaded',
                                                        Date_Mailed__c = Date.Today(),
                                                        Processed_by__c = userinfo.getFirstName() +' '+ userinfo.getLastName(),
                                                        Date_Sent_to_Print__c= Date.Today()));
            if(!lstWR.isEmpty())
                update lstWR;
        }
    }
        
    public PageReference CancelandReturn()
    {
        PageReference pr = new PageReference('/a1U');
        return pr;
    }   
/*** END FUNCTION ***/

/***** WRAPPER *****/
    public class WR
    {
        private boolean bSel;
        private Warranty_Registration__c oWR = new Warranty_Registration__c();
        private Attachment oAtt = new Attachment();
        
        public boolean propSelected { get { return bSel; } set { bSel = value; } }
        public Warranty_Registration__c propWR { get { return oWR; } set { oWR = value; } }
        public Attachment propAttach { get { return oAtt; } set { oAtt = value; } }
        
        public WR(Boolean xbSel, Attachment xoAtt, Warranty_Registration__c xoWR)
        {
            bSel = xbSel;
            oAtt = xoAtt;
            oWR = xoWR;
        }
    }
/*** END WRAPPER ***/
}