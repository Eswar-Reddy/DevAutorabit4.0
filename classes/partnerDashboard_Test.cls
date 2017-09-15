@isTest(SeeAllData=true)
private class partnerDashboard_Test
{
  //Test for Italian Partner User
  public static testmethod void TM1()
  {
    Test.startTest();     
    PageReference pageRef = Page.partnerDashboard;
    Test.setCurrentPage(pageRef);
    partnerDashboard controller = new partnerDashboard();

    List<SelectOption> lstPortalUser = controller.getPortalUserItems();

    for(SelectOption selOpt : lstPortalUser ) 
    { 
        String userSelected = selOpt.getValue();
        if(selOpt.getValue() != '-1' && selOpt.getValue().contains('--') && selOpt.getValue().split('--')[1] == 'it')
        {
            controller.propSelPartenr =  userSelected;     
            controller.propPortalUsrId = userSelected;
            controller.propPeriod = '2012-02-01--2012-07-07';
            controller.ChangePortalUser();  
            
            String strAcc   = controller.getAccountName();
            String strSDt   = controller.getSinceDate();
            String strPTier = controller.getpartnerTier();
            String strPType = controller.getPartnerType();
            String strAThe  = controller.getAccTheatre();
            String strVEFD  = controller.getValidEvalFromDate();
            String strVETD  = controller.getValidEvalToDate();          
            //Contact c = controller.getContact();
            List<SelectOption> lstSelOpt = controller.getItems();
            
            Decimal dec1 = controller.ConvertToDecimal('$ 234.997');
            Decimal dec2 = controller.ConvertToDecimal('234.997 €');
            
            Date d1 = controller.ChangetoDate('2012-3-29--2012-3-30', 'SD');
            Date d2 = controller.ChangetoDate('2012-3-29--2012-3-30', 'ED');
            
            String cur1 = partnerDashboard.DecimaltoCurrency(9999.999);           
            String cur2 = partnerDashboard.DecimaltoCurrency(0);
            
            String cur12 = controller.currencyFormat('$20000');
            String cur22 = controller.currencyFormat('$20000.1');
            String cur32 = controller.currencyFormat('$20000.12');
            String cur42 = controller.currencyFormat('$20000.123');

            String cur11 = controller.currencyFormat('20000€');
            String cur21 = controller.currencyFormat('20000.1€');
            String cur31 = controller.currencyFormat('20000.12€');
            String cur41 = controller.currencyFormat('20000.123€'); 

            partnerDashboard.WrapMet wrap = new partnerDashboard.WrapMet(String.valueOf(DateTime.now().getTime()),
                                                                        String.valueOf(DateTime.now().getTime()),
                                                                        Double.valueOf('100.01'),
                                                                        String.valueOf(DateTime.now().getTime()),
                                                                        Double.valueOf('101.01'),
                                                                        String.valueOf(DateTime.now().getTime()),
                                                                        Double.valueOf('102.01'),
                                                                        String.valueOf(DateTime.now().getTime()),
                                                                        String.valueOf(DateTime.now().getTime()),
                                                                        String.valueOf(DateTime.now().getTime()),
                                                                        String.valueOf(DateTime.now().getTime()),
                                                                        String.valueOf(DateTime.now().getTime()),
                                                                        String.valueOf(DateTime.now().getTime()),
                                                                        String.valueOf(DateTime.now().getTime()),
                                                                        String.valueOf(DateTime.now().getTime()),
                                                                        String.valueOf(DateTime.now().getTime()),
                                                                        String.valueOf(DateTime.now().getTime()),
                                                                        String.valueOf(DateTime.now().getTime()),
                                                                        true,
                                                                        String.valueOf(DateTime.now().getTime()),
                                                                        String.valueOf(DateTime.now().getTime()));                                                                      
            break; 
        }
    }
    Test.stopTest();   
  }//End Test TM1
  
  //Test for Spanish Partner User
  public static testmethod void TM2()
  {
    Test.startTest();   
    PageReference pageRef = Page.partnerDashboard;
    Test.setCurrentPage(pageRef);
    partnerDashboard controller = new partnerDashboard();

    List<SelectOption> lstPortalUser = controller.getPortalUserItems();

    for(SelectOption selOpt : lstPortalUser ) 
    { 
        String userSelected = selOpt.getValue();
        if(selOpt.getValue() != '-1' && selOpt.getValue().contains('--') && selOpt.getValue().split('--')[1] == 'es')
        {
            controller.propSelPartenr =  userSelected;     
            controller.propPortalUsrId = userSelected;
            controller.propPeriod = '2012-02-01--2012-07-07';                
            controller.ChangePortalUser();  
            
            String strAcc   = controller.getAccountName();
            String strSDt   = controller.getSinceDate();
            String strPTier = controller.getpartnerTier();
            String strPType = controller.getPartnerType();
            String strAThe  = controller.getAccTheatre();
            String strVEFD  = controller.getValidEvalFromDate();
            String strVETD  = controller.getValidEvalToDate();          

            List<SelectOption> lstSelOpt = controller.getItems();
            
            Decimal dec1 = controller.ConvertToDecimal('$ 234.997');
            Decimal dec2 = controller.ConvertToDecimal('234.997 €');
            
            Date d1 = controller.ChangetoDate('2012-3-29--2012-3-30', 'SD');
            Date d2 = controller.ChangetoDate('2012-3-29--2012-3-30', 'ED');
            
            String cur1 = partnerDashboard.DecimaltoCurrency(9999.999);           
            String cur2 = partnerDashboard.DecimaltoCurrency(0);
            
            String cur12 = controller.currencyFormat('$20000');
            String cur22 = controller.currencyFormat('$20000.1');
            String cur32 = controller.currencyFormat('$20000.12');
            String cur42 = controller.currencyFormat('$20000.123');

            String cur11 = controller.currencyFormat('20000€');
            String cur21 = controller.currencyFormat('20000.1€');
            String cur31 = controller.currencyFormat('20000.12€');
            String cur41 = controller.currencyFormat('20000.123€');  
            
            partnerDashboard.WrapMet wrap = new partnerDashboard.WrapMet(String.valueOf(DateTime.now().getTime()),
                                                            String.valueOf(DateTime.now().getTime()),
                                                            Double.valueOf('100.01'),
                                                            String.valueOf(DateTime.now().getTime()),
                                                            Double.valueOf('101.01'),
                                                            String.valueOf(DateTime.now().getTime()),
                                                            Double.valueOf('102.01'),
                                                            String.valueOf(DateTime.now().getTime()),
                                                            String.valueOf(DateTime.now().getTime()),
                                                            String.valueOf(DateTime.now().getTime()),
                                                            String.valueOf(DateTime.now().getTime()),
                                                            String.valueOf(DateTime.now().getTime()),
                                                            String.valueOf(DateTime.now().getTime()),
                                                            String.valueOf(DateTime.now().getTime()),
                                                            String.valueOf(DateTime.now().getTime()),
                                                            String.valueOf(DateTime.now().getTime()),
                                                            String.valueOf(DateTime.now().getTime()),
                                                            String.valueOf(DateTime.now().getTime()),
                                                            true,
                                                            String.valueOf(DateTime.now().getTime()),
                                                            String.valueOf(DateTime.now().getTime()));                                  
            break;
        }
    }
    Test.stopTest();
  }//End Test TM2

  //Test for French Partner User  
  public static testmethod void TM3()
  {
     Test.startTest();  
    PageReference pageRef = Page.partnerDashboard;
    Test.setCurrentPage(pageRef);
    partnerDashboard controller = new partnerDashboard();

    List<SelectOption> lstPortalUser = controller.getPortalUserItems();

    for(SelectOption selOpt : lstPortalUser ) 
    { 
        String userSelected = selOpt.getValue();
        if(selOpt.getValue() != '-1' && selOpt.getValue().contains('--') && selOpt.getValue().split('--')[1] == 'fr')
        {
            controller.propSelPartenr =  userSelected;     
            controller.propPortalUsrId = userSelected;
            controller.propPeriod = '2012-02-01--2012-07-07';               
            controller.ChangePortalUser();  
            
            String strAcc   = controller.getAccountName();
            String strSDt   = controller.getSinceDate();
            String strPTier = controller.getpartnerTier();
            String strPType = controller.getPartnerType();
            String strAThe  = controller.getAccTheatre();
            String strVEFD  = controller.getValidEvalFromDate();
            String strVETD  = controller.getValidEvalToDate();          
            //Contact c = controller.getContact();
            List<SelectOption> lstSelOpt = controller.getItems();
            
            Decimal dec1 = controller.ConvertToDecimal('$ 234.997');
            Decimal dec2 = controller.ConvertToDecimal('234.997 €');
            
            Date d1 = controller.ChangetoDate('2012-3-29--2012-3-30', 'SD');
            Date d2 = controller.ChangetoDate('2012-3-29--2012-3-30', 'ED');
            
            String cur1 = partnerDashboard.DecimaltoCurrency(9999.999);           
            String cur2 = partnerDashboard.DecimaltoCurrency(0);
            
            String cur12 = controller.currencyFormat('$20000');
            String cur22 = controller.currencyFormat('$20000.1');
            String cur32 = controller.currencyFormat('$20000.12');
            String cur42 = controller.currencyFormat('$20000.123');

            String cur11 = controller.currencyFormat('20000€');
            String cur21 = controller.currencyFormat('20000.1€');
            String cur31 = controller.currencyFormat('20000.12€');
            String cur41 = controller.currencyFormat('20000.123€');
            partnerDashboard.WrapMet wrap = new partnerDashboard.WrapMet(String.valueOf(DateTime.now().getTime()),
                                                                        String.valueOf(DateTime.now().getTime()),
                                                                        Double.valueOf('100.01'),
                                                                        String.valueOf(DateTime.now().getTime()),
                                                                        Double.valueOf('101.01'),
                                                                        String.valueOf(DateTime.now().getTime()),
                                                                        Double.valueOf('102.01'),
                                                                        String.valueOf(DateTime.now().getTime()),
                                                                        String.valueOf(DateTime.now().getTime()),
                                                                        String.valueOf(DateTime.now().getTime()),
                                                                        String.valueOf(DateTime.now().getTime()),
                                                                        String.valueOf(DateTime.now().getTime()),
                                                                        String.valueOf(DateTime.now().getTime()),
                                                                        String.valueOf(DateTime.now().getTime()),
                                                                        String.valueOf(DateTime.now().getTime()),
                                                                        String.valueOf(DateTime.now().getTime()),
                                                                        String.valueOf(DateTime.now().getTime()),
                                                                        String.valueOf(DateTime.now().getTime()),
                                                                        true,
                                                                        String.valueOf(DateTime.now().getTime()),
                                                                        String.valueOf(DateTime.now().getTime()));
            break;
        }
    }
    Test.stopTest();     
  }//End Test TM3 

  //Test for Italian German User  
  public static testmethod void TM4()
  {
    Test.startTest();
    PageReference pageRef = Page.partnerDashboard;
    Test.setCurrentPage(pageRef);
    partnerDashboard controller = new partnerDashboard();

    List<SelectOption> lstPortalUser = controller.getPortalUserItems();
     
    for(SelectOption selOpt : lstPortalUser ) 
    { 
        String userSelected = selOpt.getValue();
        if(selOpt.getValue() != '-1' && selOpt.getValue().contains('--') && selOpt.getValue().split('--')[1] == 'de')
        {
            controller.propSelPartenr =  userSelected;     
            controller.propPortalUsrId = userSelected;
            controller.propPeriod = '2012-02-01--2012-07-07';                
            controller.ChangePortalUser();  
            
            String strAcc   = controller.getAccountName();
            String strSDt   = controller.getSinceDate();
            String strPTier = controller.getpartnerTier();
            String strPType = controller.getPartnerType();
            String strAThe  = controller.getAccTheatre();
            String strVEFD  = controller.getValidEvalFromDate();
            String strVETD  = controller.getValidEvalToDate();          

            List<SelectOption> lstSelOpt = controller.getItems();
            
            Decimal dec1 = controller.ConvertToDecimal('$ 234.997');
            Decimal dec2 = controller.ConvertToDecimal('234.997 €');
            
            Date d1 = controller.ChangetoDate('2012-3-29--2012-3-30', 'SD');
            Date d2 = controller.ChangetoDate('2012-3-29--2012-3-30', 'ED');
            
            String cur1 = partnerDashboard.DecimaltoCurrency(9999.999);           
            String cur2 = partnerDashboard.DecimaltoCurrency(0);
            
            String cur12 = controller.currencyFormat('$20000');
            String cur22 = controller.currencyFormat('$20000.1');
            String cur32 = controller.currencyFormat('$20000.12');
            String cur42 = controller.currencyFormat('$20000.123');

            String cur11 = controller.currencyFormat('20000€');
            String cur21 = controller.currencyFormat('20000.1€');
            String cur31 = controller.currencyFormat('20000.12€');
            String cur41 = controller.currencyFormat('20000.123€');
                                            

            partnerDashboard.WrapMet wrap = new partnerDashboard.WrapMet(String.valueOf(DateTime.now().getTime()),
                                                            String.valueOf(DateTime.now().getTime()),
                                                            Double.valueOf('100.01'),
                                                            String.valueOf(DateTime.now().getTime()),
                                                            Double.valueOf('101.01'),
                                                            String.valueOf(DateTime.now().getTime()),
                                                            Double.valueOf('102.01'),
                                                            String.valueOf(DateTime.now().getTime()),
                                                            String.valueOf(DateTime.now().getTime()),
                                                            String.valueOf(DateTime.now().getTime()),
                                                            String.valueOf(DateTime.now().getTime()),
                                                            String.valueOf(DateTime.now().getTime()),
                                                            String.valueOf(DateTime.now().getTime()),
                                                            String.valueOf(DateTime.now().getTime()),
                                                            String.valueOf(DateTime.now().getTime()),
                                                            String.valueOf(DateTime.now().getTime()),
                                                            String.valueOf(DateTime.now().getTime()),
                                                            String.valueOf(DateTime.now().getTime()),
                                                            true,
                                                            String.valueOf(DateTime.now().getTime()),
                                                            String.valueOf(DateTime.now().getTime()));                                                                                     
            break;
        }
    }
    Test.stopTest();
  }//End Test TM4

  //Test for Dutch Partner User  
  public static testmethod void TM5()
  {
    Test.startTest();    
    PageReference pageRef = Page.partnerDashboard;
    Test.setCurrentPage(pageRef);
    partnerDashboard controller = new partnerDashboard();

    List<SelectOption> lstPortalUser = controller.getPortalUserItems();

    for(SelectOption selOpt : lstPortalUser ) 
    { 
        String userSelected = selOpt.getValue();
        if(selOpt.getValue() != '-1' && selOpt.getValue().contains('--') && selOpt.getValue().split('--')[1] == 'nl_NL')
        {
            controller.propSelPartenr =  userSelected;     
            controller.propPortalUsrId = userSelected;
            controller.propPeriod = '2012-02-01--2012-07-07';                 
            controller.ChangePortalUser();  
            
            String strAcc   = controller.getAccountName();
            String strSDt   = controller.getSinceDate();
            String strPTier = controller.getpartnerTier();
            String strPType = controller.getPartnerType();
            String strAThe  = controller.getAccTheatre();
            String strVEFD  = controller.getValidEvalFromDate();
            String strVETD  = controller.getValidEvalToDate();          
            //Contact c = controller.getContact();
            List<SelectOption> lstSelOpt = controller.getItems();
            
            Decimal dec1 = controller.ConvertToDecimal('$ 234.997');
            Decimal dec2 = controller.ConvertToDecimal('234.997 €');
            
            Date d1 = controller.ChangetoDate('2012-3-29--2012-3-30', 'SD');
            Date d2 = controller.ChangetoDate('2012-3-29--2012-3-30', 'ED');
            
            String cur1 = partnerDashboard.DecimaltoCurrency(9999.999);           
            String cur2 = partnerDashboard.DecimaltoCurrency(0);
            
            String cur12 = controller.currencyFormat('$20000');
            String cur22 = controller.currencyFormat('$20000.1');
            String cur32 = controller.currencyFormat('$20000.12');
            String cur42 = controller.currencyFormat('$20000.123');

            String cur11 = controller.currencyFormat('20000€');
            String cur21 = controller.currencyFormat('20000.1€');
            String cur31 = controller.currencyFormat('20000.12€');
            String cur41 = controller.currencyFormat('20000.123€'); 
            partnerDashboard.WrapMet wrap = new partnerDashboard.WrapMet(String.valueOf(DateTime.now().getTime()),
                                                            String.valueOf(DateTime.now().getTime()),
                                                            Double.valueOf('100.01'),
                                                            String.valueOf(DateTime.now().getTime()),
                                                            Double.valueOf('101.01'),
                                                            String.valueOf(DateTime.now().getTime()),
                                                            Double.valueOf('102.01'),
                                                            String.valueOf(DateTime.now().getTime()),
                                                            String.valueOf(DateTime.now().getTime()),
                                                            String.valueOf(DateTime.now().getTime()),
                                                            String.valueOf(DateTime.now().getTime()),
                                                            String.valueOf(DateTime.now().getTime()),
                                                            String.valueOf(DateTime.now().getTime()),
                                                            String.valueOf(DateTime.now().getTime()),
                                                            String.valueOf(DateTime.now().getTime()),
                                                            String.valueOf(DateTime.now().getTime()),
                                                            String.valueOf(DateTime.now().getTime()),
                                                            String.valueOf(DateTime.now().getTime()),
                                                            true,
                                                            String.valueOf(DateTime.now().getTime()),
                                                            String.valueOf(DateTime.now().getTime()));                                              
            break; 
        }
    }
    Test.stopTest(); 
  }//End Test TM5 

  //Test for English Partner User  
  public static testmethod void TM6()
  {
    Test.startTest();   
    PageReference pageRef = Page.partnerDashboard;
    Test.setCurrentPage(pageRef);
    partnerDashboard controller = new partnerDashboard();

    List<SelectOption> lstPortalUser = controller.getPortalUserItems();

    for(SelectOption selOpt : lstPortalUser ) 
    { 
        String userSelected = selOpt.getValue();
        if(selOpt.getValue() != '-1' && selOpt.getValue().contains('--') && selOpt.getValue().split('--')[1] == 'en_US')
        {
            controller.propSelPartenr =  userSelected;     
            controller.propPortalUsrId = userSelected;
            controller.propPeriod = '2012-02-01--2012-07-07';                
            controller.ChangePortalUser();  
            
            String strAcc   = controller.getAccountName();
            String strSDt   = controller.getSinceDate();
            String strPTier = controller.getpartnerTier();
            String strPType = controller.getPartnerType();
            String strAThe  = controller.getAccTheatre();
            String strVEFD  = controller.getValidEvalFromDate();
            String strVETD  = controller.getValidEvalToDate();          

            List<SelectOption> lstSelOpt = controller.getItems();
            
            Decimal dec1 = controller.ConvertToDecimal('$ 234.997');
            Decimal dec2 = controller.ConvertToDecimal('234.997 €');
            
            Date d1 = controller.ChangetoDate('2012-3-29--2012-3-30', 'SD');
            Date d2 = controller.ChangetoDate('2012-3-29--2012-3-30', 'ED');
            
            String cur1 = partnerDashboard.DecimaltoCurrency(9999.999);           
            String cur2 = partnerDashboard.DecimaltoCurrency(0);
            
            String cur12 = controller.currencyFormat('$20000');
            String cur22 = controller.currencyFormat('$20000.1');
            String cur32 = controller.currencyFormat('$20000.12');
            String cur42 = controller.currencyFormat('$20000.123');

            String cur11 = controller.currencyFormat('20000€');
            String cur21 = controller.currencyFormat('20000.1€');
            String cur31 = controller.currencyFormat('20000.12€');
            String cur41 = controller.currencyFormat('20000.123€'); 
            
            partnerDashboard.WrapMet wrap = new partnerDashboard.WrapMet(String.valueOf(DateTime.now().getTime()),
                                                                        String.valueOf(DateTime.now().getTime()),
                                                                        Double.valueOf('100.01'),
                                                                        String.valueOf(DateTime.now().getTime()),
                                                                        Double.valueOf('101.01'),
                                                                        String.valueOf(DateTime.now().getTime()),
                                                                        Double.valueOf('102.01'),
                                                                        String.valueOf(DateTime.now().getTime()),
                                                                        String.valueOf(DateTime.now().getTime()),
                                                                        String.valueOf(DateTime.now().getTime()),
                                                                        String.valueOf(DateTime.now().getTime()),
                                                                        String.valueOf(DateTime.now().getTime()),
                                                                        String.valueOf(DateTime.now().getTime()),
                                                                        String.valueOf(DateTime.now().getTime()),
                                                                        String.valueOf(DateTime.now().getTime()),
                                                                        String.valueOf(DateTime.now().getTime()),
                                                                        String.valueOf(DateTime.now().getTime()),
                                                                        String.valueOf(DateTime.now().getTime()),
                                                                        true,
                                                                        String.valueOf(DateTime.now().getTime()),
                                                                        String.valueOf(DateTime.now().getTime()));                                                                                   
            break;          
        }
    }
    Test.stopTest();   
  }//End Test TM6        
}//End Class partnerDashboard_Test