public class CopyMTCls {
    String performanceMetricId;
    String Country,Channel;
    public void invokeM(){
        performanceMetricId=ApexPages.currentPage().getParameters().get('id');
        Country = ApexPages.currentPage().getParameters().get('cntry');
        Channel = ApexPages.currentPage().getParameters().get('chnl');
        Integer mtrCount=[select count() from Metric_Tier_Relation__c where Performance_Metric__c=:performanceMetricId];    
        system.debug('Count**'+mtrCount);
        if(mtrCount==0){
            copyMetricTierRecords(Country,Channel,performanceMetricId); 
        }
    }
    
    public void copyMetricTierRecords(String Country,String Channel,String perfId){
        List<Metric_Tier_Relation__c> newRecords=new List<Metric_Tier_Relation__c>(); 
        system.debug('**country**'+Country+'**channel**'+Channel);
        List<Performance_Metric__c> performanceMetricList=[SELECT Id FROM Performance_Metric__c WHERE Channel__c = :Channel and Country__c=:Country ORDER By CreatedDate ];
        system.debug('Perform**'+performanceMetricList);
        if(performanceMetricList.size()>0){
            Integer i = performanceMetricList.size() - 2;
            if(performanceMetricList.size()==1){
                i=0;
            }
            system.debug('**size**'+i);
            List<Metric_Tier_Relation__c> mtrList=[select ParentMetricRelation__c,Sequence_Order__c,Thershold__c, Performance_Metric__c, Inactive__c, Child_Metric__c, Bonus_Requirement__c, Accept_Attachment__c , Metric_Description__c,Metric_Label__c,Boolean_Metric_Y_N__c,Metric_Min_Value__c,Metric_Max_Value__c,Incentive_Amount__c,Metric_Input_Type__c,
            Enter_Tier__c,Stay_Tier__c,Benefit_Tier__c,Market_Add_Row__c,isRSMView__c,Manual_Partner__c,Part_Of_Composite_Incentive__c,HelpText__c,Tier__c,Category__c from   Metric_Tier_Relation__c where Performance_Metric__c=:performanceMetricList.get(i).Id];
            system.debug('HI'+mtrList);
            for(Metric_Tier_Relation__c mtr:mtrList){
                Metric_Tier_Relation__c obj=new Metric_Tier_Relation__c();
                obj.Performance_Metric__c=perfId;
                obj.Tier__c=mtr.Tier__c;
                obj.Metric_Label__c=mtr.Metric_Label__c;
                obj.Metric_Description__c=mtr.Metric_Description__c;
                obj.Category__c=mtr.Category__c;
                obj.Metric_Input_Type__c=mtr.Metric_Input_Type__c;
                obj.Boolean_Metric_Y_N__c=mtr.Boolean_Metric_Y_N__c;
                obj.Metric_Min_Value__c=mtr.Metric_Min_Value__c;
                obj.Metric_Max_Value__c=mtr.Metric_Max_Value__c;
                obj.Incentive_Amount__c=mtr.Incentive_Amount__c;
                obj.Enter_Tier__c=mtr.Enter_Tier__c;
                obj.Stay_Tier__c=mtr.Stay_Tier__c;
                obj.Benefit_Tier__c=mtr.Benefit_Tier__c;
                obj.Market_Add_Row__c=mtr.Market_Add_Row__c;
                obj.Manual_Partner__c =mtr.Manual_Partner__c;
                obj.isRSMView__c = mtr.isRSMView__c;
                obj.Part_Of_Composite_Incentive__c = mtr.Part_Of_Composite_Incentive__c;
                obj.HelpText__c = mtr.HelpText__c;
                
                /*added new fields by hemant*/
                obj.Thershold__c = mtr.Thershold__c;
                obj.ParentMetricRelation__c = mtr.ParentMetricRelation__c;
                obj.Inactive__c = mtr.Inactive__c;
                obj.Child_Metric__c = mtr.Child_Metric__c;
                obj.Bonus_Requirement__c = mtr.Bonus_Requirement__c;
                obj.Accept_Attachment__c = mtr.Accept_Attachment__c;
                obj.Sequence_Order__c = mtr.Sequence_Order__c;
                newRecords.add(obj);    
            }
            insert newRecords;
        }
    
    }

}