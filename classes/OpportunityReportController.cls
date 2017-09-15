// ************************************************************/
// Name : OpportunityReportController 
// Created On : 14 Dec 2010
// Created By : Jitendra Kothari
// Updated On : 1 Feb 2011(Case # 00054914)
// Updated By : Jitendra Kothari
// Implementation: Controller class for Opportunity Report Page.
//  This Page has been implemented under case : 
// ***** *******************************************************/
public class OpportunityReportController {
    public List<Opportunity> listOpp{get;set;}
    public List<OppReport> listOppRep{get;set;} 
    public String selectQuery{get;set;}
    public String query{get;set;}       
    public String tableQuery{get;set;}
    public String whereQuery{get;set;}
    public String orderQuery{get;set;}
    public Integer countOpp{get;set;}
    public Opportunity sumOppCapacity{get;set;}
    public List<SelectOption> listBusiUnits{get;set;}
    public List<SelectOption> listRegion{get;set;}
    public List<SelectOption> listSubRegion{get;set;}
    public List<SelectOption> listSalesStage{get;set;}
    public List<SelectOption> listProb{get;set;}
    public List<String> busiUnits{get;set;}
    public List<String> regions{get;set;}
    public List<String> subRegions{get;set;}
    public List<String> salesStages{get;set;}
    public List<String> probs{get;set;}
    public String showbusiUnits{get;set;}
    public String showregions{get;set;}
    public String showsubRegions{get;set;}
    public String showsalesStages{get;set;}
    public String showprobs{get;set;}
    public String message{get;set;}
    public String message1{get;set;}
    public String message2{get;set;}
    public Boolean show{get;set;}
    public Boolean isAllowed{get;set;}
    public String currentUserEmail{ get; set;}
    public String sendEmailToUser {get; set;}
    public String MAIL_SUBJECT {get;set;}
    public String strEmailDealerCC{get;set;}
    public String strEmailDealerBcc{get;set;}
    public String strEmailBody{get;set;}
    public Boolean isClosed { get; set;}
    private Set<String> setSiteStatus = new Set<String>{'Comm. Letter signed', 'Optioned'};
    //constructor
    public OpportunityReportController() {
        this.show = false;                  
        getPickListValues();
        this.showbusiUnits = '';
        this.showregions = '';  
        this.showsubRegions = '';  
        this.showsalesStages = '';  
        this.showprobs = '';
        this.message2 = '';         
        currentUserEmail = Userinfo.getUserName();
        MAIL_SUBJECT ='Opportunity Report';
        strEmailBody = 'Please find the Opportunity Report attached as a PDF format here with this email.' ;
        List<GroupMember> memberList = [Select UserOrGroupId, Group.Name From GroupMember where Group.Name = 'SunRay Report Users' and Group.Type='Regular' and UserOrGroupId = :Userinfo.getUserId() limit 1];
        if(memberList.size()>0){            
            if(memberList.get(0).UserOrGroupId == Userinfo.getUserId())
                this.isAllowed = true;
        }else{
            List<User> userList = [Select Profile.Name,Email, UserName From User where Id = :Userinfo.getUserId()];
            if(userList.size()>0){  
                currentUserEmail = userList.get(0).Email;           
                if(userList.get(0).Profile.Name == 'System Administrator')
                    this.isAllowed = true;
            }
            System.debug(loggingLevel.INFO,'User Id->'+Userinfo.getUserId());
        }       
    }
    
    public void prepareQueryResult(String orderByClause){
    	//Case#00063588 replaced Region1__c with Country__c
        selectQuery ='Select Id, Name, StageName, Probability, System_SizePV__c,Average_Usable_Land_Percentage__c'+
                ', Permit_Submitted__c, Next_Meeting_with_Authorities__c, Environmental_Request_Filed__c'+
                ', Environmental_Request_Approved__c, Appeal_Period_Start_Date__c, Appeal_Period_End_Date__c'+
                ', Phase_II_Study_Filed1__c, Phase_II_Study_Received1__c, Phase_II_Study_Accepted1__c, Country__c'+
                ', Total_Land_Size__c, Sub_Region__c, Price_per_HA__c, Business_Unit__c, Reason_Won_Lost__c'+
                ', Binding_Offer_Accepted_Date__c, X75_Meeting_Date__c'+
                ', (Select Site_Status__c, Site_City__c, Notary_Option_Signed_On__c, Commercial_Letter_Expiry_Date__c'+
                ', Notary_Option_Expiry_Date__c From R00N30000000t6dPEAQ__r)'+
                ', (Select PricebookEntryId, PricebookEntry.Name, Product_Family__c, Product_Type__c From OpportunityLineItems)'+
                ', AccountId, Account.Interconnection_Request_Filed__c, Account.Phase_I_Study_Received__c'+ 
                ', Account.Phase_I_Study_Accepted__c';
        tableQuery = ' From Opportunity';
        //for case # 00054916
        whereQuery = ' Where RecordType.Name =\'Development\' ';
        //for case # 00054916
        if(busiUnits!=null && busiUnits.size()>0){
            this.showbusiUnits = getInString(busiUnits);              
            whereQuery = whereQuery + ' and Business_Unit__c in ('+this.showbusiUnits+')';
        }
        if(regions!=null && regions.size()>0){
            this.showregions = getInString(regions);
            //Case#00063588 replaced Region1__c with Country__c
            whereQuery = whereQuery + ' and Country__c in ('+this.showregions+')';
        }
        if(subRegions!=null && subRegions.size()>0){
            this.showsubRegions = getInString(subRegions);
            whereQuery = whereQuery + ' and Sub_Region__c in ('+this.showsubRegions+')';
        }
        //for case # 00054916
        if(salesStages!=null && salesStages.size()>0){
            whereQuery =  whereQuery + getInStringStage(salesStages);           
        }else{
        	whereQuery = whereQuery + ' and ((StageName = \'07 - Closed Lost\' and '+
                    ' Reason_Won_Lost__c = \'Dormant\') or (StageName = \'07 – Closed Lost\' and '+
                    ' Reason_Won_Lost__c = \'Dormant\') or (StageName != \'07 – Closed Lost\' and StageName != \'07 - Closed Lost\'))';
        }
        //for case # 00054916
        if(probs!=null && probs.size()>0){              
            this.showprobs = getInString(probs);
            this.showprobs = this.showprobs.replaceAll('\'','');
            whereQuery = whereQuery + ' and Probability in ('+this.showprobs+')';
        }
        if(orderByClause==null)//Case#00063588 replaced Region1__c with Country__c
            orderByClause = 'Business_Unit__c, Country__c, Sub_Region__c, StageName, Probability, Name Asc';        
        //orderQuery = ' Order by Name Limit 10';           
        orderQuery = ' Order by ' + orderByClause + ' Limit 10000';
        query = selectQuery + tableQuery + whereQuery + orderQuery;
        System.debug(loggingLevel.INFO, 'Debug: ' + query);
        try{
            listOpp = Database.query(query);        
            Integer i = 1;
            Double reg_space = 0;
            String region = '';
            Double reg_land = 0;
            this.sumOppCapacity = new Opportunity(System_Size_PV_Report__c = 0);
            listOppRep = new List<OppReport>();
            for(Opportunity opp : listOpp){            	
                if(opp.System_SizePV__c!=null)
                    this.sumOppCapacity.System_Size_PV_Report__c = this.sumOppCapacity.System_Size_PV_Report__c + opp.System_SizePV__c;
                OppReport oppRep = new OppReport(opp);              
                List<OpportunityLineItem> listOppLines = opp.OpportunityLineItems;
                if(listOppLines.size()>0){ 
                    for(OpportunityLineItem oppLine:listOppLines){
                        if(oppLine.Product_Family__c!=null){
                            if(oppLine.Product_Family__c=='PV Module')
                                oppRep.Modules = oppLine.PricebookEntry.Name;
                            else if(oppLine.Product_Family__c.contains('Mounting Systems'))
                                oppRep.Technology = oppLine.PricebookEntry.Name;
                        }
                    }   
                }
                List<Site_Information_Form__c> listSite = opp.R00N30000000t6dPEAQ__r;
                Date dateExpiry = null;
                Date dateOption = null;
                Boolean hasComm = false;
                Boolean hasOpt = false;
                String siteCity = '';
                Id siteId = null;//for case # 00054914
                
                if(listSite.size()>0){ 
                    for(Site_Information_Form__c site:listSite){
                        if(site.Site_City__c!=null && !siteCity.toLowerCase().contains(site.Site_City__c.toLowerCase())){
                            if(siteCity!='')
                                siteCity = siteCity + '/' + site.Site_City__c;
                            else
                                siteCity = site.Site_City__c;
                        }
                        if(site.Notary_Option_Expiry_Date__c!=null 
                        	&& setSiteStatus.contains(site.Site_Status__c)){//for case # 00054914                            
                            if(dateExpiry!=null && dateExpiry.daysBetween(site.Notary_Option_Expiry_Date__c)>0){
                                //do nothing
                            }else{
                                dateExpiry = site.Notary_Option_Expiry_Date__c;
                                siteId = site.Id;//for case # 00054914
                            }
                        }else{
                            if(site.Commercial_Letter_Expiry_Date__c!=null 
                            	&& setSiteStatus.contains(site.Site_Status__c)){//for case # 00054914                            
                                if(dateExpiry!=null && dateExpiry.daysBetween(site.Commercial_Letter_Expiry_Date__c)>0){
                                    //do nothing
                                }else{
                                    dateExpiry = site.Commercial_Letter_Expiry_Date__c;
                                    siteId = site.Id;//for case # 00054914
                                }
                            }                       
                        }
                        if(site.Site_Status__c=='Comm. Letter signed' && !hasComm){
                            hasComm = true;
                        }
                        if(site.Site_Status__c=='Optioned' && !hasOpt){
                            hasOpt = true;
                        }
                    }
                    for(Site_Information_Form__c site:listSite){
                        if(hasComm && hasOpt){
                            if(site.Site_Status__c=='Comm. Letter signed' && site.Notary_Option_Signed_On__c!=null){
                                if(dateOption!=null && dateOption.daysBetween(site.Notary_Option_Signed_On__c)>0){
                                    //do nothing
                                }else{
                                    dateOption = site.Notary_Option_Signed_On__c;
                                }
                            }
                        }
                        else if(hasOpt){
                            if(site.Site_Status__c=='Optioned' && site.Notary_Option_Signed_On__c!=null){
                                if(dateOption!=null && dateOption.daysBetween(site.Notary_Option_Signed_On__c) < 0){
                                    //do nothing
                                }else{
                                    dateOption = site.Notary_Option_Signed_On__c;
                                }
                            }
                        }
                    }
                    oppRep.Muncipality = siteCity;
                    oppRep.innerOpp.X75_Meeting_Date__c = dateExpiry;
                    oppRep.innerOpp.Binding_Offer_Accepted_Date__c = dateOption;
                    oppRep.siteId = siteId;//for case # 00054914
                    //set color
                    oppRep.Land_Option_Color = colorSetter(oppRep.innerOpp.Binding_Offer_Accepted_Date__c, System.today(), 'blue', 'black');
                    oppRep.STMG_Req_Filed_Color = colorSetter(oppRep.innerOpp.Account.Interconnection_Request_Filed__c, System.today(), 'blue', 'black');
                    oppRep.STMG_Receiving_Color = colorSetter(oppRep.innerOpp.Account.Phase_I_Study_Received__c, System.today(), 'blue', 'black');
                    oppRep.STMG_Accepted_Color = colorSetter(oppRep.innerOpp.Account.Phase_I_Study_Accepted__c, System.today(), 'blue', 'black');
                    oppRep.Autho_Req_Filed_Color = colorSetter(oppRep.innerOpp.Permit_Submitted__c, System.today(), 'blue', 'black');
                    oppRep.First_Call_CDS_Color = colorSetter(oppRep.innerOpp.Next_Meeting_with_Authorities__c, System.today(), 'blue', 'black');
                    oppRep.VIA_Req_Filed_Color = colorSetter(oppRep.innerOpp.Environmental_Request_Filed__c, System.today(), 'blue', 'black');
                    oppRep.VIA_Approval_Color = colorSetter(oppRep.innerOpp.Environmental_Request_Approved__c, System.today(), 'blue', 'black');
                    oppRep.Appeal_Period_Start_Color = colorSetter(oppRep.innerOpp.Appeal_Period_Start_Date__c, System.today(), 'blue', 'black');
                    oppRep.Appeal_Period_End_Color = colorSetter(oppRep.innerOpp.Appeal_Period_End_Date__c, System.today(), 'blue', 'black');
                    oppRep.STMD_Req_Filed_Color = colorSetter(oppRep.innerOpp.Phase_II_Study_Filed1__c, System.today(), 'blue', 'black');
                    oppRep.STMD_Receiving_Color = colorSetter(oppRep.innerOpp.Phase_II_Study_Received1__c, System.today(), 'blue', 'black');
                    oppRep.STMD_Accepted_Color = colorSetter(oppRep.innerOpp.Phase_II_Study_Accepted1__c, System.today(), 'blue', 'black');          
                    oppRep.Land_Expiry_Color = colorSetter(oppRep.innerOpp.X75_Meeting_Date__c, System.today(), 'blue', 'red');                                    
                }
                //this is done for reporting purpose only - will have the value of Id
                oppRep.Id = i++;
                if(region == ''){
                	region = opp.Sub_Region__c;
                	
                	OppReport op1 = new OppReport(new Opportunity());
                    op1.show = false;                               
                    op1.innerOpp.Sub_Region__c = region;
                    this.listOppRep.add(op1);      
                }else if(region != opp.Sub_Region__c){
                    OppReport op1 = new OppReport(new Opportunity());
                    op1.show = false;
                    op1.innerOpp.System_Size_PV_Report__c = reg_space;
                    op1.innerOpp.Total_Land_Size__c = reg_land;
                    op1.innerOpp.Sub_Region__c = null;
                    op1.innerOpp.StageName = 'Summary:';
                    //op1.innerOpp.Sub_Region__c = region;
                    this.listOppRep.add(op1);
                    System.debug(loggingLevel.INFO,'Total by '+region+' ->'+reg_space);
                    reg_space = 0;
                    reg_land = 0;
                    region = opp.Sub_Region__c;
                    
                    op1 = new OppReport(new Opportunity());
                    op1.show = false;                               
                    op1.innerOpp.Sub_Region__c = region;
                    this.listOppRep.add(op1);
                }
                if(opp.System_SizePV__c!=null){
                    reg_space = reg_space + opp.System_SizePV__c;                   
                }if(opp.Total_Land_Size__c!=null){
                    reg_land = reg_land + opp.Total_Land_Size__c;
                }
                this.listOppRep.add(oppRep);                
            }
            this.countOpp = this.listOpp.size();
            if(this.countOpp!=0){
                this.message = '';
                OppReport op = new OppReport(new Opportunity());
                op.show = false;                     
                op.innerOpp.System_Size_PV_Report__c = reg_space;
                op.innerOpp.Total_Land_Size__c = reg_land;
                op.innerOpp.StageName = 'Summary:';
                this.listOppRep.add(op);
                System.debug(loggingLevel.INFO,'Total by '+region+' ->'+reg_space);
            }
            else 
                this.message = 'No Record found......';
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,e.getMessage()));
        } 
    }
    //function is used to fill the data in multi-select picklists 
    public void getPickListValues(){
        SelectOption selopt;
        
        listBusiUnits = new List<SelectOption>();
        listRegion = new List<SelectOption>();
        listSubRegion = new List<SelectOption>();
        listSalesStage = new List<SelectOption>();
        listProb = new List<SelectOption>();
        
        //fetch picklist values for business unit
        Schema.DescribeFieldResult F = Opportunity.Business_Unit__c.getDescribe();
        List<Schema.PicklistEntry> P = F.getPicklistValues();
        for(Schema.PicklistEntry entry : P){      
            if(entry.isActive()){
                selopt =  new SelectOption(entry.getValue(), entry.getLabel());              
                listBusiUnits.add(selopt);
            } 
        }
        
        //fetch picklist values for region
        //Case#00063588 replaced Region1__c with Country__c
        F = Opportunity.Country__c.getDescribe();
        P = F.getPicklistValues();
        for(Schema.PicklistEntry entry : P){      
            if(entry.isActive()){
                selopt =  new SelectOption(entry.getValue(), entry.getLabel());              
                listRegion.add(selopt);
            }  
        }
        
        //fetch picklist values for sub region
        F = Opportunity.Sub_Region__c.getDescribe();
        P = F.getPicklistValues();
        for(Schema.PicklistEntry entry : P){
            if(entry.isActive()){      
                selopt =  new SelectOption(entry.getValue(), entry.getLabel());              
                listSubRegion.add(selopt);
            }  
        }
        
        //fetch picklist values for sales stage
        F = Opportunity.StageName.getDescribe();
        P = F.getPicklistValues();
        for(Schema.PicklistEntry entry : P){
            if(entry.isActive() &&  accept(entry)){      
                selopt =  new SelectOption(entry.getValue(), entry.getLabel());              
                listSalesStage.add(selopt);
            }  
        }
        //store picklist values for probablity
        listProb.add(new SelectOption('4.0', '4.0'));
        listProb.add(new SelectOption('12.0', '12.0'));
        listProb.add(new SelectOption('25.0', '25.0'));
        listProb.add(new SelectOption('50.0', '50.0'));
        listProb.add(new SelectOption('75.0', '75.0'));
        listProb.add(new SelectOption('90.0', '90.0'));
        listProb.add(new SelectOption('100.0', '100.0'));
    }
    
    private Boolean accept(PicklistEntry e) {
        // Only show the entries are in the show set
        Set<String> show = new Set<String>{
            '01 – Assess Opportunity'
            ,'02 – Budgetary Pricing'
            ,'03 – Binding Offer'
            ,'04 – Negotiate Contract'
            ,'05 – Agreements Finalized'
            ,'06 – Closed Won'
            ,'07 – Closed Lost'
            };
        return show.contains(e.getValue());
    }
    
    //function is used to create a string from List of Sting to be used in In clause of soql
    public String getInString(List<String> input){
        String result = '';
        for(String s : input){
            s = s.trim();
            s = s.replace('\'', '\\\'');
            if(result=='')
                result = result + '\'' + s + '\'';
            else
                result = result + ',\'' + s + '\''; 
        } 
        return result;
    }
    //function is used to create a string from List of Sting to be used in In clause of soql for sales stage
    public String getInStringStage(List<String> input){
    	String query ='';
    	String queryResult = '';
        String result = '';
        for(String s : input){
            s = s.trim();
            s = s.replace('\'', '\\\'');
            if(s == '07 – Closed Lost'){
            	queryResult = '(Reason_Won_Lost__c = \'Dormant\' and StageName  = \'07 – Closed Lost\')';
            	continue;
            }
            if(result=='')
                result = result + '\'' + s + '\'';
            else
                result = result + ',\'' + s + '\''; 
        } 
        if(result!='' && queryResult != ''){
        	query = ' and ( StageName in ('+ result + ') or ' + queryResult + ')';
        }else if(result!=''){
        	query = ' and StageName in ('+result+')';
        }else{
        	query = ' and ' + queryResult;
        }
        return query;
    }    
    //set the base on input dates
    public String colorSetter(Date d1, Date d2, String color1, String color2){        
        if(d1!=null && d2.daysBetween(d1) > 0)
            return color1;
        else        
            return color2;        
    }    
    
    public PageReference getData(){
        this.show = true;
        this.showbusiUnits = '';
        this.showregions = '';  
        this.showsubRegions = '';  
        this.showsalesStages = '';  
        this.showprobs = '';
        this.message2 = '';
        prepareQueryResult(null);       
        return null;
    }
    
    public PageReference exportToExcel() {
        this.message2 = '';
        return new PageReference('/apex/OpportunityReportExcel');
    }
    
    public PageReference exportToPDF() {
        this.message2 = '';
        return new PageReference('/apex/OpportunityReportPdf');
    }
    
    public PageReference exportToPDFAndEmail() {
        this.message2 = '';
        try{                       
            blob content = (new PageReference('/apex/OpportunityReportPdf')).getContent();
            String fileName = 'OpportunityReport-'+ Datetime.now().format('yyMMddHHmmss') + '.pdf';           
            sendEmail(content,fileName);
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,e.getMessage()));
            return null;
        }
        this.message2 = 'Email Sent Succesfully.';
        return null;
    }
    
    private void sendEmail(blob content,String fileName){        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();             
        if (sendEmailToUser != null && sendEmailToUser != '') {
            mail.setToAddresses(sendEmailToUser.split(';')); //To Email Address
            mail.setSubject(MAIL_SUBJECT);
            mail.setPlainTextBody(strEmailBody); 
        }
        
        if(content.size() > 0 && fileName != '' ) {
            List<Messaging.EmailFileAttachment> lstAttachments = new List<Messaging.EmailFileAttachment>();            
            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            attach.setBody(content);
            attach.setContentType('application/pdf');
            attach.setFileName(fileName);
            lstAttachments.add(attach);
            mail.setFileAttachments(lstAttachments);
        }
        
        if (strEmailDealerCC != null && strEmailDealerCC != '') 
            mail.setCcAddresses(strEmailDealerCC.split(';'));//Cc Email Address
        if (strEmailDealerBcc != null && strEmailDealerBcc != '')
            mail.setBccAddresses(strEmailDealerBcc.split(';'));//Bcc Email Address
            
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });                     
    }
    
    public List<String> getBusiUnits(){
        return busiUnits;
    }
    
    public void setBusiUnits(List<String> busiUnits){
        this.busiUnits = busiUnits; 
    }
    
    public List<String> getRegions(){
        return regions;
    }
    
    public void setRegions(List<String> regions){
        this.regions = regions; 
    }
    public List<String> getSubRegions(){
        return subRegions;
    }
    
    public void setSubRegions(List<String> subRegions){
        this.subRegions = subRegions;   
    }
    
    public List<String> getSalesStages(){
        return salesStages;
    }
    
    public void setSalesStages(List<String> salesStages){
        this.salesStages = salesStages; 
    }
    public List<String> getProbs(){
        return probs;
    }
    
    public void setProbs(List<String> probs){
        this.probs = probs; 
    }
    
    public List<SelectOption> getListBusiUnits() {      
        return listBusiUnits;
    }
    
    public List<SelectOption> getListRegion() {     
        return listRegion;
    }
    
    public List<SelectOption> getListSubRegion() {      
        return listSubRegion;
    }
    
    public List<SelectOption> getListSalesStage() {     
        return listSalesStage;
    }
    
    public List<SelectOption> getListProb() {       
        return listProb;
    }
    //class that hold an Opportunity Report Row
    private class OppReport{
        public Integer Id{get;set;}//1
        public String Master_Code{get;set;}//2
        public String OppName{get;set;}//3
        public String Muncipality{get;set;}//4
        public String Status{get;set;}//5
        public Double Capacity{get;set;}//6
        public Double Usable_Land{get;set;}//7
        public Date Land_Option{get;set;}//8
        public String Land_Option_Color{get;set;}//8
        public Opportunity innerOpp{get;set;}//9
        public String STMG_Req_Filed_Color{get;set;}//9
        public Date STMG_Receiving{get;set;}//10
        public String STMG_Receiving_Color{get;set;}//10
        public Date STMG_Accepted{get;set;}//11
        public String STMG_Accepted_Color{get;set;}//11
        public Date Autho_Req_Filed{get;set;}//12
        public String Autho_Req_Filed_Color{get;set;}//12
        public Date First_Call_CDS{get;set;}//13
        public String First_Call_CDS_Color{get;set;}//13
        public Date VIA_Req_Filed{get;set;}//14
        public String VIA_Req_Filed_Color{get;set;}//14
        public Date VIA_Approval{get;set;}//15
        public String VIA_Approval_Color{get;set;}//15
        public Date Appeal_Period_Start{get;set;}//16
        public String Appeal_Period_Start_Color{get;set;}//16
        public Date Appeal_Period_End{get;set;}//17
        public String Appeal_Period_End_Color{get;set;}//17
        public Date STMD_Req_Filed{get;set;}//18
        public String STMD_Req_Filed_Color{get;set;}//18
        public Date STMD_Receiving{get;set;}//19
        public String STMD_Receiving_Color{get;set;}//19
        public Date STMD_Accepted{get;set;}//20
        public String STMD_Accepted_Color{get;set;}//20
        public Date Land_Expiry{get;set;}//21
        public String Land_Expiry_Color{get;set;}//21
        public String Technology{get;set;}//22
        public String Modules{get;set;}//23
        public Double Land_Size{get;set;}//24
        public boolean show{get;set;}
        public Id siteId{get;set;}//for case # 00054914        
        
        public void colorAssign(){
            this.Land_Option_Color = 'black';
            this.STMG_Req_Filed_Color ='black';
            this.STMG_Receiving_Color ='black';
            this.STMG_Accepted_Color ='black';
            this.Autho_Req_Filed_Color = 'black';
            this.First_Call_CDS_Color = 'black';
            this.VIA_Req_Filed_Color = 'black';
            this.VIA_Approval_Color = 'black';
            this.Appeal_Period_Start_Color = 'black';
            this.Appeal_Period_End_Color = 'black';
            this.STMD_Req_Filed_Color = 'black';
            this.STMD_Receiving_Color = 'black';
            this.STMD_Accepted_Color = 'black';         
            this.Land_Expiry_Color = 'black'; 
        }
        OppReport(Opportunity opp){
            this.colorAssign();
            this.innerOpp = opp;
            this.innerOpp.Binding_Offer_Accepted_Date__c = null;
            this.innerOpp.X75_Meeting_Date__c = null;
            this.show = true;            
        }
    }
}