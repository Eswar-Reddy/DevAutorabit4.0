/* Class:     OpportunityScoreController
 * Purpose:   This class will populate categories added by admin for commercial score on Opportunity
 * CreatedBy: Raee$
 * Date:      6/14/2016
 */
public class OpportunityScoreController {

    public String message {get; private set;}
    public List<MainCategroyWrapper1> categroyValueWrapperList {get; private set;}
    public String opptyId {get; private set;}
	private Map<String,Map<String, Map<String, List<Opportunity_Score__c>>>> mainSubCatValMAP1 ;
	private List<Main_Category__c> listOfmainObj = new List<Main_Category__c>();
	private Map<String,List<Sub_Category__c>> mainSubMAP = new Map<String,List<Sub_Category__c>>();
	private Map<String,Map<String,List<Category__c>>> mainSubCatMAP = new Map<String,Map<String,List<Category__c>>>();
	private Map<String,Map<String,Map<String,List<Category_Value_Score__c>>>> mainSubCatValMAP = new Map<String,Map<String,Map<String,List<Category_Value_Score__c>>>>();
	public Map<ID,Category_Value_Score__c> mapOfCategeyValues {
		get {
			if(mapOfCategeyValues == null) {
				mapOfCategeyValues = new Map<ID,Category_Value_Score__c>();
			}
			return mapOfCategeyValues;
		}
		set;
	}
	public Map<String,Decimal> mapofMaxScore = new Map<String,Decimal>();
	private Set<ID> mainIDs = new Set<ID>();
	private Set<ID> subIDs = new Set<ID>();
	private Set<ID> catIDs = new Set<ID>();
	public Integer finalScore {get;  set;}
	public String inputNumberScore {get; set;}
	public String inputNumberCatName {get; set;}
	public String Intype {get; set;}
	public Boolean saveFinalScoreFlag = false;
	public Boolean editDisable {get; set;}
	
  	/* Contructor: OpportunityScoreController
   	* Param: void
   	* Retrun: None
   	* Purpose: Contructor load new/existing categories or scores
   	* CreatedBy: Raee$
   	* Date: 6/14/2016
   	*/  
	public OpportunityScoreController() {
        opptyId = ApexPages.currentPage().getParameters().get('OpptyId');
        finalScore = 0;
        if(opptyId != null ){
			loadScoreWrapperList();	//TODO: Not reload all this stuff upon every call;	
        }	
   	}

  	/* Method:    loadScoreWrapperList
   	* Param:     void
   	* Retrun:    None
   	* Purpose:   This method will call from construcor and load wrappers list from new/existing score and validate for updates
   	* CreatedBy: Raee$
  	* Date:      6/14/2016
   	*/  
    public void loadScoreWrapperList() {
        categroyValueWrapperList = new List<MainCategroyWrapper1> ();//CategoryValue wrapper list    
        mainSubCatValMAP1 = new Map<String,Map<String, Map<String, List<Opportunity_Score__c>>>> ();
       
        //Fetch existing Opportunity score records
 		mainSubCatValMAP1 = existingRecordsUpdates();
		
	    //Validate whch use can update scores
		//validateUpdate();
		
		// Fetch all Main>Sub>Categories>Values 
		getAllCategries(); 
        if(!listOfmainObj.isEmpty() && !mainSubMAP.isEmpty() && !mainSubCatMAP.isEmpty()){
	        for(Main_Category__c mainObject: listOfmainObj ){
	        	MainCategroyWrapper1 mainWrap = new MainCategroyWrapper1(); //1
	        	mainWrap.mainObj = mainObject;   
	        	List<SubCategroyWrapper2> listOfsubWrap = new List<SubCategroyWrapper2>();
	        	if(mainSubMAP.containsKey(mainObject.Name)){ 
		        	//SUB-Category LOOP
		        	for(Sub_Category__c subObject: mainSubMAP.get(mainObject.Name)){
		        		SubCategroyWrapper2 subWrap = new SubCategroyWrapper2(); //2
		        		subWrap.subObj = subObject;
		        		List<CategroyWrapper3> listOfcatWrap = new List<CategroyWrapper3>();
		        		if(mainSubCatMAP.containsKey(mainObject.Name) && !mainSubCatMAP.get(mainObject.Name).isEmpty() && mainSubCatMAP.get(mainObject.Name).containsKey(subObject.Name)){ 
			        		//Category LOOP
			        		for(Category__c catObject: mainSubCatMAP.get(mainObject.Name).get(subObject.Name)){
			        			CategroyWrapper3 catWrap = new CategroyWrapper3(); //3
			        			catWrap.catObj = catObject;
			        		
			        			List<Category_Value_Score__c> listOfCatValues = new List<Category_Value_Score__c>();
			        			List <SelectOption> valueOptions = new List <SelectOption> ();
			        			valueOptions.add(new SelectOption('','-None-'));
			        			List <SelectOption> scoreOptions = new List <SelectOption> ();
			        			scoreOptions.add(new SelectOption('','-None-'));
			        			List <String> scoreGuidlines = new List <String> ();
			        			Boolean inputType = false;
			        			String existingSelectedValue ;
			        			Decimal existingInputNumber;

			        			if(mainSubCatValMAP.get(mainObject.Name).get(subObject.Name).containsKey(catObject.Name)){
				        			for(Category_Value_Score__c catValuesObject: mainSubCatValMAP.get(mainObject.Name).get(subObject.Name).get(catObject.Name)){
				        				listOfCatValues.add(catValuesObject);  				        				
				        				valueOptions.add(new SelectOption(catValuesObject.Id, catValuesObject.Name ));				        				
				        				scoreOptions.add(new SelectOption(catValuesObject.Id, String.valueOf(catValuesObject.Score__c )));
				        				scoreGuidlines.add(String.valueOf(catValuesObject.Score__c) +':'+catValuesObject.Scoring_Guide__c);
				        				 if(catValuesObject.Input_Type__c == 'Picklist'){
				        					inputType = true;
				        				}  
				        				//Selected value for existing record
		        						//EXISTING DATA POPULATE
		        						if(!mainSubCatValMAP1.isEmpty() && mainSubCatValMAP1.containsKey(mainObject.Name) && 
		        						   mainSubCatValMAP1.get(mainObject.Name).containsKey(subObject.Name)){					
		        							if(mainSubCatValMAP1.get(mainObject.Name).get(subObject.Name).containsKey(catObject.Name)){	
		        								existingSelectedValue = mainSubCatValMAP1.get(mainObject.Name).get(subObject.Name).get(catObject.Name).get(0).Category_Value_Score__c;
		        								existingInputNumber = mainSubCatValMAP1.get(mainObject.Name).get(subObject.Name).get(catObject.Name).get(0).Input_Number__c;
		        								if(mainSubCatValMAP1.get(mainObject.Name).get(subObject.Name).get(catObject.Name).get(0).Category_Value_Score__c == catValuesObject.Id){
			        								if(mainWrap.mainCategoryScore != null )
			        									mainWrap.mainCategoryScore = mainWrap.mainCategoryScore + Integer.valueOf(mainSubCatValMAP1.get(mainObject.Name).get(subObject.Name).get(catObject.Name).get(0).Category_Score_Formulea__c);
			        								else
			        									mainWrap.mainCategoryScore = Integer.valueOf(mainSubCatValMAP1.get(mainObject.Name).get(subObject.Name).get(catObject.Name).get(0).Category_Score_Formulea__c);	
			        							}
		        							}
		        						}		        			      				      				
				        			}//end of catValue for loop
			        			 }
			        			catWrap.listOfCatVal = listOfCatValues; 
			        			catWrap.cardValueOptions = valueOptions;
			        			catWrap.scoreOptions = scoreOptions;    
			        			catWrap.scoreGuidlines.addAll(scoreGuidlines);
			        			catWrap.inputType = inputType;
			        			catWrap.selectedValue = existingSelectedValue;
			        			catWrap.inputNumber = existingInputNumber;
			        			
			        			listOfcatWrap.add(catWrap);    			
			        		}//end of cat for loop
			        		subWrap.listOfCategroyWrapper3 = listOfcatWrap;
		        			listOfsubWrap.add(subWrap); 	    
		        		}		        	    		
		        	}//end of sub for loop

			        if(!listOfsubWrap.isEmpty()){
				        mainWrap.listOfSubCategroyWrapper2 = listOfsubWrap;				        	
		        		categroyValueWrapperList.add(mainWrap); 
			        }
	          }//new	 
	        //  finalScore = mainWrap.mainCategoryScore;     	          	
	        }//end of main for loop   
    	 }	else{
    	 	message = Label.OpportunityScoreCategory_PR0;
    	 	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,message));
    	 }                  
      } // end of loadScoreWrapperList  
      
    
  	/* Method:    getAllCategries
   	* Param:     None
   	* Retrun:    None
   	* Purpose:   This method load all Main>Sub>Categories>Values records and add into list of Wrappers
   	* CreatedBy: Raee$
   	* Date:      6/14/2016
   	*/ 
  	private void getAllCategries(){  	
  	 	//Main Category
        for(Main_Category__c mainObj : [Select Id, Active__c, Name, (Select Id, Name, Main_Category__c From Sub_Categories__r) 
        							   from Main_Category__c 
        							   where Active__c=true order by Name DESC]) {						   	
        	mainIDs.add(mainObj.Id);
        	listOfmainObj.add(mainObj);
        } 
        // Sub-Category      
        for(Sub_Category__c objSub : [Select Name, Main_Category__c, Main_Category__r.Name, Id, (Select Name, Help__c From Categories__r)
        							 From Sub_Category__c 
        							 where Main_Category__c 
        							 IN: mainIDs]) {	
        	if(!objSub.Categories__r.isEmpty()){					 	
	        	if(mainSubMAP.containsKey(objSub.Main_Category__r.Name) ){
	        		mainSubMAP.get(objSub.Main_Category__r.Name).add(objSub);
	        	}else{
	        		mainSubMAP.put(objSub.Main_Category__r.Name,new List<Sub_Category__c>{objSub});
	        	} 
	        	subIDs.add(objSub.Id); 
        	}        	      	
        }
        //Catogory
        for(Category__c objCateg : [Select Sub_Category__r.Main_Category__r.Name, Sub_Category__r.Main_Category__c, Sub_Category__r.Name, 
        								  Sub_Category__c, Name, Id, Help__c, (Select Name From Category_Value_Scores__r) 
        						   From Category__c 
        						   where Sub_Category__c 
        						   IN: subIDs]) {  					   	     	
        	if(!objCateg.Category_Value_Scores__r.isEmpty()){	
	        	if(mainSubCatMAP.get(objCateg.Sub_Category__r.Main_Category__r.Name) != null){        		
	        		if(mainSubCatMAP.get(objCateg.Sub_Category__r.Main_Category__r.Name).containsKey(objCateg.Sub_Category__r.Name)){
	        			mainSubCatMAP.get(objCateg.Sub_Category__r.Main_Category__r.Name).get(objCateg.Sub_Category__r.Name).add(objCateg);
	        		}else{
	        			mainSubCatMAP.get(objCateg.Sub_Category__r.Main_Category__r.Name).put(objCateg.Sub_Category__r.Name,new List<Category__c>{objCateg});
	        		}        		
	        	}else{
	        		mainSubCatMAP.put(objCateg.Sub_Category__r.Main_Category__r.Name, new Map<String,List<Category__c>>{objCateg.Sub_Category__r.Name => new List<Category__c>{objCateg}});
	        	}
	         catIDs.add(objCateg.Id); 
        	}          	     	
        }
        //Category Values
		if(!catIDs.isEmpty()){
			for (Category_Value_Score__c categoryValues :[SELECT Maximum_Value__c, Minimum_Value__c,Category__c, Category__r.Main_Category__c, 
																 Category__r.Sub_Category__r.Main_Category__r.Name, Category__r.Sub_Category__r.Name, 
																 Category__r.Name, Name,Input_Type__c, Scoring_Guide__c, Score__c 
					        							  FROM Category_Value_Score__c 
					        							  WHERE Category__r.Sub_Category__r.Main_Category__r.Active__c = true
					        							  AND Category__r.Main_Category__c!='' 
					        							  AND Category__r.Sub_Category__r.Name != ''
					        							  AND Category__r.Name != ''
					        							  AND Name!=''
					        							  AND Category__c 
					        							  IN: catIDs
					        							  order by Score__c]) {        	
				mapOfCategeyValues.put(categoryValues.Id,categoryValues);
				//MAX SCORE OF CAT VAL -START
				if(mapofMaxScore.isEmpty()){
						mapofMaxScore.put(categoryValues.Category__r.Name ,categoryValues.Score__c);
					}else if(!mapofMaxScore.containsKey(categoryValues.Category__r.Name)){
						mapofMaxScore.put(categoryValues.Category__r.Name ,categoryValues.Score__c);
					}else if(mapofMaxScore.containsKey(categoryValues.Category__r.Name) && mapofMaxScore.get(categoryValues.Category__r.Name) < categoryValues.Score__c){
						mapofMaxScore.put(categoryValues.Category__r.Name,categoryValues.Score__c);
				}
				//MAX SCORE OF CAT VAL -END
				if(mainSubCatValMAP.get(categoryValues.Category__r.Sub_Category__r.Main_Category__r.Name) != null){
					
					if(mainSubCatValMAP.get(categoryValues.Category__r.Sub_Category__r.Main_Category__r.Name).get(categoryValues.Category__r.Sub_Category__r.Name) != null){
						
						if(mainSubCatValMAP.get(categoryValues.Category__r.Sub_Category__r.Main_Category__r.Name).get(categoryValues.Category__r.Sub_Category__r.Name).containsKey(categoryValues.Category__r.Name)){
							mainSubCatValMAP.get(categoryValues.Category__r.Sub_Category__r.Main_Category__r.Name).get(categoryValues.Category__r.Sub_Category__r.Name).get(categoryValues.Category__r.Name).add(categoryValues);
						}else{
							mainSubCatValMAP.get(categoryValues.Category__r.Sub_Category__r.Main_Category__r.Name).get(categoryValues.Category__r.Sub_Category__r.Name).put(categoryValues.Category__r.Name,new List<Category_Value_Score__c>{categoryValues});
						}					
					}else{
						mainSubCatValMAP.get(categoryValues.Category__r.Sub_Category__r.Main_Category__r.Name).put(categoryValues.Category__r.Sub_Category__r.Name, new Map<String,List<Category_Value_Score__c>>{categoryValues.Category__r.Name => new List<Category_Value_Score__c>{categoryValues}});
					}			
				}else{
					mainSubCatValMAP.put(categoryValues.Category__r.Sub_Category__r.Main_Category__r.Name, new Map<String, Map<String, List<Category_Value_Score__c>>> {categoryValues.Category__r.Sub_Category__r.Name => new Map<String,List<Category_Value_Score__c>>{categoryValues.Category__r.Name => new List<Category_Value_Score__c>{categoryValues}}});
				}
		    }
    	} 	
  	}

  	/* Method:    Save
   	* Param:     void
   	* Retrun:    PageReference
   	* Purpose:   This save method insert/update opportunity score records and update opportunity score value
   	* CreatedBy: Raee$
   	* Date:      6/14/2016
   	*/ 
    public PageReference Save() {	 
     	List<Opportunity_Score__c> listOfNEWOptyScore = new List<Opportunity_Score__c>();
 		List<Opportunity_Score__c> updateExistingOptyScore = new List<Opportunity_Score__c>();	
 		Boolean noSelectedflag;
 		Boolean allowOpptyScore = false;
 		PageReference pageRef;	
 		try { 
 			saveFinalScoreFlag = true; 			 
 			mainSubCatValMAP1 = new Map<String,Map<String, Map<String, List<Opportunity_Score__c>>>> ();
 			mainSubCatValMAP1 = existingRecordsUpdates();					
			for(MainCategroyWrapper1 mcWrap1: categroyValueWrapperList) {
				
				for(SubCategroyWrapper2 scWrap2 :mcWrap1.listOfSubCategroyWrapper2) {

					for(CategroyWrapper3 scWrap3 :scWrap2.listOfCategroyWrapper3) {						
						
						//CHECKING EXISTING RECORDS
					   if(((!mainSubCatValMAP1.isEmpty() && 
							mainSubCatValMAP1.containsKey(mcWrap1.mainObj.Name) && 
							mainSubCatValMAP1.get(mcWrap1.mainObj.Name).containsKey(scWrap2.subObj.Name)) &&
							mainSubCatValMAP1.get(mcWrap1.mainObj.Name).get(scWrap2.subObj.Name).containsKey(scWrap3.catObj.Name))){						
								allowOpptyScore = true;				
								Id catValueID = mainSubCatValMAP1.get(mcWrap1.mainObj.Name).get(scWrap2.subObj.Name).get(scWrap3.catObj.Name).get(0).Category_Value_Score__c;
						 		
						 		//UPDATE IF PICKLIST OF CAT-VAL CHANGED OR //UPDATE IF NUMBER HAS BEEN CHANGED
					 			if(scWrap3.selectedValue == null || scWrap3.selectedValue == '') { // MAKE IT BLANK
					 				mainSubCatValMAP1.get(mcWrap1.mainObj.Name).get(scWrap2.subObj.Name).get(scWrap3.catObj.Name).get(0).Category_Value_Score__c = null;
					 				if(mainSubCatValMAP1.get(mcWrap1.mainObj.Name).get(scWrap2.subObj.Name).get(scWrap3.catObj.Name).get(0).Input_Number__c != scWrap3.inputNumber){
					 					mainSubCatValMAP1.get(mcWrap1.mainObj.Name).get(scWrap2.subObj.Name).get(scWrap3.catObj.Name).get(0).Input_Number__c = scWrap3.inputNumber;
					 				}
					 				mainSubCatValMAP1.get(mcWrap1.mainObj.Name).get(scWrap2.subObj.Name).get(scWrap3.catObj.Name).get(0).Max_Score__c = mapofMaxScore.get(scWrap3.catObj.Name);
					 				updateExistingOptyScore.add(mainSubCatValMAP1.get(mcWrap1.mainObj.Name).get(scWrap2.subObj.Name).get(scWrap3.catObj.Name).get(0));
					 			 
					 			} else if(catValueID != scWrap3.selectedValue && scWrap3.selectedValue != null && scWrap3.selectedValue != '') {
					 				catValueID = scWrap3.selectedValue; //UPDATE CAT-VAL
					 				
					 				if(mainSubCatValMAP1.get(mcWrap1.mainObj.Name).get(scWrap2.subObj.Name).get(scWrap3.catObj.Name).get(0).Input_Number__c != scWrap3.inputNumber){
					 					mainSubCatValMAP1.get(mcWrap1.mainObj.Name).get(scWrap2.subObj.Name).get(scWrap3.catObj.Name).get(0).Input_Number__c = scWrap3.inputNumber;
					 				}
					 				mainSubCatValMAP1.get(mcWrap1.mainObj.Name).get(scWrap2.subObj.Name).get(scWrap3.catObj.Name).get(0).Category_Value_Score__c = catValueID;
					 				mainSubCatValMAP1.get(mcWrap1.mainObj.Name).get(scWrap2.subObj.Name).get(scWrap3.catObj.Name).get(0).Max_Score__c = mapofMaxScore.get(scWrap3.catObj.Name);
					 				updateExistingOptyScore.add(mainSubCatValMAP1.get(mcWrap1.mainObj.Name).get(scWrap2.subObj.Name).get(scWrap3.catObj.Name).get(0));					 			   
				 				 }	
						} else {	//INSERTION OF NEW OPPORTUNITY SCORE	
								Opportunity_Score__c opptyScore = new Opportunity_Score__c();
								opptyScore.Opportunity__c = opptyId;
								opptyScore.Main_Category__c = mcWrap1.mainObj.Name;
								opptyScore.Sub_Category__c = scWrap2.subObj.Name;
								opptyScore.Category__c = scWrap3.catObj.Name;
								noSelectedflag = false;								
								if( scWrap3.catObj.Name != null && !mapofMaxScore.isEmpty() && mapofMaxScore.containsKey(scWrap3.catObj.Name)){
									opptyScore.Max_Score__c = mapofMaxScore.get(scWrap3.catObj.Name);
								}			
								for (Category_Value_Score__c catValObject : scWrap3.listOfCatVal) {						
									if(scWrap3.selectedValue == catValObject.Id) {//main is not existing-NEW SCORE MAIN>>SUB>>CAT>>CATVAL RECORD										
										opptyScore.Category_Value_Score__c = catValObject.Id;										
									}else if (scWrap3.selectedValue == null && scWrap3.inputNumber == null){ // -Non- insertion
										opptyScore.Category_Value_Score__c = null;
										noSelectedflag = true;	
									}
									if(scWrap3.inputNumber!= null && scWrap3.inputNumber >=catValObject.Minimum_Value__c && scWrap3.inputNumber <=catValObject.Maximum_Value__c) {	
										opptyScore.Input_Number__c = scWrap3.inputNumber;
						                opptyScore.Category_Value_Score__c = catValObject.Id;
						                if(scWrap3.inputNumber== 0 && scWrap3.selectedValue == null){ // NUMBER NOT ENTERED
						                	
						                	opptyScore.Category_Value_Score__c = null;
											noSelectedflag = true;			
										}						                					              											
									}																							
								} //end of for loop catVal
							    if(scWrap3.selectedValue != null || noSelectedflag){
									if(opptyScore.Category_Value_Score__c != null){
										allowOpptyScore = true;
									}
									listOfNEWOptyScore.add(opptyScore);		
							 	}	
						 	}	           					
					 	}//end of CategroyWrapper3
					}//end of SubCategroyWrapper2			
		   		}//end of MainCategroyWrapper1
			  	if(allowOpptyScore) {	
					if(!listOfNEWOptyScore.isEmpty()) {
			   		Database.SaveResult[] srList = Database.insert(listOfNEWOptyScore, false);  	     	
		   	    } 
		  	    if(!updateExistingOptyScore.isEmpty()) {
		  	     	Database.SaveResult[] srUpdateList = Database.update(updateExistingOptyScore, false);   	       	     
		  	    }
		  	    pageRef  = new PageReference('/'+opptyId);
	    		pageRef.setRedirect(true);
			} else {
			 	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.OpportunityScoreCategoryRequired_PR0));
	            return null;
			}
	   	} catch (Exception e) {
            message = e.getMessage();
    	 	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,message));
            return null;
       	}
      return pageRef;
    }
    
  /* Method: existingRecordsUpdates
   * Param: Map<String,Map<String, Map<String, List<Opportunity_Score__c>>>>
   * Purpose: This method get all existing opportunity scores and put into respectiv map Main>Sub>Categories>Values
   * CreatedBy: Raee$
   * Date: 6/14/2016
   */ 
    public Map<String,Map<String, Map<String, List<Opportunity_Score__c>>>> existingRecordsUpdates(){
    	mainSubCatValMAP1 = new Map<String,Map<String, Map<String, List<Opportunity_Score__c>>>>();
 		if(opptyId != ''){						
		  	 for(Opportunity_Score__c opptyScore :([Select Id,Category_Value_Score__c,Opportunity__c,Category_Score_Formulea__c,Main_Category__c,Total_Opportunity_Score__c ,Sub_Category__c,Category__c,Input_Number__c 
		  										   From Opportunity_Score__c 
		  										   where Opportunity__c =:opptyId])) {
		  	if(!saveFinalScoreFlag){
			  	if(finalScore != null )
			  		finalScore = finalScore + Integer.valueOf(opptyScore.Category_Score_Formulea__c);
			  	else
			  		finalScore = Integer.valueOf(opptyScore.Category_Score_Formulea__c);
		  	}
		  	if(!mainSubCatValMAP1.isEmpty() && mainSubCatValMAP1.containsKey(opptyScore.Main_Category__c) && mainSubCatValMAP1.get(opptyScore.Main_Category__c) != null){
				
				if( mainSubCatValMAP1.get(opptyScore.Main_Category__c).containsKey(opptyScore.Sub_Category__c) && mainSubCatValMAP1.get(opptyScore.Main_Category__c).get(opptyScore.Sub_Category__c) != null){
					
					if(mainSubCatValMAP1.get(opptyScore.Main_Category__c).get(opptyScore.Sub_Category__c).containsKey(opptyScore.Category__c))
						mainSubCatValMAP1.get(opptyScore.Main_Category__c).get(opptyScore.Sub_Category__c).get(opptyScore.Category__c).add(opptyScore);
					else
						mainSubCatValMAP1.get(opptyScore.Main_Category__c).get(opptyScore.Sub_Category__c).put(opptyScore.Category__c,new List<Opportunity_Score__c>{opptyScore});
										
				}else{
					mainSubCatValMAP1.get(opptyScore.Main_Category__c).put(opptyScore.Sub_Category__c, new Map<String,List<Opportunity_Score__c>>{opptyScore.Category__c => new List<Opportunity_Score__c>{opptyScore}});
				}			
			}else{
				mainSubCatValMAP1.put(opptyScore.Main_Category__c, new Map<String, Map<String, List<Opportunity_Score__c>>> {opptyScore.Sub_Category__c => new Map<String,List<Opportunity_Score__c>>{opptyScore.Category__c => new List<Opportunity_Score__c>{opptyScore}}});	
			}	
  	   	  }
 		}
    	return mainSubCatValMAP1;
    }  //end of existingRecordsUpdates      
      
  	/* Method: getScoreInput
   	* Param: void
   	* Retrun: PageReference
   	* Purpose: This AJAX method calculate score based on selected Category value
   	* CreatedBy: Raee$
   	* Date: 6/14/2016
   	*/     
    public PageReference getScoreInput() {
   		finalscore = 0;   
  		try{
  		 	if(!categroyValueWrapperList.isEmpty() && Intype != null ){  
	   		 	for(MainCategroyWrapper1 mcWrap1: categroyValueWrapperList) {	
					mcWrap1.mainCategoryScore = 0;
					for(SubCategroyWrapper2 scWrap2 :mcWrap1.listOfSubCategroyWrapper2) {
	
						for(CategroyWrapper3 scWrap3 :scWrap2.listOfCategroyWrapper3) {
							
							for (Category_Value_Score__c catValObject : scWrap3.listOfCatVal) {
								if( catValObject.Category__r.Name != inputNumberCatName && scWrap3.selectedValue != '' && catValObject.Id == scWrap3.selectedValue){
									if(mcWrap1.mainCategoryScore != null)
	   										mcWrap1.mainCategoryScore = mcWrap1.mainCategoryScore + Integer.valueOf(catValObject.Score__c);
	   									else
	   										mcWrap1.mainCategoryScore = Integer.valueOf(catValObject.Score__c);							
								}else if(catValObject.Category__r.Name == inputNumberCatName){								
						    		  if(Intype == 'inputF'){
						    		  	if(inputNumberScore == ''){ // Removed Entered number	
								      			scWrap3.selectedValue = '';							      			
								      	}else if(Decimal.valueOf(inputNumberScore) >=catValObject.Minimum_Value__c && Decimal.valueOf(inputNumberScore) <=catValObject.Maximum_Value__c ){
							    			scWrap3.selectedValue = catValObject.Id;
							    			if(mcWrap1.mainCategoryScore != null)
		   										mcWrap1.mainCategoryScore = mcWrap1.mainCategoryScore + Integer.valueOf(catValObject.Score__c);
		   									else
		   										mcWrap1.mainCategoryScore = Integer.valueOf(catValObject.Score__c);	
							    		 }
							      	}else if(Intype == 'selectL') {
								      		if(inputNumberScore == ''){ // SELECT -NONE-
								      			
								      		}else if( inputNumberScore == catValObject.Id){
								      			scWrap3.selectedValue = catValObject.Id;
									      		if(mcWrap1.mainCategoryScore != null)
			   										mcWrap1.mainCategoryScore = mcWrap1.mainCategoryScore + Integer.valueOf(catValObject.Score__c);
			   									else
			   										mcWrap1.mainCategoryScore = Integer.valueOf(catValObject.Score__c);		
								      		}
						    		   }	
						   	      }
							 }	                			
				        }
	   				}
	   				if(finalscore != null)
   						finalscore =   finalscore + mcWrap1.mainCategoryScore; 
   					else
   						finalscore =   mcWrap1.mainCategoryScore;	
   		 	   	}
   			}   		   
	   	} catch (Exception e) {
	            message = e.getMessage();
	    	 	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,message));
	            return null;
		}		
    	return null;	
   	}

  	/* Method:    Back
   	* Param:     void
   	* Retrun:    PageReference
   	* Purpose:   This method will redirect to Opportunity
   	* CreatedBy: Raee$
   	* Date:      6/14/2016
   	*/   
  	public PageReference Back() { 
		PageReference pageRef = new PageReference('/'+opptyId);
		pageRef.setRedirect(true);
		return pageRef; 
  	}

  	/* Class:     MainCategroyWrapper1
   	* Param:     None
   	* Purpose:   This wrapper class used to load Main categories 
   	* CreatedBy: Raee$
   	* Date:      6/14/2016
   	*/            
   	public class MainCategroyWrapper1 { 
    	public Main_Category__c mainObj {get; private set;}
    	public Integer mainCategoryScore {get; private set;}
    	public List<SubCategroyWrapper2> listOfSubCategroyWrapper2 {get; private set;}
    	public MainCategroyWrapper1(){     		    		
    		if(mainObj == null){ mainObj = new Main_Category__c(); }
    		if(listOfSubCategroyWrapper2 == null){ listOfSubCategroyWrapper2 = new List<SubCategroyWrapper2>(); 	}
    	}    		
    }
  
  	/* Class:     SubCategroyWrapper2
   	* Param:     None
   	* Purpose:   This wrapper class used to load sub categories with respective Main Category  
   	* CreatedBy: Raee$
   	* Date:      6/14/2016
   	*/     
    public class SubCategroyWrapper2 {
    	public Sub_Category__c subObj {get; private set;}
    	public List<CategroyWrapper3> listOfCategroyWrapper3 {get; private set;}
    	public SubCategroyWrapper2(){
    		if(subObj == null){ subObj = new Sub_Category__c(); }
    		if(listOfCategroyWrapper3 == null){ listOfCategroyWrapper3 = new List<CategroyWrapper3>();	 }
    	}    		
    }

  	/* Class:     CategroyWrapper3
   	* Param:     None
   	* Purpose:   This wrapper class used to load categories and values with respective sub-Category  
   	* CreatedBy: Raee$
   	* Date:      6/14/2016
   	*/    
    public class CategroyWrapper3 {
    	public Category__c catObj {get; private set;}
    	public List<Category_Value_Score__c> listOfCatVal {get; set;}
    	public List <String> scoreGuidlines {get;  set;}
    	public List <SelectOption> cardValueOptions {get; set;}
    	public List <SelectOption> scoreOptions {get; set;}
    	public String selectedValue {get; set;}
    	public Boolean inputType {get; set;}
    	public Decimal inputNumber {get; set;}
    	public CategroyWrapper3(){
    		if(catObj == null){ catObj = new Category__c(); }
    		if(listOfCatVal == null){ 
    			listOfCatVal = new List<Category_Value_Score__c>();	
    			scoreGuidlines = new List <String>();
    			cardValueOptions = new List <SelectOption>();    			
    			scoreOptions = new List <SelectOption>();   			
    		}
    	}    		 
    }  
}