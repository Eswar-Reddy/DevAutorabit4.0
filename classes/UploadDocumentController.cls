public class UploadDocumentController{
public Document doc{get; set;}
public List<SelectOption> lstCategory{get;set;} 
public blob docBody{get;set;}
public boolean isSaved{get; set;}
private Set<String> foldernames{get;set;}
public String subTab{get;set;}
public UploadDocumentController(ApexPages.StandardController std){
    isSaved = false;
    doc=(Document)std.getrecord();
    subTab='';
    if(ApexPages.currentPage().getParameters().get('retSubTab')!=null){
        if(ApexPages.currentPage().getParameters().get('retSubTab')!=''){
            subTab = ApexPages.currentPage().getParameters().get('retSubTab');
        }
    }  
    FillSubCategories();
    FillFolder();      
}

private void FillFolder(){        
        lstCategory = new List<SelectOption>();
         
        for(Folder fldr:[Select name,id from Folder where type='Document' and name in :foldernames]){
            lstCategory.add(new SelectOption(fldr.id,fldr.name));
        }
}

public void save(){
    doc.body = docBody;
    insert doc;
    isSaved = true;
    //set document body to null for resolving view state issue
    doc.body = null;
    docBody = null;
}

private void FillSubCategories(){   
        foldernames = new Set<String>();     
        //Add Sub Categories of knowledge base
        if(subTab=='KnowledgeBase'){            
            foldernames.Add('Diagrams and CAD blocks');
            foldernames.Add('FAQs');
            foldernames.Add('Product Datasheets');
            foldernames.Add('Product Manuals');
            foldernames.Add('Product Warranties');
            foldernames.Add('Training Manual');
            foldernames.Add('Webinars');
        }
        //Add Sub Categories of Process Document
        if(subTab=='ProcessDocuments'){            
            foldernames.Add('General');
            foldernames.Add('Application Engineering');
            foldernames.Add('Customer Care');
            foldernames.Add('Finance');
            foldernames.Add('Information System');
            foldernames.Add('Marketing');
            foldernames.Add('Operations');
            foldernames.Add('Sales');
            foldernames.Add('Training');
            foldernames.Add('Business Development');
        }
        //Add Sub Categories of Marketing Bulletins
        if(subTab=='MarketingBulletins'){
            foldernames.Add('Marketing Bulletins');
        }
        //Add Sub Categories of Technical Notifications
        if(subTab=='TechnicalNotifications'){
            foldernames.Add('Technical Notifications');
        }
}
}