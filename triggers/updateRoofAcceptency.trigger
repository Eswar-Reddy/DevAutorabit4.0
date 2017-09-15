trigger updateRoofAcceptency on Roof_Details__c (before Insert , before Update) {
    //List<Roof_Details__c> tempList = new List<Roof_Details__c>();
    For(Roof_Details__c R : Trigger.New){
    
        if( R.Jan__c == 100 && R.Feb__c==100 && R.Mar__c == 100 && R.Apr__c == 100 && R.May__c==100 && R.Jun__c ==100
                && R.Jul__c ==100 && R.Aug__c == 100 && R.Sep__c==100 && R.Oct__c == 100 && R.Nov__c == 100 && R.Dec__c==100){
        
              if( R.Roof1_Accepted__c == false ){
                  R.Roof1_Accepted__c = true;
                  //tempList.add(R);
              }
    
         }
         if( R.Jan__c <> 100 || R.Feb__c<>100 || R.Mar__c <> 100 || R.Apr__c <> 100 || R.May__c<>100 || R.Jun__c <>100
                || R.Jul__c <>100 || R.Aug__c <> 100 || R.Sep__c<>100 || R.Oct__c <> 100 || R.Nov__c <> 100 || R.Dec__c<>100){
        
              if( R.Roof1_Accepted__c == true){
                  R.Roof1_Accepted__c = false;
                  //tempList.add(R);
              }
    
         }

    }
}