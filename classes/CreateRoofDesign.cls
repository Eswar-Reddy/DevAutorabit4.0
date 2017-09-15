//Class to create Roof Design record when user clicks on Request Design button on Account detail page
public class CreateRoofDesign {

    public static RoofDesign checkandCreateRD(Id accId,String actionType,Roof_Design__c roofDes){

        RoofDesign rfDesign = new RoofDesign();

        User usr=[select Business_Function__c from User where Id=:Userinfo.getUserId()];
        
        if(actionType=='RequestDesign' && !usr.Business_Function__c.contains(Label.Request_Design)){
            rfDesign.error = Label.ErrorRequestDesign;
            return rfDesign;
        }

        if(actionType=='CreateDesign' && !usr.Business_Function__c.contains(Label.Aurora_Design_Licensee)){
            rfDesign.error = Label.Error_Create_Design;
            return rfDesign;
        }
        
        boolean hasError = false;
        //String error=null;
        Id rdMaxFitRecordTypeId = Schema.SObjectType.Roof_Design__c.getRecordTypeInfosByName().get('Residential MaxFit Designs').getRecordTypeId();
        
        List<Roof_Design__c> rDesignList = new List<Roof_Design__c>([select Id,Status__c,Type__c,Active__c from Roof_Design__c where Account_Name__c=:accId and RecordTypeId=:rdMaxFitRecordTypeId]);
        List<Roof_Design__c> completeActiveRDList = new List<Roof_Design__c>();
        
        for(Roof_Design__c rd:rDesignList){
            if(rd.Status__c=='Pending'){
                if(actionType == 'RequestDesign'){
                    hasError=true;
                    rfDesign.error='Pending MaxFit Design already exists';
                }
            }
            else if(rd.Status__c!='Pending' && rd.Active__c==true){
                completeActiveRDList.add(rd);
            }
        }
        
        if(!hasError){
            try{
                for(Roof_Design__c crd:completeActiveRDList){
                    crd.Active__c = false;
                }
                
                if(!completeActiveRDList.isEmpty())
                    update completeActiveRDList;
                String auororaProjId = AuroraAPICallHandler.CreateProjectfromAccount(accId,actionType);
                if(auororaProjId == null && AuroraAPICallHandler.errorMessage != null){
                    rfDesign.error = AuroraAPICallHandler.errorMessage;
                    return rfDesign;
                }
                String origin = actionType == 'RequestDesign' ? 'Request' : actionType == 'CreateDesign' ? 'Self Service' : null;
                Roof_Design__c rDesign = new Roof_Design__c(Account_Name__c = accId,
                                                            Active__c = true,
                                                            Status__c = 'Pending',
                                                            RecordTypeId = rdMaxFitRecordTypeId,
                                                            Origin__c = origin,
                                                            Notes_for_Design_Team__c = roofDes.Notes_for_Design_Team__c,
                                                            Expedited_Design_Request__c = roofDes.Expedited_Design_Request__c);
                insert rDesign;
                rfDesign.roofDesignId = rDesign.Id;
            }catch(Exception e){
                rfDesign.error=e.getMessage();
            } 
        }
        return rfDesign;
    }

    public class RoofDesign{
        public Id roofDesignId;
        public String error;
    }
}