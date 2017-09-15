//Class is created for case-00013633(00028778)
public class LeadRatingManagement{
//Set Proposal Partner Type and Rating for France
    //Start 00116924
     public static void setFrance(Lead newlead, Map<String,String> mapRecordTypeIDName){
    String experienceInYears = '';
    
    if(mapRecordTypeIDName.get(newlead.recordTypeID)=='Partner'){
             newlead.Rating = '';   
             if(newlead.Total_Experience_in_Solar_Business__c != null && newlead.Installations_Realized_Previous_Year__c != null && newlead.Does_Company_Install_PV_Distribute__c != null && newlead.NumberOfEmployees != null)
             {
               experienceInYears = newlead.Total_Experience_in_Solar_Business__c;
                if(
                    (experienceInYears == '1 - 2 years' || experienceInYears == '2 - 3 years' || experienceInYears == '3 - 4 years' || experienceInYears == '4 - 5 years' || experienceInYears == '5+ years') && 
                     newlead.Has_Engineering_and_Sales_Resources__c == true && 
                     newlead.Installations_Realized_Previous_Year__c >= 10 &&
                     newlead.Focused_on_Ground_Mounted_Systems__c == false &&
                     (newlead.Does_Company_Install_PV_Distribute__c == 'Install' || newlead.Does_Company_Install_PV_Distribute__c == 'Both') &&
                     newlead.NumberOfEmployees >= 4)
                {
                    newlead.Rating = 'A';
                }
               if((newlead.Does_Company_Install_PV_Distribute__c == 'Install' || newlead.Does_Company_Install_PV_Distribute__c == 'Both') &&
                     newlead.Has_Engineering_and_Sales_Resources__c == false && 
                     newlead.Focused_on_Ground_Mounted_Systems__c == false &&
                     newlead.Installations_Realized_Previous_Year__c >= 10 &&
                     newlead.NumberOfEmployees >= 4)
                {
                    newlead.Rating = 'B';
                }
             }
            if(
            (newlead.Focused_on_Ground_Mounted_Systems__c != null && newlead.Focused_on_Ground_Mounted_Systems__c == true) ||
            (newlead.Immediate_Interest_in_Pricing__c != null && newlead.Immediate_Interest_in_Pricing__c == true)||
            (newlead.Total_Experience_in_Solar_Business__c != null && 
               (newlead.Total_Experience_in_Solar_Business__c == '< 1 year' || newlead.Total_Experience_in_Solar_Business__c == 'New to Solar Business')) ||
            (newlead.Does_Company_Install_PV_Distribute__c != null && newlead.Does_Company_Install_PV_Distribute__c == 'Distribute')||
            (newlead.NumberOfEmployees != null && newlead.NumberOfEmployees < 4) ||
            (newlead.Installations_Realized_Previous_Year__c != null && newlead.Installations_Realized_Previous_Year__c < 10))
            {
                newlead.Rating = 'C';
            }
         }
    }
    //End 00116924
    
    //Set Proposal Partner Type and Rating for United Kingdom
    //Start 00117536
 public static void setUKRating(Lead newlead, Map<String,String> mapRecordTypeIDName){
    String experienceInYears = '';
    if(mapRecordTypeIDName.get(newlead.recordTypeID)=='Partner'){
              newlead.Rating = '';   
                 if(newlead.Total_Experience_in_Solar_Business__c != null && newlead.Has_Engineering_and_Sales_Resources__c != null && newlead.Does_Company_Install_PV_Distribute__c != null && newlead.MCS_certification__c != null && newlead.Commercial_Residential_Business_Split__c != null && newlead.Immediate_Interest_in_Pricing__c != null )
             {
                 experienceInYears = newlead.Total_Experience_in_Solar_Business__c;
               //Scenario 1
               if((experienceInYears == '1 - 2 years' || experienceInYears == '2 - 3 years' || experienceInYears == '3 - 4 years' || experienceInYears == '4 - 5 years' || experienceInYears == '5+ years') && 
               newlead.Has_Engineering_and_Sales_Resources__c == true && 
               (newlead.Does_Company_Install_PV_Distribute__c == 'Install'|| newlead.Does_Company_Install_PV_Distribute__c == 'Both') &&
               newlead.MCS_certification__c == 'Yes' && 
               newlead.Commercial_Residential_Business_Split__c != 'Residential - 100%' &&
               newlead.Immediate_Interest_in_Pricing__c == false)
                {
                    newlead.Rating = 'A';
                }
                //Scenario 2
              if((experienceInYears == '< 1 year' || experienceInYears== 'New to Solar Business')&& 
               newlead.Has_Engineering_and_Sales_Resources__c == true && 
               (newlead.Does_Company_Install_PV_Distribute__c == 'Install'|| newlead.Does_Company_Install_PV_Distribute__c == 'Both') &&
               newlead.MCS_certification__c == 'Yes' && 
               newlead.Commercial_Residential_Business_Split__c != 'Residential - 100%' &&
               newlead.Immediate_Interest_in_Pricing__c== false)
                {
                    newlead.Rating = 'B';
                }
                //Scenario 3
                if((experienceInYears == '< 1 year' || experienceInYears== 'New to Solar Business')&& 
               newlead.Has_Engineering_and_Sales_Resources__c == false && 
               (newlead.Does_Company_Install_PV_Distribute__c == 'Install'|| newlead.Does_Company_Install_PV_Distribute__c == 'Both') &&
               newlead.MCS_certification__c == 'Yes' && 
               newlead.Commercial_Residential_Business_Split__c != 'Residential - 100%' &&
               newlead.Immediate_Interest_in_Pricing__c== false)
                {
                    newlead.Rating = 'B';
                }
                //Scenario 4
                if((experienceInYears == '< 1 year' || experienceInYears== 'New to Solar Business')&& 
               newlead.Has_Engineering_and_Sales_Resources__c == true && 
               (newlead.Does_Company_Install_PV_Distribute__c == 'Install'|| newlead.Does_Company_Install_PV_Distribute__c == 'Both') &&
               newlead.MCS_certification__c == 'In process' && 
               newlead.Commercial_Residential_Business_Split__c != 'Residential - 100%' &&
               newlead.Immediate_Interest_in_Pricing__c== false)
                {
                    newlead.Rating = 'B';
                }
                //Scenario 5
                if((experienceInYears == '< 1 year' || experienceInYears== 'New to Solar Business')&& 
               newlead.Has_Engineering_and_Sales_Resources__c == false && 
               (newlead.Does_Company_Install_PV_Distribute__c == 'Install'|| newlead.Does_Company_Install_PV_Distribute__c == 'Both') &&
               newlead.MCS_certification__c == 'Yes' && 
               newlead.Commercial_Residential_Business_Split__c == 'Residential - 100%' &&
               newlead.Immediate_Interest_in_Pricing__c == false)
                {
                    newlead.Rating = 'B';
                }
                //Scenario 6
                if((experienceInYears == '< 1 year' || experienceInYears== 'New to Solar Business')&& 
               newlead.Has_Engineering_and_Sales_Resources__c == false && 
               (newlead.Does_Company_Install_PV_Distribute__c == 'Install'|| newlead.Does_Company_Install_PV_Distribute__c == 'Both') &&
               newlead.MCS_certification__c == 'In process' && 
               newlead.Commercial_Residential_Business_Split__c == 'Residential - 100%' &&
               newlead.Immediate_Interest_in_Pricing__c == false)
                {
                    newlead.Rating = 'B';
                }
                //Scenario 7
                if((experienceInYears == '< 1 year' || experienceInYears== 'New to Solar Business')&& 
               newlead.Has_Engineering_and_Sales_Resources__c == false && 
               (newlead.Does_Company_Install_PV_Distribute__c == 'Install'|| newlead.Does_Company_Install_PV_Distribute__c == 'Both') &&
               newlead.MCS_certification__c == 'In process' && 
               newlead.Commercial_Residential_Business_Split__c != 'Residential - 100%' &&
               newlead.Immediate_Interest_in_Pricing__c == false)
                {
                    newlead.Rating = 'B';
                }
              //Scenario 8
                if((experienceInYears == '< 1 year' || experienceInYears== 'New to Solar Business')&& 
               newlead.Has_Engineering_and_Sales_Resources__c == false && 
               (newlead.Does_Company_Install_PV_Distribute__c == 'Install'|| newlead.Does_Company_Install_PV_Distribute__c == 'Both') &&
               newlead.MCS_certification__c == 'Yes' && 
               newlead.Commercial_Residential_Business_Split__c == 'Residential - 100%' &&
               newlead.Immediate_Interest_in_Pricing__c == false)
                {
                    newlead.Rating = 'B';
                }
                
                //Scenario 9
                if((experienceInYears == '< 1 year' || experienceInYears== 'New to Solar Business')&& 
               newlead.Has_Engineering_and_Sales_Resources__c == true && 
               (newlead.Does_Company_Install_PV_Distribute__c == 'Install'|| newlead.Does_Company_Install_PV_Distribute__c == 'Both') &&
               newlead.MCS_certification__c == 'In process' && 
               newlead.Commercial_Residential_Business_Split__c == 'Residential - 100%' &&
               newlead.Immediate_Interest_in_Pricing__c == false)
                {
                    newlead.Rating = 'B';
                }
                //Scenario 10
                if((experienceInYears == '1 - 2 years' || experienceInYears == '2 - 3 years' || experienceInYears == '3 - 4 years' || experienceInYears == '4 - 5 years' || experienceInYears == '5+ years') && 
               newlead.Has_Engineering_and_Sales_Resources__c == false && 
               (newlead.Does_Company_Install_PV_Distribute__c == 'Install'|| newlead.Does_Company_Install_PV_Distribute__c == 'Both') &&
               newlead.MCS_certification__c == 'Yes' && 
               newlead.Commercial_Residential_Business_Split__c != 'Residential - 100%' &&
               newlead.Immediate_Interest_in_Pricing__c == false)
                {
                    newlead.Rating = 'B';
                }
                //Scenario 11
                if((experienceInYears == '1 - 2 years' || experienceInYears == '2 - 3 years' || experienceInYears == '3 - 4 years' || experienceInYears == '4 - 5 years' || experienceInYears == '5+ years') && 
               newlead.Has_Engineering_and_Sales_Resources__c == true && 
               (newlead.Does_Company_Install_PV_Distribute__c == 'Install'|| newlead.Does_Company_Install_PV_Distribute__c == 'Both') &&
               newlead.MCS_certification__c == 'Yes' && 
               newlead.Commercial_Residential_Business_Split__c == 'Residential - 100%' &&
               newlead.Immediate_Interest_in_Pricing__c == false)
                {
                    newlead.Rating = 'B';
                }
                //Scenario 12
                if((experienceInYears == '1 - 2 years' || experienceInYears == '2 - 3 years' || experienceInYears == '3 - 4 years' || experienceInYears == '4 - 5 years' || experienceInYears == '5+ years') && 
               newlead.Has_Engineering_and_Sales_Resources__c == true && 
               (newlead.Does_Company_Install_PV_Distribute__c == 'Install'|| newlead.Does_Company_Install_PV_Distribute__c == 'Both') &&
               newlead.MCS_certification__c == 'In process' && 
               newlead.Commercial_Residential_Business_Split__c != 'Residential - 100%' &&
               newlead.Immediate_Interest_in_Pricing__c == false)
                {
                    newlead.Rating = 'B';
                }
                //Scenario 13
                if((experienceInYears == '1 - 2 years' || experienceInYears == '2 - 3 years' || experienceInYears == '3 - 4 years' || experienceInYears == '4 - 5 years' || experienceInYears == '5+ years') && 
               newlead.Has_Engineering_and_Sales_Resources__c == false && 
               (newlead.Does_Company_Install_PV_Distribute__c == 'Install'|| newlead.Does_Company_Install_PV_Distribute__c == 'Both') &&
               newlead.MCS_certification__c == 'In process' && 
               newlead.Commercial_Residential_Business_Split__c == 'Residential - 100%' &&
               newlead.Immediate_Interest_in_Pricing__c == false)
                {
                    newlead.Rating = 'B';
                }
                //Scenario 14
                if((experienceInYears == '1 - 2 years' || experienceInYears == '2 - 3 years' || experienceInYears == '3 - 4 years' || experienceInYears == '4 - 5 years' || experienceInYears == '5+ years') && 
               newlead.Has_Engineering_and_Sales_Resources__c == false && 
               (newlead.Does_Company_Install_PV_Distribute__c == 'Install'|| newlead.Does_Company_Install_PV_Distribute__c == 'Both') &&
               newlead.MCS_certification__c == 'Yes' && 
               newlead.Commercial_Residential_Business_Split__c == 'Residential - 100%' &&
               newlead.Immediate_Interest_in_Pricing__c == false)
                {
                    newlead.Rating = 'B';
                }
                //Scenario 15
                if((experienceInYears == '1 - 2 years' || experienceInYears == '2 - 3 years' || experienceInYears == '3 - 4 years' || experienceInYears == '4 - 5 years' || experienceInYears == '5+ years') && 
               newlead.Has_Engineering_and_Sales_Resources__c == false && 
               (newlead.Does_Company_Install_PV_Distribute__c == 'Install'|| newlead.Does_Company_Install_PV_Distribute__c == 'Both') &&
               newlead.MCS_certification__c == 'In process' && 
               newlead.Commercial_Residential_Business_Split__c != 'Residential - 100%' &&
               newlead.Immediate_Interest_in_Pricing__c == false)
                {
                    newlead.Rating = 'B';
                }
                //Scenario 16
                if((experienceInYears == '1 - 2 years' || experienceInYears == '2 - 3 years' || experienceInYears == '3 - 4 years' || experienceInYears == '4 - 5 years' || experienceInYears == '5+ years') && 
               newlead.Has_Engineering_and_Sales_Resources__c == true && 
               (newlead.Does_Company_Install_PV_Distribute__c == 'Install'|| newlead.Does_Company_Install_PV_Distribute__c == 'Both') &&
               newlead.MCS_certification__c == 'In process' && 
               newlead.Commercial_Residential_Business_Split__c == 'Residential - 100%' &&
               newlead.Immediate_Interest_in_Pricing__c == false)
                {
                    newlead.Rating = 'B';
                }
              }
             // Rating C 
             if((newlead.Immediate_Interest_in_Pricing__c != null && newlead.Immediate_Interest_in_Pricing__c== true)||(newlead.Does_Company_Install_PV_Distribute__c!=null && newlead.Does_Company_Install_PV_Distribute__c == 'Distribute')||(newlead.MCS_certification__c !=null  && newlead.MCS_certification__c == 'No')||(newlead.State != null && newlead.State == 'Northern Ireland'))
             {
               newlead.Rating = 'C';
             }
              
              }
    }
    // End 00117536

    //Set Proposal Partner Type and Rating for Italy
    public static void setItalyRating(Lead ld, Map<String,String> mapRecordTypeIDName){
        //for(Lead ld:lstLeads){
            //If Lead is not a Partner from Italy then skip the Lead
            if(ld.Theater__c!='Europe' || ld.Country!='Italy' || mapRecordTypeIDName.get(ld.recordTypeID)!='Partner'){
                return;
            }
            
            //Set the value of 'Proposal Partner Type' based on the other field values
            if(ld.Total_Experience_in_Solar_Business__c == 'New to Solar Business'){
                ld.Proposal_Partner_Type__c = 'New to Solar';
            }
            else if(ld.Size_of_Projects__c == '< 20 KW' && ld.Total_Experience_in_Solar_Business__c!='' && ld.Total_Experience_in_Solar_Business__c!=null ){
                ld.Proposal_Partner_Type__c = 'SunPower Residential Installer';
            }
            else if((ld.Size_of_Projects__c == '> 20 KW' || ld.Size_of_Projects__c == '> 250 KW') && ld.Total_Experience_in_Solar_Business__c!='' && ld.Total_Experience_in_Solar_Business__c!=null){
                ld.Proposal_Partner_Type__c = 'Authorized';
            }
            else{
                ld.Proposal_Partner_Type__c = '';
            }
            
            //Go for Rating Process
            Integer score = 0;
            //Rating process for Authorized Partners            
            if(ld.Proposal_Partner_Type__c == 'Authorized'){
                //Step-1
                if(ld.Does_Company_Install_PV_Distribute__c == 'Both'){
                    score += 2;
                }
                else if(ld.Does_Company_Install_PV_Distribute__c == 'Install'){
                    score += 3;
                }
                //Step-2
                if(ld.Total_Experience_in_Solar_Business__c == '1 - 2 years'){
                    score += 2;
                }
                else if(ld.Total_Experience_in_Solar_Business__c != '< 1 year' && ld.Total_Experience_in_Solar_Business__c != '' && ld.Total_Experience_in_Solar_Business__c != null && ld.Total_Experience_in_Solar_Business__c != 'New to Solar Business'){
                    score += 3;
                }
                //Step-3
                if(ld.Has_Rooftop_Experience__c){
                    score += 3;
                }
                //Step-4
                if(ld.Has_Engineering_and_Sales_Resources__c){
                    score += 3;
                }
                //Step-5
                //Set<String> setScore3States = new Set<String>{'Lazio','Umbria','Abruzzo','Marche','Veneto','Trentino Alto Adige','Emilia Romagna','Friuli','Lombardia','Piemonte','Liguria','Valle D\'Aosta','Campania','Toscana','Calabria','Molise','Puglia','Sicilia','Basilicata','Sardegna'};
                Set<String> setScore3States = new Set<String>{'Abruzzo','AG','Agrigento','AL','Alessandria',
                       'AN','Ancona','AO','Aosta','AP','AQ','AR','Arezzo','Ascoli Piceno','Asti','AT','AV',
                       'Avellino','BA','Bari','Barletta-Andria-Trani','Basilicata','Belluno','Benevento',
                       'Bergamo','BG','BI','Biella','BL','BN','BO','Bologna','Bolzano','BR','Brescia',
                       'Brindisi','BS','BT','BZ','CA','Cagliari','Calabria','Caltanisetta','Campania',
                       'Campobasso','Carbonia-Iglesias','Caserta','Catania','Catanzaro','CB','CE','CH',
                       'Chieti','CI','CL','CN','CO','Como','Cosenza','CR','Cremona','Crotone','CS','CT',
                       'Cuneo','CZ','Emilia-Romagna','EN','Enna','FC','FE','Ferrara','FG','FI','Firenze',
                       'FO','Foggia','Forli-Cesena','FR','Friuli-Venezia Giulia','Frosinone','GE','Genova',
                       'GO','Gorizia','GR','Grosseto','IM','Imperia','IS','Isernia','KR','La Spezia',
                       'L\'Aquila','Latina','Lazio','LC','LE','Lecce','Lecco','LI','Liguria','Livorno',
                       'LO','Lodi','Lombardia','LT','LU','Lucca','Macerata','Mantova','Marche',
                       'Massa Carrara','Matera','MB','MC','ME','Medio Campidano','Messina','MI','Milano',
                       'MN','MO','Modena','Molise','Monza e della Brianza','MS','MT','NA','Napoli','NO',
                       'Novara','NU','Nuoro','OG','Ogliastra','Olbia-Tempio','OR','Oristano','OT','PA',
                       'Padova','Palermo','Parma','Pavia','PC','PD','PE','Perugia','Pesaro-Urbino',
                       'Pescara','PG','PI','Piacenza','Piemonte','Pisa','Pistoia','PN','PO','Pordenone',
                       'Potenza','PR','Prato','PT','PU','Puglia','PV','PZ','RA','Ragusa','Ravenna','RC',
                       'RE','Reggio Calabria','Reggio Emilia','RG','RI','Rieti','Rimini','RM','RN','RO',
                       'Roma','Rovigo','SA','Salerno','Sardegna','Sassari','Savona','SI','Sicilia','Siena',
                       'Siracusa','SO','Sondrio','SP','SR','SS','SV','TA','Taranto','TE','Teramo','Terni',
                       'TN','TO','Torino','Toscana','TP','TR','Trapani','Trentino-Alto Adige','Trento',
                       'Treviso','Trieste','TS','TV','UD','Udine','Umbria','VA','Valle d\'Aosta','Varese',
                       'VB','VC','VE','Veneto','Venezia','Verbano','Vercelli','Verona','VI','Vibo Valentia',
                       'Vicenza','Viterbo','VR','VS','VT','VV'};
                if(ld.state=='Other'){
                    score += 1;
                }               
                else if(setScore3States.contains(ld.state)){
                    score += 3;
                }
                //Step-6
                if(!ld.Focused_on_Ground_Mounted_Systems__c){
                    score += 3;
                }
                //Step-7
                if(!ld.Immediate_Interest_in_Pricing__c){
                    score += 3;
                }               
            }
            
            //Rating process for SunPower Residential Installer(SRI) Partners           
            else if(ld.Proposal_Partner_Type__c == 'SunPower Residential Installer'){
                //Step-1
                if(ld.Does_Company_Install_PV_Distribute__c == 'Install'){
                    score += 3;
                }
                //Step-2
                if(ld.Total_Experience_in_Solar_Business__c == '1 - 2 years'){
                    score += 2;
                }
                else if(ld.Total_Experience_in_Solar_Business__c != '< 1 year' && ld.Total_Experience_in_Solar_Business__c != '' && ld.Total_Experience_in_Solar_Business__c != null && ld.Total_Experience_in_Solar_Business__c != 'New to Solar Business'){
                    score += 3;
                }
                //Step-3
                if(ld.Cored_Business__c == 'PV'){
                    score += 3;
                }
                //Step-4
                if(ld.Has_Engineering_and_Sales_Resources__c){
                    score += 3;
                }
                //Step-5
                //Set<String> setScore2States = new Set<String>{'Molise','Puglia','Sicilia','Calabria','Basilicata'};
                //Set<String> setScore3States = new Set<String>{'Piemonte','Lombardia','Trento','Veneto','Fruili','Emilia Romagna','Lazio','Toscana','Umbria','Liguria'};
                Set<String> setScore2States = new Set<String>{'AG','Agrigento','BA','Bari',
                    'Barletta-Andria-Trani','Basilicata','BR','Brindisi','BT','Calabria',
                    'Caltanisetta','Campobasso','Catania','Catanzaro','CB','CL','Cosenza',
                    'Crotone','CS','CT','CZ','EN','Enna','FG','Foggia','IS','Isernia','KR',
                    'LE','Lecce','Matera','ME','Messina','Molise','MT','PA','Palermo',
                    'Potenza','Puglia','PZ','Ragusa','RC','Reggio Calabria','RG','Sicilia',
                    'Siracusa','SR','TA','Taranto','TP','Trapani','Vibo Valentia','VV'};
                Set<String> setScore3States = new Set<String>{'AL','Alessandria','AR','Arezzo',
                    'Asti','AT','Belluno','Bergamo','BG','BI','Biella','BL','BO','Bologna',
                    'Bolzano','Brescia','BS','BZ','CN','CO','Como','CR','Cremona','Cuneo',
                    'Emilia-Romagna','FC','FE','Ferrara','FI','Firenze','FO','Forli-Cesena',
                    'FR','Friuli-Venezia Giulia','Frosinone','GE','Genova','GO','Gorizia',
                    'GR','Grosseto','IM','Imperia','La Spezia','Latina','Lazio','LC','Lecco',
                    'LI','Liguria','Livorno','LO','Lodi','Lombardia','LT','LU','Lucca','Mantova',
                    'Massa Carrara','MB','MI','Milano','MN','MO','Modena','Monza e della Brianza',
                    'MS','NO','Novara','Padova','Parma','Pavia','PC','PD','Perugia','PG','PI',
                    'Piacenza','Piemonte','Pisa','Pistoia','PN','PO','Pordenone','PR','Prato',
                    'PT','PV','RA','Ravenna','RE','Reggio Emilia','RI','Rieti','Rimini','RM','RN',
                    'RO','Roma','Rovigo','Savona','SI','Siena','SO','Sondrio','SP','SV','Terni',
                    'TN','TO','Torino','Toscana','TR','Trentino-Alto Adige','Trento','Treviso',
                    'Trieste','TS','TV','UD','Udine','Umbria','VA','Varese','VB','VC','VE','Veneto',
                    'Venezia','Verbano','Vercelli','Verona','VI','Vicenza','Viterbo','VR','VT'};
                if(setScore2States.contains(ld.state)){
                    score += 2;
                }
                else if(setScore3States.contains(ld.state)){
                    score += 3;
                }
                //Step-6
                if(!ld.Focused_on_Ground_Mounted_Systems__c){
                    score += 3;
                }               
                //Step-7
                if(ld.Want_to_buy_kits__c){
                    score += 3;
                }
                //Step-8
                if(!ld.Immediate_Interest_in_Pricing__c){
                    score += 3;
                }               
            }
            
            //Rating process for New to Solar(NTS) Partners         
            else if(ld.Proposal_Partner_Type__c == 'New to Solar'){
                //Step-1
                if(ld.Total_Experience_in_Solar_Business__c == 'New to Solar Business'){
                    score += 3;                 
                }
                //Step-2
                Set<String> setScore3CoreBusiness = new Set<String>{'HVAC','Satellite TV','Security Equipment Domotics','Swimming Pools and Water Treatment','Video surveillance','Windows'};
                if(ld.Cored_Business__c == 'Other'){
                    score += 2;
                }
                else if(setScore3CoreBusiness.contains(ld.Cored_Business__c)){
                    score += 3;
                }
                //Step-3
                if(ld.Has_Engineering_and_Sales_Resources__c){
                    score += 3;
                }
                //Step-4
                //Set<String> setScore1States = new Set<String>{'Molise','Puglia','Sicilia','Calabria','Basilicata'};
                //Set<String> setScore3States = new Set<String>{'Piemonte','Lombardia','Trento','Veneto','Fruili','Emilia Romagna','Lazio','Toscana','Umbria','Liguria'};
                Set<String> setScore1States = new Set<String>{'AG','Agrigento','BA','Bari',
                    'Barletta-Andria-Trani','Basilicata','BR','Brindisi','BT','Calabria',
                    'Caltanisetta','Campobasso','Catania','Catanzaro','CB','CL','Cosenza',
                    'Crotone','CS','CT','CZ','EN','Enna','FG','Foggia','IS','Isernia','KR',
                    'LE','Lecce','Matera','ME','Messina','Molise','MT','PA','Palermo',
                    'Potenza','Puglia','PZ','Ragusa','RC','Reggio Calabria','RG','Sicilia',
                    'Siracusa','SR','TA','Taranto','TP','Trapani','Vibo Valentia','VV'};
                Set<String> setScore3States = new Set<String>{'AL','Alessandria','AR','Arezzo',
                    'Asti','AT','Belluno','Bergamo','BG','BI','Biella','BL','BO','Bologna',
                    'Bolzano','Brescia','BS','BZ','CN','CO','Como','CR','Cremona','Cuneo',
                    'Emilia-Romagna','FC','FE','Ferrara','FI','Firenze','FO','Forli-Cesena',
                    'FR','Friuli-Venezia Giulia','Frosinone','GE','Genova','GO','Gorizia',
                    'GR','Grosseto','IM','Imperia','La Spezia','Latina','Lazio','LC','Lecco',
                    'LI','Liguria','Livorno','LO','Lodi','Lombardia','LT','LU','Lucca','Mantova',
                    'Massa Carrara','MB','MI','Milano','MN','MO','Modena','Monza e della Brianza',
                    'MS','NO','Novara','Padova','Parma','Pavia','PC','PD','Perugia','PG','PI',
                    'Piacenza','Piemonte','Pisa','Pistoia','PN','PO','Pordenone','PR','Prato',
                    'PT','PV','RA','Ravenna','RE','Reggio Emilia','RI','Rieti','Rimini','RM','RN',
                    'RO','Roma','Rovigo','Savona','SI','Siena','SO','Sondrio','SP','SV','Terni',
                    'TN','TO','Torino','Toscana','TR','Trentino-Alto Adige','Trento','Treviso',
                    'Trieste','TS','TV','UD','Udine','Umbria','VA','Varese','VB','VC','VE','Veneto',
                    'Venezia','Verbano','Vercelli','Verona','VI','Vicenza','Viterbo','VR','VT'};
                if(setScore1States.contains(ld.state)){
                    score += 1;
                }
                else if(setScore3States.contains(ld.state)){
                    score += 3;
                }
                //Step-5
                if(ld.Want_to_buy_kits__c){
                    score += 3;
                }
                //Step-6
                if(!ld.Immediate_Interest_in_Pricing__c){
                    score += 3;
                }
            }   
            
            //Set score and Rating
            if(ld.Proposal_Partner_Type__c != '' && ld.Proposal_Partner_Type__c != null){
                ld.LeadScore__c = score ;       
            }   
            if(ld.Proposal_Partner_Type__c == 'Authorized'||ld.Proposal_Partner_Type__c == 'SunPower Residential Installer'){                               
                if(score > 19){
                    ld.Rating = 'A';
                }
                else if(score == 18 || score == 19){
                    ld.Rating = 'B';
                }
                else{
                    ld.Rating = 'C';
                }
            }
            else if(ld.Proposal_Partner_Type__c == 'New to Solar'){
                if(score > 15){
                    ld.Rating = 'A';
                }
                else if(score >= 12){
                    ld.Rating = 'B';
                }
                else{
                    ld.Rating = 'C';
                }
            }   
            else if(ld.Proposal_Partner_Type__c == '' || ld.Proposal_Partner_Type__c == null){
                ld.Rating = '';
            }
            
            //Do not allow the Leads with rating C to convert   
            //if(ld.isConverted && ld.Rating == 'C'){
            //  ld.addError('Lead with Rating C can not be converted.');
            //}         
        //}
    }   
}