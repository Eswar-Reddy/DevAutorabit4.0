public with sharing class QualificationRulesControllerExt
{
    public static final String INCOMING_VALUE_DELIMITER = ',';
    public List<RuleModel> rulesForQualification { get; set; }
    public id qualificationRuleid {get;set;} //set it in the page as apex param to for removal of the Rule 
    private ApexPages.StandardController standardCtrl;

    public static List<SelectOption> selectableFields
    {
        get
        { 
            if( selectableFields == null )
            {
                selectableFields = new List<SelectOption>();
                for( Schema.SObjectField aField : Lead.getSObjectType().getDescribe().fields.getMap().values() )
                {
                    Schema.DescribeFieldResult fieldDescribe = aField.getDescribe();
                    if( fieldDescribe.isUpdateable() )
                    {
                        selectableFields.add( new SelectOption( fieldDescribe.getName(), fieldDescribe.getLabel() ) );
                    }
                }
                selectableFields.add( new SelectOption('DealerFound','DealerFound') );
                selectableFields.add( new SelectOption('OptedOutDealerFound','OptedOutDealerFound') );
                selectableFields.sort();
            }
            return selectableFields;
        }
        private set; 
    }

    public QualificationRulesControllerExt( ApexPages.StandardController standardCont )
    {
        this.standardCtrl = standardCont;
        this.rulesForQualification = new List<RuleModel>();
        for( Qualification_Rule__c aRule : [ SELECT Id,Order__c,Field_API_Name__c, Accepted_Values__c, Eloqua_Field_Name__c, Disqualified_Reason__c
                                                FROM Qualification_Rule__c WHERE Qualification__c = :standardCont.getId() ORDER BY Order__c ASC ] )
        {
            this.rulesForQualification.add( new RuleModel( aRule ) );
        }
    }

    public void addRule()
    {
        List<RuleModel> newRuleList = new List<RuleModel>{ new RuleModel( new Qualification_Rule__c( Qualification__c = this.standardCtrl.getId() ) ) };
        newRuleList.addAll( rulesForQualification );
        rulesForQualification = newRuleList;
    }
    public pagereference deleteRule()
    {   
       List<RuleModel> newRuleList_afterDelete=new List<RuleModel>();
       set<id> qualificationToDelete=new set<id>();
       System.debug('======>'+qualificationRuleid);
       for(RuleModel Rm:rulesForQualification) {
         if(Rm.record.id==qualificationRuleid){
              //dont add in the list    rulesForQualification.remove(i);
              qualificationToDelete.add(Rm.record.id); // Adding to the list to delete it
         }
         else{
         newRuleList_afterDelete.add(Rm);
         }
       }
     rulesForQualification.clear();
     rulesForQualification=newRuleList_afterDelete;
     if(!qualificationToDelete.isEmpty())
        deleteQualification(qualificationToDelete); //Delete the list  of qualification  
    return null;
    }
    
    public void deleteQualification(set<id> toDelete){
    if(toDelete!=null && !toDelete.isEmpty()){
      List<Qualification_Rule__c> qList=[select id from Qualification_Rule__c where id IN :toDelete];
      delete qList; 
      save();   // calling the save function to reset the order number 
      }
    }
    public void save()
    {
        List<Qualification_Rule__c> rules = new List<Qualification_Rule__c>();
        for( Integer ruleIndex = 0; ruleIndex < this.rulesForQualification.size(); ruleIndex++ )
        {
            RuleModel aRule = this.rulesForQualification[ruleIndex];
            aRule.record.Order__c = ruleIndex + 1;
            aRule.record.Accepted_Values__c = String.join( aRule.acceptedValues, '|' );
            rules.add( aRule.record );
        }

        try
        {
            upsert rules;
        }
        catch( System.DmlException ex )
        {
            ApexPages.addMessages( ex );
        }
    }

    public PageReference cancel()
    {
        ApexPages.currentPage().setRedirect(true);
        return ApexPages.currentPage();
    }

    public class RuleModel
    {
        public Qualification_Rule__c record { get; set; }
        public List<String> acceptedValues { get; set; }
        public String incomingValues { get; set; }
        public String valueToDelete { get; set; }

        public RuleModel( Qualification_Rule__c aRule )
        {
            this.record = aRule;
            this.acceptedValues = new List<String>();
            if( !String.isBlank( aRule.Accepted_Values__c ) )
            {
                for( String aValue : aRule.Accepted_Values__c.split( DynaFormWebService.DELIMITER ) )
                {
                    this.acceptedValues.add( aValue.trim() );
                }
                this.acceptedValues.sort();
            }
        }

        public void addValues()
        {
            Set<String> setOfValues = new Set<String>( this.acceptedValues );
            for( String aValue : this.incomingValues.split( INCOMING_VALUE_DELIMITER ) )
            {
                if( !String.isBlank( aValue ) )
                {
                    setOfValues.add( aValue.trim() );
                }
            }
            this.acceptedValues = new List<String>( setOfValues );
            this.acceptedValues.sort();
        }

        public void save()
        {
            this.record.Accepted_Values__c = String.join( this.acceptedValues, '|' );
            try
            {
                upsert this.record;
            }
            catch( System.DmlException ex )
            {
                ApexPages.addMessages( ex );
            }
        }

        public void deleteValue()
        {
            Set<String> setOfValues = new Set<String>( this.acceptedValues );
            setOfValues.remove( this.valueToDelete );
            this.acceptedValues = new List<String>( setOfValues );
            this.acceptedValues.sort();
        }
    }
}