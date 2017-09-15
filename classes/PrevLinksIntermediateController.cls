public without sharing class PrevLinksIntermediateController {  
    private String accountId;
    private String period;
    private String originalPeriod;
    private String year;
    private String previousType;
    public Performance_Metric__c prevPM;
    public String pageType;
    private Account acc;
    private String accTheater;
    public PrevLinksIntermediateController(){
        if(ApexPages.currentPage().getParameters().get('accId') != null && ApexPages.currentPage().getParameters().get('accId') != ''){
            accountId = ApexPages.currentPage().getParameters().get('accId');
        }else{
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR,'Account ID is required.'));
            return ;
        }
        
        if(ApexPages.currentPage().getParameters().get('period') != null && ApexPages.currentPage().getParameters().get('period') != '' ){
            originalPeriod = ApexPages.currentPage().getParameters().get('period');
            period = 'P' + ApexPages.currentPage().getParameters().get('period');
        }else{
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR,'Performance Period is required.'));
            return ;
        }
        
        if(ApexPages.currentPage().getParameters().get('year') != null && ApexPages.currentPage().getParameters().get('year') != ''){
            year = ApexPages.currentPage().getParameters().get('year');
        }else{
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR,'Performance Year is required.'));
            return ;
        }
        
        if(ApexPages.currentPage().getParameters().get('pageType') != null && ApexPages.currentPage().getParameters().get('pageType') != ''){
            pageType = ApexPages.currentPage().getParameters().get('pageType');
        }
        
        acc = [Select a.name, a.CurrencyIsoCode, a.type,a.Country_Domain__c,a.Theater__c,a.Authorized_Partner_Date__c,a.Promoted_Premier_Date__c,a.Elite_partner_Date__c,a.Residential_Installer_Date__c from Account a where id =: this.accountId];
        String accCountryDomain = acc.Country_Domain__c;
        if(accCountryDomain != null ){
           if(accCountryDomain.Substring(accCountryDomain.indexOf('-')+1,accCountryDomain.length()).equals('us')){
               if(accCountryDomain.Substring(0,accCountryDomain.indexOf('-')).equals('rvar') || accCountryDomain.Substring(0,accCountryDomain.indexOf('-')).equals('combo')){
                   accCountryDomain = accCountryDomain.Substring(accCountryDomain.indexOf('-')+1 ,accCountryDomain.length());
               }
           }
           else if((accCountryDomain.Substring(accCountryDomain.indexOf('-')+1,accCountryDomain.length()).equals('it'))||(accCountryDomain.Substring(accCountryDomain.indexOf('-')+1,accCountryDomain.length()).equals('de'))){
                   accCountryDomain = accCountryDomain.Substring(accCountryDomain.indexOf('-')+1 ,accCountryDomain.length());
           }
        }
        String country_full_name ='';
       
        if(accCountryDomain != null){       
            country_full_name = PerformanceEvalCst.countryMap.get(accCountryDomain);
        }
        
        /* Done for the case # 00051450 */
        accTheater = acc.Theater__c;
        if(PerformanceEvalCst.usTheatersMap.containsKey(accTheater)){
            accTheater = PerformanceEvalCst.usTheatersMap.get(accTheater);
        }
        
        for(Performance_Metric__c pm :[select User_To_Override__c,Performance_Period_Start_Date__c, Performance_Period_End_Date__c,Performance_Evaluation_Cut_off_Date__c from Performance_Metric__c where Thea__c in (: accTheater) and Country__c in (: country_full_name) and Performance_Year__c=:Integer.valueOf(year) and  Performance_Period__c=:period ]){
            prevPM = pm;
        }
        if(prevPM != null){
            try{
            DateTime dtStart = DateTime.newInstance(prevPM.Performance_Period_Start_Date__c.year(), prevPM.Performance_Period_Start_Date__c.month(),prevPM.Performance_Period_Start_Date__c.day());
            DateTime dtEnd = DateTime.newInstance(prevPM.Performance_Period_End_Date__c.year(), prevPM.Performance_Period_End_Date__c.month(),prevPM.Performance_Period_End_Date__c.day());
            previousType = PerformanceEvalCst.findPreviousType(accountId, dtStart, dtEnd);
            }catch(Exception e){
                
            }
        }
        if(previousType == null){
            previousType = acc.Type;
        }
        
        
    }
    
    public PageReference redirectAction(){
        Pagereference pgToRedirect;
        
        if(pageType == 'Evaluation'){
            if( accTheater == 'North America' && ( previousType == 'Commercial' || previousType == 'Partner-Commercial' )
               ) {
                
                pgToRedirect = new PageReference('/apex/PerformanceEvalPreviousComm?year='+year+'&period='+originalPeriod+'&accId='+accountId);
                pgToRedirect.setRedirect(true);
            }else if( accTheater == 'North America'  && (previousType == 'Authorized-Partner-Combo' || previousType == 'Elite-Partner-Combo' ||
                      previousType == 'Premier-Partner-Combo')
            ) {
                pgToRedirect = new PageReference('/apex/PerformanceEvalPrevPageCombo?year='+year+'&period='+originalPeriod+'&accId='+accountId);
                pgToRedirect.setRedirect(true);
            }else{
            
                pgToRedirect = new PageReference('/apex/PerformanceEvalPrevious?year='+year+'&period='+originalPeriod+'&accId='+accountId);
                pgToRedirect.setRedirect(true);
            }
        }else{
            if( accTheater == 'North America' && ( previousType == 'Commercial' || previousType == 'Partner-Commercial' )
               ) {
                
                pgToRedirect = new PageReference('/apex/incentiveDetailPreviousComm?year='+year+'&period='+originalPeriod+'&accId='+accountId);
                pgToRedirect.setRedirect(true);
            }else if( accTheater == 'North America'  && (previousType == 'Authorized-Partner-Combo' || previousType == 'Elite-Partner-Combo' ||
                      previousType == 'Premier-Partner-Combo')
            ) {
                pgToRedirect = new PageReference('/apex/incentiveDetailPreviousCombo?year='+year+'&period='+originalPeriod+'&accId='+accountId);
                pgToRedirect.setRedirect(true);
            }else{
            
                pgToRedirect = new PageReference('/apex/incentiveDetailPrevious?year='+year+'&period='+originalPeriod+'&accId='+accountId);
                pgToRedirect.setRedirect(true);
            }
        }
        
        return pgToRedirect;
    }
}