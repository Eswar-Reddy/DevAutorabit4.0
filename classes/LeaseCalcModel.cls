global with sharing class LeaseCalcModel 
{
    public final String LEASE_TYPE_MONTHLY = 'Monthly';
    public final String LEASE_TYPE_PREPAID = 'Prepaid';
    public Integer numOfMonths ;
    
    public Lease_Schedule_Summary__c leaseScheduleSummary {get; private set;}
    
    public class LeaseCalcModelException extends Exception {}
    
    public static final Set<String> requiredFields = new Set<String>
    {
        'CSI_Rebate__c', 'Customer_Prepayment__c', 'Lease_FMV__c', 'Y1_MLP__c', 'Y2_MLP__c' , 'Y3_MLP__c',
        'Y4_MLP__c', 'Y5_MLP__c', 'Y6_MLP__c', 'Y7_MLP__c', 'Y8_MLP__c', 'Y9_MLP__c', 'Y10_MLP__c', 'Y11_MLP__c',
        'Y12_MLP__c', 'Y13_MLP__c', 'Y14_MLP__c', 'Y15_MLP__c', 'Y16_MLP__c', 'Y17_MLP__c', 'Y18_MLP__c', 'Y19_MLP__c',
        'Y20_MLP__c', 'Y21_MLP__c','Y22_MLP__c','Y23_MLP__c','Y24_MLP__c','Y25_MLP__c','Calculated_Operation_and_Maintenance_Fee__c', 'Gross_Cash_Payments_Year_1_Month_1__c','Lease_Type__c','Country_Domain__c'
    };
    
    public static final Set<String> otherFields = new Set<String>
    { 
        'NPV__c','Unguaranteed_Residual__c'
    };
    
    public static Set<String> scheduleSummaryFields
    {
        get 
        {   
            if ( scheduleSummaryFields == null )
            {
                scheduleSummaryFields = new Set<String>();
                
                scheduleSummaryFields.addAll( requiredFields );
                
                scheduleSummaryFields.addAll( otherFields );
            }
            
            return scheduleSummaryFields;
        }       
    }
    
    
    public LeaseCalcModel(Lease_Schedule_Summary__c leaseScheduleSummary)
    {
        this.leaseScheduleSummary = leaseScheduleSummary;
    }
    
    //throws an exception if there are any issues
    public void checkRequiredFields( Lease_Schedule_Summary__c leaseScheduleSummary )
    {
        for ( String fieldName : requiredFields ) 
        {
            String stringValue = String.valueOf( leaseScheduleSummary.get( fieldName ) ); 
            if (leaseScheduleSummary.get('Country_Domain__c') <> 'au' && ( 
            !fieldName.equals('Y21_MLP__c') && !fieldName.equals('Y22_MLP__c') && !fieldName.equals('Y23_MLP__c') && !fieldName.equals('Y24_MLP__c') 
            && !fieldName.equals('Y25_MLP__c'))){
            
            if ( stringValue == null || stringValue == '' )
            {
                throw new LeaseCalcModelException( fieldName +', ' + Label.LeaseCalc_Missing_Required_Value );
            }
          }
        }
    }
    
    //this method may throw exceptions which will be caught in the LeaseCalculator  
    public void runCalculations()
    {
        checkRequiredFields( leaseScheduleSummary );
        
        //retreive values for calculations setup
        List<Double> monthlyPayments = buildmonthlypayments();
        
        numOfMonths = (leaseScheduleSummary.get( 'Country_Domain__c') <> 'au' ? 240 : 300);
        
        Double year1Month1Value = Double.valueOf( leaseScheduleSummary.Gross_Cash_Payments_Year_1_Month_1__c );
        
        Double downPayment = Double.valueOf( leaseScheduleSummary.CSI_Rebate__c + leaseScheduleSummary.Customer_Prepayment__c );
        
        Double leaseFmv = Double.valueOf( leaseScheduleSummary.Lease_FMV__c );
        
        Double unguaranteedResidual = Double.valueOf( leaseScheduleSummary.Unguaranteed_Residual__c );
        
        Double OMFee = ( leaseScheduleSummary.Lease_Type__c==LEASE_TYPE_MONTHLY ) ? 0 : (Double) leaseScheduleSummary.get( 'Calculated_Operation_and_Maintenance_Fee__c' ) * numOfMonths ;
        
        //running calculations
        Double calculatedIrr = calculateIrr( monthlyPayments, year1Month1Value, leaseFmv, downPayment, OMFee, unguaranteedResidual );
        
        Double calculatedNpv = calculateNPV( monthlyPayments, year1Month1Value, downPayment, OMFee, calculatedIrr/100 );
        
        Double calculatedNpvUngar = calculateNPVOfUnguaranteedResidual( unguaranteedResidual, calculatedIrr/100 );
        
        
        //assign values to record 

        leaseScheduleSummary.Implicit_Rate__c = calculatedIrr;

        leaseScheduleSummary.NPV_of_MLP__c = calculatedNpv;

        leaseScheduleSummary.NPV_of_UGRV__c = calculatedNpvUngar;
        
        leaseScheduleSummary.Lease_Calculations_Finished__c = true;
        
        leaseScheduleSummary.Error_Message__c = null;
        
    }
    
    public List<Double> buildMonthlyPayments()
    {
        List<Double> monthlyPayments = new List<Double>();
        
        Double constantFee = (Double) leaseScheduleSummary.get( 'Calculated_Operation_and_Maintenance_Fee__c' );
        Integer numOfYears = (leaseScheduleSummary.get( 'Country_Domain__c') <> 'au' ? 20 : 25);
        
        for( Integer i = 1; i <= numOfYears; i++ )
        {
            String fieldName = 'Y'+i+'_MLP__c';
            Double payment = (Double) leaseScheduleSummary.get( fieldName );
            
            for( Integer j = 0; j < 12; j++ )
            {
                
                //we should only have a constant fee if the lease type is monthly
                if(leaseScheduleSummary.Lease_Type__c==LEASE_TYPE_MONTHLY)
                {
                    monthlyPayments.add( payment - constantFee );
                }
                else
                {
                    monthlyPayments.add( payment - 0 );
                }
            } 
        }
        
        return monthlyPayments;
    }
    
    public Double calculateIRR( List<Double> monthlyPayments, Double year1Month1, Double fmv, Double downPayment, Double OMFee, Double unguaranteedResidual )
    {
    
        System.debug(LoggingLevel.error,'monthlyPayments.size() is : ' + monthlyPayments.size());
        System.debug(LoggingLevel.error,'year1Month1 : ' + year1Month1);
        System.debug(LoggingLevel.error,'fmv : ' + fmv);
        System.debug(LoggingLevel.error,'downPayment : ' + downPayment);
        System.debug(LoggingLevel.error,'OMFee : ' + OMFee);
        System.debug(LoggingLevel.error,'unguaranteedResidual : ' + unguaranteedResidual);
        monthlyPayments=monthlyPayments.clone();
        If(leaseScheduleSummary.get( 'Country_Domain__c') <> 'au')
        //partialPrepayment is the year1 month1 amount
            monthlyPayments[0] = year1Month1 + downPayment - fmv - OMFee;
        else
        {
            monthlyPayments.add(0,downPayment - fmv - OMFee);
            monthlyPayments[1] = year1Month1;
        }
        System.debug(LoggingLevel.error,'monthlyPayments[0] is : ' + monthlyPayments[0]);
        System.debug(LoggingLevel.error,'monthlyPayments[1] is : ' + monthlyPayments[1]);
        System.debug(LoggingLevel.error,'monthlyPayments[2] is : ' + monthlyPayments[2]);
        monthlyPayments.add( unguaranteedResidual );
        System.debug(LoggingLevel.error,'monthlyPayments.size is : ' + monthlyPayments.size());
        
        integer MAX_ITER = 220;
        double EXCEL_EPSILON = 0.00000001;
        
        double x = 0.1; 
        integer iter = 0;
        try{
        
        while (iter++ < MAX_ITER) 
        {
            double x1 = 1 + (x/12);
            System.debug(LoggingLevel.error,'x1 is : ' + x1);
            System.debug(LoggingLevel.error,'x is : ' + x);
            System.debug(LoggingLevel.error,'iter is : ' + iter);

            double fx = 0;

            double dfx = 0.0;

            for (integer i = 0; i < monthlyPayments.size(); i++) 
            {
                System.debug(LoggingLevel.error,'monthlyPayments[i] is : ' + monthlyPayments[i]);
                System.debug(LoggingLevel.error,'i is : ' + i);
                System.debug(LoggingLevel.error,'x1 is : ' + x1);
                double v = monthlyPayments[ i ];
//                 System.debug(LoggingLevel.error,'x1_i previous value is : ' + x1_i);
                double x1_i = Math.pow( x1, double.valueOf( i )  );
                System.debug(LoggingLevel.error,'x1_i is : ' + x1_i);

                fx += v / x1_i;
                
                final double x1_i1 = x1_i * x1;
                System.debug(LoggingLevel.error,'x1_i1 is : ' + x1_i1);
                System.debug(LoggingLevel.error,'dfx value before is : ' + dfx);
                dfx += -i * v / x1_i1;
                System.debug(LoggingLevel.error,'dfx is : ' + dfx);
            }
            
            double new_x = x - fx / dfx;
            
            double epsilon = Math.abs( new_x - x );
           System.debug(LoggingLevel.error,'epsilon is : '+ epsilon);
            
            if (epsilon <= EXCEL_EPSILON) 
            {
                if (x == 0.0 && Math.abs( new_x ) <= EXCEL_EPSILON) 
                {
                    return 0.0; 
                }
                else 
                {
                    return new_x*100;
                }
            }
            
            x = new_x;
            System.debug(logginglevel.error,'x = new_x is : ' + x);
        }
        }catch(Exception e)
        {    system.debug('Exception is : ' + e.getMessage());
                x = 0;
             return x;
        }
        
        System.debug(logginglevel.error,'x is : ' + x);
        return x;   
    }
    
    public Double calculateNPV(List<Double> monthlyPayments, Double year1Month1, Double downPayment, Double OMFee, Double rate)
    {
        Double npv=0;
        
        monthlyPayments=monthlyPayments.clone();
        
        If(leaseScheduleSummary.get( 'Country_Domain__c') <> 'au')
        //partialPrepayment is the year1 month1 amount
            monthlyPayments[0] = year1Month1 + downPayment - OMFee;
        else
        {
            monthlyPayments.add(0,downPayment - OMFee);
            monthlyPayments[1] = year1Month1;
        }
        
//        monthlyPayments[0] = year1Month1 + downPayment - OMFee;
        System.debug(LoggingLevel.error,'monthlyPayments[0] : ' +monthlyPayments[0]);
        System.debug(LoggingLevel.error,'year1Month1 : ' +year1Month1);
        System.debug(LoggingLevel.error,'downPayment: ' +downPayment);
        System.debug(LoggingLevel.error,'OMFee: ' +OMFee);
        System.debug(LoggingLevel.error,'rate: ' +rate);
        
        
        for(Integer i = 0;i<monthlyPayments.size();i++)
        {
           System.debug(LoggingLevel.error,'monthlyPayments in calculateNPV : ' + monthlyPayments[i]);
            Double payment = monthlyPayments[i];
            Double monthlyRate= (rate/12);
            Double exp = Double.valueOf(i);
            npv += payment/( Math.pow(  1+monthlyRate , exp ) );
            System.debug(LoggingLevel.error,'npv in calculateNPV : ' + npv );
            System.debug(LoggingLevel.error,'Number of Months in calculateNPV : ' + i);
        
        }
            System.debug(LoggingLevel.error,'Final npv in calculateNPV : ' + npv );        
        return npv;
    }
    
    public Double calculateNPVOfUnguaranteedResidual(Double unguaranteedResidual, Double rate)
    {
        Double npv=0;
        
       if(numOfMonths != null && rate != null)
        npv = unguaranteedResidual/ ( Math.pow(  1+(rate/12) , numOfMonths ) );
        
        System.debug(LoggingLevel.error,'npv in calculateNPVOfUnguaranteedResidual : ' +npv);
        
        return npv;
    }
    
    public static List<LeaseCalcModel> retrieveLeaseCalcModels( List<Id> leaseScheduleSummaryIds )
    {
        List<Id> queryIds = leaseScheduleSummaryIds;
         
        String queryString = 'SELECT ID';
        
        for ( String selectField : scheduleSummaryFields )
        {
            queryString += ' , ' + selectField;
        }
        
        queryString += ' FROM Lease_Schedule_Summary__c WHERE Id IN :queryIds';
        
        List<Lease_Schedule_Summary__c> leaseScheduleSummaries = (List<Lease_Schedule_Summary__c>) Database.query( queryString );
        
        //return overloaded result
        return retrieveLeaseCalcModels( leaseScheduleSummaries );
    }
            
    public static List<LeaseCalcModel> retrieveLeaseCalcModels( List<Lease_Schedule_Summary__c> leaseScheduleSummaries )
    {
        List<LeaseCalcModel> leaseCalcModels = new List<LeaseCalcModel>();
                
        for ( Lease_Schedule_Summary__c summary : leaseScheduleSummaries )
        {
            LeaseCalcModel model = new LeaseCalcModel( summary );
            
            leaseCalcModels.add( model );
        }

        return leaseCalcModels;
    }

}