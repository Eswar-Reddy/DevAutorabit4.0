/*********************************************************************
    Name  : CopyMTClsTest
  Date  : July 18,2011
    Description:This is a Test Class For Class "CopyMTCls".
*********************************************************************/

public class CopyMTClsTest {
    public static testMethod void testCopy(){
      //  List<Performance_Metric__c>  pmList = [Select Id from Performance_Metric__c where Country__c ='Italy' ];
        
        Performance_Metric__c pm;
        List<Performance_Metric__c> pmlist;
        pmlist = [select id from Performance_Metric__c where Peformance_Metric_Name__c='Italy-Jan2012_to_Jun2012'];
        
        if(pmlist.size()==0){
          pm = new Performance_Metric__c(Peformance_Metric_Name__c='Italy-Jan2012_to_Jun2012');
          insert pm;
        }  
        else
          pm = pmlist.get(0);
        
        ApexPages.currentPage().getParameters().put('id',pm.id);
        ApexPages.currentPage().getParameters().put('cntry','Italy');
        ApexPages.currentPage().getParameters().put('chnl','EU Program');
        
        CopyMTCls cpyObj = new CopyMTCls();
            cpyObj.invokeM();
            cpyObj.copyMetricTierRecords('Italy', 'EU Program', pm.id);
            
        Performance_Metric__c perfMetric = new Performance_Metric__c();
        
        Tier__c tier = new Tier__c();
            tier.Tier_Name__c = 'Tier1';
        
        Metric_Tier_Relation__c metTierRel = new Metric_Tier_Relation__c();
            metTierRel.Performance_Metric__c = perfMetric.Id;
            metTierRel.Tier__c = tier.Id;
            metTierRel.Metric_Label__c = 'BGSM Scorecard';
            metTierRel.Metric_Description__c = 'hi';
            metTierRel.Category__c = 'Training';
            metTierRel.Metric_Input_Type__c = 'Manual';
            metTierRel.Boolean_Metric_Y_N__c = true;
            metTierRel.Metric_Min_Value__c = 25;
            metTierRel.Metric_Max_Value__c = 50; 
            metTierRel.Incentive_Amount__c = 0.9;
            metTierRel.Enter_Tier__c = true;
            metTierRel.Stay_Tier__c = true;
            metTierRel.Benefit_Tier__c = true;
            metTierRel.Market_Add_Row__c = true;
            metTierRel.Manual_Partner__c = true;
            metTierRel.isRSMView__c = true;
            metTierRel.Part_Of_Composite_Incentive__c = true;
            metTierRel.HelpText__c = 'hello';
            
            metTierRel.Thershold__c = 15;
        //    metTierRel.ParentMetricRelation__c = mtr.ParentMetricRelation__c;
            metTierRel.Inactive__c = true;
            metTierRel.Child_Metric__c = true;
            metTierRel.Bonus_Requirement__c = 0.9;
            metTierRel.Accept_Attachment__c = true;
            metTierRel.Sequence_Order__c = 20;          
            insert metTierRel;
    }    
}