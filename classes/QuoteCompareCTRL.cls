public class QuoteCompareCTRL
{
   List<ID> lsIDS = new List<ID>();
   public System_Production__c s1 {get; set;}    
   public System_Production__c s2 {get; set;}
   public System_Production__c s3 {get; set;}
   public boolean s1panel {get;set;}
   public boolean s2panel {get;set;}
   public boolean s3panel {get;set;}
   public String leasePayment{get;set;}
   public String leasePayment2{get;set;}
   public String leasePayment3{get;set;}
   public Decimal eWithPV{get;set;}
   public Decimal eWithPV2{get;set;}
   public Decimal eWithPV3{get;set;}
   public Decimal eWithoutPV{get;set;}
   public Decimal eWithoutPV2{get;set;}
   public Decimal eWithoutPV3{get;set;}
   public Decimal tEnergy1 {get;set;}
   public Decimal tEnergy2 {get;set;}
   public Decimal tEnergy3 {get;set;}
   Decimal unitPrice = 0;
   public Decimal Leasesch1{get;set;}
   public Decimal Leasesch2{get;set;}
   public Decimal Leasesch3{get;set;}
   public Decimal sprdAnnual{get;set;}
   public Decimal sprdAnnual1{get;set;}
   public Decimal sprdAnnual2{get;set;} 
   public Decimal UpPayment1{get;set;}
   public Decimal UpPayment2{get;set;} 
   public Decimal UpPayment3{get;set;} 
   public String subModule1{get;set;}
   public String subModule2{get;set;}
   public String subModule3{get;set;}
   public String width1 {get;set;}
   public String width2 {get;set;}
   public String width3 {get;set;}
   public Decimal propSTaxRate { get; set; }
   Decimal propSFYear;
   Decimal PartialPrePayAmount;
   public Decimal tempNtSavALL1 {get; set;}
   public Decimal tempNtSavALL2 {get; set;}
   public Decimal tempNtSavALL3 {get; set;}
   public string accName {get; set;}
   public  Decimal UtliCst;  //Utility Cost Per kWh of Electric Bill Summary Object 
   public  Integer SysProdYr1 = 0;
   public  Decimal toRound2CPKW = 0.0 ;
   public Decimal Yr1OldBil = 0.0;
   public  Decimal Yr1NewBil = 0.0;
   public Decimal  MinBillx  = 0.0;
   public Decimal UtliCstminimumNewBill = 0.0;  
   public Decimal propSysPrice;    //System Price  
   public Decimal propNetSysCost;  //Net System Cost
   public Decimal propIncentive;   //Rebate
   public Decimal propFedTaxCrdt;  //Federal tax Credit
   public Decimal CumulProd = 0.0 ;//Cumulative Production for 1- 20 years 
   Public  List<Monthly_Electric_Bill__c>  MinimumBillMEB;
   public  List<Electric_Bill_Summary__c> lstEBS;
   public List<Lease_Schedule__c> Leasesch;
   public Decimal zeroSalesTax = 0.0;
   
public QuoteCompareCTRL()
{
s1panel = false;
s2panel = false;
s3panel = false;

String leasefields2 = 'ID,System_Size_DC__c,quote__r.quoteType__C,quote__r.System_Cost__c,quote__r.System_Model__c,quote__r.Description__c,quote__r.Lease_Annual_Escalation__c,quote__r.module__c,quote__r.id,Total_Energy__c,System_Size_AC__c,Upfront_Incentives__c,Monthly_Lease_Payment__c,Upfront_Lease_Payment__c,Cost_per_watt_DC__c,cost_per_watt_AC__c,Incentive_Design_Factor__c,Monthly_Lease_Payment7_50discount__c,Monthly_Electric_Bill_Without_PV_year1__c,Monthly_Electric_Bill_With_PV_year1__c,Monthly_Electric_Bill_saving_year1__c,Percentage_Electricity_Produced__c,Cash_Price_Return_On_Investment_year1__c,Monthly_Electric_Bill_Without_PV_year5__c,Monthly_Electric_Bill_With_PV_year5__c,Monthly_Electric_Bill_saving_year5__c,Cash_Price_Return_On_Investment_year5__c,Quote__c';
     
    s1 = new System_Production__c ();
    s3 = new System_Production__c ();
    s2 = new System_Production__c ();        

    if(ApexPages.currentPage().getParameters().get('ls1') != 'null')
    {
       string ls1 = ApexPages.currentPage().getParameters().get('ls1');
       String queryString1 = 'SELECT '+ leasefields2  +' FROM System_Production__c '+' WHERE Id =\'' + ls1 + '\' LIMIT 1';       
       if(queryString1!=null)
       {
           s1 = Database.query(queryString1);
       }
       if(s1.quote__r.System_Model__c!=null)
       {
            String Module = s1.quote__r.System_Model__c;
            List<String> ModuleArray = Module.split('Model', 2);
            subModule1 = ModuleArray[1].substring(0, ModuleArray[1].length() - 1);
            system.debug('Substring'+subModule1);
       }
       if(s1.Monthly_Lease_Payment7_50discount__c!=null)
       {
            leasePayment = '$'+ String.valueof(s1.Monthly_Lease_Payment7_50discount__c.SetScale(2));
       }
       else
       {
           leasePayment = 'NA';
       }
       if(s1.Monthly_Electric_Bill_Without_PV_year1__c!=null)
       {
            unitPrice = s1.Monthly_Electric_Bill_Without_PV_year1__c;
            eWithoutPV = unitPrice.SetScale(2);
       }
       if(s1.Monthly_Electric_Bill_With_PV_year1__c!=null)
       {
            unitPrice = s1.Monthly_Electric_Bill_With_PV_year1__c;
            eWithPV = unitPrice.SetScale(2);
       }
       if(s1.Total_Energy__c!=null)
       {
          tEnergy1 = s1.Total_Energy__c;
       }
       Leasesch = [SELECT ID, Years__c, System_Production_Annual_Production__c, X95_of_S_P_A_P__c,X105_of_S_P_A_P__c, Cumulative_Production_kWh__c,Cost_of_Lease_Per_kWh__c  FROM Lease_Schedule__c WHERE quote__r.ID =:s1.quote__r.id Order by Years__c];
       CumulProd = Leasesch.get(Leasesch.size()-1).Cumulative_Production_kWh__c;
       List<Incentive_details__c>  IncentDetails = [SELECT id,Incentive_amount__c FROM Incentive_details__c WHERE Quote__c =:s1.quote__r.id AND incentive_description__c = 'federalTaxCredit' ];
      
        if(IncentDetails.size()> 0 && IncentDetails[0].Incentive_amount__c!=null)
        {
            propFedTaxCrdt   = IncentDetails[0].Incentive_amount__c;
        }
        else
        {
            propFedTaxCrdt= 0;
        }
       if(Leasesch.size()>0 && s1.quote__r.quoteType__C=='Lease')
       {
          
           if(Leasesch[0].Cost_of_Lease_Per_kWh__c!=null)
           {
               unitPrice = Leasesch[0].Cost_of_Lease_Per_kWh__c;
               if(unitPrice!=0.00)
               {
                   sprdAnnual = Math.round(unitPrice* 100) / 100.0; // unitPrice.SetScale(2);
               }
               else if (unitPrice == 0.00)
               {
                    sprdAnnual = 0;
               }     
           }
           
       }
       
       if(s1.quote__r.System_Cost__c!=null)
       {
          propSysPrice  = s1.quote__r.System_Cost__c;
       }
       else
       {
           propSysPrice= 0;
       }
       if(s1.Upfront_Incentives__c!=null)
       {
           propIncentive = s1.Upfront_Incentives__c; 
       }
       else
       {
           propIncentive = 0;
       }
       if(propSysPrice != null)
       {
         propNetSysCost   = propSysPrice  - propIncentive - propFedTaxCrdt;
       }
       if(s1.quote__r.quoteType__C=='cash')
       {
           if(CumulProd != 0 && CumulProd !=null)
           sprdAnnual =  (propNetSysCost  / CumulProd );
           else
           sprdAnnual = 0;
       }   
       
       
       Quote qot = [SELECT id,Is_Locked__c,Sales_Tax_Rate__c, name,quoteType__C, System_Cost__c,Partial_Prepayment__c,Account__r.Name,Account__r.Sales_Tax_Rate__c,Account__r.BillingState, 
                                    (SELECT id,
                                            Final_Estimated_Monthly_W_Tax_W_ACH__c,
                                     Years__c, Quote__c 
                                     FROM Lease_Progress__r 
                                     ORDER BY Years__c ASC), 
                                     (SELECT id, AnnualRECValue__c,
                                             Lease_Termination_Value__c,
                                             PBI__c,annualBillAfter__c,
                                             annualBillBefore__c,         
                                             Lease_Payment__c,Lease_Payment_Sales_Tax__c,
                                             Year__c  
                                      FROM Cash_Flow_Details__r 
                                      ORDER BY Year__c ASC),      
                                     (SELECT id,Utility_Cost_Per_kWh__c,
                                          Year_1_Old_Bill__c, Year_2_Old_Bill__c,
                                          Year_3_Old_Bill__c,Year_4_Old_Bill__c,
                                          Year_5_Old_Bill__c,Year_6_Old_Bill__c,
                                          Year_7_Old_Bill__c,Year_8_Old_Bill__c,
                                          Year_9_Old_Bill__c,Year_10_Old_Bill__c,
                                          Year_11_Old_Bill__c,Year_12_Old_Bill__c,
                                          Year_13_Old_Bill__c,Year_14_Old_Bill__c,
                                          Year_15_Old_Bill__c,Year_16_Old_Bill__c,
                                          Year_17_Old_Bill__c,Year_18_Old_Bill__c,
                                          Year_19_Old_Bill__c,Year_20_Old_Bill__c,
                                          Year_1_New_Bill__c, Year_2_New_Bill__c, 
                                          Year_3_New_Bill__c, Year_4_New_Bill__c, 
                                          Year_5_New_Bill__c, Year_6_New_Bill__c, 
                                          Year_7_New_Bill__c, Year_8_New_Bill__c, 
                                          Year_9_New_Bill__c, Year_10_New_Bill__c, 
                                          Year_11_New_Bill__c, Year_12_New_Bill__c, 
                                          Year_13_New_Bill__c, Year_14_New_Bill__c, 
                                          Year_15_New_Bill__c, Year_16_New_Bill__c, 
                                          Year_17_New_Bill__c, Year_18_New_Bill__c, 
                                          Year_19_New_Bill__c, Year_20_New_Bill__c                                           
                                     FROM Electric_Bill_Summarys__r 
                                     LIMIT 1)  
                             FROM Quote 
                             WHERE Id =: s1.quote__r.id]; 
            System.debug('#qot=' + qot);
            
            Decimal  SystemPriceX = 0.0;
            Decimal  FedTaxCrdtX =0.0;
            Decimal  IncentiveX =0.0;
            Decimal  NetSysCostX =0.0; //Net System Cost 
            Decimal zeroSalesTax = 0.0;
            
            if(qot != null && qot.Id != null)
            {
                List<Lease_Schedule__c> lstCFD = qot.Lease_Progress__r; //Lease Progress List               
                lstEBS = qot.Electric_Bill_Summarys__r;//Electric Bill Summary List
                List<Cash_Flow_Details__c> lstCFDx = qot.Cash_Flow_Details__r;//Cash Flow Details List
                 if(qot.Partial_Prepayment__c!=null)
                        
                 PartialPrePayAmount = qot.Partial_Prepayment__c ; 
                   if(qot.Is_Locked__c == true && qot.Sales_Tax_Rate__c!=null)
                   {
                        propSTaxRate  =  qot.Sales_Tax_Rate__c;  
                   }
                   else
                   {
                     if(qot.Account__r.Sales_Tax_Rate__c!=null)   
                     propSTaxRate  =  qot.Account__r.Sales_Tax_Rate__c;  
                   }
                   
                   if(qot.QuoteType__c == 'lease' && qot.Account__r.billingstate == 'CA')
                    propSTaxRate = zeroSalesTax;
                
                
                 String AccountId = qot.Account__c ;                 
                
                
                Map<String, Cash_Flow_Details__c> mCFD = new Map<String, Cash_Flow_Details__c>();
                if(!lstCFDx.isEmpty()){
                    for(Cash_Flow_Details__c cfd: lstCFDx)
                        mCFD.put(String.valueOf(Integer.valueOf(cfd.Year__c)), cfd);
                }
            if(qot.System_Cost__c!=null)
            {
                 SystemPriceX  = qot.System_Cost__c;
            }
            else
            {
                SystemPriceX = 0;
            }           
            if (S1.Upfront_Incentives__c != null)
            { 
               IncentiveX = S1.Upfront_Incentives__c;
            }
            else
            {
                IncentiveX = 0;
            }
            if(IncentDetails.size()>0)
            {
                FedTaxCrdtX   = IncentDetails[0].Incentive_amount__c;
            }
            else
            {
                FedTaxCrdtX = 0;
            }
            NetSysCostX   = SystemPriceX  - IncentiveX - FedTaxCrdtX;   
                 
            System.debug('\n#lstCFD=' + lstCFD.size() + '\n#lstEBS=' + lstEBS.size() + '\nlstCFDx=' + lstCFDx.size());       
            Decimal UpfrontLPay  = 0.0; //Upfrong Lease Payment when Full Prepaid Lease is checked
            if(s1.Upfront_Lease_Payment__c!=null)
            {
                UpfrontLPay = s1.Upfront_Lease_Payment__c;
            }
            Decimal  PartialPrePlusST = 0.0;
            Decimal  UpfrontLeasePaymentST = 0.0;  //Sales Tax on UpfrontLeasePayment
            // To calculate - (Partial Prepayment * SalesTax rate)/100
            if(propSTaxRate != null)
            {
                PartialPrePlusST = (PartialPrePayAmount * propSTaxRate)/100;
                UpfrontLeasePaymentST =  (UpfrontLPay * propSTaxRate)/100;
            }  
            
            System.debug('#PartialPrePlusST =' + PartialPrePlusST);                         

            MinimumBillMEB=  [SELECT Id, Month__c,With_PV_System__c, Without_PV_System__c FROM Monthly_Electric_Bill__c WHERE (Quote__c  =: qot.id AND Month__c = 'Minimum Bill')];
              
            System.debug('# MinimumBillMEB=' + MinimumBillMEB);
              
                List<Integer> lstYears = new List<Integer>();
                
                if(!lstEBS.isEmpty() && lstEBS.size()==1 && !lstCFD.isEmpty())
                {
                    for(Lease_Schedule__c cfdY : lstCFD)
                        lstYears.add(Integer.valueOf(cfdY.Years__c));
                        
                    if(!lstYears.isEmpty())
                        lstYears.sort();

                    
                    Decimal oBAll = 0.00;
                    Decimal oBAll1 = 0.00;
                    Decimal nBAll = 0.00;
                    Decimal nBAll1 = 0.00;
                    Decimal tempLSTAXALL = 0.0;
                    Integer tempAddIncAll= 0;
                    Decimal tempNtSavALL = 0.0;
                    Decimal tempCumSAV = 0.0;
                    Integer tempRemVal= 0;                  
            
                    System.debug('#X lstYears.size()=' + lstYears.size());
                    
                    for(Integer i=0; i<lstYears.size(); i++)
                    {
                        for(Lease_Schedule__c cfd : lstCFD)
                        {
                            if(lstYears[i]==(Integer.valueOf(cfd.Years__c)) && qot.id == cfd.quote__c)
                            {
                                 
                                Integer tempoD = 0;  // Math.Round value
                                Decimal tempoD1 = 0.0; //To store the orginal value                                 
                                Integer tempnD = 0;  // Math.Round value
                                Decimal tempnD1 = 0.0; //To store the orginal value
                                Integer tempLSTAX = 0; // Math.Round value
                                Decimal tempLSTAX1 = 0.0;//To store the orginal value
                                Integer tempAddInc = 0;  // Math.Round value
                                Decimal tempAddInc1 = 0.0; //To store the orginal value                         
                                Integer tempNtSAV = 0;
                                Decimal tempNtSAV1 = 0.0;   //To store the orginal value   
                                if(!mCFD.isEmpty() && mCFD.containsKey(cfd.Years__c))
                                {
                                    //changes done by abhishek Replaced PBI__C to AnnualRECValue__c for the below lines
                                    tempRemVal = integer.valueof((mCFD.get(cfd.Years__c).Lease_Termination_Value__c != null) ? mCFD.get(cfd.Years__c).Lease_Termination_Value__c : 0.0);
                                    tempAddInc =   integer.valueof((mCFD.get(cfd.Years__c).AnnualRECValue__c != null) ? mCFD.get(cfd.Years__c).AnnualRECValue__c : 0.0);      
                                    //WITHOUT integer.valueof
                                    tempAddInc1 =   (mCFD.get(cfd.Years__c).AnnualRECValue__c != null) ? mCFD.get(cfd.Years__c).AnnualRECValue__c : 0.0;
                                    tempoD = Math.round((mCFD.get(cfd.Years__c).annualBillBefore__c != null) ? mCFD.get(cfd.Years__c).annualBillBefore__c : 0.0);
                                    tempoD1 = (mCFD.get(cfd.Years__c).annualBillBefore__c != null) ? mCFD.get(cfd.Years__c).annualBillBefore__c : 0.0;
                                    tempnD = Math.round((mCFD.get(cfd.Years__c).annualBillAfter__c != null) ? mCFD.get(cfd.Years__c).annualBillAfter__c : 0.0);
                                    tempnD1 = (mCFD.get(cfd.Years__c).annualBillAfter__c != null) ? mCFD.get(cfd.Years__c).annualBillAfter__c : 0.0;           
                                    if(i==0 && qot.QuoteType__c=='Lease')
                                    {
                                        System.debug('##TTT1##');   
                            System.debug('##TTT1##PartialPrePayAmount=' + PartialPrePayAmount);
                            System.debug('##TTT1##PartialPrePlusST=' + PartialPrePlusST);
                            System.debug('##TTT1##UpfrontLeasePayment=' + UpfrontLPay);
                            System.debug('##TTT1##UpfrontLeasePaymentST=' + UpfrontLeasePaymentST);  
                                        if(mCFD.get(cfd.Years__c) != null && mCFD.get(cfd.Years__c).Lease_Payment__c != null){
                                            tempLSTAX1 += mCFD.get(cfd.Years__c).Lease_Payment__c;
                                        }
                                        if(mCFD.get(cfd.Years__c) != null && mCFD.get(cfd.Years__c).Lease_Payment_Sales_Tax__c != null){
                                            tempLSTAX1 += mCFD.get(cfd.Years__c).Lease_Payment_Sales_Tax__c;
                                        }                                        
                                        if(PartialPrePayAmount != null){ 
                                            tempLSTAX1 += PartialPrePayAmount ;
                                        }
                                        if(PartialPrePlusST != null){ 
                                            tempLSTAX1 += PartialPrePlusST;
                                        }
                                        if(UpfrontLPay != null){ 
                                            tempLSTAX1 += UpfrontLPay ;
                                        }
                                        if(UpfrontLeasePaymentST!= null){ 
                                            tempLSTAX1 += UpfrontLeasePaymentST;
                                        }
                                       
                                    }
                                    else
                                    {
                                      tempLSTAX1 = (mCFD.get(cfd.Years__c).Lease_Payment__c != null) ? (mCFD.get(cfd.Years__c).Lease_Payment__c + mCFD.get(cfd.Years__c).Lease_Payment_Sales_Tax__c) : 0.0;                                   
                                    }                                   
                                }   
                                  oBAll += tempoD1; 
                                  nBAll += tempnD1 ; 
                                  tempLSTAXALL +=  tempLSTAX1; 
                                  tempNtSAV =  Math.round(tempoD1 - tempnD1 -tempLSTAX1 + tempAddInc1);
                                  if(qot.QuoteType__c=='Lease')
                                  tempNtSAV1 =  Math.Round(tempoD1 - tempnD1 -tempLSTAX1 + tempAddInc1);
                                  else
                                  tempNtSAV1 =  tempoD1 - tempnD1 -tempLSTAX1 + tempAddInc1;
                                  System.debug('#tempNtSAV=' +  tempNtSAV);
                                  tempNtSavALL += tempNtSAV1;
                                
                            }
                        }
                    }  
                    if(qot.QuoteType__c=='Lease')
                    {
                        tempNtSavALL1 = tempNtSavALL; 
                    }   
                    else
                    {
                         tempNtSavALL1 = tempNtSavALL - NetSysCostX; 
                    }       
                                     
                }
                                  
    }
/*** END FUNCTION ***/      
          if(MinimumBillMEB[0].Month__c=='Minimum Bill' && MinimumBillMEB[0].With_PV_System__c!=null)
           {
             MinBillx = MinimumBillMEB[0].With_PV_System__c;
             system.debug('MinBillx '+MinBillx);
           } 
           if(lstEBS[0].Year_1_Old_Bill__c!=null)
           {
               Yr1OldBil =lstEBS[0].Year_1_Old_Bill__c; 
               system.debug('Year_1_Old_Bill__c '+lstEBS[0].Year_1_Old_Bill__c);
           }
           if(lstEBS[0].Year_1_New_Bill__c!=null)
           {
               Yr1NewBil = lstEBS[0].Year_1_New_Bill__c; 
               system.debug('Year_1_New_Bill__c'+lstEBS[0].Year_1_New_Bill__c);
           }
           if(Yr1OldBil!=null && MinBillx!=null)
           {
               UtliCstminimumNewBill = Yr1OldBil - MinBillx ;
               system.debug('UtliCstminimumNewBill '+UtliCstminimumNewBill );
           }
          
                  
            if(lstEBS[0].Utility_Cost_Per_kWh__c!=null)
            {
                UtliCst = lstEBS[0].Utility_Cost_Per_kWh__c;
                 system.debug('UtliCst '+UtliCst );
            }  
            if(leaseSch[0].System_Production_Annual_Production__c!=null)
            {
               SysProdYr1 = integer.valueof(leaseSch[0].System_Production_Annual_Production__c);
                system.debug('SysProdYr1'+SysProdYr1);
            }
            if(SysProdYr1 != 0 && Yr1NewBil !=null && MinBillx!=null && UtliCst!=null && UtliCstminimumNewBill !=null)
            {     
              toRound2CPKW = (Yr1NewBil < MinBillx  && MinBillx > 0 ) ? (UtliCstminimumNewBill / SysProdYr1) : (UtliCst / SysProdYr1); 
              system.debug('toRound2CPKW '+toRound2CPKW );
              Leasesch1 =  toRound2CPKW.setScale(2);
              system.debug('Leasesch1 '+Leasesch1);
            } 
            else
            {
                Leasesch1 = 0;
            } 
            
         if(qot.quoteType__c=='Lease' && s1.Upfront_Lease_Payment__c!=null && qot.Partial_Prepayment__c!=null && qot.Account__r.Sales_Tax_Rate__c!=null)
         {
           if(s1.Upfront_Lease_Payment__c!= 0 || qot.Partial_Prepayment__c!=0)
           {
             if(qot.Account__r.billingstate != 'CA')
                    UpPayment1 = s1.Upfront_Lease_Payment__c+qot.Partial_Prepayment__c+qot.Account__r.Sales_Tax_Rate__c;
             else
                    UpPayment1 = s1.Upfront_Lease_Payment__c+qot.Partial_Prepayment__c + zeroSalesTax;          
           }
           else
           {
            UpPayment1 = 0;
           }
       } 
       if(qot.quoteType__c=='cash' && qot.System_Cost__c!=null)
       UpPayment1 = qot.System_Cost__c;
       this.accName = qot.Account__r.Name;             
       s1panel = true;  
    }
    if(ApexPages.currentPage().getParameters().get('ls2') != 'null')
    {
       string ls2 = ApexPages.currentPage().getParameters().get('ls2');    
       String queryString2 = 'SELECT '+ leasefields2  +' FROM System_Production__c '+' WHERE Id =\'' +ls2 + '\' LIMIT 1';  
       if(queryString2!=null) 
       {
           s2 = Database.query(queryString2);
       }
       if(s2.quote__r.System_Model__c!=null)
       {
            String Module = s2.quote__r.System_Model__c;
            List<String> ModuleArray = Module.split('Model', 2);
            subModule2 = ModuleArray[1].substring(0, ModuleArray[1].length() - 1);
            system.debug('Substring'+subModule2);
       }
       if(s2.Monthly_Lease_Payment7_50discount__c!=null)
       {
            leasePayment2 = '$'+ String.valueof(s2.Monthly_Lease_Payment7_50discount__c.SetScale(2));
            //leasePayment2 = '$' + unitPrice.SetScale(2);     
       } 
       else
       {
           leasePayment2 = 'NA';
       }
       if(s2.Monthly_Electric_Bill_Without_PV_year1__c!=null)
       {
            unitPrice = s2.Monthly_Electric_Bill_Without_PV_year1__c;
            eWithoutPV2 = unitPrice.SetScale(2);
       }
       if(s2.Monthly_Electric_Bill_With_PV_year1__c!=null)
       {
            unitPrice = s2.Monthly_Electric_Bill_With_PV_year1__c;
            eWithPV2 = unitPrice.SetScale(2);
       }
       if(s2.Total_Energy__c!=null)
       {
          tEnergy2 = Math.round(s2.Total_Energy__c);
       }
       /*if(eWithoutPV2!=null && eWithPV2!=null && s2.Monthly_Electric_Bill_saving_year1__c!=null)
       {
           Leasesch2 = math.round((eWithoutPV2 - eWithPV2)/s2.Monthly_Electric_Bill_saving_year1__c);
       }*/
       if(eWithoutPV2!=null && eWithPV2!=null && tEnergy2 !=null)
       {
              
              // Leasesch2 = ((eWithoutPV2*12) - (eWithPV2*12))/tEnergy2;
       } 
       Leasesch = [SELECT ID, Years__c, System_Production_Annual_Production__c, X95_of_S_P_A_P__c,X105_of_S_P_A_P__c, Cumulative_Production_kWh__c,Cost_of_Lease_Per_kWh__c  FROM Lease_Schedule__c WHERE quote__r.ID =:s2.quote__r.id Order by Years__c];
       CumulProd = Leasesch.get(Leasesch.size()-1).Cumulative_Production_kWh__c;
       List<Incentive_details__c>  IncentDetails = [SELECT id,Incentive_amount__c FROM Incentive_details__c WHERE Quote__c =:s2.quote__r.id AND incentive_description__c = 'federalTaxCredit' ];
        if(IncentDetails.size()>0 && IncentDetails[0].Incentive_amount__c!=null)
        {
            propFedTaxCrdt   = IncentDetails[0].Incentive_amount__c;
        }
        else
        {
            propFedTaxCrdt = 0;
        }
       if(Leasesch.size()>0 && s2.quote__r.quoteType__C=='Lease')
       {
          
           if(Leasesch[0].Cost_of_Lease_Per_kWh__c!=null)
           {
               unitPrice = Leasesch[0].Cost_of_Lease_Per_kWh__c;
               if(unitPrice!=0.00)
               {
                   sprdAnnual1 = Math.round(unitPrice* 100) / 100.0; // unitPrice.SetScale(2);
               }
               else if (unitPrice == 0.00)
               {
                    sprdAnnual1 = 0;
               }     
           }
           
       }
       
       if(s2.quote__r.System_Cost__c!=null)
       {
          propSysPrice  = s2.quote__r.System_Cost__c;
       }
       else
       {
            propSysPrice = 0;
       }
       if(s2.Upfront_Incentives__c!=null)
       {
           propIncentive = s2.Upfront_Incentives__c; 
       }
       else
       {
         propIncentive = 0;
       }
       if(propSysPrice != null)
       {
         propNetSysCost   = propSysPrice  - propIncentive - propFedTaxCrdt;
       }
       if(s2.quote__r.quoteType__C=='Cash')  
       { 
           if(CumulProd != 0 && CumulProd !=null)
           sprdAnnual1 =  (propNetSysCost  / CumulProd );
           else
           sprdAnnual1 = 0;
       }
      
       Quote qot = [SELECT id,Is_Locked__c,Sales_Tax_Rate__c, name,QuoteType__c,System_Cost__c , Partial_Prepayment__c,Account__r.Name,Account__r.Sales_Tax_Rate__c,Account__r.BillingState,
                                    (SELECT id,
                                            Final_Estimated_Monthly_W_Tax_W_ACH__c,
                                     Years__c, Quote__c 
                                     FROM Lease_Progress__r 
                                     ORDER BY Years__c ASC), 
                                     (SELECT id, AnnualRECValue__c,
                                             Lease_Termination_Value__c,
                                             PBI__c,annualBillAfter__c,
                                             annualBillBefore__c,         
                                             Lease_Payment__c,Lease_Payment_Sales_Tax__c,
                                             Year__c  
                                      FROM Cash_Flow_Details__r 
                                      ORDER BY Year__c ASC),      
                                     (SELECT id,Utility_Cost_Per_kWh__c,
                                          Year_1_Old_Bill__c, Year_2_Old_Bill__c,
                                          Year_3_Old_Bill__c,Year_4_Old_Bill__c,
                                          Year_5_Old_Bill__c,Year_6_Old_Bill__c,
                                          Year_7_Old_Bill__c,Year_8_Old_Bill__c,
                                          Year_9_Old_Bill__c,Year_10_Old_Bill__c,
                                          Year_11_Old_Bill__c,Year_12_Old_Bill__c,
                                          Year_13_Old_Bill__c,Year_14_Old_Bill__c,
                                          Year_15_Old_Bill__c,Year_16_Old_Bill__c,
                                          Year_17_Old_Bill__c,Year_18_Old_Bill__c,
                                          Year_19_Old_Bill__c,Year_20_Old_Bill__c,
                                          Year_1_New_Bill__c, Year_2_New_Bill__c, 
                                          Year_3_New_Bill__c, Year_4_New_Bill__c, 
                                          Year_5_New_Bill__c, Year_6_New_Bill__c, 
                                          Year_7_New_Bill__c, Year_8_New_Bill__c, 
                                          Year_9_New_Bill__c, Year_10_New_Bill__c, 
                                          Year_11_New_Bill__c, Year_12_New_Bill__c, 
                                          Year_13_New_Bill__c, Year_14_New_Bill__c, 
                                          Year_15_New_Bill__c, Year_16_New_Bill__c, 
                                          Year_17_New_Bill__c, Year_18_New_Bill__c, 
                                          Year_19_New_Bill__c, Year_20_New_Bill__c                                           
                                     FROM Electric_Bill_Summarys__r 
                                     LIMIT 1)  
                             FROM Quote 
                             WHERE Id =: s2.quote__r.id]; 
            System.debug('#qot=' + qot);
            Decimal  SystemPriceX = 0.0;
            Decimal  FedTaxCrdtX =0.0;
            Decimal  IncentiveX =0.0;
            Decimal  NetSysCostX =0.0; //Net System Cost 
            if(qot != null && qot.Id != null)
            {
                List<Lease_Schedule__c> lstCFD = qot.Lease_Progress__r; //Lease Progress List               
                lstEBS = qot.Electric_Bill_Summarys__r;//Electric Bill Summary List
                List<Cash_Flow_Details__c> lstCFDx = qot.Cash_Flow_Details__r;//Cash Flow Details List
                 if(qot.Partial_Prepayment__c!=null)              
                 PartialPrePayAmount = qot.Partial_Prepayment__c ; 
                 
               if(qot.Is_Locked__c == true && qot.Sales_Tax_Rate__c!=null)
               {
                    propSTaxRate  =  qot.Sales_Tax_Rate__c;  
               }
               else
               {
                 if(qot.Account__r.Sales_Tax_Rate__c!=null)   
                 propSTaxRate  =  qot.Account__r.Sales_Tax_Rate__c;  
               }
               
                 if(qot.Account__r.billingstate == 'CA' && qot.QuoteType__c == 'lease')
                 propSTaxRate = zeroSalesTax;   
                
                 String AccountId = qot.Account__c ;                 
                
                
                Map<String, Cash_Flow_Details__c> mCFD = new Map<String, Cash_Flow_Details__c>();
                if(!lstCFDx.isEmpty()){
                    for(Cash_Flow_Details__c cfd: lstCFDx)
                        mCFD.put(String.valueOf(Integer.valueOf(cfd.Year__c)), cfd);
                }
                System.debug('#PartialPrePayAmount =' + PartialPrePayAmount);  
                if(qot.System_Cost__c!=null)
                {
                     SystemPriceX  = qot.System_Cost__c;
                }
                else{
                    SystemPriceX = 0;
                }               
                if (S2.Upfront_Incentives__c != null)
                { 
                   IncentiveX = S2.Upfront_Incentives__c;
                }
                else
                {
                    IncentiveX = 0;
                }
                if(IncentDetails.size()>0)
                {
                    FedTaxCrdtX   = IncentDetails[0].Incentive_amount__c;
                }
                else
                {
                    FedTaxCrdtX = 0;
                }               
                NetSysCostX   = SystemPriceX  - IncentiveX - FedTaxCrdtX;  
                
                System.debug('\n#lstCFD=' + lstCFD.size() + '\n#lstEBS=' + lstEBS.size() + '\nlstCFDx=' + lstCFDx.size());       
            Decimal UpfrontLPay  = 0.0; //Upfrong Lease Payment when Full Prepaid Lease is checked
            if(s2.Upfront_Lease_Payment__c!=null)
            {
                UpfrontLPay = s2.Upfront_Lease_Payment__c;
            }
            Decimal  PartialPrePlusST = 0.0;
            Decimal  UpfrontLeasePaymentST = 0.0;  //Sales Tax on UpfrontLeasePayment
            // To calculate - (Partial Prepayment * SalesTax rate)/100
            if(propSTaxRate != null)
            {
                PartialPrePlusST = (PartialPrePayAmount * propSTaxRate)/100;
                UpfrontLeasePaymentST =  (UpfrontLPay * propSTaxRate)/100;
            }  
            
System.debug('#PartialPrePlusST =' + PartialPrePlusST);                         

              MinimumBillMEB=  [SELECT Id, Month__c,With_PV_System__c, Without_PV_System__c FROM Monthly_Electric_Bill__c WHERE (Quote__c  =: qot.id AND Month__c = 'Minimum Bill')];
              
              System.debug('# MinimumBillMEB=' + MinimumBillMEB);
                List<Integer> lstYears = new List<Integer>();
                
                if(!lstEBS.isEmpty() && lstEBS.size()==1 && !lstCFD.isEmpty())
                {
                    for(Lease_Schedule__c cfdY : lstCFD)
                        lstYears.add(Integer.valueOf(cfdY.Years__c));
                        
                    if(!lstYears.isEmpty())
                        lstYears.sort();

                    
                    Decimal oBAll = 0.00;
                    Decimal oBAll1 = 0.00;
                    Decimal nBAll = 0.00;
                    Decimal nBAll1 = 0.00;
                    Decimal tempLSTAXALL = 0.0;
                    Integer tempAddIncAll= 0;
                    Decimal tempNtSavALL = 0.0;
                    Decimal tempCumSAV = 0.0;
                    Integer tempRemVal= 0;                 
            
                    System.debug('#X lstYears.size()=' + lstYears.size());
                    
                    for(Integer i=0; i<lstYears.size(); i++)
                    {
                        for(Lease_Schedule__c cfd : lstCFD)
                        {
                            if(lstYears[i]==(Integer.valueOf(cfd.Years__c)) && qot.id == cfd.quote__c)
                            {
                                 
                                Integer tempoD = 0;  // Math.Round value
                                Decimal tempoD1 = 0.0; //To store the orginal value                                 
                                Integer tempnD = 0;  // Math.Round value
                                Decimal tempnD1 = 0.0; //To store the orginal value
                                Integer tempLSTAX = 0; // Math.Round value
                                Decimal tempLSTAX1 = 0.0;//To store the orginal value
                                Integer tempAddInc = 0;  // Math.Round value
                                Decimal tempAddInc1 = 0.0; //To store the orginal value                         
                                Integer tempNtSAV = 0;
                                Decimal tempNtSAV1 = 0.0;   //To store the orginal value   
                                if(!mCFD.isEmpty() && mCFD.containsKey(cfd.Years__c))
                                {
                                    tempRemVal = integer.valueof((mCFD.get(cfd.Years__c).Lease_Termination_Value__c != null) ? mCFD.get(cfd.Years__c).Lease_Termination_Value__c : 0.0);
                                    tempAddInc =   integer.valueof((mCFD.get(cfd.Years__c).AnnualRECValue__c != null) ? mCFD.get(cfd.Years__c).AnnualRECValue__c : 0.0);      
                                    //WITHOUT integer.valueof
                                    tempAddInc1 =   (mCFD.get(cfd.Years__c).AnnualRECValue__c != null) ? mCFD.get(cfd.Years__c).AnnualRECValue__c : 0.0;
                                    tempoD = Math.round((mCFD.get(cfd.Years__c).annualBillBefore__c != null) ? mCFD.get(cfd.Years__c).annualBillBefore__c : 0.0);
                                    tempoD1 = (mCFD.get(cfd.Years__c).annualBillBefore__c != null) ? mCFD.get(cfd.Years__c).annualBillBefore__c : 0.0;
                                    tempnD = Math.round((mCFD.get(cfd.Years__c).annualBillAfter__c != null) ? mCFD.get(cfd.Years__c).annualBillAfter__c : 0.0);
                                    tempnD1 = (mCFD.get(cfd.Years__c).annualBillAfter__c != null) ? mCFD.get(cfd.Years__c).annualBillAfter__c : 0.0;           
                                    if(i==0 && qot.QuoteType__c=='Lease')
                                    {

                                        if(mCFD.get(cfd.Years__c) != null && mCFD.get(cfd.Years__c).Lease_Payment__c != null){
                                            tempLSTAX1 += mCFD.get(cfd.Years__c).Lease_Payment__c;
                                        }
                                        if(mCFD.get(cfd.Years__c) != null && mCFD.get(cfd.Years__c).Lease_Payment_Sales_Tax__c != null){
                                            tempLSTAX1 += mCFD.get(cfd.Years__c).Lease_Payment_Sales_Tax__c;
                                        }                                        
                                        if(PartialPrePayAmount != null){ 
                                            tempLSTAX1 += PartialPrePayAmount ;
                                        }
                                        if(PartialPrePlusST != null){ 
                                            tempLSTAX1 += PartialPrePlusST;
                                        }
                                        if(UpfrontLPay != null){ 
                                            tempLSTAX1 += UpfrontLPay ;
                                        }
                                        if(UpfrontLeasePaymentST!= null){ 
                                            tempLSTAX1 += UpfrontLeasePaymentST;
                                        }
                                       
                                    }
                                    else
                                    {
                                      tempLSTAX1 = (mCFD.get(cfd.Years__c).Lease_Payment__c != null) ? (mCFD.get(cfd.Years__c).Lease_Payment__c + mCFD.get(cfd.Years__c).Lease_Payment_Sales_Tax__c) : 0.0;                                   
                                    }                                   
                                }   
                                  oBAll += tempoD1; 
                                  nBAll += tempnD1 ; 
                                  tempLSTAXALL +=  tempLSTAX1; 
                                  tempNtSAV =  Math.round(tempoD1 - tempnD1 -tempLSTAX1 + tempAddInc1);
                                  if(qot.QuoteType__c=='Lease')
                                  tempNtSAV1 =  Math.Round(tempoD1 - tempnD1 -tempLSTAX1 + tempAddInc1);
                                  else
                                  tempNtSAV1 =  tempoD1 - tempnD1 -tempLSTAX1 + tempAddInc1; 
                                  System.debug('#tempNtSAV=' +  tempNtSAV);
                                  tempNtSavALL += tempNtSAV1;
                                
                            }
                        }
                    }  
                    if(qot.QuoteType__c=='Lease')
                    {
                        tempNtSavALL2 = tempNtSavALL; 
                    }   
                    else
                    {
                        tempNtSavALL2 = tempNtSavALL - NetSysCostX; 
                    }                       
                                    
                }
                                  
    }
/*** END FUNCTION ***/      
          if(MinimumBillMEB[0].Month__c=='Minimum Bill' && MinimumBillMEB[0].With_PV_System__c!=null)
           {
             MinBillx = MinimumBillMEB[0].With_PV_System__c;
             system.debug('MinBillx '+MinBillx);
           } 
           if(lstEBS[0].Year_1_Old_Bill__c!=null)
           {
               Yr1OldBil =lstEBS[0].Year_1_Old_Bill__c;
               system.debug('Yr1OldBil '+Yr1OldBil);
           }
           if(lstEBS[0].Year_1_New_Bill__c!=null)
           {
               Yr1NewBil = lstEBS[0].Year_1_New_Bill__c; 
               system.debug('Yr1NewBil '+Yr1NewBil);
           }
           if(Yr1OldBil!=null && MinBillx!=null)
           {
               UtliCstminimumNewBill = Yr1OldBil - MinBillx ;
               system.debug('UtliCstminimumNewBill '+UtliCstminimumNewBill);
           }
                  
            if(lstEBS[0].Utility_Cost_Per_kWh__c!=null)
            {
                UtliCst = lstEBS[0].Utility_Cost_Per_kWh__c;
                system.debug('UtliCst '+UtliCst);
            }  
            if(leaseSch[0].System_Production_Annual_Production__c!=null)
            {
               SysProdYr1 = integer.valueof(leaseSch[0].System_Production_Annual_Production__c);
               system.debug('SysProdYr1 '+SysProdYr1);
            }
            if(SysProdYr1 != 0 && Yr1NewBil !=null && MinBillx!=null && UtliCst!=null && UtliCstminimumNewBill !=null)
            {     
              toRound2CPKW = (Yr1NewBil < MinBillx  && MinBillx > 0 ) ? (UtliCstminimumNewBill / SysProdYr1) : (UtliCst / SysProdYr1); 
               system.debug('toRound2CPKW '+toRound2CPKW);
              Leasesch2 =  toRound2CPKW.setScale(2);   
              system.debug('Leasesch2 '+Leasesch2);           
            }
            else
            {
                Leasesch2 = 0;
            } 
         if(s2.Upfront_Lease_Payment__c!=null && qot.Partial_Prepayment__c!=null && qot.Account__r.Sales_Tax_Rate__c!=null)
           {
           if(s2.Upfront_Lease_Payment__c!= 0 || qot.Partial_Prepayment__c!=0)
           {
               if(qot.Account__r.billingstate == 'CA' && qot.QuoteType__c == 'lease')
                    UpPayment2 = s2.Upfront_Lease_Payment__c+qot.Partial_Prepayment__c+zeroSalesTax;
                else
                    UpPayment2 = s2.Upfront_Lease_Payment__c+qot.Partial_Prepayment__c+qot.Account__r.Sales_Tax_Rate__c;
           }
           else
           {
               UpPayment2 = 0;
           }
       } 
       //Added By: Nikki De Guzman - CS
       //Fix for Case 00386902
       if(qot.quoteType__c == 'cash' && qot.System_Cost__c != null)
       UpPayment2 = qot.System_Cost__c;
       //End 
       this.accName = qot.Account__r.Name;
       s2panel  = true;
    }
    if(ApexPages.currentPage().getParameters().get('ls3') != 'null' )
    {
       string ls3 = ApexPages.currentPage().getParameters().get('ls3');
       String queryString3 = 'SELECT '+ leasefields2  +' FROM System_Production__c '+' WHERE Id =\''+ ls3 +'\' LIMIT 1';
       if(queryString3!=null)
       {
            s3 = Database.query(queryString3);   
       }      
       if(s3!=null)
       {
           if(s3.Monthly_Lease_Payment7_50discount__c!=null)
           {
                  leasePayment3 = '$'+ String.valueof(s3.Monthly_Lease_Payment7_50discount__c.SetScale(2));
                     
           }
           else
           {
           leasePayment3 = 'NA';
           }
           if(s3.quote__r.System_Model__c!=null)
           {
            String Module = s3.quote__r.System_Model__c;
            List<String> ModuleArray = Module.split('Model', 2);
            subModule3 = ModuleArray[1].substring(0, ModuleArray[1].length() - 1);
            system.debug('Substring'+subModule3);
           }
           if(s3.Monthly_Electric_Bill_Without_PV_year1__c!=null)
           {
                unitPrice = s3.Monthly_Electric_Bill_Without_PV_year1__c;
                eWithoutPV3 = unitPrice.SetScale(2);
           }
           if(s3.Monthly_Electric_Bill_With_PV_year1__c!=null)
           {
                unitPrice = s3.Monthly_Electric_Bill_With_PV_year1__c;
                eWithPV3 = unitPrice.SetScale(2);
           }
           if(s3.Total_Energy__c!=null)
           {
              tEnergy3 = s3.Total_Energy__c;
           }
       }
      
       
       Leasesch = [SELECT ID, Years__c, System_Production_Annual_Production__c, X95_of_S_P_A_P__c,X105_of_S_P_A_P__c, Cumulative_Production_kWh__c,Cost_of_Lease_Per_kWh__c  FROM Lease_Schedule__c WHERE quote__r.ID =:s3.quote__r.id Order by Years__c];
       CumulProd = Leasesch.get(Leasesch.size()-1).Cumulative_Production_kWh__c;
       List<Incentive_details__c>  IncentDetails = [SELECT id,Incentive_amount__c FROM Incentive_details__c WHERE Quote__c =:s3.quote__r.id AND incentive_description__c = 'federalTaxCredit' ];
        if(IncentDetails.size()>0 && IncentDetails[0].Incentive_amount__c!=null)
        {
            propFedTaxCrdt   = IncentDetails[0].Incentive_amount__c;
        }
        else
        {
            propFedTaxCrdt = 0;
        }
       if(Leasesch.size()>0 && s3.quote__r.quoteType__C=='Lease')
       {
          
           if(Leasesch[0].Cost_of_Lease_Per_kWh__c!=null)
           {
               unitPrice = Leasesch[0].Cost_of_Lease_Per_kWh__c;
               if(unitPrice!=0.00)
               {
                   sprdAnnual2 = Math.round(unitPrice* 100) / 100.0; // unitPrice.SetScale(2);
               }
               else if (unitPrice == 0.00)
               {
                    sprdAnnual2 = 0;
               }     
           }
           
       }
       
       if(s3.quote__r.System_Cost__c!=null)
       {
          propSysPrice  = s3.quote__r.System_Cost__c;
       }
       else
       {
            propSysPrice = 0;
       }
       if(s3.Upfront_Incentives__c!=null)
       {
           propIncentive = s3.Upfront_Incentives__c; 
       }
       else
       {
         propIncentive = 0;
       }
       if(propSysPrice != null)
       {
         propNetSysCost   = propSysPrice  - propIncentive - propFedTaxCrdt;
       }
       if(s3.quote__r.quoteType__C=='Cash')
       {
           if(CumulProd != 0 && CumulProd !=null)
           sprdAnnual2 =  (propNetSysCost  / CumulProd );
           else
           sprdAnnual2 = 0;
       }   
      
  Quote qot = [SELECT id, Is_Locked__c,Sales_Tax_Rate__c,name,QuoteType__c,System_Cost__c, Partial_Prepayment__c,Account__r.Name,Account__r.Sales_Tax_Rate__c,Account__r.BillingState,
                                    (SELECT id,
                                            Final_Estimated_Monthly_W_Tax_W_ACH__c,
                                     Years__c, Quote__c 
                                     FROM Lease_Progress__r 
                                     ORDER BY Years__c ASC), 
                                     (SELECT id, AnnualRECValue__c,
                                             Lease_Termination_Value__c,
                                             PBI__c,annualBillAfter__c,
                                             annualBillBefore__c,         
                                             Lease_Payment__c,Lease_Payment_Sales_Tax__c,
                                             Year__c  
                                      FROM Cash_Flow_Details__r 
                                      ORDER BY Year__c ASC),      
                                     (SELECT id,Utility_Cost_Per_kWh__c,
                                          Year_1_Old_Bill__c, Year_2_Old_Bill__c,
                                          Year_3_Old_Bill__c,Year_4_Old_Bill__c,
                                          Year_5_Old_Bill__c,Year_6_Old_Bill__c,
                                          Year_7_Old_Bill__c,Year_8_Old_Bill__c,
                                          Year_9_Old_Bill__c,Year_10_Old_Bill__c,
                                          Year_11_Old_Bill__c,Year_12_Old_Bill__c,
                                          Year_13_Old_Bill__c,Year_14_Old_Bill__c,
                                          Year_15_Old_Bill__c,Year_16_Old_Bill__c,
                                          Year_17_Old_Bill__c,Year_18_Old_Bill__c,
                                          Year_19_Old_Bill__c,Year_20_Old_Bill__c,
                                          Year_1_New_Bill__c, Year_2_New_Bill__c, 
                                          Year_3_New_Bill__c, Year_4_New_Bill__c, 
                                          Year_5_New_Bill__c, Year_6_New_Bill__c, 
                                          Year_7_New_Bill__c, Year_8_New_Bill__c, 
                                          Year_9_New_Bill__c, Year_10_New_Bill__c, 
                                          Year_11_New_Bill__c, Year_12_New_Bill__c, 
                                          Year_13_New_Bill__c, Year_14_New_Bill__c, 
                                          Year_15_New_Bill__c, Year_16_New_Bill__c, 
                                          Year_17_New_Bill__c, Year_18_New_Bill__c, 
                                          Year_19_New_Bill__c, Year_20_New_Bill__c                                           
                                     FROM Electric_Bill_Summarys__r 
                                     LIMIT 1)  
                             FROM Quote 
                             WHERE Id =: s3.quote__r.id]; 
            System.debug('#qot=' + qot);
            Decimal  SystemPriceX = 0.0;
            Decimal  FedTaxCrdtX =0.0;
            Decimal  IncentiveX =0.0;
            Decimal  NetSysCostX =0.0; //Net System Cost 
            if(qot != null && qot.Id != null)
            {
                List<Lease_Schedule__c> lstCFD = qot.Lease_Progress__r; //Lease Progress List               
                lstEBS = qot.Electric_Bill_Summarys__r;//Electric Bill Summary List
                List<Cash_Flow_Details__c> lstCFDx = qot.Cash_Flow_Details__r;//Cash Flow Details List
                 if(qot.Partial_Prepayment__c!=null)             
                 PartialPrePayAmount = qot.Partial_Prepayment__c ; 
                  if(qot.Is_Locked__c == true && qot.Sales_Tax_Rate__c!=null)
                   {
                        propSTaxRate  =  qot.Sales_Tax_Rate__c;  
                   }
                   else
                   {
                     if(qot.Account__r.Sales_Tax_Rate__c!=null)   
                     propSTaxRate  =  qot.Account__r.Sales_Tax_Rate__c;  
                   }
                 if(qot.QuoteType__c == 'lease' && qot.account__r.billingstate == 'CA')     
                 propSTaxRate = zeroSalesTax; 
                  
                 String AccountId = qot.Account__c ;                 
                
                
                Map<String, Cash_Flow_Details__c> mCFD = new Map<String, Cash_Flow_Details__c>();
                if(!lstCFDx.isEmpty()){
                    for(Cash_Flow_Details__c cfd: lstCFDx)
                        mCFD.put(String.valueOf(Integer.valueOf(cfd.Year__c)), cfd);
                }
                System.debug('#PartialPrePayAmount =' + PartialPrePayAmount);  
                if(qot.System_Cost__c!=null)
                {
                     SystemPriceX  = qot.System_Cost__c;
                }   
                else
                {
                    SystemPriceX = 0;
                }
                if (S3.Upfront_Incentives__c != null)
                { 
                   IncentiveX = S3.Upfront_Incentives__c;
                }
                else
                {
                    IncentiveX = 0;
                }
                if(IncentDetails.size()>0)
                {
                    FedTaxCrdtX   = IncentDetails[0].Incentive_amount__c;
                }
                else
                {
                    FedTaxCrdtX = 0;
                }
                NetSysCostX   = SystemPriceX  - IncentiveX - FedTaxCrdtX;  
                System.debug('\n#lstCFD=' + lstCFD.size() + '\n#lstEBS=' + lstEBS.size() + '\nlstCFDx=' + lstCFDx.size());       
            Decimal UpfrontLPay  = 0.0; //Upfrong Lease Payment when Full Prepaid Lease is checked
            if(s3.Upfront_Lease_Payment__c!=null)
            {
                UpfrontLPay = s3.Upfront_Lease_Payment__c;
            }
            Decimal  PartialPrePlusST = 0.0;
            Decimal  UpfrontLeasePaymentST = 0.0;  //Sales Tax on UpfrontLeasePayment
            // To calculate - (Partial Prepayment * SalesTax rate)/100
            if(propSTaxRate != null)
            {
                PartialPrePlusST = (PartialPrePayAmount * propSTaxRate)/100;
                UpfrontLeasePaymentST =  (UpfrontLPay * propSTaxRate)/100;
            }  
            
System.debug('#PartialPrePlusST =' + PartialPrePlusST);                         

              MinimumBillMEB=  [SELECT Id, Month__c,With_PV_System__c, Without_PV_System__c FROM Monthly_Electric_Bill__c WHERE (Quote__c  =: qot.id AND Month__c = 'Minimum Bill')];
              
              System.debug('# MinimumBillMEB=' + MinimumBillMEB);
            
                List<Integer> lstYears = new List<Integer>();
                
                if(!lstEBS.isEmpty() && lstEBS.size()==1 && !lstCFD.isEmpty())
                {
                    for(Lease_Schedule__c cfdY : lstCFD)
                        lstYears.add(Integer.valueOf(cfdY.Years__c));
                        
                    if(!lstYears.isEmpty())
                        lstYears.sort();

                    
                     
                    Decimal oBAll = 0.00;
                    Decimal oBAll1 = 0.00;
                    Decimal nBAll = 0.00;
                    Decimal nBAll1 = 0.00;
                    Decimal tempLSTAXALL = 0.0;
                    Integer tempAddIncAll= 0;
                    Decimal tempNtSavALL = 0.0;
                    Decimal tempCumSAV = 0.0;
                    Integer tempRemVal= 0;              
            
                    System.debug('#X lstYears.size()=' + lstYears.size());
                    
                 for(Integer i=0; i<lstYears.size(); i++)
                    {
                        for(Lease_Schedule__c cfd : lstCFD)
                        {
                            if(lstYears[i]==(Integer.valueOf(cfd.Years__c)) && qot.id == cfd.quote__c)
                            {
                                 
                                Integer tempoD = 0;  // Math.Round value
                                Decimal tempoD1 = 0.0; //To store the orginal value                                 
                                Integer tempnD = 0;  // Math.Round value
                                Decimal tempnD1 = 0.0; //To store the orginal value
                                Integer tempLSTAX = 0; // Math.Round value
                                Decimal tempLSTAX1 = 0.0;//To store the orginal value
                                Integer tempAddInc = 0;  // Math.Round value
                                Decimal tempAddInc1 = 0.0; //To store the orginal value                         
                                Integer tempNtSAV = 0;
                                Decimal tempNtSAV1 = 0.0;   //To store the orginal value   
                                if(!mCFD.isEmpty() && mCFD.containsKey(cfd.Years__c))
                                {
                                    tempRemVal = integer.valueof((mCFD.get(cfd.Years__c).Lease_Termination_Value__c != null) ? mCFD.get(cfd.Years__c).Lease_Termination_Value__c : 0.0);
                                    tempAddInc =   integer.valueof((mCFD.get(cfd.Years__c).AnnualRECValue__c != null) ? mCFD.get(cfd.Years__c).AnnualRECValue__c : 0.0);      
                                    //WITHOUT integer.valueof
                                    tempAddInc1 =   (mCFD.get(cfd.Years__c).AnnualRECValue__c != null) ? mCFD.get(cfd.Years__c).AnnualRECValue__c : 0.0;
                                    tempoD = Math.round((mCFD.get(cfd.Years__c).annualBillBefore__c != null) ? mCFD.get(cfd.Years__c).annualBillBefore__c : 0.0);
                                    tempoD1 = (mCFD.get(cfd.Years__c).annualBillBefore__c != null) ? mCFD.get(cfd.Years__c).annualBillBefore__c : 0.0;
                                    tempnD = Math.round((mCFD.get(cfd.Years__c).annualBillAfter__c != null) ? mCFD.get(cfd.Years__c).annualBillAfter__c : 0.0);
                                    tempnD1 = (mCFD.get(cfd.Years__c).annualBillAfter__c != null) ? mCFD.get(cfd.Years__c).annualBillAfter__c : 0.0;           
                                    if(i==0 && qot.QuoteType__c=='Lease')
                                    {
                                   
                                        if(mCFD.get(cfd.Years__c) != null && mCFD.get(cfd.Years__c).Lease_Payment__c != null){
                                            tempLSTAX1 += mCFD.get(cfd.Years__c).Lease_Payment__c;
                                        }
                                        if(mCFD.get(cfd.Years__c) != null && mCFD.get(cfd.Years__c).Lease_Payment_Sales_Tax__c != null){
                                            tempLSTAX1 += mCFD.get(cfd.Years__c).Lease_Payment_Sales_Tax__c;
                                        }                                        
                                        if(PartialPrePayAmount != null){ 
                                            tempLSTAX1 += PartialPrePayAmount ;
                                        }
                                        if(PartialPrePlusST != null){ 
                                            tempLSTAX1 += PartialPrePlusST;
                                        }
                                        if(UpfrontLPay != null){ 
                                            tempLSTAX1 += UpfrontLPay ;
                                        }
                                        if(UpfrontLeasePaymentST!= null){ 
                                            tempLSTAX1 += UpfrontLeasePaymentST;
                                        }
                                       
                                    }
                                    else
                                    {
                                      tempLSTAX1 = (mCFD.get(cfd.Years__c).Lease_Payment__c != null) ? (mCFD.get(cfd.Years__c).Lease_Payment__c + mCFD.get(cfd.Years__c).Lease_Payment_Sales_Tax__c) : 0.0;                                   
                                    }                                   
                                }   
                              oBAll += tempoD1; 
                              nBAll += tempnD1 ; 
                              tempLSTAXALL +=  tempLSTAX1; 
                              tempNtSAV =  Math.round(tempoD1 - tempnD1 -tempLSTAX1 + tempAddInc1);
                              if(qot.QuoteType__c=='Lease')
                              tempNtSAV1 =  Math.Round(tempoD1 - tempnD1 -tempLSTAX1 + tempAddInc1);
                              else
                              tempNtSAV1 =  tempoD1 - tempnD1 -tempLSTAX1 + tempAddInc1; 
                              System.debug('#tempNtSAV=' +  tempNtSAV);
                              tempNtSavALL += tempNtSAV1;
                                
                            }
                        }
                    }
                    if(qot.QuoteType__c=='Lease')
                    {
                        tempNtSavALL3 = tempNtSavALL; 
                    }   
                    else
                    {
                        tempNtSavALL3 = tempNtSavALL - NetSysCostX; 
                    }    
                             
                }
                                  
    }
/*** END FUNCTION ***/       
        if(MinimumBillMEB[0].Month__c=='Minimum Bill' && MinimumBillMEB[0].With_PV_System__c!=null)
           {
             MinBillx = MinimumBillMEB[0].With_PV_System__c;
           } 
           if(lstEBS[0].Year_1_Old_Bill__c!=null)
           {
               Yr1OldBil =lstEBS[0].Year_1_Old_Bill__c; 
           }
           if(lstEBS[0].Year_1_New_Bill__c!=null)
           {
               Yr1NewBil = lstEBS[0].Year_1_New_Bill__c; 
           }
           if(Yr1OldBil!=null && MinBillx!=null)
           {
               UtliCstminimumNewBill = Yr1OldBil - MinBillx ;
           }
                  
            if(lstEBS[0].Utility_Cost_Per_kWh__c!=null)
            {
                UtliCst = lstEBS[0].Utility_Cost_Per_kWh__c;
            }  
            if(leaseSch[0].System_Production_Annual_Production__c!=null)
            {
               SysProdYr1 = integer.valueof(leaseSch[0].System_Production_Annual_Production__c);
            }
            if(SysProdYr1 != 0 && Yr1NewBil !=null && MinBillx!=null && UtliCst!=null && UtliCstminimumNewBill !=null)
            {     
              toRound2CPKW = (Yr1NewBil < MinBillx  && MinBillx > 0 ) ? (UtliCstminimumNewBill / SysProdYr1) : (UtliCst / SysProdYr1); 
              Leasesch3 =  toRound2CPKW.setScale(2);      
            }
            else
            {
                Leasesch3 = 0;
            } 
     if(s3.Upfront_Lease_Payment__c!=null && qot.Partial_Prepayment__c!=null && qot.Account__r.Sales_Tax_Rate__c!=null)
       {
           if(s3.Upfront_Lease_Payment__c!= 0 || qot.Partial_Prepayment__c!=0)
           {
                if(qot.Account__r.billingstate == 'CA' && qot.QuoteType__c == 'lease')
                        UpPayment3 = s3.Upfront_Lease_Payment__c+qot.Partial_Prepayment__c+zeroSalesTax;
                else
                        UpPayment3 = s3.Upfront_Lease_Payment__c+qot.Partial_Prepayment__c+qot.Account__r.Sales_Tax_Rate__c;
           }
           else
           {
               UpPayment3 = 0;
           }   
       }    
       
       //Added By: Nikki De Guzman - CS
       //Fix for Case 00386902
       if(qot.quoteType__c == 'cash' && qot.System_Cost__c != null)
       UpPayment3 = qot.System_Cost__c;
       //End 
       this.accName = qot.Account__r.Name;
       s3panel = true; 
    }
        if(s1panel && s2panel && s3panel){
            width1 = '20%';
            width2 = '20%';
            width3 = '20%';
        }
        if(!s1panel && s2panel && s3panel){
            width1 = '0%';
            width2 = '32%';
            width3 = '32%';
        }
        if(s1panel && !s2panel && s3panel){
            width1 = '32%';
            width2 = '0%';
            width3 = '32%';
        }
        if(s1panel && s2panel && !s3panel){
            width1 = '32%';
            width2 = '32%';
            width3 = '0%';
        }     
}

}