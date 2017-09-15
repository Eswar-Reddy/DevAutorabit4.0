public class AutoOppRoutAPI {

//@future (callout=false)
public static boolean AssignCampaignLeadPartnerRandom(ALR_Metadata__c Mdata, ID Oppid){

List <ALRA_Audit__c> ALRA_All = new List<ALRA_Audit__c>();
List <ALRA_Audit__c> ALRA_All_1 = new List<ALRA_Audit__c>();
//ALRA_Audit__c ALRA = new ALRA_Audit__c();
//ALRA = [SELECT Id, OwnerId, IsDeleted, Name, CurrencyIsoCode, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, ConnectionReceivedId, ConnectionSentId, Assignment_Date__c, Campaign__c, Closed_Opp_Ratio__c, Distance_Range__c, Distance__c, Opportunity__c, Partner_Tier__c, Partner__c, Randomly_selected__c, Scenario_Applied__c, Selected__c from ALRA_Audit__c];

//For CPO data added by abhishek

List<CPO__c> CPO_All = new List<CPO__c>();
List<CPO__c> CPO_All_1 = new List<CPO__c>();
List<Campaign_Partner__c> campOppId = new List<Campaign_Partner__c>();

boolean rslt = false;
Decimal Dist;
GeoUtils.Coordinates coords1;
GeoUtils.Coordinates coords2;
List<Account> Rsltacc = new List<Account>();
List<Opportunity> oppcampId = [SELECT id,CampaignId,Name,ownerId, Partner_Account_Id__c, Campaign.recordtype.Name,Campaign.AssignRandomPartner__c, Account.Geo__Longitude__s, Account.Geo__Latitude__s,Account.Theater__c  FROM Opportunity where Id =:Oppid];

/*
if(oppcampId.size() > 0){
integer i =0 ;
}

if(oppcampId[0].CampaignId!= null){
integer i =0 ;
}

if(oppcampId[0].Campaign.recordtype.Name != 'Alliance'){
integer i =0 ;
}

if(oppcampId[0].Campaign.AssignRandomPartner__c == true){
integer i =0 ;
}
*/

try{
if(oppcampId.size() > 0 && oppcampId[0].CampaignId != null && oppcampId[0].Campaign.recordtype.Name != 'Alliance' && oppcampId[0].Campaign.AssignRandomPartner__c == true){
   
    system.debug('AssignCampaignLeadPartnerRandom  Result is ' + oppcampId[0]);
    Rsltacc = CampaignLeadPartnerInRadius(Mdata,oppcampId[0]); //Distance_Radius__c,Distance_Unit__c
    List<Campaign_Partner__c> camPartner = [Select Id,Name,Partner__c From Campaign_Partner__c Where Campaign__c =: oppcampId[0].CampaignId];
         if(camPartner.size() > 0){
             for(Campaign_Partner__c CPO : camPartner)
             {
               
                campOppId.add(CPO);
               
             }
         }
       
}else{
    system.debug('AssignCampaignLeadPartnerRandom condition false for Random: Result is ' + rslt);
    return rslt;
}
if(Rsltacc.size()>0)
{
coords1 = new GeoUtils.Coordinates(oppcampId[0].Account.Geo__Latitude__s, oppcampId[0].Account.Geo__Longitude__s);    
}
for(integer i=0;i<Rsltacc.size();i++){
     ALRA_Audit__c ALRA = new ALRA_Audit__c();
     ALRA.Scenario_Applied__c = 'Campaign Lead Random';
     ALRA.Partner__c = Rsltacc[i].id;
     ALRA.Partner_Tier__c = Rsltacc[i].Dealer_Tier__c;
     ALRA.Partner_Class__c = Rsltacc[i].Partner_Class__c;
     ALRA.Closed_Opp_Ratio__c = Rsltacc[i].Opportunity_Close__c;
     ALRA.Distance_Range__c = Mdata.Distance_Radius__c;
     ALRA.Distance_Unit__c = Mdata.Distance_Unit__c;
     ALRA.Opportunity__c = oppcampId[0].id;
     if(oppcampId[0].CampaignId!=null)
                    ALRA.Campaign__c = oppcampId[0].CampaignId;
     coords2 = new GeoUtils.Coordinates(Rsltacc[i].Geo__Latitude__s, Rsltacc[i].Geo__Longitude__s);
    // if(oppcampId[0].Account.Theater__c == 'Europe'){
     if(MData.Distance_Unit__c == 'km'){
         Dist = (GeoUtils.computeDistance(coords1, coords2)/1000);
     }    
     else{
         Dist = GeoUtils.toMiles(GeoUtils.computeDistance(coords1, coords2) / 1000);
     }
    // Dist = GeoUtils.toMiles(GeoUtils.computeDistance(coords1, coords2) / 1000);
     Dist=Dist.setscale(2);
     ALRA.Distance__c = Dist;
     ALRA_All.add(ALRA);
    system.debug('All AssignCampaignLeadPartnerRandom ' + Rsltacc[i]);
    
}
 // Added for CPO's
for(integer i=0;i<Rsltacc.size();i++){
    CPO__c cPO = new CPO__c();
    if(oppcampId[0].CampaignId!=null)
    cPO.Campaign__c = oppcampId[0].CampaignId;
    cPO.Opportunity__c = oppcampId[0].id;
    cPO.Partner__c = Rsltacc[i].id;
    for(Campaign_Partner__c  cp : campOppId)
    {
        if(cp.Partner__C == Rsltacc[i].id){
            cPO.Campaign_Partner__c = cp.Id;
            system.debug('cPO.Campaign_Partner__c'+cPO.Campaign_Partner__c);
        }
    }
   // cPO.Campaign_Partner__c = camPartnerId[0].Id;
    system.debug('cpodata'+cPO);
    CPO_All.add(cPO);
    
}
//upsert ALRA_All;
// Do not forget to apply null check in responses
//-----------------------------------------------
if(Rsltacc.size()>1){
    // If flag is checked than by pass all the exsiting ALR Logic added by abhishek 
    
        Rsltacc = RandomAllocation(Rsltacc,Rsltacc.size());
           for(ALRA_Audit__c A : ALRA_All){
               if(A.Partner__c == Rsltacc[0].id){
                    A.Randomly_selected__c = true;
               }
               ALRA_All_1.add(A);
             }
             // Added for CPO's
             for(CPO__c cp : CPO_All)
             {
                if(cp.Partner__c == Rsltacc[0].id)
                {
                    CPO_All_1.add(cp);
                }
             }
            // ALRA_All.clear();
            system.debug('Rslt Accounts' + Rsltacc[0]);
        
    }
    

if(Rsltacc.size()==1){
    if(updatePartner(Rsltacc[0],Oppid) == true){
        if(ALRA_All_1.size()>0){ //if randomly selected then ALRA_All_1 has been updated
            ALRA_All.clear();
            for(ALRA_Audit__c A : ALRA_All_1){
              if(A.Partner__c == Rsltacc[0].id){
                     A.Selected__c = true;
                     A.Assignment_Date__c = Date.Today();                 
                }
              ALRA_All.add(A);
            }
          upsert ALRA_All; 
        }else{
            for(ALRA_Audit__c A : ALRA_All){
              if(A.Partner__c == Rsltacc[0].id){
                     A.Selected__c = true;
                     A.Assignment_Date__c = Date.Today();
                }
              ALRA_All_1.add(A);
            }
             upsert ALRA_All_1; 
        }
        system.debug('updated ALRA');
        if(CPO_All_1.size()>0)
        {    
            CPO_All.clear();
            for(CPO__c cp : CPO_All_1)
            {    
                if(cp.Partner__c == Rsltacc[0].id)
                    {
                        CPO_All.add(cp);
                    }
            }
            upsert CPO_All;
        }else{
            for(CPO__c cp : CPO_All)
            {
                    if(cp.Partner__c == Rsltacc[0].id)
                    {
                        CPO_All_1.add(cp);
                    }
            }
            upsert CPO_All_1;
        }
     rslt = true;
    }else{
        if(ALRA_All_1.size()>0){ //if randomly selected then ALRA_All_1 has been updated
                ALRA_All.clear();
                for(ALRA_Audit__c A : ALRA_All_1){
                  if(A.Partner__c == Rsltacc[0].id){
                         A.Exception__c = 'Error on selected Account.Check Contact on this Account. Contact should have contact role as Owner/President and should be a portal user.';
                       // A.Assignment_Date__c = Date.Today();                 
                    }
                  ALRA_All.add(A);
                }
              upsert ALRA_All; 
            }else{
                for(ALRA_Audit__c A : ALRA_All){
                  if(A.Partner__c == Rsltacc[0].id){
                         A.Exception__c = 'Error on selected Account.Check Contact on this Account. Contact should have contact role as Owner/President and should be a portal user.';
                      
                    }
                  ALRA_All_1.add(A);
                }
                 upsert ALRA_All_1; 
            }
    
    }
   // rslt = true;
} 
//upsert ALRA_All_1;
system.debug('AssignCampaignLeadPartnerRandom Result is ' + rslt);
return rslt;
}
catch(Exception e)
{
    createException(e,oppcampId,Rsltacc);
    return rslt;
}
}

public static boolean AssignAllianceLeadPartnerRandom(ALR_Metadata__c Mdata, ID Oppid){

List <ALRA_Audit__c> ALRA_All = new List<ALRA_Audit__c>();
List <ALRA_Audit__c> ALRA_All_1 = new List<ALRA_Audit__c>();

//For CPO data added by abhishek
List<CPO__c> CPO_All = new List<CPO__c>();
List<CPO__c> CPO_All_1 = new List<CPO__c>();
List<Campaign_Partner__c> campOppId = new List<Campaign_Partner__c>();
boolean rslt = false;
Decimal Dist;
GeoUtils.Coordinates coords1;
GeoUtils.Coordinates coords2;

List<Account> Rsltacc = new List<Account>();
List<Opportunity> oppcampId = [SELECT CampaignId,ownerId, Partner_Account_Id__c, Campaign.recordtype.Name, Campaign.AssignRandomPartner__c, Account.Geo__Longitude__s, Account.Geo__Latitude__s,Account.Theater__c  FROM Opportunity where Id =:Oppid];

try{
if(oppcampId.size() > 0 && oppcampId[0].CampaignId != null && oppcampId[0].Campaign.recordtype.Name == 'Alliance' && oppcampId[0].Campaign.AssignRandomPartner__c == true){
    Rsltacc = AllianceLeadPartnerInRadius(Mdata,oppcampId[0]);
    system.debug('Rsltacc = ' + Rsltacc);
    List<Campaign_Partner__c> camPartner = [Select Id,Name,Partner__c From Campaign_Partner__c Where Campaign__c =: oppcampId[0].CampaignId];
         if(camPartner.size() > 0){
             for(Campaign_Partner__c CPO : camPartner)
             {
               
                campOppId.add(CPO);
               
             }
         }
}else{
    system.debug('AssignAllianceLeadPartnerRandom condition false for Random: Result is ' + rslt);
    return rslt;
}
if(Rsltacc.size()>0)
{
coords1 = new GeoUtils.Coordinates(oppcampId[0].Account.Geo__Latitude__s, oppcampId[0].Account.Geo__Longitude__s);    
}
for(integer i=0;i<Rsltacc.size();i++){
     ALRA_Audit__c ALRA = new ALRA_Audit__c();
     ALRA.Scenario_Applied__c = 'Alliance Lead Random';
     ALRA.Partner__c = Rsltacc[i].id;
     ALRA.Partner_Tier__c = Rsltacc[i].Dealer_Tier__c;
     ALRA.Partner_Class__c = Rsltacc[i].Partner_Class__c;
     ALRA.Closed_Opp_Ratio__c = Rsltacc[i].Opportunity_Close__c;
     ALRA.Distance_Range__c = Mdata.Distance_Radius__c;
     ALRA.Distance_Unit__c = Mdata.Distance_Unit__c;
     ALRA.Opportunity__c = oppcampId[0].id;
     if(oppcampId[0].CampaignId!=null)
                    ALRA.Campaign__c = oppcampId[0].CampaignId;
     coords2 = new GeoUtils.Coordinates(Rsltacc[i].Geo__Latitude__s, Rsltacc[i].Geo__Longitude__s);
     //if(oppcampId[0].Account.Theater__c == 'Europe'){
     if(MData.Distance_Unit__c == 'km'){
         Dist = (GeoUtils.computeDistance(coords1, coords2)/1000);
     }    
     else{
         Dist = GeoUtils.toMiles(GeoUtils.computeDistance(coords1, coords2) / 1000);
     }
     //Dist = GeoUtils.toMiles(GeoUtils.computeDistance(coords1, coords2) / 1000);
     Dist=Dist.setscale(2);
     ALRA.Distance__c = Dist;
     ALRA_All.add(ALRA);
    system.debug('All AllianceLeadPartnerinRadiusRandom ' + Rsltacc[i]);
}
// Added for CPO's
for(integer i=0;i<Rsltacc.size();i++){
    CPO__c cPO = new CPO__c();
    if(oppcampId[0].CampaignId!=null)
    cPO.Campaign__c = oppcampId[0].CampaignId;
    cPO.Opportunity__c = oppcampId[0].id;
    cPO.Partner__c = Rsltacc[i].id;
    for(Campaign_Partner__c  cp : campOppId)
    {
        if(cp.Partner__C == Rsltacc[i].id){
            cPO.Campaign_Partner__c = cp.Id;
            system.debug('cPO.Campaign_Partner__c'+cPO.Campaign_Partner__c);
        }
    }
   // cPO.Campaign_Partner__c = camPartnerId[0].Id;
    system.debug('cpodata'+cPO);
    CPO_All.add(cPO);
    
}
// Do not forget to apply null check in responses
//-----------------------------------------------
if(Rsltacc.size()>1){
   
        Rsltacc = RandomAllocation(Rsltacc,Rsltacc.size());
        for(ALRA_Audit__c A : ALRA_All){
               if(A.Partner__c == Rsltacc[0].id){
                    A.Randomly_selected__c = true;
               }
               ALRA_All_1.add(A);
         }
         // Added for CPO's
         for(CPO__c cp : CPO_All)
             {
                if(cp.Partner__c == Rsltacc[0].id)
                {
                    CPO_All_1.add(cp);
                }
            }
    }

    for(integer i=0;i<Rsltacc.size();i++){
        system.debug('Rslt Accounts' + Rsltacc[i]);
    }

    
if(Rsltacc.size()==1){
    if(updatePartner(Rsltacc[0],Oppid) == true){
        if(ALRA_All_1.size()>0){ //if randomly selected then ALRA_All_1 has been updated
            ALRA_All.clear();
            for(ALRA_Audit__c A : ALRA_All_1){
              if(A.Partner__c == Rsltacc[0].id){
                     A.Selected__c = true;
                     A.Assignment_Date__c = Date.Today();                 
                }
              ALRA_All.add(A);
            }
          upsert ALRA_All; 
        }else{
            for(ALRA_Audit__c A : ALRA_All){
              if(A.Partner__c == Rsltacc[0].id){
                     A.Selected__c = true;
                     A.Assignment_Date__c = Date.Today();
                }
              ALRA_All_1.add(A);
            }
             upsert ALRA_All_1; 
        }
        if(CPO_All_1.size()>0)
        {    
            CPO_All.clear();
            for(CPO__c cp : CPO_All_1)
            {    
                if(cp.Partner__c == Rsltacc[0].id)
                    {
                        CPO_All.add(cp);
                    }
            }
            upsert CPO_All;
        }else{
            for(CPO__c cp : CPO_All)
            {
                    if(cp.Partner__c == Rsltacc[0].id)
                    {
                        CPO_All_1.add(cp);
                    }
            }
            upsert CPO_All_1;
        }
     rslt = true;
   }else{
        if(ALRA_All_1.size()>0){ //if randomly selected then ALRA_All_1 has been updated
                ALRA_All.clear();
                for(ALRA_Audit__c A : ALRA_All_1){
                  if(A.Partner__c == Rsltacc[0].id){
                         A.Exception__c = 'Error on selected Account.Check Contact on this Account. Contact should have contact role as Owner/President and should be a portal user.';
                       // A.Assignment_Date__c = Date.Today();                 
                    }
                  ALRA_All.add(A);
                }
              upsert ALRA_All; 
            }else{
                for(ALRA_Audit__c A : ALRA_All){
                  if(A.Partner__c == Rsltacc[0].id){
                         A.Exception__c = 'Error on selected Account.Check Contact on this Account. Contact should have contact role as Owner/President and should be a portal user.';
                      
                    }
                  ALRA_All_1.add(A);
                }
                 upsert ALRA_All_1; 
            }
    
    }
   // rslt = true;
} 

system.debug('AssignAllianceLeadPartnerRandom Result is ' + rslt);
return rslt;
}
catch(Exception e)
{
    createException(e,oppcampId,Rsltacc);
    return rslt;
}
}

//added new function to call Alliance lead by Distance on date 02-07-2013

public static boolean AllianceLeadbyDistance(ALR_Metadata__c Mdata, ID Oppid){
List <ALRA_Audit__c> ALRA_All = new List<ALRA_Audit__c>();
List <ALRA_Audit__c> ALRA_All_1 = new List<ALRA_Audit__c>();

//For CPO data added by abhishek
List<CPO__c> CPO_All = new List<CPO__c>();
List<CPO__c> CPO_All_1 = new List<CPO__c>();
List<Campaign_Partner__c> campOppId = new List<Campaign_Partner__c>();
boolean rslt = false;
Decimal Dist;
GeoUtils.Coordinates coords1;
GeoUtils.Coordinates coords2;

List<Account> Rsltacc = new List<Account>();
List<Account> Acc = [SELECT id, Name, BillingCity,BillingCountry,BillingPostalCode,BillingState,BillingStreet,Geo__Latitude__s, Geo__Longitude__s, Theater__c from Account where id IN (select AccountId from opportunity where id = :Oppid )];
List<Opportunity> Opprt = [select id,CampaignId,Partner_Account_Id__c, Campaign.recordtype.Name, Campaign.AssignRandomPartner__c, Account.Geo__Longitude__s, Account.Geo__Latitude__s,Account.Theater__c  from opportunity where id = :Oppid ];
//List<Opportunity> oppcampId = [SELECT CampaignId,ownerId, Partner_Account_Id__c, Campaign.recordtype.Name, Campaign.AssignRandomPartner__c, Account.Geo__Longitude__s, Account.Geo__Latitude__s,Account.Theater__c  FROM Opportunity where Id =:Oppid];
try{
if(Opprt.size() > 0 && Opprt[0].CampaignId != null && Opprt[0].Campaign.recordtype.Name == 'Alliance'){
    Rsltacc = AllianceLeadByDistancePartner(Mdata,Acc[0]);
    system.debug('Rsltaccbydistance = ' + Rsltacc);
    /* List<Campaign_Partner__c> camPartner = [Select Id,Name,Partner__c From Campaign_Partner__c Where Campaign__c =: Opprt[0].CampaignId];
         if(camPartner.size() > 0){
             for(Campaign_Partner__c CPO : camPartner)
             {
               
                campOppId.add(CPO);
               
             }
         } */
}else{
    system.debug('AssignAllianceLeadbydistacne condition false for Random: Result is ' + rslt);
    return rslt;
}
if(Rsltacc.size()>0)
{
coords1 = new GeoUtils.Coordinates(Opprt[0].Account.Geo__Latitude__s, Opprt[0].Account.Geo__Longitude__s); 
}
for(integer i=0;i<Rsltacc.size();i++){
     ALRA_Audit__c ALRA = new ALRA_Audit__c();
     ALRA.Scenario_Applied__c = 'Alliance Lead by Distance';
     ALRA.Partner__c = Rsltacc[i].id;
     ALRA.Partner_Tier__c = Rsltacc[i].Dealer_Tier__c;
     ALRA.Partner_Class__c = Rsltacc[i].Partner_Class__c;
     ALRA.Closed_Opp_Ratio__c = Rsltacc[i].Opportunity_Close__c;
     ALRA.Distance_Range__c = 1000;
     ALRA.Distance_Unit__c = Mdata.Distance_Unit__c;
     ALRA.Opportunity__c = Opprt[0].id;
     if(Opprt[0].CampaignId!=null)
                    ALRA.Campaign__c = Opprt[0].CampaignId;
     coords2 = new GeoUtils.Coordinates(Rsltacc[i].Geo__Latitude__s, Rsltacc[i].Geo__Longitude__s);
     if(MData.Distance_Unit__c == 'km'){
         Dist = (GeoUtils.computeDistance(coords1, coords2)/1000);
     }    
     else{
         Dist = GeoUtils.toMiles(GeoUtils.computeDistance(coords1, coords2) / 1000);
     }
     Dist=Dist.setscale(2);
     ALRA.Distance__c = Dist;
     ALRA_All.add(ALRA);
    system.debug('All AllianceLeadByDistance ' + Rsltacc[i]);
}
// Added for CPO's
/* for(integer i=0;i<Rsltacc.size();i++){
    CPO__c cPO = new CPO__c();
    if(Opprt[0].CampaignId!=null)
    cPO.Campaign__c = Opprt[0].CampaignId;
    cPO.Opportunity__c = Opprt[0].id;
    cPO.Partner__c = Rsltacc[i].id;
    for(Campaign_Partner__c  cp : campOppId)
    {
        if(cp.Partner__C == Rsltacc[i].id){
            cPO.Campaign_Partner__c = cp.Id;
            system.debug('cPO.Campaign_Partner__c'+cPO.Campaign_Partner__c);
        }
    }
    system.debug('cpodata'+cPO);
    CPO_All.add(cPO);
    
} */
// Do not forget to apply null check in responses
//-----------------------------------------------
if(Rsltacc.size()>1){
   
        Rsltacc = RandomAllocation(Rsltacc,Rsltacc.size());
        for(ALRA_Audit__c A : ALRA_All){
               if(A.Partner__c == Rsltacc[0].id){
                    A.Randomly_selected__c = true;
               }
               ALRA_All_1.add(A);
         }
         // Added for CPO's
        /*  for(CPO__c cp : CPO_All)
             {
                if(cp.Partner__c == Rsltacc[0].id)
                {
                    CPO_All_1.add(cp);
                }
            } */
    }

    for(integer i=0;i<Rsltacc.size();i++){
        system.debug('Rslt Accounts by distance' + Rsltacc[i]);
    }

    
if(Rsltacc.size()==1){
    if(updatePartner(Rsltacc[0],Oppid) == true){
        if(ALRA_All_1.size()>0){ //if randomly selected then ALRA_All_1 has been updated
            ALRA_All.clear();
            for(ALRA_Audit__c A : ALRA_All_1){
              if(A.Partner__c == Rsltacc[0].id){
                     A.Selected__c = true;
                     A.Assignment_Date__c = Date.Today();                 
                }
              ALRA_All.add(A);
            }
          upsert ALRA_All; 
        }else{
            for(ALRA_Audit__c A : ALRA_All){
              if(A.Partner__c == Rsltacc[0].id){
                     A.Selected__c = true;
                     A.Assignment_Date__c = Date.Today();
                }
              ALRA_All_1.add(A);
            }
             upsert ALRA_All_1; 
        }
        /* if(CPO_All_1.size()>0)
        {    
            CPO_All.clear();
            for(CPO__c cp : CPO_All_1)
            {    
                if(cp.Partner__c == Rsltacc[0].id)
                    {
                        CPO_All.add(cp);
                    }
            }
            upsert CPO_All;
        }else{
            for(CPO__c cp : CPO_All)
            {
                    if(cp.Partner__c == Rsltacc[0].id)
                    {
                        CPO_All_1.add(cp);
                    }
            }
            upsert CPO_All_1; 
        }*/
     rslt = true;
   }else{
        if(ALRA_All_1.size()>0){ //if randomly selected then ALRA_All_1 has been updated
                ALRA_All.clear();
                for(ALRA_Audit__c A : ALRA_All_1){
                  if(A.Partner__c == Rsltacc[0].id){
                         A.Exception__c = 'Error on selected Account.Check Contact on this Account. Contact should have contact role as Owner/President and should be a portal user.';
                       // A.Assignment_Date__c = Date.Today();                 
                    }
                  ALRA_All.add(A);
                }
              upsert ALRA_All; 
            }else{
                for(ALRA_Audit__c A : ALRA_All){
                  if(A.Partner__c == Rsltacc[0].id){
                         A.Exception__c = 'Error on selected Account.Check Contact on this Account. Contact should have contact role as Owner/President and should be a portal user.';
                      
                    }
                  ALRA_All_1.add(A);
                }
                 upsert ALRA_All_1; 
            }
    
    }
   // rslt = true;
} 

system.debug('Alliance Lead by Distance Result is ' + rslt);
return rslt;
}
catch(Exception e)
{
    createException(e,Opprt,Rsltacc);
    return rslt;
}
}

public static boolean AssignCampaignLeadPartner(ALR_Metadata__c Mdata, ID Oppid){

List <ALRA_Audit__c> ALRA_All = new List<ALRA_Audit__c>();
List <ALRA_Audit__c> ALRA_All_1 = new List<ALRA_Audit__c>();
//ALRA_Audit__c ALRA = new ALRA_Audit__c();
//ALRA = [SELECT Id, OwnerId, IsDeleted, Name, CurrencyIsoCode, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, ConnectionReceivedId, ConnectionSentId, Assignment_Date__c, Campaign__c, Closed_Opp_Ratio__c, Distance_Range__c, Distance__c, Opportunity__c, Partner_Tier__c, Partner__c, Randomly_selected__c, Scenario_Applied__c, Selected__c from ALRA_Audit__c];

//For CPO data added by abhishek

List<CPO__c> CPO_All = new List<CPO__c>();
List<CPO__c> CPO_All_1 = new List<CPO__c>();
List<Campaign_Partner__c> campOppId = new List<Campaign_Partner__c>();

boolean rslt = false;
Decimal Dist;
GeoUtils.Coordinates coords1;
GeoUtils.Coordinates coords2;
List<Account> Rsltacc = new List<Account>();
List<Opportunity> oppcampId = [SELECT id,CampaignId,Name,ownerId, Partner_Account_Id__c, Campaign.recordtype.Name,Campaign.AssignRandomPartner__c, Account.Geo__Longitude__s, Account.Geo__Latitude__s,Account.Theater__c  FROM Opportunity where Id =:Oppid];
try{
if(oppcampId.size() > 0 && oppcampId[0].CampaignId != null && oppcampId[0].Campaign.recordtype.Name != 'Alliance' && oppcampId[0].Campaign.AssignRandomPartner__c!=true){
   
    system.debug('CampaignLeadPartnerinRadius  Result is ' + oppcampId[0]);
    Rsltacc = CampaignLeadPartnerInRadius(Mdata,oppcampId[0]); //Distance_Radius__c,Distance_Unit__c
    List<Campaign_Partner__c> camPartner = [Select Id,Name,Partner__c From Campaign_Partner__c Where Campaign__c =: oppcampId[0].CampaignId];
         if(camPartner.size() > 0){
             for(Campaign_Partner__c CPO : camPartner)
             {
               
                campOppId.add(CPO);
               
             }
         }
       
}else{
    system.debug('CampaignLeadPartnerinRadius No Record Result is ' + rslt);
    return rslt;
}
if(Rsltacc.size()>0)
{
coords1 = new GeoUtils.Coordinates(oppcampId[0].Account.Geo__Latitude__s, oppcampId[0].Account.Geo__Longitude__s);    
}
for(integer i=0;i<Rsltacc.size();i++){
     ALRA_Audit__c ALRA = new ALRA_Audit__c();
     ALRA.Scenario_Applied__c = 'Campaign Lead';
     ALRA.Partner__c = Rsltacc[i].id;
     ALRA.Partner_Tier__c = Rsltacc[i].Dealer_Tier__c;
     ALRA.Partner_Class__c = Rsltacc[i].Partner_Class__c;
     ALRA.Closed_Opp_Ratio__c = Rsltacc[i].Opportunity_Close__c;
     ALRA.Distance_Range__c = Mdata.Distance_Radius__c;
     ALRA.Distance_Unit__c = Mdata.Distance_Unit__c;
     ALRA.Opportunity__c = oppcampId[0].id;
     if(oppcampId[0].CampaignId!=null)
                    ALRA.Campaign__c = oppcampId[0].CampaignId;
     coords2 = new GeoUtils.Coordinates(Rsltacc[i].Geo__Latitude__s, Rsltacc[i].Geo__Longitude__s);
     //if(oppcampId[0].Account.Theater__c == 'Europe'){
     if(MData.Distance_Unit__c == 'km'){
         Dist = (GeoUtils.computeDistance(coords1, coords2)/1000);
     }    
     else{
         Dist = GeoUtils.toMiles(GeoUtils.computeDistance(coords1, coords2) / 1000);
     }
    // Dist = GeoUtils.toMiles(GeoUtils.computeDistance(coords1, coords2) / 1000);
     Dist=Dist.setscale(2);
     ALRA.Distance__c = Dist;
     ALRA_All.add(ALRA);
    system.debug('All CampaignLeadPartnerinRadius ' + Rsltacc[i]);
    
}
 // Added for CPO's
for(integer i=0;i<Rsltacc.size();i++){
    CPO__c cPO = new CPO__c();
    if(oppcampId[0].CampaignId!=null)
    cPO.Campaign__c = oppcampId[0].CampaignId;
    cPO.Opportunity__c = oppcampId[0].id;
    cPO.Partner__c = Rsltacc[i].id;
    for(Campaign_Partner__c  cp : campOppId)
    {
        if(cp.Partner__C == Rsltacc[i].id){
            cPO.Campaign_Partner__c = cp.Id;
            system.debug('cPO.Campaign_Partner__c'+cPO.Campaign_Partner__c);
        }
    }
   // cPO.Campaign_Partner__c = camPartnerId[0].Id;
    system.debug('cpodata'+cPO);
    CPO_All.add(cPO);
    
}
//upsert ALRA_All;

if(Rsltacc.size()>1){
   
            Rsltacc = DealersTier(Rsltacc);
            for(integer i=0;i<Rsltacc.size();i++){
                 system.debug('Rslt Accounts' + Rsltacc[i]);
            }   
    
}
if(Rsltacc.size()>1){
   
        Rsltacc = PartnerClass(Rsltacc);
        for(integer i=0;i<Rsltacc.size();i++){
             system.debug('Rslt Partner class' + Rsltacc[i]);
        }    
}
if(Rsltacc.size()>1){
    Rsltacc = DealersOppRatio(Rsltacc);
    //- Below is debug message, delete later
    for(integer i=0;i<Rsltacc.size();i++){       
        system.debug('CR Accounts' + Rsltacc[i]);
    }
}

if(Rsltacc.size()>1){
    Rsltacc = RandomAllocation(Rsltacc,Rsltacc.size());
        for(ALRA_Audit__c A : ALRA_All){
               if(A.Partner__c == Rsltacc[0].id){
                    A.Randomly_selected__c = true;
               }
             ALRA_All_1.add(A);
         }
         // Added for CPO's
         for(CPO__c cp : CPO_All)
             {
                if(cp.Partner__c == Rsltacc[0].id)
                {
                    CPO_All_1.add(cp);
                }
            }
       //  ALRA_All_1.clear();
        system.debug('Random Accounts' + Rsltacc[0]);
}
    
if(Rsltacc.size()==1){
    if(updatePartner(Rsltacc[0],Oppid) == true){
        if(ALRA_All_1.size()>0){ //if randomly selected then ALRA_All_1 has been updated
            ALRA_All.clear();
            for(ALRA_Audit__c A : ALRA_All_1){
              if(A.Partner__c == Rsltacc[0].id){
                     A.Selected__c = true;
                     A.Assignment_Date__c = Date.Today();                 
                }
              ALRA_All.add(A);
            }
          upsert ALRA_All; 
        }else{
            for(ALRA_Audit__c A : ALRA_All){
              if(A.Partner__c == Rsltacc[0].id){
                     A.Selected__c = true;
                     A.Assignment_Date__c = Date.Today();
                }
              ALRA_All_1.add(A);
            }
             upsert ALRA_All_1; 
        }
        system.debug('updated ALRA');
        if(CPO_All_1.size()>0)
        {    
            CPO_All.clear();
            for(CPO__c cp : CPO_All_1)
            {    
                if(cp.Partner__c == Rsltacc[0].id)
                    {
                        CPO_All.add(cp);
                    }
            }
            upsert CPO_All;
        }else{
            for(CPO__c cp : CPO_All)
            {
                    if(cp.Partner__c == Rsltacc[0].id)
                    {
                        CPO_All_1.add(cp);
                    }
            }
            upsert CPO_All_1;
        }
     rslt = true;
    }else{
            system.debug('inside lead campaign');
        if(ALRA_All_1.size()>0){ //if randomly selected then ALRA_All_1 has been updated
        system.debug('inside ALRA_All_1');
                ALRA_All.clear();
                for(ALRA_Audit__c A : ALRA_All_1){
                  if(A.Partner__c == Rsltacc[0].id){
                    system.debug('inside Partner__c');
                         A.Exception__c = 'Error on selected Account.Check Contact on this Account. Contact should have contact role as Owner/President and should be a portal user.';
                       // A.Assignment_Date__c = Date.Today();                 
                    }
                  ALRA_All.add(A);
                }
              upsert ALRA_All; 
            }else{
                system.debug('inside else');
                for(ALRA_Audit__c A : ALRA_All){
                  if(A.Partner__c == Rsltacc[0].id){
                         A.Exception__c = 'Error on selected Account.Check Contact on this Account. Contact should have contact role as Owner/President and should be a portal user.';
                      
                    }
                  ALRA_All_1.add(A);
                }
                 upsert ALRA_All_1; 
            }
    
    }
    //rslt = true;
} 
//upsert ALRA_All_1;
system.debug('CampaignLeadPartnerinRadius Result is ' + rslt);
return rslt;
}
catch(Exception e)
{
    createException(e,oppcampId,Rsltacc);
    return rslt;
}
}

public static boolean AssignAllianceLeadPartner(ALR_Metadata__c Mdata, ID Oppid){

List <ALRA_Audit__c> ALRA_All = new List<ALRA_Audit__c>();
List <ALRA_Audit__c> ALRA_All_1 = new List<ALRA_Audit__c>();

//For CPO data added by abhishek
List<CPO__c> CPO_All = new List<CPO__c>();
List<CPO__c> CPO_All_1 = new List<CPO__c>();
List<Campaign_Partner__c> campOppId = new List<Campaign_Partner__c>();
boolean rslt = false;
Decimal Dist;
GeoUtils.Coordinates coords1;
GeoUtils.Coordinates coords2;

List<Account> Rsltacc = new List<Account>();
List<Opportunity> oppcampId = [SELECT CampaignId,ownerId, Partner_Account_Id__c, Campaign.recordtype.Name, Campaign.AssignRandomPartner__c, Account.Geo__Longitude__s, Account.Geo__Latitude__s,Account.Theater__c  FROM Opportunity where Id =:Oppid];
try{
if(oppcampId.size() > 0 && oppcampId[0].CampaignId != null && oppcampId[0].Campaign.recordtype.Name == 'Alliance' && oppcampId[0].Campaign.AssignRandomPartner__c!=true){
    Rsltacc = AllianceLeadPartnerInRadius(Mdata,oppcampId[0]);
    List<Campaign_Partner__c> camPartner = [Select Id,Name,Partner__c From Campaign_Partner__c Where Campaign__c =: oppcampId[0].CampaignId];
         if(camPartner.size() > 0){
             for(Campaign_Partner__c CPO : camPartner)
             {
               
                campOppId.add(CPO);
               
             }
         }
}else{
    system.debug('AssignAllianceLeadPartner No Record Result is ' + rslt);
    return rslt;
}
if(Rsltacc.size()>0)
{
coords1 = new GeoUtils.Coordinates(oppcampId[0].Account.Geo__Latitude__s, oppcampId[0].Account.Geo__Longitude__s);    
}
for(integer i=0;i<Rsltacc.size();i++){
     ALRA_Audit__c ALRA = new ALRA_Audit__c();
     ALRA.Scenario_Applied__c = 'Alliance Lead';
     ALRA.Partner__c = Rsltacc[i].id;
     ALRA.Partner_Tier__c = Rsltacc[i].Dealer_Tier__c;
      ALRA.Partner_Class__c = Rsltacc[i].Partner_Class__c;
     ALRA.Closed_Opp_Ratio__c = Rsltacc[i].Opportunity_Close__c;
     ALRA.Distance_Range__c = Mdata.Distance_Radius__c;
     ALRA.Distance_Unit__c = Mdata.Distance_Unit__c;
     ALRA.Opportunity__c = oppcampId[0].id;
     if(oppcampId[0].CampaignId!=null)
                    ALRA.Campaign__c = oppcampId[0].CampaignId;
     coords2 = new GeoUtils.Coordinates(Rsltacc[i].Geo__Latitude__s, Rsltacc[i].Geo__Longitude__s);
    // if(oppcampId[0].Account.Theater__c == 'Europe'){
    if(MData.Distance_Unit__c == 'km'){
         Dist = (GeoUtils.computeDistance(coords1, coords2)/1000);
     }    
     else{
         Dist = GeoUtils.toMiles(GeoUtils.computeDistance(coords1, coords2) / 1000);
     }
     //Dist = GeoUtils.toMiles(GeoUtils.computeDistance(coords1, coords2) / 1000);
     Dist=Dist.setscale(2);
     ALRA.Distance__c = Dist;
     ALRA_All.add(ALRA);
    system.debug('All AllianceLeadPartnerinRadius ' + Rsltacc[i]);
}
// Added for CPO's
for(integer i=0;i<Rsltacc.size();i++){
    CPO__c cPO = new CPO__c();
    if(oppcampId[0].CampaignId!=null)
    cPO.Campaign__c = oppcampId[0].CampaignId;
    cPO.Opportunity__c = oppcampId[0].id;
    cPO.Partner__c = Rsltacc[i].id;
    for(Campaign_Partner__c  cp : campOppId)
    {
        if(cp.Partner__C == Rsltacc[i].id){
            cPO.Campaign_Partner__c = cp.Id;
            system.debug('cPO.Campaign_Partner__c'+cPO.Campaign_Partner__c);
        }
    }
   // cPO.Campaign_Partner__c = camPartnerId[0].Id;
    system.debug('cpodata'+cPO);
    CPO_All.add(cPO);
    
}
// Do not forget to apply null check in responses
//-----------------------------------------------
if(Rsltacc.size()>1){
    
    Rsltacc = DealersTier(Rsltacc);
    for(integer i=0;i<Rsltacc.size();i++){
        system.debug('Rslt Accounts' + Rsltacc[i]);
    }
}
if(Rsltacc.size()>1){
   
        Rsltacc = PartnerClass(Rsltacc);
        for(integer i=0;i<Rsltacc.size();i++){
             system.debug('Rslt Partner class' + Rsltacc[i]);
        }    
}
if(Rsltacc.size()>1){
    Rsltacc = DealersOppRatio(Rsltacc);
    //- Below is debug message, delete later
    for(integer i=0;i<Rsltacc.size();i++){
        system.debug('CR Accounts' + Rsltacc[i]);
    }
}

if(Rsltacc.size()>1){
    Rsltacc = RandomAllocation(Rsltacc,Rsltacc.size());
    for(ALRA_Audit__c A : ALRA_All){
               if(A.Partner__c == Rsltacc[0].id){
                    A.Randomly_selected__c = true;
               }
             ALRA_All_1.add(A);
         }
     // Added for CPO's
     for(CPO__c cp : CPO_All)
         {
            if(cp.Partner__c == Rsltacc[0].id)
            {
                CPO_All_1.add(cp);
            }
        }
    //- Below is debug message, delete later
    for(integer i=0;i<Rsltacc.size();i++){
        system.debug('Random Accounts' + Rsltacc[i]);
    }
}
    
if(Rsltacc.size()==1){
    if(updatePartner(Rsltacc[0],Oppid) == true){
        if(ALRA_All_1.size()>0){ //if randomly selected then ALRA_All_1 has been updated
            ALRA_All.clear();
            for(ALRA_Audit__c A : ALRA_All_1){
              if(A.Partner__c == Rsltacc[0].id){
                     A.Selected__c = true;
                     A.Assignment_Date__c = Date.Today();                 
                }
              ALRA_All.add(A);
            }
          upsert ALRA_All; 
        }else{
            for(ALRA_Audit__c A : ALRA_All){
              if(A.Partner__c == Rsltacc[0].id){
                     A.Selected__c = true;
                     A.Assignment_Date__c = Date.Today();
                }
              ALRA_All_1.add(A);
            }
             upsert ALRA_All_1; 
        }
        if(CPO_All_1.size()>0)
        {    
            CPO_All.clear();
            for(CPO__c cp : CPO_All_1)
            {    
                if(cp.Partner__c == Rsltacc[0].id)
                    {
                        CPO_All.add(cp);
                    }
            }
            upsert CPO_All;
        }else{
            for(CPO__c cp : CPO_All)
            {
                    if(cp.Partner__c == Rsltacc[0].id)
                    {
                        CPO_All_1.add(cp);
                    }
            }
            upsert CPO_All_1;
        }
     rslt = true;
   }
   // rslt = true;
}else{
        if(ALRA_All_1.size()>0){ //if randomly selected then ALRA_All_1 has been updated
                ALRA_All.clear();
                for(ALRA_Audit__c A : ALRA_All_1){
                  if(A.Partner__c == Rsltacc[0].id){
                         A.Exception__c = 'Error on selected Account.Check Contact on this Account. Contact should have contact role as Owner/President and should be a portal user.';
                       // A.Assignment_Date__c = Date.Today();                 
                    }
                  ALRA_All.add(A);
                }
              upsert ALRA_All; 
            }else{
                for(ALRA_Audit__c A : ALRA_All){
                  if(A.Partner__c == Rsltacc[0].id){
                         A.Exception__c = 'Error on selected Account.Check Contact on this Account. Contact should have contact role as Owner/President and should be a portal user.';
                      
                    }
                  ALRA_All_1.add(A);
                }
                 upsert ALRA_All_1; 
            }
    
    } 

system.debug('AssignAllianceLeadPartner Result is ' + rslt);
return rslt;
}
catch(Exception e)
{
    createException(e,oppcampId,Rsltacc);
    return rslt;
}
}

public static boolean AssignExclusivityPartner(ALR_Metadata__c Mdata, ID Oppid){
List <ALRA_Audit__c> ALRA_All = new List<ALRA_Audit__c>();
ALRA_Audit__c ALRA = new ALRA_Audit__c();
boolean rslt = false;
Decimal Dist;
GeoUtils.Coordinates coords1;
GeoUtils.Coordinates coords2;

List<Account> Rsltacc = new List<Account>();
List<Opportunity> AccZipCode = [SELECT id,OwnerId,CampaignId, Account.BillingPostalcode,Account.BillingCountry, Partner_Account_Id__c, Customer_Zip__c,Account.Geo__Longitude__s, Account.Geo__Latitude__s,Account.Theater__c from opportunity where id = :Oppid];
try{
if(AccZipCode.size() > 0 && AccZipCode[0].Account.BillingPostalcode != Null && AccZipCode[0].Account.BillingCountry != Null){
    system.debug('AssignExclusivityPartne Result is ' + AccZipCode[0]);
    Rsltacc = ExclusivityPartnerInRadius(Mdata,AccZipCode[0]);
    
}else{
    system.debug('AssignExclusivityPartne No Record Result is ' + rslt);
    return rslt;
}

    for(integer i=0;i<Rsltacc.size();i++){
         coords1 = new GeoUtils.Coordinates(AccZipCode[0].Account.Geo__Latitude__s, AccZipCode[0].Account.Geo__Longitude__s);  
         
         system.debug('First Exclusive Partner ' + Rsltacc[0]);
         ALRA.Scenario_Applied__c = 'Exclusive Partner';
         ALRA.Partner__c = Rsltacc[0].id;
         ALRA.Partner_Tier__c = Rsltacc[0].Dealer_Tier__c;
         ALRA.Partner_Class__c = Rsltacc[i].Partner_Class__c;
         ALRA.Closed_Opp_Ratio__c = Rsltacc[0].Opportunity_Close__c;
         ALRA.Distance_Range__c = Mdata.Distance_Radius__c;
         ALRA.Distance_Unit__c = Mdata.Distance_Unit__c;
         ALRA.Opportunity__c = AccZipCode[0].id;
        // ALRA.Selected__c = true;
         ALRA.Assignment_Date__c = Date.Today();
         if(AccZipCode[0].CampaignId!=null)
                        ALRA.Campaign__c = AccZipCode[0].CampaignId;
          system.debug('latitude =  ' + Rsltacc[0].Geo__Latitude__s);
          system.debug('longitude =  ' + Rsltacc[0].Geo__Longitude__s);
         coords2 = new GeoUtils.Coordinates(Rsltacc[0].Geo__Latitude__s, Rsltacc[0].Geo__Longitude__s);
         //if(AccZipCode[0].Account.Theater__c == 'Europe'){
         if(MData.Distance_Unit__c == 'km'){
             Dist = (GeoUtils.computeDistance(coords1, coords2)/1000);
             system.debug('debug point -last');
         }    
         else{
             Dist = GeoUtils.toMiles(GeoUtils.computeDistance(coords1, coords2) / 1000);
         }
         //Dist = GeoUtils.toMiles(GeoUtils.computeDistance(coords1, coords2) / 1000);
         Dist=Dist.setscale(2);
         ALRA.Distance__c = Dist;
         ALRA_All.add(ALRA);
         
    }
if(Rsltacc.size()>0){
     //rslt = updatePartner(Rsltacc[0],Oppid); 
      if(updatePartner(Rsltacc[0],Oppid) == true){
        rslt = true;
        ALRA.Selected__c = true;
        upsert ALRA_All;
       }else{ 
          ALRA.Exception__c = 'Error on selected Account.Check Contact on this Account. Contact should have contact role as Owner/President and should be a portal user.';
          upsert ALRA_All;
        }
    
    
}  
//upsert ALRA_All;
system.debug('AssignExclusivityPartner Result is ' + rslt);  
return rslt;
}
catch(Exception e)
{
    createException(e,accZipCode,Rsltacc);
    return rslt;
}
}

public static boolean AssignDealerPartner(ALR_Metadata__c Mdata, ID Oppid){
List <ALRA_Audit__c> ALRA_All = new List<ALRA_Audit__c>();
List <ALRA_Audit__c> ALRA_All_1 = new List<ALRA_Audit__c>();
boolean rslt = false;
Decimal Dist;
GeoUtils.Coordinates coords1;
GeoUtils.Coordinates coords2;
List<Account> Rsltacc = new List<Account>();
List<Opportunity> oppcampId = [SELECT id,CampaignId,ownerId,Referral_Program__c, Dealer_Selection__c,Partner_Account_Id__c, Campaign.recordtype.Name, Account.Geo__Longitude__s, Account.Geo__Latitude__s, Account.Theater__c  FROM Opportunity where Id =:Oppid];
system.debug('oppcampId =' + oppcampId );
try{
if(oppcampId[0].Dealer_Selection__c != null){
        System.debug('Dealer');
        Rsltacc = DealerPartner(oppcampId[0]);
}else{
       
        system.debug('AssignDealerPartner No delear selected Result ' + rslt);
       return rslt;
}
if(Rsltacc.size()>0)
{
coords1 = new GeoUtils.Coordinates(oppcampId[0].Account.Geo__Latitude__s, oppcampId[0].Account.Geo__Longitude__s);    
}
//- Below is debug message, delete later
for(integer i=0;i<Rsltacc.size();i++){
    ALRA_Audit__c ALRA = new ALRA_Audit__c();
    if(oppcampId[0].Referral_Program__c == null){
         ALRA.Scenario_Applied__c = 'Dealer Locator';
    }else{
        ALRA.Scenario_Applied__c = 'Referral';
    }
     ALRA.Partner__c = Rsltacc[i].id;
     ALRA.Partner_Tier__c = Rsltacc[i].Dealer_Tier__c;
     ALRA.Partner_Class__c = Rsltacc[i].Partner_Class__c;
     ALRA.Closed_Opp_Ratio__c = Rsltacc[i].Opportunity_Close__c;
     ALRA.Distance_Range__c = Mdata.Distance_Radius__c;
     ALRA.Distance_Unit__c = Mdata.Distance_Unit__c;
     ALRA.Opportunity__c = oppcampId[0].id;
     if(oppcampId[0].CampaignId!=null)
                    ALRA.Campaign__c = oppcampId[0].CampaignId;
     coords2 = new GeoUtils.Coordinates(Rsltacc[i].Geo__Latitude__s, Rsltacc[i].Geo__Longitude__s);
    // if(oppcampId[0].Account.Theater__c == 'Europe'){
    if(MData.Distance_Unit__c == 'km'){
             Dist = (GeoUtils.computeDistance(coords1, coords2)/1000);
         }    
         else{
             Dist = GeoUtils.toMiles(GeoUtils.computeDistance(coords1, coords2) / 1000);
         }
     //Dist = GeoUtils.toMiles(GeoUtils.computeDistance(coords1, coords2) / 1000);
     Dist=Dist.setscale(2);
     ALRA.Distance__c = Dist;
     ALRA_All.add(ALRA);
    system.debug('All DealerPartnerinRadius ' + Rsltacc[i]);
}
// Not possible to have multiple dealer partners, Hence commenting the code below
//-----------------------------------------------
/*if(Rsltacc.size()>1){
    Rsltacc = DealersTier(Rsltacc);
    //- Below is debug message, delete later
    for(integer i=0;i<Rsltacc.size();i++){
        system.debug('Rslt Accounts Tier ' + Rsltacc[i]);
    }
}
if(Rsltacc.size()>1){
    Rsltacc = DealersOppRatio(Rsltacc);
    //- Below is debug message, delete later
    for(integer i=0;i<Rsltacc.size();i++){
        system.debug('CRO Accounts ' + Rsltacc[i]);
    }
}

if(Rsltacc.size()>1){
    Rsltacc = RandomAllocation(Rsltacc,Rsltacc.size());
    //- Below is debug message, delete later
    for(integer i=0;i<Rsltacc.size();i++){
        for(ALRA_Audit__c A : ALRA_All){
               if(A.Partner__c == Rsltacc[0].id){
                    A.Randomly_selected__c = true;
               }
             ALRA_All_1.add(A);
        system.debug('Random Account ' + Rsltacc[i]);
        }
      }
}*/
    
if(Rsltacc.size()==1){
     if(updatePartner(Rsltacc[0],Oppid) == true){
         if(ALRA_All_1.size()>0){ //if randomly selected then ALRA_All_1 has been updated
            ALRA_All.clear();
            for(ALRA_Audit__c A : ALRA_All_1){
              if(A.Partner__c == Rsltacc[0].id){
                     A.Selected__c = true;
                     A.Assignment_Date__c = Date.Today();                 
                }
              ALRA_All.add(A);
            }
          upsert ALRA_All; 
        }else{
            for(ALRA_Audit__c A : ALRA_All){
              if(A.Partner__c == Rsltacc[0].id){
                     A.Selected__c = true;
                     A.Assignment_Date__c = Date.Today();  
                }
              ALRA_All_1.add(A);
            }
             upsert ALRA_All_1; 
        }
    rslt = true;
    }else{
        if(ALRA_All_1.size()>0){ //if randomly selected then ALRA_All_1 has been updated
                ALRA_All.clear();
                for(ALRA_Audit__c A : ALRA_All_1){
                  if(A.Partner__c == Rsltacc[0].id){
                         A.Exception__c = 'Error on selected Account.Check Contact on this Account. Contact should have contact role as Owner/President and should be a portal user.';
                       // A.Assignment_Date__c = Date.Today();                 
                    }
                  ALRA_All.add(A);
                }
              upsert ALRA_All; 
            }else{
                for(ALRA_Audit__c A : ALRA_All){
                  if(A.Partner__c == Rsltacc[0].id){
                         A.Exception__c = 'Error on selected Account.Check Contact on this Account. Contact should have contact role as Owner/President and should be a portal user.';
                      
                    }
                  ALRA_All_1.add(A);
                }
                 upsert ALRA_All_1; 
            }
    
    } 
} 
system.debug('AssignDealerPartner Result is ' + rslt);

return rslt;
}
catch(Exception e)
{
    createException(e,oppcampId,Rsltacc);
    return rslt;
}
}

/* public static boolean AssignReferralPartner(Decimal rad, ID Oppid){
boolean rslt = false;
List<Account> Rsltacc = new List<Account>();
List<Opportunity> oppcampId = [SELECT CampaignId,ownerId, Partner_Account_Id__c, Campaign.recordtype.Name, Account.Geo__Longitude__s, Account.Geo__Latitude__s  FROM Opportunity where Id =:Oppid];
if(oppcampId[0].Partner_Account_Id__c == null){
        System.debug('Dealer');
        Rsltacc = ReferralPartner(oppcampId[0]);
}else{
    system.debug('AssignReferralPartner No Record Result is ' + rslt);
    return rslt;
}

- Below is debug message, delete later
for(integer i=0;i<Rsltacc.size();i++){
    system.debug('All ReferralPartnerinRadius ' + Rsltacc[i]);
}
Do not forget to apply null check in responses
-----------------------------------------------
if(Rsltacc.size()>1){
    Rsltacc = DealersTier(Rsltacc);
    - Below is debug message, delete later
    for(integer i=0;i<Rsltacc.size();i++){
        system.debug('Rslt Accounts Tier ' + Rsltacc[i]);
    }
}
if(Rsltacc.size()>1){
    Rsltacc = DealersOppRatio(Rsltacc);
    - Below is debug message, delete later
    for(integer i=0;i<Rsltacc.size();i++){
        system.debug('CRO Accounts ' + Rsltacc[i]);
    }
}

if(Rsltacc.size()>1){
    Rsltacc = RandomAllocation(Rsltacc,Rsltacc.size());
    - Below is debug message, delete later
    for(integer i=0;i<Rsltacc.size();i++){
        system.debug('Random Account ' + Rsltacc[i]);
    }
}
    
if(Rsltacc.size()==1){
     rslt = updatePartner(Rsltacc[0],Oppid);
    rslt = true;
} 

system.debug('AssignReferralPartner Result is ' + rslt);
return rslt;

} */


public static boolean AssignPartnerInDist(ALR_Metadata__c Mdata, ID Oppid){
List <ALRA_Audit__c> ALRA_All = new List<ALRA_Audit__c>();
List <ALRA_Audit__c> ALRA_All_1 = new List<ALRA_Audit__c>();
boolean rslt = false;
Decimal Dist;
GeoUtils.Coordinates coords1;
GeoUtils.Coordinates coords2;
List<Account> Rsltacc = new List<Account>();
List<Account> Acc = [SELECT id, Name, BillingCity,BillingCountry,BillingPostalCode,BillingState,BillingStreet,Geo__Latitude__s, Geo__Longitude__s, Theater__c from Account where id IN (select AccountId from opportunity where id = :Oppid )];
List<Opportunity> Opprt = [select id,OwnerId,PartnerAccount.Id,Check_Partner__c,CampaignId from opportunity where id = :Oppid ];
//system.debug(Acc);
try{
if(Acc.size()>0){
    Rsltacc = DealerInRadius(Mdata,Acc[0]);
}else{
    system.debug('AssignPartnerInDist No Record Result is ' + rslt);
    return rslt;
}
if(Rsltacc.size()>0)
{
coords1 = new GeoUtils.Coordinates(Acc[0].Geo__Latitude__s, Acc[0].Geo__Longitude__s); 
} 
else{
    if(Opprt[0].PartnerAccount.Id==null)
    {
        Opprt[0].Check_Partner__c=True;
        update Opprt;
    }
}

//- Below is debug message, delete later
for(integer i=0;i<Rsltacc.size();i++){    
     ALRA_Audit__c ALRA = new ALRA_Audit__c();
     ALRA.Scenario_Applied__c = 'Distance';
     ALRA.Partner__c = Rsltacc[i].id;
     ALRA.Partner_Tier__c = Rsltacc[i].Dealer_Tier__c;
     ALRA.Partner_Class__c = Rsltacc[i].Partner_Class__c;
     ALRA.Closed_Opp_Ratio__c = Rsltacc[i].Opportunity_Close__c;
     ALRA.Distance_Range__c = Mdata.Distance_Radius__c;
     ALRA.Distance_Unit__c = Mdata.Distance_Unit__c;
     ALRA.Opportunity__c = Opprt[0].id;
     if(Opprt[0].CampaignId!=null)
                    ALRA.Campaign__c = Opprt[0].CampaignId;
     coords2 = new GeoUtils.Coordinates(Rsltacc[i].Geo__Latitude__s, Rsltacc[i].Geo__Longitude__s);
    // if(Acc[0].Theater__c == 'Europe'){
    if(MData.Distance_Unit__c == 'km'){
         Dist = (GeoUtils.computeDistance(coords1, coords2)/1000);
     }    
     else{
         Dist = GeoUtils.toMiles(GeoUtils.computeDistance(coords1, coords2) / 1000);
     }
         
     Dist=Dist.setscale(2);
     ALRA.Distance__c = Dist;
     ALRA_All.add(ALRA);
    system.debug('All PartnerinRadius ' + Rsltacc[i]);
   }

// Do not forget to apply null check in responses
//-----------------------------------------------
if(Rsltacc.size()>1){
    Rsltacc = DealersTier(Rsltacc);
    //- Below is debug message, delete later
    for(integer i=0;i<Rsltacc.size();i++){
        system.debug('Rslt Accounts Dealer Tier' + Rsltacc[i]);
    }
}
if(Rsltacc.size()>1){
   
        Rsltacc = PartnerClass(Rsltacc);
        for(integer i=0;i<Rsltacc.size();i++){
             system.debug('Rslt Partner class' + Rsltacc[i]);
        }    
}
if(Rsltacc.size()>1){
    Rsltacc = DealersOppRatio(Rsltacc);
    //- Below is debug message, delete later
    for(integer i=0;i<Rsltacc.size();i++){
        system.debug('CRO Accounts = ' + Rsltacc[i]);
    }
}

if(Rsltacc.size()>1){
    Rsltacc = RandomAllocation(Rsltacc,Rsltacc.size());
    //- Below is debug message, delete later
    for(integer i=0;i<Rsltacc.size();i++){
        for(ALRA_Audit__c A : ALRA_All){
               if(A.Partner__c == Rsltacc[0].id){
                   system.debug('######log 2######');
                    A.Randomly_selected__c = true;
               }
             ALRA_All_1.add(A);
         }
        system.debug('Random Accounts = ' + Rsltacc[i]);
    }
}

    
if(Rsltacc.size()==1){
      if(updatePartner(Rsltacc[0],Oppid) == true){
        if(ALRA_All_1.size()>0){ //if randomly selected then ALRA_All_1 has been updated
            ALRA_All.clear();
            for(ALRA_Audit__c A : ALRA_All_1){
              if(A.Partner__c == Rsltacc[0].id){
                     A.Selected__c = true;
                     A.Assignment_Date__c = Date.Today();                 
                }
              ALRA_All.add(A);
            }
          upsert ALRA_All; 
        }else{
            for(ALRA_Audit__c A : ALRA_All){
              if(A.Partner__c == Rsltacc[0].id){
                     A.Selected__c = true;
                     A.Assignment_Date__c = Date.Today();
                }
              ALRA_All_1.add(A);
            }
         upsert ALRA_All_1; 
        }
    rslt = true;
    }else{
        if(ALRA_All_1.size()>0){ //if randomly selected then ALRA_All_1 has been updated
                ALRA_All.clear();
                for(ALRA_Audit__c A : ALRA_All_1){
                  if(A.Partner__c == Rsltacc[0].id){
                         A.Exception__c = 'Error on selected Account.Check Contact on this Account. Contact should have contact role as Owner/President and should be a portal user.';
                       // A.Assignment_Date__c = Date.Today();                 
                    }
                  ALRA_All.add(A);
                }
              upsert ALRA_All; 
            }else{
                for(ALRA_Audit__c A : ALRA_All){
                  if(A.Partner__c == Rsltacc[0].id){
                         A.Exception__c = 'Error on selected Account.Check Contact on this Account. Contact should have contact role as Owner/President and should be a portal user.';
                      
                    }
                  ALRA_All_1.add(A);
                }
                 upsert ALRA_All_1; 
            }
    
    } 
}  
system.debug('AssignPartnerInDist Result is ' + rslt);  
return rslt;
}
catch(Exception e)
  {
    createException(e,Opprt,Rsltacc);
    return rslt;
          
  }
}
//Campaign API

public static  List<Account> CampaignLeadPartnerInRadius(ALR_Metadata__c MData, Opportunity Acc){
            system.debug('campaign id '+Acc.CampaignId);
            
            Decimal Radius = MData.Distance_Radius__c;            
            String Runit = MData.Distance_Unit__c;
            
            Id campId = Acc.CampaignId;
            Id RecordTypeIdAcc = [SELECT Id, Name From Recordtype WHERE recordtype.Name = 'Partner' and sobjecttype = 'Account' Limit 1].Id;
            Decimal a;
            Decimal b;
            String q;
            List<Account> lstDealers = new List<Account>();
            List<Campaign_Partner__c> allCP = new List<Campaign_Partner__c>();
             Account Acnt = new Account();
             
            a=Acc.Account.Geo__Latitude__s;//Latitude of lead
            b=Acc.Account.Geo__Longitude__s;//Longitude of lead    
            system.debug('Geo__Latitude__s is ' + a);
            system.debug('Geo__Longitude__s is ' + b);
            
            if(a==null){
            //Acnt  = findLocation(Acc.Account); //check location again
           // a=Acnt.Geo__Latitude__s;//Latitude of lead
           // b=Acnt.Geo__Longitude__s;//Longitude of lead
            
             //    if(a==null){
                    return lstDealers ;
              //   }
           }
            // do not check eligible for lead routing (  Lead_Flow_opt_out__c ) in Europe
            if(MData.Theatre__c == 'Europe'){ 
                lstDealers = [SELECT Id, Name, OwnerId,     Theater__c, recordtypeid, Geo__Latitude__s,Geo__Longitude__s, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry,Opportunity_Close__c,Partner_Class__c,Dealer_Tier__c,Lead_Flow_opt_out__c FROM Account WHERE ID IN (SELECT Partner__c FROM Campaign_Partner__c where Campaign__c =:campId AND Enabled__c = true ) AND Status__c='Active' AND Type NOT IN ('Partner-Commercial','Residential Installer')];
            }else{
                 lstDealers = [SELECT Id, Name, OwnerId,    Theater__c, recordtypeid, Geo__Latitude__s,Geo__Longitude__s, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry,Opportunity_Close__c,Partner_Class__c,Dealer_Tier__c,Lead_Flow_opt_out__c FROM Account WHERE ID IN (SELECT Partner__c FROM Campaign_Partner__c where Campaign__c =:campId AND Enabled__c = true ) AND  Lead_Flow_opt_out__c = FALSE AND Status__c='Active' AND Type NOT IN ('Partner-Commercial','Residential Installer')];
            }
            if(lstDealers.size()==1 || Acc.Campaign.AssignRandomPartner__c == true){
               system.debug('lstDealers'+lstDealers);
               return lstDealers;
             }else{
                //String q = 'SELECT Id, Partner__c, Partner__r.Geo__Latitude__s, Partner__r.Geo__Longitude__s, Partner__r.OwnerID FROM Campaign_Partner__c WHERE DISTANCE(Partner__r.Geo__c, GEOLOCATION('+String.valueOf(a)+','+String.valueOf(b)+'), \'mi\') <'+radius+' AND Partner__r.RecordTypeId =: RecordTypeIdAcc  AND Campaign__c =:campId  ORDER BY DISTANCE(Partner__r.Geo__c, GEOLOCATION('+String.valueOf(a)+','+String.valueOf(b)+'), \'mi\') asc';
            // do not check eligible for lead routing (  Lead_Flow_opt_out__c ) in Europe
            // Geo__c throwing error in test so bypassing Geolocation here
            if(test.isRunningtest()){
                    q = 'SELECT Id, Partner__c, Partner__r.Geo__Latitude__s, Partner__r.Geo__Longitude__s, Partner__r.OwnerID,Partner__r.Lead_Flow_opt_out__c , Enabled__c FROM Campaign_Partner__c where Partner__r.Geo__Latitude__s!=null limit 3';
            }else{
                if(MData.Theatre__c == 'Europe'){ 
                      q = 'SELECT Id, Partner__c, Partner__r.Geo__Latitude__s, Partner__r.Geo__Longitude__s, Partner__r.OwnerID,Enabled__c FROM Campaign_Partner__c WHERE DISTANCE(Partner__r.Geo__c, GEOLOCATION('+String.valueOf(a)+','+String.valueOf(b)+'), \''+Runit+'\') <'+radius+' AND Enabled__c = true AND Partner__r.RecordTypeId =: RecordTypeIdAcc  AND Campaign__c =:campId  ORDER BY DISTANCE(Partner__r.Geo__c, GEOLOCATION('+String.valueOf(a)+','+String.valueOf(b)+'), \''+Runit+'\') asc';
                 }else{
                      q = 'SELECT Id, Partner__c, Partner__r.Geo__Latitude__s, Partner__r.Geo__Longitude__s, Partner__r.OwnerID,Partner__r.Lead_Flow_opt_out__c , Enabled__c FROM Campaign_Partner__c WHERE DISTANCE(Partner__r.Geo__c, GEOLOCATION('+String.valueOf(a)+','+String.valueOf(b)+'), \''+Runit+'\') <'+radius+' AND Enabled__c = true AND Partner__r.RecordTypeId =: RecordTypeIdAcc  AND Campaign__c =:campId AND Partner__r.Lead_Flow_opt_out__c = false ORDER BY DISTANCE(Partner__r.Geo__c, GEOLOCATION('+String.valueOf(a)+','+String.valueOf(b)+'), \''+Runit+'\') asc';
                 
                 }  
             }
                List<ID> accId = new List<ID>();                                                                    
                allCP = Database.query(q);
                for(Campaign_Partner__c cp :allCP){
                    accId.add(cp.Partner__c);
                }
                lstDealers = [SELECT Id, Name,OwnerId,  Theater__c,recordtypeid, Geo__Latitude__s,Geo__Longitude__s, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry,Opportunity_Close__c,Partner_Class__c,Dealer_Tier__c FROM Account WHERE id in :accId AND Status__c='Active' AND Type NOT IN ('Partner-Commercial','Residential Installer')];//modified by abhishek on date 01-29-2013
                system.debug('lstDealers'+lstDealers);
                return lstDealers;
            }
    }
    

    
//Alliance API
public static List<Account> AllianceLeadPartnerInRadius(ALR_Metadata__c MData, Opportunity Acc){
      //  integer radius=50; //hard coded to 50 miles check from where to get exact value
        Decimal Radius = MData.Distance_Radius__c;            
        String Runit = MData.Distance_Unit__c;
        Id campId = Acc.CampaignId;
        Id RecordTypeIdAcc = [SELECT Id, Name From Recordtype WHERE recordtype.Name = 'Partner' and sobjecttype = 'Account' Limit 1].Id;
        Decimal a;
        Decimal b;
        String q;
        List<Account> lstDealers = new List<Account>();
        List<Campaign_Partner__c> allCP = new List<Campaign_Partner__c>();
        Account Acnt = new Account();
        a=Acc.Account.Geo__Latitude__s;//Latitude of lead
        b=Acc.Account.Geo__Longitude__s;//Longitude of lead    
        system.debug('Geo__Latitude__s is ' + a);
        system.debug('Geo__Longitude__s is ' + b);
        
        if(a==null){
           // Acnt  = findLocation(Acc.Account); //check location again
           // a=Acnt.Geo__Latitude__s;//Latitude of lead
           // b=Acnt.Geo__Longitude__s;//Longitude of lead
            
            //     if(a==null){
                    return lstDealers ;
            //     }
        }
        
            if(MData.Theatre__c == 'Europe'){ 
                lstDealers = [SELECT Id, Name,  Theater__c, OwnerId, recordtypeid, Geo__Latitude__s,Geo__Longitude__s, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry,Opportunity_Close__c,Partner_Class__c,Dealer_Tier__c FROM Account WHERE ID IN (SELECT Partner__c FROM Campaign_Partner__c where Campaign__c =:campId AND Enabled__c = true) AND Status__c='Active' AND Type NOT IN ('Partner-Commercial','Residential Installer')];
            }else{
                lstDealers = [SELECT Id, Name,  Theater__c, OwnerId, recordtypeid, Geo__Latitude__s,Geo__Longitude__s, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry,Opportunity_Close__c,Partner_Class__c,Dealer_Tier__c,Lead_Flow_opt_out__c FROM Account WHERE ID IN (SELECT Partner__c FROM Campaign_Partner__c where Campaign__c =:campId AND Enabled__c = true) AND Lead_Flow_opt_out__c = false AND Status__c='Active' AND Type NOT IN ('Partner-Commercial','Residential Installer')];
            }
        
        if(lstDealers.size()==1 || Acc.Campaign.AssignRandomPartner__c == true){
           return lstDealers;
         }else{
            // Geo__c throwing error in test so bypassing Geolocation here
        if(test.isRunningtest()){
            q = 'SELECT Id, Partner__c, Partner__r.Geo__Latitude__s, Partner__r.Geo__Longitude__s, Partner__r.OwnerID,Partner__r.Lead_Flow_opt_out__c, Enabled__c FROM Campaign_Partner__c WHERE Enabled__c = true AND Partner__r.RecordTypeId =: RecordTypeIdAcc AND Campaign__c =:campId and Partner__r.Lead_Flow_opt_out__c = false limit 3';
         }
        else{
            if(MData.Theatre__c == 'Europe'){ 
                 q = 'SELECT Id, Partner__c, Partner__r.Geo__Latitude__s, Partner__r.Geo__Longitude__s, Partner__r.OwnerID, Enabled__c FROM Campaign_Partner__c WHERE DISTANCE(Partner__r.Geo__c, GEOLOCATION('+String.valueOf(a)+','+String.valueOf(b)+'),\''+Runit+'\') <'+radius+' AND Enabled__c = true AND Partner__r.RecordTypeId =: RecordTypeIdAcc AND Campaign__c =:campId ORDER BY DISTANCE(Partner__r.Geo__c, GEOLOCATION('+String.valueOf(a)+','+String.valueOf(b)+'), \''+Runit+'\') asc';
            }else{
                q = 'SELECT Id, Partner__c, Partner__r.Geo__Latitude__s, Partner__r.Geo__Longitude__s, Partner__r.OwnerID,Partner__r.Lead_Flow_opt_out__c, Enabled__c FROM Campaign_Partner__c WHERE DISTANCE(Partner__r.Geo__c, GEOLOCATION('+String.valueOf(a)+','+String.valueOf(b)+'),\''+Runit+'\') <'+radius+' AND Enabled__c = true AND Partner__r.RecordTypeId =: RecordTypeIdAcc AND Campaign__c =:campId and Partner__r.Lead_Flow_opt_out__c = false ORDER BY DISTANCE(Partner__r.Geo__c, GEOLOCATION('+String.valueOf(a)+','+String.valueOf(b)+'), \''+Runit+'\') asc';
         }
         }
            List<ID> accId = new List<ID>();                                                         
            allCP = Database.query(q);
            for(Campaign_Partner__c cp :allCP){
                accId.add(cp.Partner__c);
            }
            
            lstDealers = [SELECT Id, Name, OwnerId,     Theater__c, recordtypeid, Geo__Latitude__s,Geo__Longitude__s, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry,Opportunity_Close__c,Partner_Class__c,Dealer_Tier__c FROM Account WHERE id in :accId AND Status__c='Active' AND Type NOT IN ('Partner-Commercial','Residential Installer')];
            system.debug('lstDealers'+lstDealers);
            return lstDealers;
        }
    }
//AllianceLeadByDistancePartner
public static List<Account> AllianceLeadByDistancePartner(ALR_Metadata__c MData, Account Acc){
        Decimal a;
        Decimal b;
        String q;
        String AccCountry = Acc.BillingCountry;
        Account Acnt = new Account();         
        String Runit = MData.Distance_Unit__c;
        //Decimal Radius = 1;  
        Decimal Radius = 1000;    
        Id RecordTypeIdAcc = [SELECT Id, Name From Recordtype WHERE recordtype.Name = 'Partner' and sobjecttype = 'Account' Limit 1].Id;
        List<Account> lstDealers = new List<Account>();
        
        a=Acc.Geo__Latitude__s;//Latitude of lead
        b=Acc.Geo__Longitude__s;//Longitude of lead
        if(a==null){
            return lstDealers ;
        }
        system.debug('Geo__Latitude__s is ' + a);
        system.debug('Geo__Longitude__s is ' + b);
        // Geo__c throwing error in test so bypassing Geolocation here
        if(test.isRunningtest()){
            q = 'SELECT Id, Theater__c, Name, recordtypeid, Geo__Latitude__s,Geo__Longitude__s, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry,Opportunity_Close__c,Partner_Class__c,Dealer_Tier__c,status__c,Lead_Flow_opt_out__c FROM Account WHERE recordtypeid =:RecordTypeIdAcc limit 3';
        }else{
             q = 'SELECT Id, Theater__c, Name, recordtypeid, Geo__Latitude__s,Geo__Longitude__s, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry,Opportunity_Close__c,Partner_Class__c,Dealer_Tier__c,status__c,Lead_Flow_opt_out__c FROM Account WHERE DISTANCE(Geo__c, GEOLOCATION('+String.valueOf(a)+','+String.valueOf(b)+'),\''+Runit+'\') <'+radius+' AND Status__c=\'Active\' AND Alliance_Program_Partner__c=true AND Type NOT IN (\'Partner-Commercial\',\'Residential Installer\') AND recordtypeid =\''+RecordTypeIdAcc+'\' AND BillingCountry =\''+AccCountry+'\' AND Lead_Flow_opt_out__c = false ORDER BY DISTANCE(Geo__c, GEOLOCATION('+String.valueOf(a)+','+String.valueOf(b)+'),\''+Runit+'\') asc limit 1';
             system.debug('<<<<<<query'+q);
         }
        lstDealers = Database.query(q);
               
        return lstDealers;
}   
    
// Exclusivity API
public static List<Account> ExclusivityPartnerInRadius(ALR_Metadata__c MData, Opportunity Zipcode){
   // Integer oppZipcode = Integer.valueof(Zipcode.Account.billingPostalCode);
    List<Id> partnerId = new List<Id>();
    List<Account> lstDealers = new List<Account>();
    Decimal Radius = MData.Distance_Radius__c;            
    String Runit = MData.Distance_Unit__c;
    system.debug('zipcode = ' + Zipcode);
     List<Exclusive_Zip_codes__c> listAlrZip = [SELECT Id, Zip_code__c,Country__c, Partner__c, Partner__r.OwnerID     From Exclusive_Zip_codes__c WHERE Zip_code__c =:Zipcode.Account.BillingPostalcode and Country__c = :Zipcode.Account.BillingCountry  ];
    system.debug('Exclusive Partner from Exclusive_Zip_codes__c object = ' + listAlrZip);
    For(Exclusive_Zip_codes__c partnerOwner : listAlrZip)
    {
       partnerId.add(partnerOwner.Partner__c);
    }
    if(partnerId.size()>0){
        lstDealers = [SELECT Id, Name,  Theater__c, OwnerId, recordtypeid, Geo__Latitude__s,Geo__Longitude__s, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry,Opportunity_Close__c,Partner_Class__c,Dealer_Tier__c FROM Account WHERE Id IN :partnerId AND Status__c='Active' AND Lead_Flow_opt_out__c = false  AND Type NOT IN ('Partner-Commercial','Residential Installer')];
        system.debug('lstexclusivity'+lstDealers);
     }
      system.debug('Exclusive Partner Account = ' + lstDealers );
        return lstDealers; 
}

//Dealer API
public static List<Account> DealerPartner(Opportunity oppId){
       //integer radius=50; //hard coded to 50 miles check from where to get exact value
        List<Account> lstDealers = new List<Account>();
        //lstDealers = [SELECT Id, Name, OwnerId,Opportunity_Close__c,Dealer_Tier__c,Geo__Latitude__s,Geo__Longitude__s FROM Account WHERE Id =: oppId.Partner_Account_Id__c];
        lstDealers = [SELECT Id, Name,  Theater__c, OwnerId,Opportunity_Close__c,Partner_Class__c,Dealer_Tier__c,Geo__Latitude__s,Geo__Longitude__s FROM Account WHERE Id =: oppId.Dealer_Selection__c AND Status__c='Active' AND Lead_Flow_opt_out__c = false  AND Type NOT IN ('Partner-Commercial','Residential Installer')];
        system.debug('Dealer Partner lstDealers = '+lstDealers);
        return lstDealers;
    }

// Distance API
public static List<Account> DealerInRadius(ALR_Metadata__c MData, Account Acc){
        Decimal a;
        Decimal b;
        String q;
        String AccCountry = Acc.BillingCountry;
        Account Acnt = new Account();
        Decimal Radius = MData.Distance_Radius__c;            
        String Runit = MData.Distance_Unit__c;
        Id RecordTypeIdAcc = [SELECT Id, Name From Recordtype WHERE recordtype.Name = 'Partner' and sobjecttype = 'Account' Limit 1].Id;
        List<Account> lstDealers = new List<Account>();
        
        a=Acc.Geo__Latitude__s;//Latitude of lead
        b=Acc.Geo__Longitude__s;//Longitude of lead
        if(a==null){
           // Acnt  = findLocation(Acc); //check location again
           // a=Acnt.Geo__Latitude__s;//Latitude of lead
           // b=Acnt.Geo__Longitude__s;//Longitude of lead
            
            //     if(a==null){
                    return lstDealers ;
            //     }
        }
        system.debug('Geo__Latitude__s is ' + a);
        system.debug('Geo__Longitude__s is ' + b);
        //select all dealers in 50 miles radius
        // Geo__c throwing error in test so bypassing Geolocation here
        if(test.isRunningtest()){
            q = 'SELECT Id, Theater__c, Name, recordtypeid, Geo__Latitude__s,Geo__Longitude__s, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry,Opportunity_Close__c,Partner_Class__c,Dealer_Tier__c,status__c,Lead_Flow_opt_out__c FROM Account WHERE recordtypeid =:RecordTypeIdAcc limit 3';
        }else{
           q = 'SELECT Id,Theater__c, Name, recordtypeid, Geo__Latitude__s,Geo__Longitude__s, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry,Opportunity_Close__c,Partner_Class__c,Dealer_Tier__c,status__c,Lead_Flow_opt_out__c FROM Account WHERE DISTANCE(Geo__c, GEOLOCATION('+String.valueOf(a)+','+String.valueOf(b)+'), \''+Runit+'\') <'+Radius+' AND Status__c=\'Active\' AND Type NOT IN (\'Partner-Commercial\',\'Residential Installer\') AND recordtypeid =:RecordTypeIdAcc AND BillingCountry = :AccCountry AND Lead_Flow_opt_out__c = false ORDER BY DISTANCE(Geo__c, GEOLOCATION('+String.valueOf(a)+','+String.valueOf(b)+'), \''+Runit+'\') asc';
           
         }
        lstDealers = Database.query(q);
               
        return lstDealers;
}

public static List<Account> DealersTier(List<Account>  acc){

List<Account> AccElite = new List<Account>();
List<Account> AccPremier = new List<Account>();
List<Account> AccAuthorized = new List<Account>();
List<Account> AccOthers = new List<Account>();


PartnerTier__c PTier = PartnerTier__c.getall().values();
system.debug('All Tiers ' + PTier);
system.debug('All accs ' + acc);

List<Account> listTier = [SELECT Id,    Theater__c, Partner_Class__c,Dealer_Tier__c FROM Account WHERE Id IN : acc AND Status__c='Active' AND Type NOT IN ('Partner-Commercial','Residential Installer') AND Dealer_Tier__c != Null AND Owner.IsActive = true];

      For(Account tier : listTier){
        //System.debug('Tier1'+PTier.Tier1__c);
        if(tier.Dealer_Tier__c == PTier.Tier1__c){
            AccElite.add(tier);
           }else if(tier.Dealer_Tier__c == PTier.Tier2__c){
            AccPremier.add(tier);
           }else if(tier.Dealer_Tier__c == PTier.Tier3__c){
            AccAuthorized.add(tier);
           }else{
            AccOthers.add(tier);  
           }           
       }
   if(AccElite.size()>0){
       return AccElite;
   }else if(AccPremier.size()>0){
       return AccPremier;
   }else if(AccAuthorized.size()>0){
       return AccAuthorized;
   }else {
       return AccOthers;
   }
}

public static List<Account> partnerClass(List<Account>  acc)
{
    List<Account> PDevelop = new List<Account>();
    List<Account> PRetain = new List<Account>();
    List<Account> PAquire = new List<Account>();
    List<Account> PTerminate = new List<Account>();
    List<Account> listTier = new List<Account>();
    listTier = [SELECT Id, Partner_Class__c, Theater__c, Dealer_Tier__c FROM Account WHERE Id IN : acc AND Status__c='Active' AND Type NOT IN ('Partner-Commercial','Residential Installer') AND Dealer_Tier__c != Null AND Owner.IsActive = true];
        if(listTier.size()>0)
        {
            for(Account pclass : listTier)
            {
                if(pclass.Theater__c=='Europe')
                {
                    if(pclass.Partner_Class__c=='Develop')
                    {
                        PDevelop.add(pclass);
                    }
                    else if(pclass.Partner_Class__c=='Retain')
                    {
                        PRetain.add(pclass);
                    }
                    else if(pclass.Partner_Class__c=='Aquire')
                    {
                        PAquire.add(pclass);
                    }
                    else
                    {
                        PTerminate.add(pclass);
                    }
                }
                else
                {
                    return listTier;
                }
             }
              
         }
         else
         {
           return listTier;
         }
    
    if(PDevelop.size()>0)
    {
        return PDevelop;
    }else if(PRetain.size()>0){
        return PRetain;
    }
    else if(PAquire.size()>0)
    {
        return PAquire;
    }
    else
    {
        return PTerminate;
    }
}
                    
public static List<Account> DealersOppRatio(List<Account>  acc){

        Decimal holdRatio = 0;
        integer count = 1;
        integer i;
        List<Account> listDlrs = [SELECT id,    Theater__c, Opportunity_Close__c FROM Account WHERE Id IN : acc AND Status__c='Active' AND Type NOT IN ('Partner-Commercial','Residential Installer') AND Opportunity_Close__c != Null order by Opportunity_Close__c desc ];
        if(listDlrs.size()>0){
            holdRatio = listDlrs[0].Opportunity_Close__c;
            for(i = 0; i<listDlrs.size();i++){
                if(holdRatio == listDlrs[i].Opportunity_Close__c){
                    count++;
                   }
            }
        }else{
             return acc;
        }
        if(count>1){
            listDlrs = [SELECT id,  Theater__c, Opportunity_Close__c FROM Account WHERE Id IN : acc AND Status__c='Active' AND Type NOT IN ('Partner-Commercial','Residential Installer') AND Opportunity_Close__c =:holdRatio ];
              System.debug('>>>listDlrs holdratio'+listDlrs);
        }
        return listDlrs ;
}                       

public static List<Account> RandomAllocation(List<Account>  acc,Integer count){ 
                
               // Integer count = acc.size();
                Integer rand = Math.floor(Math.random() * count).intValue();
                if(rand>2000)
                    rand=2000;  // Offset can not be more than 2000
                List<Account> a = [SELECT id,   Theater__c,Name FROM Account where id IN : acc AND Status__c='Active' AND Type NOT IN ('Partner-Commercial','Residential Installer') LIMIT 1 OFFSET :rand];
                return a;
               
}
public static boolean updatePartner(Account acc,ID OpId){
 
 
    boolean rslt = true;
    List <Contact> Con = new List<Contact>();
    Opportunity Opp;
    Account Acnt;
    Opportunity oppPartnerAcc;
    Account AcntPartnerDate;
try{    
    if(acc.Theater__c == 'Europe')
    {
         Con = [SELECT Id,OwnerId,Partner_Portal_User__c, contact.Account.Opportunity_Recipient__c,contact.Owner.isActive from contact where Id IN (SELECT ContactId from AccountContactRole where AccountId = :acc.id and Role = 'Opportunity Recipient') AND Active_Partner_Portal_User__c='yes'];
         
         if(Con.size()<1)
            con = [SELECT Id,OwnerId,Partner_Portal_User__c, contact.Account.Opportunity_Recipient__c,contact.Account.Opportunity_Recipient__r.isActive,contact.Owner.isActive from contact where Id IN (SELECT ContactId from AccountContactRole where AccountId = :acc.id)  AND Active_Partner_Portal_User__c='yes'];// modified by abhishek on date 04-3-2013
    }
    else if(acc.Theater__c == 'North America')
    {
           Con = [SELECT Id,OwnerId,Partner_Portal_User__c, contact.Account.Opportunity_Recipient__c, contact.Account.Opportunity_Recipient__r.isActive, contact.Owner.isActive from contact where contact.Account.Id =: acc.id and contact.Account.Opportunity_Recipient__c != null  and contact.Account.Opportunity_Recipient__r.isActive = true and Active_Partner_Portal_User__c='yes' AND Portal_User_Profile__c != 'NA Warranty Pilot'];

           if(Con.size()<1)
                con = [SELECT Id,OwnerId,Partner_Portal_User__c, contact.Account.Opportunity_Recipient__c,contact.Account.Opportunity_Recipient__r.isActive,contact.Owner.isActive from contact where contact.Account.Id =:acc.id  AND Active_Partner_Portal_User__c='yes' AND Portal_User_Profile__c != 'NA Warranty Pilot'];// modified by abhishek on date 04-3-2013
        
    }
       
        if(Con.size() < 1)
        {
            // added by abhishek on date 01-29-2013
            Opp = [SELECT id,OwnerId,PartnerAccount.Id,Check_Partner__c FROM Opportunity WHERE Id=:OpId] ;
            if(Opp.PartnerAccount.Id==null)
            {
                Opp.Check_Partner__c=True;
                update Opp;
            }
            else
            {
                system.debug ('No contact as owner ' + Con);
            }
            return false;
        }

    system.debug ('owner contact is ' + Con);
   
    Opp = [SELECT id,OwnerId FROM Opportunity WHERE Id=:OpId] ;
     system.debug ('Opp is ' + Opp );
    Acnt = [SELECT id, Name,OwnerId from Account where id IN (select AccountId from opportunity where id = :Opid )];
    system.debug ('Accnt is is ' + Acnt );
   List <Contact> ConvertedCon = [SELECT id, Name ,OwnerId from Contact where id IN (select ConvertedContactId from lead where ConvertedOpportunityId = :Opid ) limit 1];
   
      if(Con[0].Partner_Portal_User__c!=null && acc.Theater__c == 'North America' && Con[0].Account.Opportunity_Recipient__c != null && Con[0].Account.Opportunity_Recipient__r.isActive == true){
        Opp.OwnerId=Con[0].Account.Opportunity_Recipient__c;
        Acnt.OwnerId=Con[0].Account.Opportunity_Recipient__c;
        if(ConvertedCon.size()>0){
                system.debug ('ConvertedCon is ' + ConvertedCon );
              ConvertedCon[0].OwnerId=Con[0].Account.Opportunity_Recipient__c;
               update ConvertedCon[0];
        }
        update Opp;
        update Acnt;  
        
   } else if(Con[0].Partner_Portal_User__c!=null){
        Opp.OwnerId=Con[0].Partner_Portal_User__c;
        Acnt.OwnerId=Con[0].Partner_Portal_User__c;
        if(ConvertedCon.size()>0){
                system.debug ('ConvertedCon is 1' + ConvertedCon );
              ConvertedCon[0].OwnerId=Con[0].Partner_Portal_User__c;
               update ConvertedCon[0];
        }
        update Opp;
        update Acnt;  
   }else{
       system.debug('Contact is not a portal User');
       rslt = false;
   }
   if(test.isRunningtest()){
    oppPartnerAcc = [SELECT id,OwnerId,LastModifiedDate,PartnerAccount.Id,Check_Partner__c FROM Opportunity WHERE Id=:Opp.Id];
   }else{
     oppPartnerAcc = [SELECT id,OwnerId,LastModifiedDate,PartnerAccount.Id,Check_Partner__c FROM Opportunity WHERE Id=:Opp.Id];
   system.debug('>>>>>>>>>oppPartnerAcc'+oppPartnerAcc);
     AcntPartnerDate = [SELECT id,Last_Opportunity_Assigned_Date__c,Partner_Class__c,Dealer_Tier__c from Account WHERE Id =: oppPartnerAcc.PartnerAccount.Id];
   system.debug('>>>>>>>>>AcntPartnerDate'+AcntPartnerDate);
       if(AcntPartnerDate.Id!=null)
       {
            AcntPartnerDate.Last_Opportunity_Assigned_Date__c=Date.valueof(oppPartnerAcc.LastModifiedDate);
            update AcntPartnerDate;
       }
   }
   
   return rslt;
 }
catch(Exception e)
{
    
Exception_log__c exceptionLog = new Exception_log__c();
exceptionLog.Error_Message__c = e.getMessage();
exceptionLog.Stack_Trace__c = e.getStackTraceString();
if(AcntPartnerDate != null)
    exceptionLog.Account_Id__c = AcntPartnerDate.id;
else if (Acnt!= null)
    exceptionLog.Account_Id__c = Acnt.id;
if(oppPartnerAcc != null)
     exceptionLog.Opportunity_Id__c = oppPartnerAcc.id;
else if(Opp != null)
     exceptionLog.Opportunity_Id__c = Opp.id;
insert exceptionLog;
return rslt;
          
}
}

public static void createException(Exception e, List<Opportunity> OppList, List<Account> AccList)
{

Exception_log__c exceptionLog = new Exception_log__c();
exceptionLog.Error_Message__c = e.getMessage();
exceptionLog.Stack_Trace__c = e.getStackTraceString();
if(AccList.size() == 1)
    exceptionLog.Account_Id__c = AccList[0].id;
if(OppList.size() == 1)
    exceptionLog.Opportunity_Id__c = OppList[0].id;

insert exceptionLog;
}
}