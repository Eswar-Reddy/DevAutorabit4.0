// *********************************************************************
// Name : InspectionRedirectController 
// Created On : 15th April,2009
// Created By : Appirio (Kirtesh)
// Implementation: Decision is taken for move to appropriate page
//                 in Edit mode of Inspection type of Cases.
// 
// **********************************************************************
public class InspectionRedirectController {
  public string redirectUrl{get; set;}
  private final Inspection__c inspection ;
  private Inspection__c inspectionObj;
  public Boolean isEdit{get;set;}  
  
  public InspectionRedirectController(ApexPages.StandardController stdController) {
    this.inspection = (Inspection__c)stdController.getRecord();
    inspectionObj =  null; 
    if ( inspection.id != null){
    	
    	inspectionObj = [Select id,Name,InspectionNameType__c from Inspection__c where id = :inspection.id limit 1];
    }
    if(ApexPages.currentPage().getParameters().get('retURL') != null){
      isEdit = true;
    }
    else{
      isEdit = false;
    }
    checkRedirectUrl();
  }
  
  public void checkRedirectUrl(){
    String caseid=null;
    String insid=null;
    //start for case 00045421
    //To pick Caseid on dev sandbox
    if(ApexPages.currentPage().getParameters().get('CF00NQ0000000G2cO_lkid') != null){
          caseid=ApexPages.currentPage().getParameters().get('CF00NQ0000000G2cO_lkid');
    }  
    //To pick Caseid on uat and production
    else if(ApexPages.currentPage().getParameters().get('CF00N80000003bZm6_lkid') != null){
         caseid=ApexPages.currentPage().getParameters().get('CF00N80000003bZm6_lkid');
    }
    
    List<Case> c;
    if(caseid!=null){
        c = [Select RecordType.Name from Case where id= :caseid limit 1];
        if(c.size()==1 && c[0].RecordType.Name == 'New Inspections'){
            redirectUrl = '/apex/InspectionReportEU?caseid='+caseid+'&';
        }else{  
            //end for case 00045421
            if( this.inspection.site_type__c == 'Residential' ){
            	if ( inspectionObj != null)
                	redirectUrl = '/apex/InspectionReportNew?id='+this.inspection.id +'&ReportName=' + this.inspectionObj.InspectionNameType__c + '&' ;
                else
                  redirectUrl = '/apex/InspectionReportNew?id='+this.inspection.id + '&' ;
            }
            else if( this.inspection.site_type__c == 'Commercial' ){
                redirectUrl = '/apex/InspectionReport_Commercial?id='+this.inspection.id+'&' ; 
            }
            else{
                redirectUrl = '/apex/InspectionReportNew?';
                //To pick Caseid on dev sandbox
                if(ApexPages.currentPage().getParameters().get('CF00NQ0000000G2cO_lkid') != null){
                      redirectUrl = redirectUrl+'caseid='+ApexPages.currentPage().getParameters().get('CF00NQ0000000G2cO_lkid')+'&';
                }  
                //To pick Caseid on uat and production
                else if(ApexPages.currentPage().getParameters().get('CF00N80000003bZm6_lkid') != null){
                    redirectUrl = redirectUrl+'caseid='+ApexPages.currentPage().getParameters().get('CF00N80000003bZm6_lkid')+'&';
                }      
            }       
        }//start for case 00045421
    }else if(ApexPages.currentPage().getParameters().get('id') != null){
        insid = ApexPages.currentPage().getParameters().get('id');   
        List<Inspection__c> ins = [Select Id, Case__r.RecordType.Name from Inspection__c where id= :insid limit 1];
        if(ins.size()==1 && ins[0].Case__r.RecordType.Name == 'New Inspections'){
        	isEdit = true;
            redirectUrl = '/apex/InspectionReportEU?id='+insid+'&';
        }else{  
            //end for case 00045421
            if( this.inspection.site_type__c == 'Residential' ){
            	if ( inspectionObj != null)
                	redirectUrl = '/apex/InspectionReportNew?id='+this.inspection.id +'&ReportName=' + this.inspectionObj.InspectionNameType__c + '&' ;
                else
                	redirectUrl = '/apex/InspectionReportNew?id='+this.inspection.id + '&' ;
            }
            else if( this.inspection.site_type__c == 'Commercial' ){
                redirectUrl = '/apex/InspectionReport_Commercial?id='+this.inspection.id+'&' ; 
            }
            else{
                redirectUrl = '/apex/InspectionReportNew?';
                //To pick Caseid on dev sandbox
                if(ApexPages.currentPage().getParameters().get('CF00NQ0000000G2cO_lkid') != null){
                      redirectUrl = redirectUrl+'caseid='+ApexPages.currentPage().getParameters().get('CF00NQ0000000G2cO_lkid')+'&';
                }  
                //To pick Caseid on uat and production
                else if(ApexPages.currentPage().getParameters().get('CF00N80000003bZm6_lkid') != null){
                    redirectUrl = redirectUrl+'caseid='+ApexPages.currentPage().getParameters().get('CF00N80000003bZm6_lkid')+'&';
                }      
            }       
        }
    }   //end for case 00045421
    redirectUrl = redirectUrl + 'isEdit=' + isEdit; 
  }  
}