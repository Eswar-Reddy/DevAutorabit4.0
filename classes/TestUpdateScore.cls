/**************************************************
** PR- 01923
**Created By- Harsh Mathur
**Created On- June 11 2009
**Last Modified- Harsh Mathur 
**Last Modified On-  June 17 2009 
**Desciption- Test class for controller UpdateScore
*****************************************************/
@isTest
private class TestUpdateScore
{
    @isTest
  public static void checkUpdateScore(){
  	
    DealerUtility.bulkLeadTest = TRUE;

    Map<String, Schema.RecordTypeInfo> nameToLeadRecordTypeInfoMap = LeadManagement.nameToLeadRecordTypeInfoMap;
    List<Lead> leadList = new List<Lead>();
    Lead leadObj = new Lead();
    leadObj.Company = 'Test' + DateTime.now();
    leadObj.LastName = 'Test' + DateTime.now();
    leadObj.Lead_Type__c = 'Residential';   
    leadObj.Theater__c = 'North America'; 
    leadObj.Ground_Roof_Space__c= '255';
    leadObj.Roof_Material__c ='Membrane';
    leadObj.Age_Of_Roof__c= '> 15 yrs';
    leadObj.Time_Of_Installation__c='> 6 months';
    leadObj.Average_Monthly_Electricity_Bill__c = '< $50';
    leadObj.Country= 'Italy';
    leadObj.System_Size_in_KWp__c= '< 500';
    leadObj.Email = 'abcTest1@test.com';
    leadObj.LeadSource = 'Web';
    leadList.add(leadObj);
    
    Lead leadObj1 = new Lead();
    leadObj1.Company = 'Test1' + DateTime.now();
    leadObj1.LastName = 'Test1' + DateTime.now();
    leadObj1.Lead_Type__c = 'Commercial';
    leadObj1.Permitting__c='Not Initiated';
    leadObj1.Ground_Roof_Space__c= '255';
    leadObj1.Roof_Material__c ='Membrane';
    leadObj1.Age_Of_Roof__c= '> 15 yrs';
    leadObj1.Time_Of_Installation__c='> 12 months';
    leadObj1.Average_Monthly_Electricity_Bill__c = '< $50';
    leadObj1.Theater__c = 'NA';
    leadObj1.Country= 'Italy';
    leadObj1.System_Size_in_KWp__c= '< 500';
    leadObj1.Email = 'abcTest2@test.com';
    leadObj1.LeadSource = 'Web';
    leadList.add(leadObj1);
    
    Lead leadObj2 = new Lead();
    leadObj2.Company = 'Test' + DateTime.now();
    leadObj2.LastName = 'Test' + DateTime.now();
    leadObj2.Lead_Type__c = 'Residential';   
    leadObj2.Theater__c = 'North America'; 
    leadObj2.Ground_Roof_Space__c= '245';
    leadObj2.Roof_Material__c ='Corrugated Metal';
    leadObj2.Age_Of_Roof__c= '> 10 yrs';
    leadObj2.Time_Of_Installation__c='> 3 months';
    leadObj2.Average_Monthly_Electricity_Bill__c = '> $50';
    leadObj2.Country= 'Portugal';
    leadObj2.System_Size_in_KWp__c= '> 500';
    leadObj2.Email = 'abcTest3@test.com';
    leadObj2.LeadSource = 'Web';
    leadList.add(leadObj2);
    
    Lead leadObj3 = new Lead();
    leadObj3.Company = 'Test' + DateTime.now();
    leadObj3.LastName = 'Test' + DateTime.now();
    leadObj3.Lead_Type__c = 'Residential';   
    leadObj3.Theater__c = 'North America'; 
    leadObj3.Ground_Roof_Space__c= '550';
    leadObj3.Roof_Material__c ='Metal Standing';
    leadObj3.Age_Of_Roof__c= '> 5 yrs';
    leadObj3.Time_Of_Installation__c='< 2 months';
    leadObj3.Average_Monthly_Electricity_Bill__c = '> $150';
    leadObj3.Country= 'Portugal';
    leadObj3.System_Size_in_KWp__c= '> 500';
    leadObj3.Email = 'abcTest4@test.com';
    leadObj3.LeadSource = 'Web';
    leadList.add(leadObj3);
    
    Lead leadObj4 = new Lead();
    leadObj4.Company = 'Test' + DateTime.now();
    leadObj4.LastName = 'Test' + DateTime.now();
    leadObj4.Lead_Type__c = 'Residential';   
    leadObj4.Theater__c = 'North America'; 
    leadObj4.Ground_Roof_Space__c= '550';
    leadObj4.Roof_Material__c ='Asphalt Shingle';
    leadObj4.Age_Of_Roof__c= '< 5 yrs';
    leadObj4.Time_Of_Installation__c='< 1 month';
    leadObj4.Average_Monthly_Electricity_Bill__c = '> $300';
    leadObj4.Country= 'Portugal';
    leadObj4.System_Size_in_KWp__c= '> 500';
    leadObj4.Email = 'abcTest5@test.com';
    leadObj4.LeadSource = 'Web';
    leadList.add(leadObj4);
    
    Lead leadObj5 = new Lead();
    leadObj5.Company = 'Test' + DateTime.now();
    leadObj5.LastName = 'Test' + DateTime.now();
    leadObj5.Lead_Type__c = 'Residential';   
    leadObj5.Theater__c = 'Europe'; 
    leadObj5.Ground_Roof_Space__c= '550';
    leadObj5.Roof_Material__c ='Asphalt Shingle';
    leadObj5.Age_Of_Roof__c= '> 6 months';
    leadObj5.Time_Of_Installation__c='> 6 months';
    leadObj5.Average_Monthly_Electricity_Bill__c = '> $300';
    leadObj5.Country= 'Portugal';
    leadObj5.System_Size_in_KWp__c= '> 500';
    leadObj5.Email = 'abcTest6@test.com';
    leadObj5.LeadSource = 'Web';
    leadList.add(leadObj5);
    
    Lead leadObj6 = new Lead();
    leadObj6.Company = 'Test' + DateTime.now();
    leadObj6.LastName = 'Test' + DateTime.now();
    leadObj6.Lead_Type__c = 'Residential';   
    leadObj6.Theater__c = 'Europe'; 
    leadObj6.Ground_Roof_Space__c= '550';
    leadObj6.Roof_Material__c ='Asphalt Shingle';
    leadObj6.Age_Of_Roof__c= '> 6 months';
    leadObj6.Time_Of_Installation__c='< 1 month';
    leadObj6.Average_Monthly_Electricity_Bill__c = '> $300';
    leadObj6.Country= 'Spain';
    leadObj6.System_Size_in_KWp__c= '< 500';
    leadObj6.Email = 'abcTest7@test.com';
    leadObj6.LeadSource = 'Web';
    leadList.add(leadObj6);
    
  for(Integer i=1 ; i<41; i++)
  {
      Lead leadObject = new Lead();
      if(i<=18)      
      	leadObject.RecordTypeId = nameToLeadRecordTypeInfoMap.get('Systems').getRecordTypeId();
      else if(i<=23)
      	leadObject.RecordTypeId = nameToLeadRecordTypeInfoMap.get('New Homes').getRecordTypeId();
      else if(i<=40)
      	leadObject.RecordTypeId = nameToLeadRecordTypeInfoMap.get('Partner').getRecordTypeId();
      leadObject.Company = 'Test' + DateTime.now();
      leadObject.LastName = 'Test'+(i+7)+' ' + DateTime.now();
      leadObject.Email = 'abcTest'+(i+7)+'@test.com';
      leadObject.LeadSource = 'Web';
      leadObject.Business_Unit__c = 'RLC';
      leadObject.Phone = i*100000+'';
      if(i<=12)   
      	leadObject.Theater__c = 'Europe'; 
      else if(i<=18)
      	leadObject.Theater__c = 'Australia';
      else if(i<=23)
      	leadObject.Theater__c = 'North America';
      else if(i<=40){
      	leadObject.Theater__c = 'Europe';
      	leadObject.Street = 'Not null';
      } 
      if(i==1)
      {
              leadObject.Installation_Type__c= 'Flat Roof';
              leadObject.Time_Of_Installation__c='> 6 months';
              leadObject.Did_you_apply_for_financing__c = True;
     }
      if(i==2)
      {
              leadObject.Installation_Type__c= 'Flat Roof';
              leadObject.Time_Of_Installation__c='> 3 months';
              leadObject.Did_you_apply_for_financing__c = True;
      }
      if(i==3 || i==13)
      {
              leadObject.Installation_Type__c= 'Slope Roof';
              leadObject.Time_Of_Installation__c='> 3 months';
              leadObject.Did_you_apply_for_financing__c = True;
              leadObject.Roof_Orientation__c = 'South';
      }
      if(i==4 || i==14)
      {
              leadObject.Installation_Type__c= 'Slope Roof';
              leadObject.Time_Of_Installation__c='> 6 months';
              leadObject.Did_you_apply_for_financing__c = True;
              leadObject.Roof_Orientation__c = 'South';
      }
       if(i==5 || i==15)
      {
             leadObject.Installation_Type__c= 'Slope Roof';
              leadObject.Time_Of_Installation__c='> 3 months';
              leadObject.Did_you_apply_for_financing__c = True;
              leadObject.Roof_Orientation__c = 'West';
      }
       if(i==6 || i==16)
      {
             leadObject.Installation_Type__c= 'Slope Roof';
              leadObject.Time_Of_Installation__c='> 6 months';
              leadObject.Did_you_apply_for_financing__c = True;
              leadObject.Roof_Orientation__c = 'West';
      }
       if(i==7 || i == 17)
      {
              leadObject.Installation_Type__c= 'Slope Roof';
              leadObject.Time_Of_Installation__c='> 3 months';
              leadObject.Did_you_apply_for_financing__c = True;
              leadObject.Roof_Orientation__c = 'North';
      }
       if(i==8 || i == 18)
      {
              leadObject.Installation_Type__c= 'Slope Roof';
              leadObject.Time_Of_Installation__c='> 6 months';
              leadObject.Did_you_apply_for_financing__c = True;
              leadObject.Roof_Orientation__c = 'North';
      }
       if(i==9)
      {
             leadObject.Installation_Type__c= 'Slope Roof';
              leadObject.Time_Of_Installation__c='> 6 months';
              leadObject.Did_you_apply_for_financing__c = false;
              leadObject.Roof_Orientation__c = 'West';
      }
       if(i==10)
      {
             leadObject.Installation_Type__c= 'Flat Roof';
              leadObject.Time_Of_Installation__c='> 5 months';
              leadObject.Did_you_apply_for_financing__c = True;
      }
       if(i==11)
      {
             leadObject.Installation_Type__c= 'Flat Roof';
              leadObject.Time_Of_Installation__c = null;
              leadObject.Did_you_apply_for_financing__c = false;
      }
       if(i==12)
      {
             leadObject.Installation_Type__c= 'Flat Roof';
              leadObject.Time_Of_Installation__c = '< 1 month';
              leadObject.Did_you_apply_for_financing__c = false;
      }
      
      
       if(i==19)
      {
             leadObject.System_Size_in_KWp__c = '> 1000';
             leadObject.State = 'New';
             leadObject.Permitting__c='Approved';
      }
         if(i==20)
      {
             leadObject.Homes_Built_per_year__c = '< 500';
             leadObject.State = 'California';
             leadObject.Number_Of_States__c='1';
             leadObject.Number_of_Sites_to_Install_Solar__c ='< 25';
      }
         if(i==21)
      {
             leadObject.Homes_Built_per_year__c = '500 - 1000';
             leadObject.State = null;
             leadObject.Number_Of_States__c='2';
             leadObject.Number_of_Sites_to_Install_Solar__c ='25 - 50';
      }
         if(i==22)
      {
             leadObject.Homes_Built_per_year__c = '1000 - 2000';
             leadObject.state = 'California';
             leadObject.Number_Of_States__c='3 +';
             leadObject.Number_of_Sites_to_Install_Solar__c ='51 - 75';
      }
         if(i==23)
      {
             leadObject.Homes_Built_per_year__c = '> 2000';
             leadObject.state = 'California';
             leadObject.Number_Of_States__c=null;
             leadObject.Number_of_Sites_to_Install_Solar__c ='> 75';
      }
      
      
      
      if(i==24)
      {
             leadObject.Country = 'Spain';
             leadObject.Does_Company_Install_PV_Distribute__c='Distribute';
             leadObject.Registry_Presence__c = 'No Presence';
             leadObject.Immediate_Interest_in_Pricing__c = True;
      }
         if(i==25)
      {
             leadObject.Country = 'Spain';
             leadObject.Does_Company_Install_PV_Distribute__c='Install';
             leadObject.Registry_Presence__c = '1st and 2nd';
             leadObject.Immediate_Interest_in_Pricing__c = True;
      }
         if(i==26)
      {
             leadObject.Country = 'Spain';
             leadObject.Does_Company_Install_PV_Distribute__c='Both';
             leadObject.Registry_Presence__c = '3rd and 4th';
             leadObject.Immediate_Interest_in_Pricing__c = False;
      }
         if(i==27)
      {
             leadObject.Country = null;
             leadObject.Does_Company_Install_PV_Distribute__c='Distribute';
             leadObject.Registry_Presence__c = 'No Presence';
             leadObject.Immediate_Interest_in_Pricing__c = True;
      }
          if(i==28)
      {
             leadObject.Country = 'France';
             leadObject.Size_of_Projects__c=  '< 20 KW';
             leadObject.Does_Company_Install_PV_Distribute__c='Distribute';
             leadObject.Total_Experience_in_Solar_Business__c = '< 1 year';
             leadObject.Has_Engineering_and_Sales_Resources__c = True;
             leadObject.Immediate_Interest_in_Pricing__c =True;
      }
          if(i==29)
      {
             leadObject.Country = 'France';
             leadObject.Size_of_Projects__c=  '< 250 KW';
             leadObject.Does_Company_Install_PV_Distribute__c='Both';
             leadObject.Total_Experience_in_Solar_Business__c = 'News to Solar Business';
             leadObject.Has_Engineering_and_Sales_Resources__c = False;
             leadObject.Immediate_Interest_in_Pricing__c =True;
      }
          if(i==30)
      {
             leadObject.Country = 'France';
             leadObject.Size_of_Projects__c=  '> 250 KW';
             leadObject.Does_Company_Install_PV_Distribute__c='Install';
             leadObject.Total_Experience_in_Solar_Business__c = 'News to Solar Business';
             leadObject.Has_Engineering_and_Sales_Resources__c = False;
             leadObject.Immediate_Interest_in_Pricing__c =False;
      }
      
      
          if(i==31)
      {
             leadObject.Country = 'Germany';
             leadObject.PostalCode = '33606';
             leadObject.Does_Company_Install_PV_Distribute__c  = 'Distribute';
             leadObject.Focused_on_Ground_Mounted_Systems__c= True;
             leadObject.Has_Rooftop_Experience__c= True;
             leadObject.Total_Experience_in_Solar_Business__c = '< 1 year';
             leadObject.Has_Engineering_and_Sales_Resources__c  = True;
             leadObject.Large_Systems_Experience__c =True;
             leadObject.Immediate_Interest_in_Pricing__c = True;
      }
          if(i==32)
      {
             leadObject.Country = 'Germany';
             leadObject.PostalCode = '31606';
             leadObject.Does_Company_Install_PV_Distribute__c  = 'Both';
             leadObject.Focused_on_Ground_Mounted_Systems__c= False;
             leadObject.Has_Rooftop_Experience__c= False;
             leadObject.Total_Experience_in_Solar_Business__c = '1 - 2 years';
             leadObject.Has_Engineering_and_Sales_Resources__c  = False;
             leadObject.Large_Systems_Experience__c =False;
             leadObject.Immediate_Interest_in_Pricing__c = False;
      }
      
          if(i==33)
      {
             leadObject.Country = 'Germany';
             leadObject.PostalCode = '71409';
             leadObject.Does_Company_Install_PV_Distribute__c  = 'Install';
             leadObject.Focused_on_Ground_Mounted_Systems__c= False;
             leadObject.Has_Rooftop_Experience__c= False;
             leadObject.Total_Experience_in_Solar_Business__c = '2 - 3 years';
             leadObject.Has_Engineering_and_Sales_Resources__c  = False;
             leadObject.Large_Systems_Experience__c =False;
             leadObject.Immediate_Interest_in_Pricing__c = False;
      }
           if(i==34)
      {
             leadObject.Country = 'Italy';
             leadObject.Does_Company_Install_PV_Distribute__c  = 'Install';
             leadObject.Total_Experience_in_Solar_Business__c= '4 - 5 years';
             leadObject.Has_Rooftop_Experience__c= True;
             leadObject.Has_Engineering_and_Sales_Resources__c  = True;
             leadObject.State  ='Lazio';
             leadObject.Focused_on_Ground_Mounted_Systems__c =True;
             leadObject.Immediate_Interest_in_Pricing__c = True;
      }
        if(i==35)
      {
             leadObject.Country = 'Italy';
             leadObject.Does_Company_Install_PV_Distribute__c  = 'Distribute';
             leadObject.Total_Experience_in_Solar_Business__c= '1 - 2 years';
             leadObject.Has_Rooftop_Experience__c= False;
             leadObject.Has_Engineering_and_Sales_Resources__c  = False;
             leadObject.State  ='Jaipur';
             leadObject.Focused_on_Ground_Mounted_Systems__c =False;
             leadObject.Immediate_Interest_in_Pricing__c = False;
      }
         if(i==36)
      {
             leadObject.Country = 'Italy';
             leadObject.Does_Company_Install_PV_Distribute__c  = 'Both';
             leadObject.Total_Experience_in_Solar_Business__c= '< 1 year';
             leadObject.Has_Rooftop_Experience__c= True;
             leadObject.Has_Engineering_and_Sales_Resources__c  = True;
             leadObject.State  ='Lazio';
             leadObject.Focused_on_Ground_Mounted_Systems__c =True;
             leadObject.Immediate_Interest_in_Pricing__c = False;
      }
          if(i==37)
      {
             leadObject.Country = 'Belgium';
             leadObject.Does_Company_Install_PV_Distribute__c  = 'Distribute';
             leadObject.Total_Experience_in_Solar_Business__c= '1 - 2 years';
             leadObject.State  ='Portugal';
             leadObject.Immediate_Interest_in_Pricing__c = True;
             leadObject.Anticipated_Demand__c ='Average';
      }
           if(i==38)
      {
             leadObject.Country = 'Belgium';
             leadObject.Does_Company_Install_PV_Distribute__c  = 'Both';
             leadObject.Total_Experience_in_Solar_Business__c= 'New to Solar Business';
             leadObject.State  ='Russia';
             leadObject.Immediate_Interest_in_Pricing__c = True;
             leadObject.Anticipated_Demand__c ='Very Low';
      }
          if(i==39)
      {
             leadObject.Country = 'Belgium';
             leadObject.Does_Company_Install_PV_Distribute__c  = 'Install';
             leadObject.Total_Experience_in_Solar_Business__c= '< 1 year';
             leadObject.State  ='Jaipur';
             leadObject.Immediate_Interest_in_Pricing__c = False;
             leadObject.Anticipated_Demand__c ='Full Containers';
      }
      if(i==40)
      {
             leadObject.Country = 'Belgium';
             //leadObject.Does_Company_Install_PV_Distribute__c  = 'Distribute';
             leadObject.Total_Experience_in_Solar_Business__c= 'New to Solar Business';
             leadObject.State  ='Portugal';
             leadObject.Immediate_Interest_in_Pricing__c = True;
             leadObject.Anticipated_Demand__c ='Average';
      }    
           leadList.add(leadObject);  
      
  }
    Test.startTest();
    
    List<Lead> lead1List = new List<Lead>();
    Lead leadObj7 = new Lead();
    leadObj7.RecordTypeId = nameToLeadRecordTypeInfoMap.get('Residential').getRecordTypeId();
    leadObj7.Company = 'Test' + DateTime.now();
    leadObj7.LastName = 'Test' + DateTime.now();
    leadObj7.Lead_Type__c = 'Residential';   
    leadObj7.Theater__c = 'North America'; 
    leadObj7.Ground_Roof_Space__c= '45.55';    
    leadObj7.Email = 'abcTest17@test.com';
    leadObj7.LeadSource = 'Web';
    lead1List.add(leadObj7);
    
    Lead leadObj8 = new Lead();
    leadObj8.Country = 'Germany';
    leadObj8.PostalCode = '5';
    leadObj8.RecordTypeId = nameToLeadRecordTypeInfoMap.get('Partner').getRecordTypeId();
	leadObj8.Company = 'Test' + DateTime.now();
	leadObj8.LastName = 'Test258' + DateTime.now();
	leadObj8.Email = 'abcTest258@test.com';
	leadObj8.LeadSource = 'Web';
	leadObj8.Business_Unit__c = 'RLC';
	leadObj8.Phone = '5497879778789797';
	lead1List.add(leadObj8);
	
	Lead leadObj9 = new Lead();
    leadObj9.Country = 'Germany';
    leadObj9.PostalCode = '555555-5449';
    leadObj9.RecordTypeId = nameToLeadRecordTypeInfoMap.get('Partner').getRecordTypeId();
	leadObj9.Company = 'Test' + DateTime.now();
	leadObj9.LastName = 'Test259' + DateTime.now();
	leadObj9.Email = 'abcTest259@test.com';
	leadObj9.LeadSource = 'Web';
	leadObj9.Business_Unit__c = 'RLC';
	leadObj9.Phone = '549787977878';
	lead1List.add(leadObj9);
	
    try{
    	insert lead1List;
    }catch(DMLException ex){
    	ex.getMessage();
    }
    insert leadList;
    Test.stopTest();
    //JAJA-25-JUNE-2015
    Utility_Lead.BulkConvert(leadList);
    leadlist[0].Source_System__c = 'Eloqua';  
    Utility_lead.setFieldsBasedOnLeadValues(leadlist[0], null);
    Utility_lead.setAutoConvertLeadFields(leadlist[1]);
    Utility_Lead.setAutoConvertLeadFieldsSPD(leadlist[0]);
  }
}