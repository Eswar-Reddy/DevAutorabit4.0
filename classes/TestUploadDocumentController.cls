public class TestUploadDocumentController{
@isTest
public static void checkUploadController(){
    //Create folder
    List<Folder> fldr = new List<Folder>();
    fldr = [Select id from Folder where type='Document' limit 1];
    if(fldr.size()==0){
        return;
    }
    //Initialize new Document
    Document doc = new Document(Body=Blob.valueOf('TestContent'),FolderID=fldr[0].id,Name='TestDoc'+String.valueOf(DateTime.Now()));   
    //Create standard controller for Document 
    ApexPages.StandardController ctrl = new  ApexPages.StandardController(doc);
    //Set query parameter and create object of controller class
    ApexPages.currentPage().getParameters().put('retSubTab','KnowledgeBase');
    UploadDocumentController objUploadTest = new UploadDocumentController(ctrl);
    //Set another query parameter and Create onject of controller class
    ApexPages.currentPage().getParameters().put('retSubTab','ProcessDocuments');
    UploadDocumentController objUpload = new UploadDocumentController(ctrl);
    //Call 'Save' method
    objUpload.save();
}
}