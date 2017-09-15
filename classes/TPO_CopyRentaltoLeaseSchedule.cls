/*** Class added in Sunpower TPO VP2 -- 10/04/2014, To copy the final Rental Schedule to Lease Schedule ***/
public class TPO_CopyRentaltoLeaseSchedule {/* Code Cleanup 2017 WW21
@future
//public static void copyRentaltoLease(Map<Id, Quote> map_NewQuote, Map<Id, Quote> map_OldQuote){
public static void copyRentaltoLease(Set<id> sQIds){

      List<Id> lstQIds = new List<Id>();
      lstQIds.addAll(sQIds);

       map<integer,decimal> mapintannual = new map<integer,decimal>();
       //String QTID = ApexPages.currentPage().getParameters().get('qID');
       for(Quote q  : [SELECT id,name,Customer_Downpayment_Type__c  FROM Quote WHERE id IN : lstQIds]){
       //for(Quote q : map_NewQuote.values()){
       String QTID = q.ID;
       List<System_Production__c> lstsp = [select Id, Name, annual_Produced__c,Quote__c,PV_AnnualNetEnergy_Year1__c,PV_AnnualNetEnergy_Year2__c,PV_AnnualNetEnergy_Year3__c,PV_AnnualNetEnergy_Year4__c,PV_AnnualNetEnergy_Year5__c,PV_AnnualNetEnergy_Year6__c,PV_AnnualNetEnergy_Year7__c,PV_AnnualNetEnergy_Year8__c,PV_AnnualNetEnergy_Year9__c,PV_AnnualNetEnergy_Year10__c,PV_AnnualNetEnergy_Year11__c,PV_AnnualNetEnergy_Year12__c,PV_AnnualNetEnergy_Year13__c,PV_AnnualNetEnergy_Year14__c,PV_AnnualNetEnergy_Year15__c,PV_AnnualNetEnergy_Year16__c,PV_AnnualNetEnergy_Year17__c,PV_AnnualNetEnergy_Year18__c,PV_AnnualNetEnergy_Year19__c,PV_AnnualNetEnergy_Year20__c from System_Production__c where Quote__c =:QTID order by createddate desc Limit 1 ];
       if(lstsp.size()>0){
         List<decimal> lstannual = new List<decimal>{lstsp[0].PV_AnnualNetEnergy_Year1__c,lstsp[0].PV_AnnualNetEnergy_Year2__c,lstsp[0].PV_AnnualNetEnergy_Year3__c,lstsp[0].PV_AnnualNetEnergy_Year4__c,lstsp[0].PV_AnnualNetEnergy_Year5__c,lstsp[0].PV_AnnualNetEnergy_Year6__c,lstsp[0].PV_AnnualNetEnergy_Year7__c,lstsp[0].PV_AnnualNetEnergy_Year8__c,lstsp[0].PV_AnnualNetEnergy_Year9__c,lstsp[0].PV_AnnualNetEnergy_Year10__c,lstsp[0].PV_AnnualNetEnergy_Year11__c,lstsp[0].PV_AnnualNetEnergy_Year12__c,lstsp[0].PV_AnnualNetEnergy_Year13__c,lstsp[0].PV_AnnualNetEnergy_Year14__c,lstsp[0].PV_AnnualNetEnergy_Year15__c,lstsp[0].PV_AnnualNetEnergy_Year16__c,lstsp[0].PV_AnnualNetEnergy_Year17__c,lstsp[0].PV_AnnualNetEnergy_Year18__c,lstsp[0].PV_AnnualNetEnergy_Year19__c,lstsp[0].PV_AnnualNetEnergy_Year20__c};
         
         for(integer i=0 ; i<lstannual.size(); i++)
          {
            mapintannual.put(i,lstannual[i]);
           }
         }
       String DownPaymentABC = '';
       If(q.Customer_Downpayment_Type__c == '0 Deposit Offer'){
          DownPaymentABC = 'DownPayment1';
       }else If(q.Customer_Downpayment_Type__c == 'With Deposit Offer'){
          DownPaymentABC = 'DownPayment2';
       }
       
       List<Rental_Schedule__c> RentalScheduleRec = [select Id,Name,Quote__c,Quote__r.DownPayment_Type__c,Payments_to_the_customer_1__c,Payments_to_the_customer_2__c,TVs_1__c,TVs_2__c,Year__c  from Rental_Schedule__c where Quote__c =: QTID AND Customer_Downpayment_Type__c =: DownPaymentABC];
               
                if(RentalScheduleRec.size() >0)
                {
                    list<Lease_Schedule__c> LeaseShadileLst = new list<Lease_Schedule__c>();
                    for(Rental_Schedule__c rShedule : RentalScheduleRec)
                    {
                        Lease_Schedule__c  LSchedule = new Lease_Schedule__c();
                        LSchedule.Quote__c = rShedule.Quote__c;
                        LSchedule.Year__c= rShedule.Year__c ;
                        // Hari: Added code to Fill Record_Count__c,Annual_Lease_Payments_Year__c : Request on 3-28-2014 (SFDC Lease payment UI)
                        LSchedule.Record_Count__c= rShedule.Year__c ;
                        LSchedule.Annual_Lease_Payments_Year__c= String.valueOf(rShedule.Year__c) ;
                        //LSchedule.RecordTypeId = LeaseScheduleRTId;

                        LSchedule.Annual_Lease_Payment__c  = rShedule.Payments_to_the_customer_1__c ;
                        LSchedule.Remaining_Lease_Value__c = rShedule.TVs_1__c ;
                        LSchedule.Remaining_Lease_Value2__c = rShedule.TVs_2__c ;                    
                      
                        LeaseShadileLst.add(LSchedule);
                    }
                     
                    if(mapintannual.size()>0)
                    {
                     for(integer i=0 ; i < LeaseShadileLst.size(); i++)
                      {
                      LeaseShadileLst[i].System_Production_Annual_Production__c = integer.valueOf(mapintannual.get(i));
                       }
                    }
                    //Util.setTriggerHasRun();
                    if(LeaseShadileLst.size()>0)
                    {
                        insert LeaseShadileLst;
                    }
                }
       }
   
}*/
}