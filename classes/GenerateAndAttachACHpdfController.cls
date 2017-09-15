public with sharing class GenerateAndAttachACHpdfController {
    
    public ID parentId {get;set;} //Id for attaching PDF to agreement record
    public String pdfName {get;set;} //PDF name given in VF page 
    public static String agreementId{get; set;}
    public static String accountId{get; set;}
    
    /*******************************************************************************************************************************************************************************
Method      : attachPDFtoRecord
Parameters  : 
Return Type : PageReference 
Summary     : Function will create a PDF with Provided Name, attach it to Agreement Record then will redirect the page to Agreement Layout
********************************************************************************************************************************************************************************/
    
    public PageReference attachPDFtoRecord() {
        
        PageReference pdf = Page.ACH_Form_Template;
        agreementId=ApexPages.currentPage().getParameters().get('aggId'); //gettting Agreement Id from URL 
        accountId=ApexPages.currentPage().getParameters().get('Id'); //Getting Account Id from URL
        
        pdf.getParameters().put('Id',accountId); // Pass this Parameter to Render Page
        pdf.getParameters().put('aggId',agreementId); // Pass this Parameter to Render Page
        
        Attachment attach = new Attachment(); //  Creating Agreement Object
        
        Blob body; // Creating Blob For Getting Content As PDF 
        
        try {
            
            // returns the output of the page as a PDF
            body= pdf.getContentAsPDF(); // Getting Content as PDF 
            
        } catch (VisualforceException e) {
            body = Blob.valueOf('We have encountered some error');
        }
        
        attach.Body = body;
        attach.Name = pdfName+'.pdf';
        attach.IsPrivate = false;
        parentId =Id.valueOf(agreementId); //Setting Parent Id as Agreement Id 
        attach.ParentId = parentId;
        insert attach;
        return new PageReference('/'+parentId); // redirection to Agreement Page
        
    }
    
}