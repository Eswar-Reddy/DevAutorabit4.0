/***************************************
	Author: Appirio (Prakash G.)
	Ref : PR-1990
	Purpose: Store Assigned PSR Users in Account Object as comma separted .
			 Store IDs and Name in two separate fields 
	Modified: 24 June 2009
***************************************/
public class AssignedPSRController{
	
	public Account acct {get;set;}
    public String closeStatus {get;set;} 
    List<User> psrUsers = null;
    //List<String> debugsLog = new List<String>();
    public String accid {get;set;}
    
    public AssignedPSRController(ApexPages.StandardController ctrl){
        closeStatus ='none';
         if(accid == null || accid == '' || accid.length() < 1) 
            accid = ApexPages.currentPage().getParameters().get('id');
         // Done for Case # 00071202   
         // acct = [select id,Name,Assigned_PSR_IDS__c,Assigned_PSR_s__c from Account where id =:accid];
         try{
         	acct = [select id,Name,Assigned_PSR_IDS__c,Assigned_PSR_s__c from Account where id =:accid];
         }catch(Exception e){
         	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Account does not exist.'));
            return; 
         }
    }
    public boolean getHasMessages(){
    	return ApexPages.hasMessages();
    }
    // End Case # 00071202.
    
    public List<User> getPsrUsers(){
        if(psrUsers ==null){
            psrUsers = new List<User>();
            psrUsers = [select FirstName,LastName,Id,Name,Extension from User where UserRole.Name like 'Partner Support Representative%' order by FirstName LIMIT 1000]; 
         }
        return psrUsers;
    }
    public List<SelectOption> getPSRUsersOptions(){
        //debugsLog.add('Entered in getPSRUsersOptions');
        List<SelectOption> options = null;
        //options.add(new SelectOption('--','--'));
        if(psrUsers   == null){
            psrUsers = getPSRUsers();
        }
        //debugsLog.add('Entered in getPSRUsersOptions::psrUsers::'+psrUsers);
        for(User u :psrUsers){
            String assPSRids =null;
            if(acct.Assigned_PSR_IDS__c != null){
               assPSRids = acct.Assigned_PSR_IDS__c;
            }
         // debugsLog.add('Entered in getPSRUsersOptions::assPSRids ::'+assPSRids );
         // debugsLog.add('Entered in getPSRUsersOptions::u.Id ::'+u.Id );
         // debugsLog.add('Entered in getPSRUsersOptions::u.Id ::'+assPSRids.indexOf(u.Id));
            if(!(assPSRids != null && assPSRids.indexOf(u.Id)>=0)){
            	SelectOption opt= null;
            	String name ='';
            	if(u.FirstName != null) name += u.FirstName +' ';
            	if(u.lastName != null) name += u.lastName;
            	//if (u.Extension == null)
                	// opt = new SelectOption(u.id,u.Name);
                //else
                	//opt= new SelectOption(u.id,u.Name + ' # ' + u.Extension);
                	opt = new SelectOption(u.id,name);
                	if(options == null)
                		options = new List<SelectOption>();
                	options.add(opt);
             }
        }
         //debugsLog.add('Entered in getPSRUsersOptions::options ::'+options);
        return options;      
    }
  
    public List<SelectOption> getAssignedPSRUsersOptions(){
        List<SelectOption> options = null;
        //options.add(new SelectOption('--','--'));
        if(psrUsers  == null){
            psrUsers = getPSRUsers();
        }
        Map<ID,User> mapPsrUsers = new Map<ID,User>();
        for(User u :psrUsers){
        	mapPsrUsers.put(u.Id,u);
        }
        if(acct.Assigned_PSR_IDS__c != null && acct.Assigned_PSR_IDS__c != ''){
        	for(String psrID : acct.Assigned_PSR_IDS__c.split(',')){
        		// Added id length check for case # 00071523
        		if(psrID.length() == 15 || psrID.length() == 18){
        			SelectOption opt= null;
	            	String name ='';
	            	User u = mapPsrUsers.get(psrID);
	            	if(u != null){
	            		if(u.FirstName != null) name += u.FirstName +' ';
	            		if(u.lastName != null) name += u.lastName;
	            		opt = new SelectOption(u.id,name);	
	            	}
	            	if(opt != null){
	            		if(options == null)
	                		options = new List<SelectOption>();	
	                	options.add(opt);
	            	}	
        		}
        	} 
        }
       /*  
        for(User u :psrUsers){
            String assPSRids =null;
            if(acct.Assigned_PSR_IDS__c != null){
               assPSRids = acct.Assigned_PSR_IDS__c;
            }
            if((assPSRids != null && assPSRids.indexOf(u.Id)>=0)){
            	SelectOption opt= null;
            	String name ='';
            	if(u.FirstName != null) name += u.FirstName +' ';
            	if(u.lastName != null) name += u.lastName;
                //if (u.Extension == null)
                	 //opt = new SelectOption(u.id,u.Name);
                //else
                	//opt= new SelectOption(u.id,u.Name + ' # ' + u.Extension);
				opt = new SelectOption(u.id,name);				                	
                if(options == null)
                	options = new List<SelectOption>();	
                options.add(opt);
             }
        }*/
        return options;      
    }
	//For Saving Users List
	//Save and Close Popup and Refresh Parent
    public PageReference save1(){
       	update acct;
        closeStatus='save';
        PageReference pf = new PageReference('/apex/AssignedPSRPage?id='+acct.id);
        return pf;
    }
    //Cancel and Close Popup
    public PageReference cancel(){
        update acct;
        closeStatus = 'close';
        PageReference pf = new PageReference('/apex/AssignedPSRPage?id='+acct.id);
        return pf;

    }

    
}