/** Class: ScoreCardUtilityTest
 **Description: This class will use to insert required object records
 **CreatedBy- Raee$
 **CreatedDate: 7/5/2016
 **Desciption- Test class for controller ScoreCard and relatedlist page 
 **/
@isTest(SeeAllData=true)
public with sharing class ScoreCardUtilityTest {
	
	static Account newAccount;
    static Contact newContact;
    static Opportunity newOpportunity;
    static Main_Category__c objMainCategory;
    static Sub_Category__c objSubCategory;
    static Category__c objCategory;
    static Category_Value_Score__c objCategoryValueScore;    
    static List<Category_Value_Score__c> listOfCategoryValueScore;
    
  /* Method:  TestInsertMainCategory
   * Param:   void
   * Retrun:  Main_Category__c
   * Porpose: This utility method used to insert Main_Category__c for Opportunity score card 
   * CreatedBy: Raee$
   * Date: 7/06/2016
   */
    public static Main_Category__c TestInsertMainCategory(){
		objMainCategory = new Main_Category__c();
		objMainCategory.Name = 'Test Main';
		objMainCategory.Active__c = true;
		insert objMainCategory;
		return objMainCategory;
	}
  /* Method:  TestInsertSubCategory
   * Param:   Main_Category__c
   * Retrun:  Sub_Category__c
   * Porpose: This utility method used to insert Sub_Category__c for Opportunity score card 
   * CreatedBy: Raee$
   * Date: 7/06/2016
   */
	public static Sub_Category__c TestInsertSubCategory(Main_Category__c objMainCategory1){
		objMainCategory1 = objMainCategory;
		objSubCategory = new Sub_Category__c();
		objSubCategory.Name = 'Test Sub-Category';
		objSubCategory.Main_Category__c = objMainCategory1.Id;
		insert objSubCategory;
		return objSubCategory;
	}
  /* Method:  TestInsertCategory
   * Param:   Sub_Category__c
   * Retrun:  Category__c
   * Porpose: This utility method used to insert Category__c for Opportunity score card 
   * CreatedBy: Raee$
   * Date: 7/06/2016
   */
	public static Category__c TestInsertCategory(Sub_Category__c objSubCategory1){
		objSubCategory1 = objSubCategory;
		objCategory = new Category__c();
		objCategory.Name = 'Test Category';
		objCategory.Sub_Category__c = objSubCategory1.Id;
		insert objCategory;
		return objCategory;
	}
  /* Method:  TestInsertCategoryValueScores
   * Param:   Category__c,name,inputType,score,minScore,MaxScore
   * Retrun:  Category_Value_Score__c
   * Porpose: This utility method used to insert Category_Value_Score__c for Opportunity score card 
   * CreatedBy: Raee$
   * Date: 7/06/2016
   */		
	public static Category_Value_Score__c TestInsertCategoryValueScores(Category__c objCategory1,String name, String InputType,Decimal score,Decimal min, Decimal max){
		objCategoryValueScore = new Category_Value_Score__c();
		objCategory1 = objCategory;
		objCategoryValueScore.Name = name;
		objCategoryValueScore.Category__c = objCategory1.Id;
		objCategoryValueScore.Input_Type__c = InputType;
		if(InputType == 'Number'){
			objCategoryValueScore.Minimum_Value__c = min;
			objCategoryValueScore.Maximum_Value__c = max;	
		}
		objCategoryValueScore.Score__c = score;
		objCategoryValueScore.Scoring_Guide__c = objCategoryValueScore.Name;
		insert objCategoryValueScore;	
		return 	objCategoryValueScore;
	}
  /* Method:  TestInsertOpportunityScore
   * Param:   Category__c,name,inputType,score,minScore,MaxScore
   * Retrun:  Category_Value_Score__c
   * Porpose: This utility method used to insert Category_Value_Score__c for Opportunity score card 
   * CreatedBy: Raee$
   * Date: 7/06/2016
   */	
	public static void TestInsertOpportunityScore(Id OpptyId,Category__c objCategory1){
		Opportunity_Score__c oppScore = new Opportunity_Score__c();		
        oppScore.Opportunity__c = newOpportunity.Id;
        oppScore.Main_Category__c = 'Main';
        oppScore.Sub_Category__c = 'Sub';
        oppScore.Category__c = 'Cat';	
		oppScore.Category_Value_Score__c = TestInsertCategoryValueScores(objCategory,'Test Value', 'Picklist',1,null, 5).Id;
		oppScore.Max_Score__c = 5;
		insert oppScore;		
	}	
  /* Method:  TestMethodScoreCardINSERTPositive
   * Param:   void
   * Retrun:  void
   * Porpose: This test method used to covere insert scenario for Opportunity score card 
   * CreatedBy: Raee$
   * Date: 7/06/2016
   */
	public static testMethod void TestMethodScoreCardINSERTPositive(){
		listOfCategoryValueScore = new List<Category_Value_Score__c>();
		String postFix = String.valueOf(Datetime.now().getTime());
		Test.startTest();
		newAccount = TestUtils.createAccount('TestCommercialAccount' + postFix, TestUtils.getResidentialRecordTypeId(), true);
        newContact = TestUtils.createContact('TestCommercialContact' + postFix, newAccount.Id, true);
        newOpportunity = TestUtils.createOpportunities(1, newAccount.id, newContact.Id, true).get(0);
        newOpportunity.Business_Unit__c = 'NA Commercial';
        newOpportunity.RecordTypeId = TestClassFactory.retrieveRecordTypeId('Opportunity', 'Systems');
        newOpportunity.StageName = '01 - Build Single Sales Objective';
        newOpportunity.Proposal_Due_Date__c = System.today();
        update newOpportunity;
        
        objMainCategory = TestInsertMainCategory();  
        System.debug('objMainCategory==>'+objMainCategory);
        objSubCategory  = TestInsertSubCategory(objMainCategory);
        System.debug('objSubCategory==>'+objSubCategory);
        objCategory = TestInsertCategory(objSubCategory);
        System.debug('objCategory==>'+objCategory);
          
        for(Integer i=1 ; i<=2 ; i++ ){        	
        	listOfCategoryValueScore.add(TestInsertCategoryValueScores(objCategory,'Test Value'+i, 'Picklist',i,null, null));
        }
        for(Integer i=1 ; i<=2 ; i++ ){        	
        	listOfCategoryValueScore.add(TestInsertCategoryValueScores(objCategory,'Test Value'+i, 'Number', i, i, i+2));
        }
        PageReference pageRef = Page.OpportunityScorePage;
        Test.setCurrentPageReference(pageRef);
        ApexPages.CurrentPage().getparameters().put('opptyId',newOpportunity.Id);
        OpportunityScoreController objCustom = new OpportunityScoreController ();
        for(OpportunityScoreController.MainCategroyWrapper1 mcWrap1: objCustom.categroyValueWrapperList){
			for(OpportunityScoreController.SubCategroyWrapper2 scWrap2 :mcWrap1.listOfSubCategroyWrapper2){	
				for(OpportunityScoreController.CategroyWrapper3 scWrap3 :scWrap2.listOfCategroyWrapper3){
					System.debug('***Save=scWrap3.catObj.Name=>'+scWrap3.catObj.Name);	
					for(Category_Value_Score__c obj : listOfCategoryValueScore){
					    scWrap3.selectedValue = obj.Id;					    
					}					
				}
			}
        }					
	    objCustom.save();
		for(Category_Value_Score__c obj : listOfCategoryValueScore){
		    	obj.Score__c = 10;
		    	update obj;
		}		
	    objCustom.existingRecordsUpdates();
	    objCustom.loadScoreWrapperList();       
	    objCustom.getScoreInput();
	    objCustom.save();
	    objCustom.Back();
        Test.stopTest(); 
	}
  /* Method:  TestMethodScoreCardUPDATEPositive
   * Param:   void
   * Retrun:  void
   * Porpose: This test method used to covere update scenario for Opportunity score card 
   * CreatedBy: Raee$
   * Date: 7/06/2016
   */
	public static testMethod void TestMethodScoreCardUPDATEPositive(){
		listOfCategoryValueScore = new List<Category_Value_Score__c>();
		String postFix = String.valueOf(Datetime.now().getTime());
		newAccount = TestUtils.createAccount('TestCommercialAccount' + postFix, TestUtils.getResidentialRecordTypeId(), true);
        newContact = TestUtils.createContact('TestCommercialContact' + postFix, newAccount.Id, true);
        newOpportunity = TestUtils.createOpportunities(1, newAccount.id, newContact.Id, true).get(0);        
        newOpportunity.Business_Unit__c = 'NA Commercial';
        newOpportunity.RecordTypeId = TestClassFactory.retrieveRecordTypeID('Opportunity', 'Systemes');
        newOpportunity.StageName = '01 - Build Single Sales Objective';
        newOpportunity.Proposal_Due_Date__c = System.today();
        update newOpportunity;
        
		Test.startTest();        
        objMainCategory = TestInsertMainCategory();  
        objSubCategory  = TestInsertSubCategory(objMainCategory);
        objCategory = TestInsertCategory(objSubCategory);
        for(Integer i=1 ; i<=2 ; i++ ){        	
        	listOfCategoryValueScore.add(TestInsertCategoryValueScores(objCategory,'Test Value'+i, 'Picklist',i,null, null));
        }
        for(Integer i=1 ; i<=2 ; i++ ){        	
        	listOfCategoryValueScore.add(TestInsertCategoryValueScores(objCategory,'Test Value'+i, 'Number', i, i, i+2));
        }
        PageReference pageRef = Page.OpportunityScorePage;
        Test.setCurrentPageReference(pageRef);
        ApexPages.CurrentPage().getparameters().put('opptyId',newOpportunity.Id);
        OpportunityScoreController objCustom = new OpportunityScoreController ();
        objCustom.existingRecordsUpdates();
	    objCustom.loadScoreWrapperList();   
 
        for(OpportunityScoreController.MainCategroyWrapper1 mcWrap1: objCustom.categroyValueWrapperList){
			for(OpportunityScoreController.SubCategroyWrapper2 scWrap2 :mcWrap1.listOfSubCategroyWrapper2){					
				for(OpportunityScoreController.CategroyWrapper3 scWrap3 :scWrap2.listOfCategroyWrapper3){
					System.debug('***Save=scWrap3.catObj.Name=>'+scWrap3.catObj.Name);	
					for(Category_Value_Score__c obj : listOfCategoryValueScore){
					    scWrap3.selectedValue = obj.Id;
					}					
				}
			}
        }					
	    objCustom.save();
		for(Category_Value_Score__c obj : listOfCategoryValueScore){
		    	obj.Score__c = 10;
		    	update obj;
		}			    
	    objCustom.existingRecordsUpdates();
	    objCustom.getScoreInput();
	    objCustom.save();
	    objCustom.Back();
        Test.stopTest(); 
	}

  /* Method: TestMethodScoreCardRelatedList
   * Param: void
   * Retrun: void
   * Porpose: This test method used to coverege for OpportunityScoreRelatedListController 
   * CreatedBy: Raee$
   * Date: 7/12/2016
   */	
	public static testMethod void TestMethodScoreCardRelatedList(){
		listOfCategoryValueScore = new List<Category_Value_Score__c>();
		String postFix = String.valueOf(Datetime.now().getTime());
		newAccount = TestUtils.createAccount('TestCommercialAccount' + postFix, TestUtils.getResidentialRecordTypeId(), true);
        newContact = TestUtils.createContact('TestCommercialContact' + postFix, newAccount.Id, true);
        newOpportunity = TestUtils.createOpportunities(1, newAccount.id, newContact.Id, true).get(0);
     
		Test.startTest();
	    newOpportunity.Business_Unit__c = 'NA Commercial';
        newOpportunity.RecordTypeId = TestClassFactory.retrieveRecordTypeID('Opportunity', 'Systems');
        newOpportunity.StageName = '01 - Build Single Sales Objective';
        Util.UsersToSkipTrigger.add(userinfo.getUserid());
        newOpportunity.Proposal_Due_Date__c = System.today();
        update newOpportunity;
        
        objMainCategory = TestInsertMainCategory();  
        objSubCategory  = TestInsertSubCategory(objMainCategory);
        objCategory = TestInsertCategory(objSubCategory);              
        TestInsertOpportunityScore(newOpportunity.Id,objCategory);

  	    PageReference pageRef1 = Page.OpportunityScoreRelatedListPage;
	    Test.setCurrentPageReference(pageRef1);
	    ApexPages.CurrentPage().getparameters().put('opptyId',newOpportunity.Id);
	    ApexPages.StandardController sc = new ApexPages.StandardController(newOpportunity);
	    OpportunityScoreRelatedListController objOSR = new OpportunityScoreRelatedListController(sc);
	    objOSR.loadScoreWrapperList();
	    objOSR.ShowScorePage();
        Test.stopTest(); 
	}
	
  /* Method: TestCategoryMissingNegative
   * Param: void
   * Retrun: void
   * Porpose: This test method used to cover negative scenario for Opportunity score card 
   * CreatedBy: Raee$
   * Date: 7/15/2016
   */
	public static testMethod void TestCategoryMissingNegative(){
		listOfCategoryValueScore = new List<Category_Value_Score__c>();
		String postFix = String.valueOf(Datetime.now().getTime());
		newAccount = TestUtils.createAccount('TestCommercialAccount' + postFix, TestUtils.getResidentialRecordTypeId(), true);
        newContact = TestUtils.createContact('TestCommercialContact' + postFix, newAccount.Id, true);
        newOpportunity = TestUtils.createOpportunities(1, newAccount.id, newContact.Id, true).get(0);
       
		Test.startTest();
		newOpportunity.Business_Unit__c = 'NA Commercial';
        newOpportunity.RecordTypeId = TestClassFactory.retrieveRecordTypeID('Opportunity', 'Systems');
        newOpportunity.StageName = '01 - Build Single Sales Objective';
        newOpportunity.Proposal_Due_Date__c = System.today();
        update newOpportunity;
        
        objMainCategory = TestInsertMainCategory();  
        objSubCategory  = TestInsertSubCategory(objMainCategory);
        PageReference pageRef = Page.OpportunityScorePage;
        Test.setCurrentPageReference(pageRef);
        ApexPages.CurrentPage().getparameters().put('opptyId',newOpportunity.Id);
        OpportunityScoreController objCustom = new OpportunityScoreController ();
	    objCustom.loadScoreWrapperList();    
	    objCustom.getScoreInput();   
        Test.stopTest(); 
	}
	
  /* Method: TestMethodSSOFinalizedPositive
   * Param: void
   * Retrun: void
   * Porpose: This test method used to coverage for finalizedSSOPR0Validation-
   *          validated required fields to filled before changing Stage 1 to 2  for PR0-COMMERICAL PROJECT
   * CreatedBy: Raee$
   * Date: 7/15/2016
   */	
	public static testMethod void TestMethodSSOFinalizedPositive(){
		listOfCategoryValueScore = new List<Category_Value_Score__c>();
		String postFix = String.valueOf(Datetime.now().getTime());
		newAccount = TestUtils.createAccount('TestCommercialAccount' + postFix, TestUtils.getResidentialRecordTypeId(), true);
        newContact = TestUtils.createContact('TestCommercialContact' + postFix, newAccount.Id, true);
        newOpportunity = TestUtils.createOpportunities(1, newAccount.id, newContact.Id, true).get(0);
       
		Test.startTest();
		newOpportunity.Business_Unit__c = 'NA Commercial';
		newOpportunity.RecordTypeId = TestClassFactory.retrieveRecordTypeID('Opportunity', 'Systems');
        newOpportunity.StageName = '01 - Build Single Sales Objective';
        newOpportunity.Country__c = 'United States';
        newOpportunity.Sub_Region__c = 'California - North';
        newOpportunity.Customer_selection_process__c = 'Test Customer selection process';
        newOpportunity.My_Position_vs_Competition__c = 'Test My position v/s compition';
        newOpportunity.Closure_Deal_Risks__c = 'Test closure deal risks';
        newOpportunity.Proposal_Due_Date__c = System.today();
        objMainCategory = TestInsertMainCategory();  
        System.debug('objMainCategory==>'+objMainCategory);
        objSubCategory  = TestInsertSubCategory(objMainCategory);
        System.debug('objSubCategory==>'+objSubCategory);
        objCategory = TestInsertCategory(objSubCategory);
        System.debug('objCategory==>'+objCategory);
      	TestInsertOpportunityScore(newOpportunity.Id,objCategory);
        
        update newOpportunity;
        Boolean foundPVModule = false;
		Boolean foundMountingSystem = false;
        List<OpportunityLineItem> lstOLI2 = new List<OpportunityLineItem>();        
        List<PricebookEntry> LstPricebookEntry2 = new List<PricebookEntry>();
        for(PricebookEntry objPricebookEntry : [SELECT Id, Name, Pricebook2id, Product2Id,Product2.Product_Family_Text__c
                                                FROM PricebookEntry 
                                                WHERE Pricebook2.name Like '%System%' 
                                                and CurrencyISOCode = 'USD' and IsActive = True                                                
                                                and (Product2.Product_Family_Text__c = 'Mounting Systems - Ground'        
                                                OR Product2.Product_Family_Text__c = 'PV Module' )                                   
                                                order by Product2.Product_Family_Text__c asc
                                                limit 50]){
            if(objPricebookEntry.Product2.Product_Family_Text__c == 'PV Module' && !foundPVModule){
            	LstPricebookEntry2.add(objPricebookEntry);
            	foundPVModule = true;
            }                                                            	
     		if(objPricebookEntry.Product2.Product_Family_Text__c == 'Mounting Systems - Ground' && !foundMountingSystem){
     			LstPricebookEntry2.add(objPricebookEntry);
     			foundMountingSystem = true;
     		}
     		if(foundMountingSystem & foundPVModule)	break;        		
         }
       
        for(PricebookEntry pbe : LstPricebookEntry2){           
	        OpportunityLineItem OLI = new OpportunityLineItem();
	        OLI.Opportunityid = newOpportunity.id;
	        OLI.PricebookEntryID = pbe.id;
	        OLI.TotalPrice = 50;
	        OLI.Quantity = 2;
	        lstOLI2.add(OLI);          
        }       
        if(!lstOLI2.isEmpty()){		 	
		   	Database.SaveResult[] srList = Database.insert(lstOLI2, false);  	     	
	    }        
        newOpportunity.StageName = '02 - Finalize SSO';
        update newOpportunity;
    }
}