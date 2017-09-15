//Implement SingleTon Design Framework
//Only one instance should be reated
//BLUEWOLF

public class PriceListItemUtilityLease {
    private static Decimal smsPriceToAdd = 0;
    private static Decimal promotionalDiscountToAdd = 0;//for case 00057686
    private static Boolean discountAvail = false;
    private static Boolean promotionalDiscountAvail = false;//for case 00057686
    private static Decimal promotionalDiscount = 0;//for case 00057686
    private static Decimal alaCartapromotionalDiscountToAdd = 0;//for case 00057686
    private static String alaCartPromotionalDiscountId;

    //Start for case # 00047219 - closed by customer
    //private static Decimal euDiscToAdd = 0;
    //private static Decimal euDisc = null;
    //private static Decimal euDiscQty = null;
    //End for case # 00047219 - closed by customer
    public static String serviceCreditSMSItemId = null;
    public static String promotionalDiscountItemId = null;
    public static String alaCartapromotionalDiscountItemId = null;

    //static reference to the class
    private static PriceListItemUtilityLease instance = new PriceListItemUtilityLease();
    //private constructor
    private PriceListItemUtilityLease(){}
    //return instance of this class
    public static PriceListItemUtilityLease newInstance(){
        return instance;
    }
    // Added for Case 00042521
    private static Boolean moduleItemPresent = true;
    private static Boolean moduleAlaCarteItemPresent = false;

    private static final String SMARTPACK_PANELITEM ='Module';

    //added for case#00058280
    public static final String SMARTPACK_POITEMTYPE ='Smart Pack';
    public static final String PVINVERTER_POITEMTYPE ='PV + Inverter';
    public static final String ALACARTE_POITEMTYPE = 'Ala Carte';

	public static String setErrorAlaCarteItems; //for Case# 00088825
    /*
    Function 1 isValidDesignForUser
    Functionality:-
    Fetch the Item from SunPower_Design_Item__c as per the SunPower Design
    Fetch the PriceList Items where  ITem_ID__c == Oracle_Item_ID__C
    ( We can use it for:-
        1. When using a SunPower Design to create a new Purchase Order, we will use this class to validate that the line items in the Design are available for the current user. If any of the line items are not then the user should get an error message listing the items that are not available for this user.
    )

    >>Arguments
        UserID
        SunPower_Design__c ID
    >>Return True/False
    */
   /* public static boolean isValidDesignForUser(String userID,String designID){
        Account acct = null;
        Set<String> validItemIDs = new Set<String>();
        for(User u :[select id,Name,contactId,Contact.AccountID,Contact.Account.Oracle_Operating_Unit__c,Contact.Account.AccountNumber,Contact.Account.Name,Contact.Account.ShippingStreet,Contact.Account.ShippingState,Contact.Account.ShippingCity,Contact.Account.ShippingCountry,Contact.Account.ShippingPostalCode from User where id = :userID and ContactID != null LIMIT 1])
            acct = u.Contact.Account;
        //Invalid User
        if(acct == null)
            return false;
        if(acct.Oracle_Operating_Unit__c != null){
            String operatingUnit = acct.Oracle_Operating_Unit__c;
            Date currentDate = Date.today();
            for(Price_List_Item__c pl:[Select p.Type_2__c, p.Type_1__c, p.Quantity_2__c, p.Quantity_1__c, p.Pricing_2__c, p.Pricing_3__c,p.Pricing_1__c,p.Price_List__r.Expedite_Fee__c ,p.Price_List__r.Oracle_Operating_Unit__c, p.Price_List__r.Name, p.Price_List__c, p.Oracle_Item_ID__c, p.Name, p.Effective_Start_Date__c, p.Effective_End_Date__c, p.Description__c, p.Category__c From Price_List_Item__c p where p.Price_List__r.Oracle_Operating_Unit__c = :operatingUnit and p.Effective_Start_Date__c <=:currentDate and p.Effective_End_Date__c >=:currentDate]){
                validItemIDs.add(pl.Oracle_Item_ID__c);
            }
            for( SunPower_Design_Item__c designItem : [Select s.SunPower_Design__c, s.Quantity__c, s.Name, s.Item_ID__c, s.Is_Smart_Pack_Item__c, s.Id, s.Description__c, s.Component_Type__c From SunPower_Design_Item__c s where s.SunPower_Design__c = :designID LIMIT 1000]){
                if(!validItemIDs.contains(designItem.Item_ID__c))
                    return false; //Not a Valid Item so return false;
            }
        }//ends of if(acct.Oracle_Operating_Unit__c != null)
        return true;
    }*/

    /*
    Function 2.1 getPriceListForDealer
    Use the current dealer users Account.Oracle_Operating_Unit__c field to filter the Price_List items that match the Oracle_Operating_Unit.
    Also filter the products in the price list items that have an effective date range that matches the current date. (Between Effective start date and Effective
    End Date)
    ( We can use it for:-
        2. Within the Purchase Order Wizard "Add Products" step we will use this class to create the available list or products that the user can add to the order.
    )
    >>Arguments
            AccountID
    >>Return
        List<Price_List__c> else null
    */
    /*
    public  static  List<Price_List_Item__c> getPriceListForDealer(String accountID){
        List<Price_List_Item__c> priceList = null;
        String operatingUnit =null;
        for(Account acct:[select id,Name,Oracle_Operating_Unit__c from account where ID =:accountID LIMIT 1])
            operatingUnit = acct.Oracle_Operating_Unit__c;
        if(operatingUnit != null){
            Date currentDate = Date.today();
            priceList = [Select p.Type_2__c, p.Type_1__c, p.Quantity_2__c, p.Quantity_1__c, p.Pricing_2__c,p.Pricing_3__c, p.Pricing_1__c, p.Price_List__r.Expedite_Fee__c ,p.Price_List__r.Oracle_Operating_Unit__c, p.Price_List__r.Name, p.Price_List__c, p.Oracle_Item_ID__c, p.Name, p.Effective_Start_Date__c, p.Effective_End_Date__c, p.Description__c, p.Category__c From Price_List_Item__c p where p.Price_List__r.Oracle_Operating_Unit__c = :operatingUnit and p.Effective_Start_Date__c <=:currentDate and p.Effective_End_Date__c >=:currentDate Limit 1000];
        }
        return  priceList;
    }
    */
    /*
        Function 2.2 getPriceListForDealer
    */

    /*public  static  ApexPages.Standardsetcontroller getPriceListForDealer2(String accountID){
        List<Price_List_Item__c> priceList = null;
        String operatingUnit =null;
        for(Account acct:[select id,Name,Oracle_Operating_Unit__c from account where ID =:accountID LIMIT 1])
            operatingUnit = acct.Oracle_Operating_Unit__c;
        if(operatingUnit != null){
            Date currentDate = Date.today();
            //String qry = 'Select p.Type_2__c, p.Type_1__c, p.Quantity_2__c, p.Quantity_1__c, p.Pricing_2__c, p.Pricing_1__c, p.Price_List__r.Expedite_Fee__c , p.Price_List__r.Oracle_Operating_Unit__c, p.Price_List__r.Name, p.Price_List__c, p.Oracle_Item_ID__c, p.Name, p.Effective_Start_Date__c, p.Effective_End_Date__c, p.Description__c, p.Category__c From Price_List_Item__c p where p.Price_List__r.Oracle_Operating_Unit__c = :operatingUnit and p.Effective_Start_Date__c <=:currentDate and p.Effective_End_Date__c >=:currentDate';
            String qry = 'Select p.Type_2__c, p.Type_1__c, p.Quantity_2__c, p.Quantity_1__c, p.Pricing_2__c, p.Pricing_1__c, p.Price_List__r.Expedite_Fee__c , p.Price_List__r.Oracle_Operating_Unit__c, p.Price_List__r.Name, p.Price_List__c, p.Name, p.Effective_Start_Date__c, p.Effective_End_Date__c, p.Category__c From Price_List_Item__c p where p.Price_List__r.Oracle_Operating_Unit__c = :operatingUnit and p.Effective_Start_Date__c <=:currentDate and p.Effective_End_Date__c >=:currentDate';
            ApexPages.Standardsetcontroller setCon = new ApexPages.StandardSetController(Database.getQueryLocator(qry));
            return setCon;
        }
        return  null;
    }*/
    /*
        Function:   2.3
        Function responsible return the StandardSetControl
    */
    /*
    public static ApexPages.Standardsetcontroller getPriceListForDealer2_FilterType2(String accountID, String type2){
        List<Price_List_Item__c> priceList = null;
        String operatingUnit =null;
        for(Account acct:[select id,Name,Oracle_Operating_Unit__c from account where ID =:accountID LIMIT 1])
            operatingUnit = acct.Oracle_Operating_Unit__c;
        if(operatingUnit != null){
            Date currentDate = Date.today();
            String qry = null;
            if(type2 != null && type2 != '--None--'){
                type2 =type2.trim();
                qry ='Select p.Type_2__c, p.Type_1__c, p.Quantity_2__c, p.Quantity_1__c, p.Pricing_2__c, p.Pricing_1__c, p.Price_List__r.Expedite_Fee__c ,p.Price_List__r.Oracle_Operating_Unit__c, p.Price_List__r.Name, p.Price_List__c, p.Oracle_Item_ID__c, p.Name, p.Effective_Start_Date__c, p.Effective_End_Date__c, p.Description__c, p.Category__c From Price_List_Item__c p where p.Price_List__r.Oracle_Operating_Unit__c = :operatingUnit and p.Effective_Start_Date__c <=:currentDate and p.Effective_End_Date__c >=:currentDate and p.Type_2__c = \''+type2 +'\'';
            }
            else
                qry = 'Select p.Type_2__c, p.Type_1__c, p.Quantity_2__c, p.Quantity_1__c, p.Pricing_2__c, p.Pricing_1__c, p.Price_List__r.Expedite_Fee__c ,p.Price_List__r.Oracle_Operating_Unit__c, p.Price_List__r.Name, p.Price_List__c, p.Oracle_Item_ID__c, p.Name, p.Effective_Start_Date__c, p.Effective_End_Date__c, p.Description__c, p.Category__c From Price_List_Item__c p where p.Price_List__r.Oracle_Operating_Unit__c = :operatingUnit and p.Effective_Start_Date__c <=:currentDate and p.Effective_End_Date__c >=:currentDate';
            ApexPages.Standardsetcontroller setCon = new ApexPages.StandardSetController(Database.getQueryLocator(qry));
            return setCon;
        }
        return  null;
    }
    */
    /*
        Function 3.1 getFilteredPriceListItems
        Filter
        ( We can use it for:-
            3. We will use this for a custom VF page used for Administrators to mange the price lists. This page should have 2 inputs: the Oracle Operating Unit and the selected Date. It would then allow the user to generate a price list that match the inputs.
        )
        >>Arguments
                Oracle Operating Unit
                selected Date
        >>Return
            ApexPages.Standardsetcontroller else null
    */

    /*public static ApexPages.Standardsetcontroller   getFilteredPriceItemsSet(String operatingUnit, Date selDate){
        //String qry = 'select p.Type_2__c, p.Type_1__c, p.Quantity_3__c, p.Quantity_2__c, p.Quantity_1__c, p.Product_Unique_ID__c, p.Pricing_3__c, p.Pricing_2__c, p.Pricing_1__c, p.OwnerId, p.Oracle_Operating_Unit__c, p.Oracle_Item_ID__c, p.Name, p.Id, p.Effective_Start_Date__c, p.Effective_End_Date__c, p.Description__c From Price_List__c p where Oracle_Operating_Unit__c = :operatingUnit and p.Effective_Start_Date__c <=:selDate and p.Effective_End_Date__c >=:selDate';
        String qry = 'Select p.Type_2__c, p.Type_1__c, p.Quantity_2__c, p.Quantity_1__c, p.Pricing_2__c, p.Pricing_3__c,p.Pricing_1__c, p.Price_List__r.Expedite_Fee__c ,p.Price_List__r.Oracle_Operating_Unit__c, p.Price_List__r.Name, p.Price_List__c, p.Name, p.Effective_Start_Date__c, p.Effective_End_Date__c,  p.Category__c From Price_List_Item__c p where p.Price_List__r.Oracle_Operating_Unit__c = :operatingUnit and p.Effective_Start_Date__c <=:selDate and p.Effective_End_Date__c >=:selDate';
        ApexPages.Standardsetcontroller setCon = new ApexPages.StandardSetController(Database.getQueryLocator(qry));
        return setCon;
    }*/
    /* Function 3.2*/
    // Same as above but return List instead ApexPages.Standardsetcontroller
    /*public static List<Price_List_Item__c> getFilteredPriceItemsList(String operatingUnit, Date selDate){
        return [Select p.Type_2__c, p.Type_1__c, p.Quantity_2__c, p.Quantity_1__c, p.Pricing_2__c,p.Pricing_3__c, p.Pricing_1__c, p.Price_List__r.Expedite_Fee__c ,p.Price_List__r.Oracle_Operating_Unit__c, p.Price_List__r.Name, p.Price_List__c, p.Name, p.Effective_Start_Date__c, p.Effective_End_Date__c, p.Category__c From Price_List_Item__c p where p.Price_List__r.Oracle_Operating_Unit__c = :operatingUnit and p.Effective_Start_Date__c <=:selDate and p.Effective_End_Date__c >=:selDate Limit 1000];
    }*/
    //Function 4
    //query modified to PriceList insted of Expedite_Fee__c
    /** This function fetches the price list for selected dealer account.
     *  @return Price_List__c
     */
    public static Price_List__c getExpediteFeeForPriceList(String accountID){
        String operatingUnit =null;
        for(Account acct:[select id,Name,Oracle_Operating_Unit__c from account where ID =:accountID LIMIT 1])
            operatingUnit = acct.Oracle_Operating_Unit__c;
        //Double curr =0.0;
        Price_List__c priceList;
        if(operatingUnit != null && operatingUnit != '')
            for(Price_List__c pr:[select id, Oracle_Operating_Unit__c, Expedite_Fee__c, Shipping_Codes__c, DSR_PO_Group_Email__c  from Price_List__c where Oracle_Operating_Unit__c =:operatingUnit Limit 1]){
                //curr= pr.Expedite_Fee__c;
                priceList = pr;
            }
            //return curr;
        return priceList;
    }

    public static Price_List__c getExpediteFeeForPriceListLease(String operatingUnit){

        Price_List__c priceList;
        if(operatingUnit != null && operatingUnit != '')
            for(Price_List__c pr:[select id, Oracle_Operating_Unit__c, Expedite_Fee__c, Shipping_Codes__c, DSR_PO_Group_Email__c  from Price_List__c where Oracle_Operating_Unit__c =:operatingUnit Limit 1]){
                //curr= pr.Expedite_Fee__c;
                priceList = pr;
            }
            //return curr;
        return priceList;
    }

    public  static  ApexPages.Standardsetcontroller getPriceListForDealer2AlaCarteLease(String operatingUnit){
        List<Price_List_Item__c> priceList = null;
        if(operatingUnit != null){
            Date currentDate = Date.today();
            // following changes are made in query
            // 1) Oracle_Item_ID__c - Text(18)    replaced by Item_ID - Lookup(Item)
            // 2) Description__c - Long Text Area(4000)  replaced by Item_Description__c - Formula (Text)
            //String qry = 'Select p.CurrencyIsoCode,p.Type_2__c, p.Type_1__c, p.Quantity_2__c, p.Quantity_1__c, p.Pricing_3__c,p.Pricing_2__c, p.Pricing_1__c, p.Price_List__r.Expedite_Fee__c , p.Price_List__r.Oracle_Operating_Unit__c, p.Price_List__r.Name, p.Price_List__c, p.Oracle_Item_ID__c, p.Name, p.Effective_Start_Date__c, p.Effective_End_Date__c, p.Description__c, p.Category__c From Price_List_Item__c p where p.Price_List__r.Oracle_Operating_Unit__c = :operatingUnit and p.Effective_Start_Date__c <=:currentDate and p.Effective_End_Date__c >=:currentDate and p.Is_Active__c = \'true\' and p.Type_1__c =\'Ala Carte\'';
            String qry = 'Select p.Disc_Item_ID__c,p.Disc_Item_Description__c,p.Disc_Item_ID__r.Name,p.CurrencyIsoCode,p.Type_2__c, p.Type_1__c, p.Quantity_2__c, p.Quantity_1__c, p.Pricing_3__c,p.Pricing_2__c, p.Pricing_1__c, p.Price_List__r.Expedite_Fee__c , p.Price_List__r.Oracle_Operating_Unit__c, p.Price_List__r.Name, p.Price_List__c, p.Item_ID__c, p.Item_ID__r.Name, p.Name, p.Effective_Start_Date__c, p.Effective_End_Date__c, p.Item_Description__c, p.Category__c From Price_List_Item__c p where p.Price_List__r.Oracle_Operating_Unit__c = :operatingUnit and p.Effective_Start_Date__c <=:currentDate and p.Effective_End_Date__c >=:currentDate and p.Is_Active__c = \'true\' and p.Type_1__c =\'Ala Carte\' order by p.Item_Description__c';
            ApexPages.Standardsetcontroller setCon = new ApexPages.StandardSetController(Database.getQueryLocator(qry));
            return setCon;
        }
        return  null;
    }

//Function 5.1
//Fetch only Ala-carte Items
    /** This function fetches the Ala-Carte price list items for selected dealer account.
     *  @return ApexPages.Standardsetcontroller
     */
    public  static  ApexPages.Standardsetcontroller getPriceListForDealer2AlaCarte(String accountID){
        List<Price_List_Item__c> priceList = null;
        String operatingUnit =null;
        for(Account acct:[select id,Name,Oracle_Operating_Unit__c from account where ID =:accountID LIMIT 1])
            operatingUnit = acct.Oracle_Operating_Unit__c;
        if(operatingUnit != null){
            Date currentDate = Date.today();
            // following changes are made in query
            // 1) Oracle_Item_ID__c - Text(18)    replaced by Item_ID - Lookup(Item)
            // 2) Description__c - Long Text Area(4000)  replaced by Item_Description__c - Formula (Text)
            //String qry = 'Select p.CurrencyIsoCode,p.Type_2__c, p.Type_1__c, p.Quantity_2__c, p.Quantity_1__c, p.Pricing_3__c,p.Pricing_2__c, p.Pricing_1__c, p.Price_List__r.Expedite_Fee__c , p.Price_List__r.Oracle_Operating_Unit__c, p.Price_List__r.Name, p.Price_List__c, p.Oracle_Item_ID__c, p.Name, p.Effective_Start_Date__c, p.Effective_End_Date__c, p.Description__c, p.Category__c From Price_List_Item__c p where p.Price_List__r.Oracle_Operating_Unit__c = :operatingUnit and p.Effective_Start_Date__c <=:currentDate and p.Effective_End_Date__c >=:currentDate and p.Is_Active__c = \'true\' and p.Type_1__c =\'Ala Carte\'';
            String qry = 'Select p.Disc_Item_ID__c,p.Disc_Item_Description__c,p.Disc_Item_ID__r.Name,p.CurrencyIsoCode,p.Type_2__c, p.Type_1__c, p.Quantity_2__c, p.Quantity_1__c, p.Pricing_3__c,p.Pricing_2__c, p.Pricing_1__c, p.Price_List__r.Expedite_Fee__c , p.Price_List__r.Oracle_Operating_Unit__c, p.Price_List__r.Name, p.Price_List__c, p.Item_ID__c, p.Item_ID__r.Name, p.Name, p.Effective_Start_Date__c, p.Effective_End_Date__c, p.Item_Description__c, p.Category__c From Price_List_Item__c p where p.Price_List__r.Oracle_Operating_Unit__c = :operatingUnit and p.Effective_Start_Date__c <=:currentDate and p.Effective_End_Date__c >=:currentDate and p.Is_Active__c = \'true\' and p.Type_1__c =\'Ala Carte\' order by p.Item_Description__c';
            ApexPages.Standardsetcontroller setCon = new ApexPages.StandardSetController(Database.getQueryLocator(qry));
            return setCon;
        }
        return  null;
    }
    //ADDED BY BW to hard code operating unit
    public  static  ApexPages.Standardsetcontroller getPriceListForDealer2AlaCarteAndBOSLease(String operatingUnit){
        List<Price_List_Item__c> priceList = null;
        if(operatingUnit != null){
            Date currentDate = Date.today();
            // following changes are made in query
            // 1) Oracle_Item_ID__c - Text(18)    replaced by Item_ID - Lookup(Item)
            // 2) Description__c - Long Text Area(4000)  replaced by Item_Description__c - Formula (Text)
            //String qry = 'Select p.CurrencyIsoCode,p.Type_2__c, p.Type_1__c, p.Quantity_2__c, p.Quantity_1__c, p.Pricing_3__c,p.Pricing_2__c, p.Pricing_1__c, p.Price_List__r.Expedite_Fee__c , p.Price_List__r.Oracle_Operating_Unit__c, p.Price_List__r.Name, p.Price_List__c, p.Oracle_Item_ID__c, p.Name, p.Effective_Start_Date__c, p.Effective_End_Date__c, p.Description__c, p.Category__c From Price_List_Item__c p where p.Price_List__r.Oracle_Operating_Unit__c = :operatingUnit and p.Effective_Start_Date__c <=:currentDate and p.Effective_End_Date__c >=:currentDate and p.Is_Active__c = \'true\' and p.Type_1__c =\'Ala Carte\' and p.Category__c =\'BoS\'';
            String qry = 'Select p.Disc_Item_ID__c,p.Disc_Item_Description__c,p.Disc_Item_ID__r.Name,p.CurrencyIsoCode,p.Type_2__c, p.Type_1__c, p.Quantity_2__c, p.Quantity_1__c, p.Pricing_3__c,p.Pricing_2__c, p.Pricing_1__c, p.Price_List__r.Expedite_Fee__c , p.Price_List__r.Oracle_Operating_Unit__c, p.Price_List__r.Name, p.Price_List__c, p.Item_ID__c, p.Item_ID__r.Name, p.Name, p.Effective_Start_Date__c, p.Effective_End_Date__c, p.Item_Description__c, p.Category__c From Price_List_Item__c p where p.Price_List__r.Oracle_Operating_Unit__c = :operatingUnit and p.Effective_Start_Date__c <=:currentDate and p.Effective_End_Date__c >=:currentDate and p.Is_Active__c = \'true\' and p.Type_1__c =\'Ala Carte\' and p.Category__c =\'BoS\' order by p.Item_Description__c';
            ApexPages.Standardsetcontroller setCon = new ApexPages.StandardSetController(Database.getQueryLocator(qry));
            return setCon;
        }
        return  null;
    }

    //Function 5.1
//Fetch only Ala-carte and BoS category Items for purchase orders having design id
    /** This function fetches the price list items of type_2 Ala-Carte and Category BoS for selected dealer account.
     *  @return ApexPages.Standardsetcontroller
     */
    public  static  ApexPages.Standardsetcontroller getPriceListForDealer2AlaCarteAndBOS(String accountID){
        List<Price_List_Item__c> priceList = null;
        String operatingUnit =null;
        for(Account acct:[select id,Name,Oracle_Operating_Unit__c from account where ID =:accountID LIMIT 1])
            operatingUnit = acct.Oracle_Operating_Unit__c;
        if(operatingUnit != null){
            Date currentDate = Date.today();
            // following changes are made in query
            // 1) Oracle_Item_ID__c - Text(18)    replaced by Item_ID - Lookup(Item)
            // 2) Description__c - Long Text Area(4000)  replaced by Item_Description__c - Formula (Text)
            //String qry = 'Select p.CurrencyIsoCode,p.Type_2__c, p.Type_1__c, p.Quantity_2__c, p.Quantity_1__c, p.Pricing_3__c,p.Pricing_2__c, p.Pricing_1__c, p.Price_List__r.Expedite_Fee__c , p.Price_List__r.Oracle_Operating_Unit__c, p.Price_List__r.Name, p.Price_List__c, p.Oracle_Item_ID__c, p.Name, p.Effective_Start_Date__c, p.Effective_End_Date__c, p.Description__c, p.Category__c From Price_List_Item__c p where p.Price_List__r.Oracle_Operating_Unit__c = :operatingUnit and p.Effective_Start_Date__c <=:currentDate and p.Effective_End_Date__c >=:currentDate and p.Is_Active__c = \'true\' and p.Type_1__c =\'Ala Carte\' and p.Category__c =\'BoS\'';
            String qry = 'Select p.Disc_Item_ID__c,p.Disc_Item_Description__c,p.Disc_Item_ID__r.Name,p.CurrencyIsoCode,p.Type_2__c, p.Type_1__c, p.Quantity_2__c, p.Quantity_1__c, p.Pricing_3__c,p.Pricing_2__c, p.Pricing_1__c, p.Price_List__r.Expedite_Fee__c , p.Price_List__r.Oracle_Operating_Unit__c, p.Price_List__r.Name, p.Price_List__c, p.Item_ID__c, p.Item_ID__r.Name, p.Name, p.Effective_Start_Date__c, p.Effective_End_Date__c, p.Item_Description__c, p.Category__c From Price_List_Item__c p where p.Price_List__r.Oracle_Operating_Unit__c = :operatingUnit and p.Effective_Start_Date__c <=:currentDate and p.Effective_End_Date__c >=:currentDate and p.Is_Active__c = \'true\' and p.Type_1__c =\'Ala Carte\' and p.Category__c =\'BoS\' order by p.Item_Description__c';
            ApexPages.Standardsetcontroller setCon = new ApexPages.StandardSetController(Database.getQueryLocator(qry));
            return setCon;
        }
        return  null;
    }
    //ADDED BY BW to have hard coded operating unit
    public static ApexPages.Standardsetcontroller getPriceListForDealer2_FilterType2AlaCarteLease(String operatingUnit, String selectedCategory,String productDescFilter){//added for case # 00047707
        List<Price_List_Item__c> priceList = null;
        String prodFilter='';
        //if(productNameFilter != null && productNameFilter !=''){//removed for case # 00047707
            //prodFilter = ' and p.Item_ID__r.Name like \'%' + productNameFilter + '%\'';//removed for case # 00047707
        if(productDescFilter != null && productDescFilter !=''){//added for case # 00047707
            prodFilter = ' and p.Item_ID__r.Description__c like \'%' + productDescFilter + '%\'';
        }

        if(operatingUnit != null){
            Date currentDate = Date.today();
            String qry = null;
            //if(selectedCategory != null && selectedCategory != '--None--'){
            if(selectedCategory != null && selectedCategory != System.Label.POWizardNonePicklistValue){
                selectedCategory = selectedCategory.trim();
                // following changes are made in query
                // 1) Oracle_Item_ID__c - Text(18)    replaced by Item_ID - Lookup(Item)
                // 2) Description__c - Long Text Area(4000)  replaced by Item_Description__c - Formula (Text)
                //qry ='Select p.CurrencyIsoCode,p.Type_2__c, p.Type_1__c, p.Quantity_2__c, p.Quantity_1__c, p.Pricing_2__c,p.Pricing_3__c, p.Pricing_1__c, p.Price_List__r.Expedite_Fee__c ,p.Price_List__r.Oracle_Operating_Unit__c, p.Price_List__r.Name, p.Price_List__c, p.Oracle_Item_ID__c, p.Name, p.Effective_Start_Date__c, p.Effective_End_Date__c, p.Description__c, p.Category__c From Price_List_Item__c p where p.Price_List__r.Oracle_Operating_Unit__c = :operatingUnit and p.Effective_Start_Date__c <=:currentDate and p.Effective_End_Date__c >=:currentDate and p.Is_Active__c = \'true\' and type_1__c = \'Ala Carte\' and p.Category__c = \''+selectedCategory +'\'';
                  qry ='Select p.Disc_Item_ID__c,p.Disc_Item_Description__c,p.Disc_Item_ID__r.Name,p.CurrencyIsoCode,p.Type_2__c, p.Type_1__c, p.Quantity_2__c, p.Quantity_1__c, p.Pricing_2__c,p.Pricing_3__c, p.Pricing_1__c, p.Price_List__r.Expedite_Fee__c ,p.Price_List__r.Oracle_Operating_Unit__c, p.Price_List__r.Name, p.Price_List__c, p.Item_ID__c, p.Item_ID__r.Name, p.Name, p.Effective_Start_Date__c, p.Effective_End_Date__c, p.Item_Description__c, p.Category__c From Price_List_Item__c p where p.Price_List__r.Oracle_Operating_Unit__c = :operatingUnit and p.Effective_Start_Date__c <=:currentDate and p.Effective_End_Date__c >=:currentDate and p.Is_Active__c = \'true\' and type_1__c = \'Ala Carte\' and p.Category__c = \''+selectedCategory +'\'' + prodFilter;
                  System.debug('TEST===================='+qry);
            }
            else{
                //qry = 'Select p.CurrencyIsoCode,p.Type_2__c, p.Type_1__c, p.Quantity_2__c, p.Quantity_1__c, p.Pricing_2__c, p.Pricing_3__c,p.Pricing_1__c, p.Price_List__r.Expedite_Fee__c ,p.Price_List__r.Oracle_Operating_Unit__c, p.Price_List__r.Name, p.Price_List__c, p.Oracle_Item_ID__c, p.Name, p.Effective_Start_Date__c, p.Effective_End_Date__c, p.Description__c, p.Category__c From Price_List_Item__c p where p.Price_List__r.Oracle_Operating_Unit__c = :operatingUnit and p.Effective_Start_Date__c <=:currentDate and p.Effective_End_Date__c >=:currentDate and p.Is_Active__c = \'true\' and type_1__c = \'Ala Carte\'' ;
                  qry = 'Select p.Disc_Item_ID__c,p.Disc_Item_Description__c,p.Disc_Item_ID__r.Name,p.CurrencyIsoCode,p.Type_2__c, p.Type_1__c, p.Quantity_2__c, p.Quantity_1__c, p.Pricing_2__c, p.Pricing_3__c,p.Pricing_1__c, p.Price_List__r.Expedite_Fee__c ,p.Price_List__r.Oracle_Operating_Unit__c, p.Price_List__r.Name, p.Price_List__c, p.Item_ID__c, p.Item_ID__r.Name, p.Name, p.Effective_Start_Date__c, p.Effective_End_Date__c, p.Item_Description__c, p.Category__c From Price_List_Item__c p where p.Price_List__r.Oracle_Operating_Unit__c = :operatingUnit and p.Effective_Start_Date__c <=:currentDate and p.Effective_End_Date__c >=:currentDate and p.Is_Active__c = \'true\' and type_1__c = \'Ala Carte\'' + prodFilter ;
                 System.debug('TEST===================='+qry);
            }
            qry += ' order by p.Item_Description__c';
            ApexPages.Standardsetcontroller setCon = new ApexPages.StandardSetController(Database.getQueryLocator(qry));
            return setCon;
        }
        return  null;
    }

//Fetch only Filtered Ala-carte Items
//Funtion 5.2
    /** This function fetches price list items of selected category for selected dealer account.
     *  @return ApexPages.Standardsetcontroller
     */
    //public static ApexPages.Standardsetcontroller getPriceListForDealer2_FilterType2AlaCarte(String accountID, String selectedCategory,String productNameFilter){//removed for case # 00047707
    public static ApexPages.Standardsetcontroller getPriceListForDealer2_FilterType2AlaCarte(String accountID, String selectedCategory,String productDescFilter){//added for case # 00047707
        List<Price_List_Item__c> priceList = null;
        String prodFilter='';
        //if(productNameFilter != null && productNameFilter !=''){//removed for case # 00047707
            //prodFilter = ' and p.Item_ID__r.Name like \'%' + productNameFilter + '%\'';//removed for case # 00047707
        if(productDescFilter != null && productDescFilter !=''){//added for case # 00047707
            prodFilter = ' and p.Item_ID__r.Description__c like \'%' + productDescFilter + '%\'';
        }
        String operatingUnit =null;
        for(Account acct:[select id,Name,Oracle_Operating_Unit__c from account where ID =:accountID LIMIT 1])
            operatingUnit = acct.Oracle_Operating_Unit__c;
        if(operatingUnit != null){
            Date currentDate = Date.today();
            String qry = null;
            //if(selectedCategory != null && selectedCategory != '--None--'){
            if(selectedCategory != null && selectedCategory != System.Label.POWizardNonePicklistValue){
                selectedCategory = selectedCategory.trim();
                // following changes are made in query
                // 1) Oracle_Item_ID__c - Text(18)    replaced by Item_ID - Lookup(Item)
                // 2) Description__c - Long Text Area(4000)  replaced by Item_Description__c - Formula (Text)
                //qry ='Select p.CurrencyIsoCode,p.Type_2__c, p.Type_1__c, p.Quantity_2__c, p.Quantity_1__c, p.Pricing_2__c,p.Pricing_3__c, p.Pricing_1__c, p.Price_List__r.Expedite_Fee__c ,p.Price_List__r.Oracle_Operating_Unit__c, p.Price_List__r.Name, p.Price_List__c, p.Oracle_Item_ID__c, p.Name, p.Effective_Start_Date__c, p.Effective_End_Date__c, p.Description__c, p.Category__c From Price_List_Item__c p where p.Price_List__r.Oracle_Operating_Unit__c = :operatingUnit and p.Effective_Start_Date__c <=:currentDate and p.Effective_End_Date__c >=:currentDate and p.Is_Active__c = \'true\' and type_1__c = \'Ala Carte\' and p.Category__c = \''+selectedCategory +'\'';
                  qry ='Select p.Disc_Item_ID__c,p.Disc_Item_Description__c,p.Disc_Item_ID__r.Name,p.CurrencyIsoCode,p.Type_2__c, p.Type_1__c, p.Quantity_2__c, p.Quantity_1__c, p.Pricing_2__c,p.Pricing_3__c, p.Pricing_1__c, p.Price_List__r.Expedite_Fee__c ,p.Price_List__r.Oracle_Operating_Unit__c, p.Price_List__r.Name, p.Price_List__c, p.Item_ID__c, p.Item_ID__r.Name, p.Name, p.Effective_Start_Date__c, p.Effective_End_Date__c, p.Item_Description__c, p.Category__c From Price_List_Item__c p where p.Price_List__r.Oracle_Operating_Unit__c = :operatingUnit and p.Effective_Start_Date__c <=:currentDate and p.Effective_End_Date__c >=:currentDate and p.Is_Active__c = \'true\' and type_1__c = \'Ala Carte\' and p.Category__c = \''+selectedCategory +'\'' + prodFilter;
                  System.debug('TEST===================='+qry);
            }
            else{
                //qry = 'Select p.CurrencyIsoCode,p.Type_2__c, p.Type_1__c, p.Quantity_2__c, p.Quantity_1__c, p.Pricing_2__c, p.Pricing_3__c,p.Pricing_1__c, p.Price_List__r.Expedite_Fee__c ,p.Price_List__r.Oracle_Operating_Unit__c, p.Price_List__r.Name, p.Price_List__c, p.Oracle_Item_ID__c, p.Name, p.Effective_Start_Date__c, p.Effective_End_Date__c, p.Description__c, p.Category__c From Price_List_Item__c p where p.Price_List__r.Oracle_Operating_Unit__c = :operatingUnit and p.Effective_Start_Date__c <=:currentDate and p.Effective_End_Date__c >=:currentDate and p.Is_Active__c = \'true\' and type_1__c = \'Ala Carte\'' ;
                  qry = 'Select p.Disc_Item_ID__c,p.Disc_Item_Description__c,p.Disc_Item_ID__r.Name,p.CurrencyIsoCode,p.Type_2__c, p.Type_1__c, p.Quantity_2__c, p.Quantity_1__c, p.Pricing_2__c, p.Pricing_3__c,p.Pricing_1__c, p.Price_List__r.Expedite_Fee__c ,p.Price_List__r.Oracle_Operating_Unit__c, p.Price_List__r.Name, p.Price_List__c, p.Item_ID__c, p.Item_ID__r.Name, p.Name, p.Effective_Start_Date__c, p.Effective_End_Date__c, p.Item_Description__c, p.Category__c From Price_List_Item__c p where p.Price_List__r.Oracle_Operating_Unit__c = :operatingUnit and p.Effective_Start_Date__c <=:currentDate and p.Effective_End_Date__c >=:currentDate and p.Is_Active__c = \'true\' and type_1__c = \'Ala Carte\'' + prodFilter ;
                 System.debug('TEST===================='+qry);
            }
            qry += ' order by p.Item_Description__c';
            ApexPages.Standardsetcontroller setCon = new ApexPages.StandardSetController(Database.getQueryLocator(qry));
            return setCon;
        }
        return  null;
    }

    //Function 6
    /*public static List<Price_List_Item__c> getPriceListItemsForDesign(String accountID,Set<String> descrip){
        List<Price_List_Item__c> priceList = null;
        String operatingUnit =null;
        for(Account acct:[select id,Name,Oracle_Operating_Unit__c from account where ID =:accountID LIMIT 1])
            operatingUnit = acct.Oracle_Operating_Unit__c;
        if(operatingUnit != null){
            Date currentDate = Date.today();
            //priceList = [ select p.Type_2__c, p.Type_1__c, p.Quantity_3__c, p.Quantity_2__c, p.Quantity_1__c, p.Product_Unique_ID__c, p.Pricing_3__c, p.Pricing_2__c, p.Pricing_1__c, p.OwnerId, p.Oracle_Operating_Unit__c, p.Oracle_Item_ID__c, p.Name, p.Id, p.Effective_Start_Date__c, p.Effective_End_Date__c, p.Description__c From Price_List__c p where Oracle_Operating_Unit__c = :operatingUnit and p.Effective_Start_Date__c <=:currentDate and p.Effective_End_Date__c >=:currentDate LIMIT 1000];
            for(Price_List_Item__c p: [Select p.Item_Description__c,p.Type_3_Criteria__c,p.RecordTypeID,p.RecordType.Name,p.Type_2__c, p.Type_1__c, p.Quantity_2__c, p.Quantity_1__c, p.Pricing_2__c,p.Pricing_3__c, p.Pricing_1__c, p.Price_List__r.Expedite_Fee__c ,p.Price_List__r.Oracle_Operating_Unit__c, p.Price_List__r.Name, p.Price_List__c,  p.Name, p.Effective_Start_Date__c, p.Effective_End_Date__c, p.Category__c From Price_List_Item__c p where p.Price_List__r.Oracle_Operating_Unit__c = :operatingUnit and p.Effective_Start_Date__c <=:currentDate and p.Effective_End_Date__c >=:currentDate and Type_1__c = 'Smart Pack']){
                if(priceList == null) priceList = new List<Price_List_Item__c>();
                if(descrip.contains(p.Item_Description__c))
                    priceList.add(p);
            }
        }
        return  priceList;
    }*/

    //Function 7.
    //Fetch All Smart Pack Design ITems with their Price and return Design Object and also populate the List of WrapperList Items

	//BW Created function to Hard code Oracle Operating Unit
    public static SunPower_Design__c setDesignItemswithPrice(String designID,String accountID,List<LeaseOrderWizardController.PurchaseOrderLineItemWrapper> selProductItems,Purchase_Order__c purchaseOrder,Account dealerAccount,Boolean isNAUser){

    	return setDesignItemswithPrice( designID, accountID, selProductItems, purchaseOrder, dealerAccount.Oracle_Operating_Unit__c, isNAUser );

    }

//Function 8
    // this function has been changed
    // 1) Oracle_Item_ID__c - Text(18)    replaced by Item_ID - Lookup(Item)
    // 2) Description__c - Long Text Area(4000)  replaced by Item_Description__c - Formula (Text)
    /** This function fetches All Smart Pack Design ITems with their Price
     *  and also populate the List of WrapperList Items. included isEUUser
     *  @return SunPower_Design__c
     */
    public static SunPower_Design__c setDesignItemswithPrice(String designID,String accountID,List<LeaseOrderWizardController.PurchaseOrderLineItemWrapper> selProductItems,Purchase_Order__c purchaseOrder,String operatingUnit,Boolean isNAUser){
        if(designID == null || designID == '') return null;
        //Set<String> descriptionSet = new Set<String>();
        Set<String> itemIDsSet = new Set<String>();
        // Added for Case 00042518
        Set<String> aLaCarteItemIDsSet = new Set<String>();
        String packagedSystemItemId = null;
        SunPower_Design__c selectedDesign =null;
        setErrorAlaCarteItems = null; //for Case# 00088825
        //Fetch all Design Items as per the Design
        for(SunPower_Design_Item__c item:[Select s.Oracle_Item_Id__c, s.Oracle_Item_Id__r.Id, s.Oracle_Item_Id__r.Name,s.Oracle_Item_Id__r.Active__c, s.Item_Description__c, s.SunPower_Design__r.EU_Mounting_Type__c,s.SunPower_Design__r.EU_Inverter_Type__c,s.SunPower_Design__r.SmartMount__c,s.SunPower_Design__r.DealerAccount__c, s.SunPower_Design__r.Purchase_Order_Number__c, s.SunPower_Design__r.Design_Notes__c, s.SunPower_Design__r.system_size__c, s.SunPower_Design__r.Name, s.SunPower_Design__r.SMS_KIT__r.Effective_End_Date__c, s.SunPower_Design__r.SMS_KIT__r.Effective_Start_Date__c, s.SunPower_Design__r.SMS_KIT__r.Price__c, s.SunPower_Design__r.SMS_KIT__c, s.SunPower_Design__c, s.SunPower_Design__r.System_Source__c, s.Quantity__c, s.Name, s.Is_Smart_Pack_Item__c, s.Id, s.Component_Type__c From SunPower_Design_Item__c s where SunPower_Design__c =:designID and Oracle_Item_Id__c != null order by Is_Smart_Pack_Item__c desc]){
            //check if any design item is inactive then return selected design as null
            if(item.Oracle_Item_ID__r.Active__c == false)
                return null;
            if(selectedDesign == null){
                selectedDesign =item.SunPower_Design__r;
                purchaseOrder.Name = item.SunPower_Design__r.Purchase_Order_Number__c;
                purchaseOrder.SunPower_Design__c = item.SunPower_Design__c;
                purchaseOrder.SunPower_Design__r = item.SunPower_Design__r;
                purchaseOrder.System_Size__c = item.SunPower_Design__r.system_size__c;

                purchaseOrder.SmartMount__c = item.SunPower_Design__r.SmartMount__c;

                /*SMS_Pricing__c relatedSMSP = item.SunPower_Design__r.SMS_KIT__r;
                if (item.SunPower_Design__c != null && selectedDesign.SMS_KIT__c != null
                        && relatedSMSP.Effective_Start_Date__c != null && relatedSMSP.Effective_Start_Date__c <= Date.today()
                        && relatedSMSP.Effective_End_Date__c != null && relatedSMSP.Effective_End_Date__c >= Date.today()) {
                    smsPriceToAdd = relatedSMSP.Price__c;
                } else if (isNAUser) {
                    smsPriceToAdd = -200;
                    discountAvail = true;
                }*/
            }//ends of selectedDesign == null
            LeaseOrderWizardController.PurchaseOrderLineItemWrapper pWrap = new LeaseOrderWizardController.PurchaseOrderLineItemWrapper(item.ID,'0.0',item.Item_Description__c,item.Component_Type__c,String.valueOf(item.Quantity__c),item.Is_Smart_Pack_Item__c,true,'Smart Pack',item.SunPower_Design__r.EU_Mounting_Type__c,item.SunPower_Design__r.EU_Inverter_Type__c);
            //done by Jitendra for Case#00058280
            if(item.Is_Smart_Pack_Item__c)
            	pWrap.itemType = SMARTPACK_POITEMTYPE;
            else
            	pWrap.itemType = ALACARTE_POITEMTYPE;
            //done by Jitendra for Case#00058280
            pWrap.oracleItemIDRef = item.Oracle_Item_Id__c == null ? '' : item.Oracle_Item_Id__c;
            pWrap.itemID = item.Oracle_Item_Id__r.Name == null ? '': item.Oracle_Item_Id__r.Name;
            pWrap.itemSource = 'SmartPack';//for Case# 00077093
            selProductItems.add(pWrap);
            //Change here
            //if(item.Component_Type__c == SMARTPACK_PANELITEM){
            if(item.Is_Smart_Pack_Item__c && item.Component_Type__c == SMARTPACK_PANELITEM){ // Changed for Case 00042518
                if(itemIDsSet.size() ==0)
                    itemIDsSet.add(item.Oracle_Item_Id__c);
                else
                    return null; //  exists more than one so error and return
            } else if (item.Is_Smart_Pack_Item__c == false) { // Added for Case 00042518
                aLaCarteItemIDsSet.add(item.Oracle_Item_Id__c);
                if (item.Component_Type__c == SMARTPACK_PANELITEM) {
                    moduleAlaCarteItemPresent = true;
                }
            }
        }//ends of for Loop

        if(itemIDsSet == null || itemIDsSet.size() ==0) {
          // Changed for Case 00042521
          if (aLaCarteItemIDsSet.size() == 0) {
            return null;
          } else {
            moduleItemPresent = false;
          }
          //
        }

        System.debug('size of item id set*********'+itemIDsSet.size());
        System.debug('Ala-Carte item id set*********'+aLaCarteItemIDsSet);
        //Fetch all PriceListItems as per Design Description start
        Map<Id,Price_List_Item__c> priceListItems = null;
        Double systemSizeLimit = null;//for case # 00062051
        if(operatingUnit != null){
            Date currentDate = Date.today();
            System.debug('Current Date is*********'+currentDate);
            //priceList = [ select p.Type_2__c, p.Type_1__c, p.Quantity_3__c, p.Quantity_2__c, p.Quantity_1__c, p.Product_Unique_ID__c, p.Pricing_3__c, p.Pricing_2__c, p.Pricing_1__c, p.OwnerId, p.Oracle_Operating_Unit__c, p.Oracle_Item_ID__c, p.Name, p.Id, p.Effective_Start_Date__c, p.Effective_End_Date__c, p.Description__c From Price_List__c p where Oracle_Operating_Unit__c = :operatingUnit and p.Effective_Start_Date__c <=:currentDate and p.Effective_End_Date__c >=:currentDate LIMIT 1000];
            // Changed for Case 00042518
            //for(Price_List_Item__c p: [Select p.Disc_Item_ID__c,p.Disc_Item_Description__c,p.Disc_Item_ID__r.Name,p.ID,p.Type_3_Criteria__c,p.RecordTypeID,p.RecordType.Name,p.Type_2__c, p.Type_1__c, p.Quantity_2__c, p.Quantity_1__c, p.Pricing_2__c, p.Pricing_3__c,p.Pricing_1__c, p.Price_List__r.Expedite_Fee__c ,p.Price_List__r.Oracle_Operating_Unit__c, p.Price_List__r.Packaged_System_Item_ID__c,p.Price_List__r.Service_Credit_SMS_Item_ID__c,p.Price_List__r.Name, p.Price_List__c, p.Item_ID__c,p.Item_ID__r.Id, p.Item_ID__r.Name, p.Name, p.Effective_Start_Date__c, p.Effective_End_Date__c, p.Item_Description__c, p.Category__c From Price_List_Item__c p where p.Price_List__r.Oracle_Operating_Unit__c = :operatingUnit and p.Effective_Start_Date__c <=:currentDate and p.Effective_End_Date__c >=:currentDate and Type_1__c = 'Smart Pack' and Is_Active__c = 'true' and p.Item_ID__c != null and p.Item_ID__c in :itemIDsSet]){
            //Start for case # 00062051
            for(Price_List_Item__c p: [Select p.Disc_Item_ID__c,p.Disc_Item_Description__c,p.Disc_Item_ID__r.Name,p.ID,p.Type_3_Criteria__c,p.RecordTypeID,p.RecordType.Name,p.Type_2__c, p.Type_1__c, p.Quantity_3__c, p.Pricing_4__c, p.Quantity_2__c, p.Quantity_1__c, p.Pricing_2__c, p.Pricing_3__c,p.Pricing_1__c, p.Price_List__r.Expedite_Fee__c ,p.Price_List__r.Oracle_Operating_Unit__c, p.Price_List__r.Packaged_System_Item_ID__c,p.Price_List__r.Service_Credit_SMS_Item_ID__c,p.Price_List__r.Promotional_Discount_Item_Id__c,p.Price_List__r.Name, p.Price_List__c, p.Item_ID__c,p.Item_ID__r.Id, p.Item_ID__r.Name, p.Name, p.Effective_Start_Date__c, p.Effective_End_Date__c, p.Item_Description__c, p.Category__c, p.Price_List__r.System_Size__c From Price_List_Item__c p where p.Price_List__r.Oracle_Operating_Unit__c = :operatingUnit and p.Effective_Start_Date__c <=:currentDate and p.Effective_End_Date__c >=:currentDate and Is_Active__c = 'true' and p.Item_ID__c != null and ((p.Item_ID__c in :itemIDsSet and Type_1__c = 'Smart Pack') or (p.Item_ID__c in :aLaCarteItemIDsSet and Type_1__c = 'Ala Carte'))]){
            //for(Price_List_Item__c p: [Select p.Disc_Item_ID__c,p.Disc_Item_Description__c,p.Disc_Item_ID__r.Name,p.ID,p.Type_3_Criteria__c,p.RecordTypeID,p.RecordType.Name,p.Type_2__c, p.Type_1__c, p.Quantity_3__c, p.Pricing_4__c, p.Quantity_2__c, p.Quantity_1__c, p.Pricing_2__c, p.Pricing_3__c,p.Pricing_1__c, p.Price_List__r.Expedite_Fee__c ,p.Price_List__r.Oracle_Operating_Unit__c, p.Price_List__r.Packaged_System_Item_ID__c,p.Price_List__r.Service_Credit_SMS_Item_ID__c,p.Price_List__r.Promotional_Discount_Item_Id__c,p.Price_List__r.Name, p.Price_List__c, p.Item_ID__c,p.Item_ID__r.Id, p.Item_ID__r.Name, p.Name, p.Effective_Start_Date__c, p.Effective_End_Date__c, p.Item_Description__c, p.Category__c From Price_List_Item__c p where p.Price_List__r.Oracle_Operating_Unit__c = :operatingUnit and p.Effective_Start_Date__c <=:currentDate and p.Effective_End_Date__c >=:currentDate and Is_Active__c = 'true' and p.Item_ID__c != null and ((p.Item_ID__c in :itemIDsSet and Type_1__c = 'Smart Pack') or (p.Item_ID__c in :aLaCarteItemIDsSet and Type_1__c = 'Ala Carte'))]){
            //End for case # 00062051
                System.debug('PriceListitem ID::'+p.ID);
                System.debug('Debug: p.Item_ID__r.Name ' + p.Item_ID__r.Name);
                if(p != null) {
                    if (packagedSystemItemId == null) {
                        packagedSystemItemId = p.Price_List__r.Packaged_System_Item_ID__c;
                    }
                    if (serviceCreditSMSItemId == null) {
                        serviceCreditSMSItemId = p.Price_List__r.Service_Credit_SMS_Item_ID__c;
                        checkSMSPrice(selectedDesign, isNAUser, operatingUnit);
                    }
                    //Added for case 00057686
                    if (promotionalDiscountItemId == null) {
                        promotionalDiscountItemId = p.Price_List__r.Promotional_Discount_Item_Id__c;
                        system.debug('-----------------Abhay  1 promotionalDiscountItemId'+promotionalDiscountItemId);
                        checkPromotion(selectedDesign, isNAUser, operatingUnit);
                    }
                    //Start for case # 00062051
                    if (systemSizeLimit == null && !isNAUser) {
                        systemSizeLimit = p.Price_List__r.System_Size__c;
                        system.debug('-----------------systemSizeLimit'+systemSizeLimit);
                        setOrderType(operatingUnit, systemSizeLimit, purchaseOrder);
                    }
                    //End for case # 00062051
                    //Start for case # 00047219 - closed by customer
                    /*if(isEUUser &&
                        p.Price_List__r.Disc_Quantity__c!=null && p.Price_List__r.Discount__c!=null
                        && euDisc == null && euDiscQty ==null
                    ){
                        euDisc = p.Price_List__r.Discount__c;
                        euDiscQty = p.Price_List__r.Disc_Quantity__c;
                    }*/
                    //End for case # 00047219 - closed by customer
                }

                if(priceListItems == null) priceListItems = new Map<Id,Price_List_Item__c>();
                    priceListItems.put(p.ID,p);
            }
        }
         System.debug('priceListItems*********'+priceListItems);
        //Fetch all PriceListItems as per Design Description ends
        //Now Populating Pricing Accordingingly
        String recFoundID;
        System.debug('wrapper list***************'+selProductItems);
        //System.debug('size of price list items***************'+priceListItems.size());
        if(priceListItems != null && priceListItems.size()>0){
            for(LeaseOrderWizardController.PurchaseOrderLineItemWrapper pWrap :selProductItems){
                recFoundID =null;
                for(Price_List_Item__c pItem:priceListItems.values()){
                    //if(pItem.Type_1__c == 'Smart Pack' && pItem.Type_2__c == selectedDesign.EU_Mounting_Type__c && pItem.Item_ID__c == pwrap.oracleItemIDRef)
                    if(pItem.Type_1__c == 'Smart Pack' && pItem.Item_ID__c == pwrap.oracleItemIDRef){
                        if(pItem.RecordType.Name =='EU' && pItem.Type_2__c == selectedDesign.EU_Mounting_Type__c){
                            if(pItem.Type_3_Criteria__c == selectedDesign.EU_Inverter_Type__c){
                                recFoundID = pItem.ID;
                                break;
                            }
//                            Working here
                        }else if(pItem.RecordType.Name =='NA' && ((selectedDesign.SmartMount__c && pItem.Type_2__c =='SmartMount') || (!selectedDesign.SmartMount__c && (pItem.Type_2__c == null || pItem.Type_2__c ==''))) ){
                            System.debug('NA found:*********');
                            recFoundID = pItem.ID;
                            break;
                        }
                    } else if (pItem.Type_1__c == 'Ala Carte' && pItem.Item_ID__c == pwrap.oracleItemIDRef) { // Added for Case 00042518
                        recFoundID = pItem.ID;
                        System.debug('Debug: pItem.Item_ID__r.Name ' + pItem.Item_ID__r.Name);
                        break;
                    }

                }//for ends for(Price_List_Item__c plItem...................
                System.debug('Debug: recFoundID ' + recFoundID);
                //Start for Case# 00088825
                if(recFoundID == null && aLaCarteItemIDsSet.contains(pwrap.oracleItemIDRef)){
                	System.debug('not found pricelist item for***************'+pwrap.itemID);
                	if(setErrorAlaCarteItems != null)
                		setErrorAlaCarteItems = setErrorAlaCarteItems + ', '+ pwrap.itemID;
                	else
                		setErrorAlaCarteItems = pwrap.itemID;
                }
                //End for Case# 00088825
                if(recFoundID != null){
                    copySmartPackPriceToWrapper(priceListItems.get(recFoundID),pWrap);
                    //finalSelProductItems.add(pWrap);
                }
            }//for ends for(LeaseOrderWizardController...................

            //selProductItems.clear();
            //selProductItems.addAll(finalSelProductItems);
            if(selProductItems != null && selProductItems.size() > 0 && packagedSystemItemId != null)
                //Start for case # 00047219 - closed by customer
                //selProductItems = addPackagedSystem(selProductItems, packagedSystemItemId, isEUUser);
                selProductItems = addPackagedSystem(selProductItems, packagedSystemItemId);
                //Start for case # 00047219 - closed by customer
        }//ends != null
        else{
            //Item mot exist or not validated as per the Date
                selProductItems.clear();
                return null;
        }

        /* Checking if no exact Item Found , so price not populated accordingly */
            for(LeaseOrderWizardController.PurchaseOrderLineItemWrapper pWrapTemp: selProductItems){
                if(pWrapTemp.itemID == packagedSystemItemId && pWrapTemp.Name.startsWith('PACKAGED SYSTEMS')){
                    if(pWrapTemp.perUnitPrice ==0 || pWrapTemp.totalPrice ==0){
                        selProductItems.clear();
                        return null;
                    }
                }
                //Start for Case# 00088825
                if(setErrorAlaCarteItems != null && setErrorAlaCarteItems.contains(pWrapTemp.itemID)){
                	selProductItems.clear();
                    return null;
                }
                //End for Case# 00088825
            }
         /* Checking if no exact Item Found , so price not populated accordingly */
        // Now FetchingPrice and
        return selectedDesign;
    }
    //Start for case # 00062051
    public static void setOrderType(String oracleOperatingUnit, Double systemSizeLimit, Purchase_Order__c purchaseOrder){
        if(systemSizeLimit == null)
            return;
        if(oracleOperatingUnit!=null && oracleOperatingUnit.contains(' OU'))
            oracleOperatingUnit = oracleOperatingUnit.replaceFirst(' OU', '');
        String businessType = ' ';
        if(purchaseOrder.System_Size__c > systemSizeLimit)
            businessType += 'CVAR';
        else
            businessType += 'RVAR';
        purchaseOrder.Order_Type__c = oracleOperatingUnit + businessType +' Standard';
    }
    //End for case # 00062051
    //Added For Case 00057686
    private static void checkPromotion(SunPower_Design__c sunPowerDesign, Boolean isNAUser,String operatingUnit){
      if(sunPowerDesign == null || promotionalDiscountItemId == null || promotionalDiscountItemId == '') {
            return;
        }

      Date currentDate = Date.today();
       List<Price_List_Item__c> itemList = [Select Id, Pricing_1__c From Price_List_Item__c
                where Price_List__r.Oracle_Operating_Unit__c = :operatingUnit
                and Effective_Start_Date__c <=:currentDate and Effective_End_Date__c >=:currentDate
                and Is_Active__c = 'true'
                and Item_ID__r.Name = :promotionalDiscountItemId];
                if (isNAUser && itemList.size() > 0) {
                       promotionalDiscountToAdd = itemList[0].Pricing_1__c;
                       promotionalDiscountAvail = true;
                }

    }

    // Added for Case 00042523
    private static void checkSMSPrice(SunPower_Design__c sunPowerDesign, Boolean isNAUser,
            String operatingUnit) {
        if (sunPowerDesign == null || serviceCreditSMSItemId == null || serviceCreditSMSItemId == '') {
            return;
        }

        SMS_Pricing__c relatedSMSP = sunPowerDesign.SMS_KIT__r;
        Date currentDate = Date.today();
        List<Price_List_Item__c> itemList = [Select Id, Pricing_1__c From Price_List_Item__c
                where Price_List__r.Oracle_Operating_Unit__c = :operatingUnit
                and Effective_Start_Date__c <=:currentDate and Effective_End_Date__c >=:currentDate
                and Type_1__c = 'Smart Pack' and Is_Active__c = 'true'
                and Item_ID__r.Name = :serviceCreditSMSItemId];

        if (sunPowerDesign.SMS_KIT__c != null
                && relatedSMSP.Effective_Start_Date__c != null && relatedSMSP.Effective_Start_Date__c <= Date.today()
                && relatedSMSP.Effective_End_Date__c != null && relatedSMSP.Effective_End_Date__c >= Date.today()) {
            smsPriceToAdd = relatedSMSP.Price__c;
        } else if (isNAUser && itemList.size() > 0) {
            // smsPriceToAdd = (-1) * itemList[0].Pricing_1__c; // Gurvinder - Test with Gnana for positive price
            smsPriceToAdd = itemList[0].Pricing_1__c;
            discountAvail = true;
        }
    }

    /** This function adds a PACKAGED SYSTEM item in selected product wrapper list
     *  which contains the total price of all smart pack items in the design and populates prices of all other
     *  smart pack items as zero.
     *  @return List<LeaseOrderWizardController.PurchaseOrderLineItemWrapper>
     */
    private static List<LeaseOrderWizardController.PurchaseOrderLineItemWrapper> addPackagedSystem(List<LeaseOrderWizardController.PurchaseOrderLineItemWrapper> selectedWrapperList, String packagedSystemItemId){
        // Case 00042523
        Decimal totalPrice = 0;
        if (discountAvail == false && promotionalDiscountAvail==false) {
            totalPrice = smsPriceToAdd;
        }


        List<Item__c> itemList = [Select Id,Name,Description__c,Long_Description__c from Item__c where Active__c = true and (Name =:packagedSystemItemId OR Name =:serviceCreditSMSItemId OR Name =:promotionalDiscountItemId)];//added for case 00057686
        Item__c packagedSystemItem = null;
        Item__c serviceCreditSMSItem = null;
        Item__c promotionalDiscountItem = null;
        for (Item__c item : itemList) {
            if (item.Name == packagedSystemItemId) {
                packagedSystemItem = item;
            } else if (item.Name == serviceCreditSMSItemId) {
                serviceCreditSMSItem = item;

            }else if(item.Name == promotionalDiscountItemId){ // Added for case0007686
                promotionalDiscountItem=item;

            }
        }
        /////////

        if(selectedWrapperList != null && selectedWrapperList.size() > 0){
            for(LeaseOrderWizardController.PurchaseOrderLineItemWrapper pWrap : selectedWrapperList){
                // Added for Case 00042518
                if (pWrap.isSmartPack == false) {
                    continue;
                }

                totalPrice = totalPrice + pWrap.totalPrice;

                //for case 00057686
                if(pWrap.Qty!=null && Double.valueOf(pWrap.Qty)>0 && pwrap.ItemID=='114556'){
                    promotionalDiscount=promotionalDiscountToAdd*(Double.valueOf(pWrap.Qty));
                }
                 //for case 00057686
                if(promotionalDiscount>100){
                    promotionalDiscount=100;
                }
                //Start for case # 00047219 - closed by customer
                /*if(isEUUser && euDiscQty != null && euDisc != null && Decimal.valueOf(pWrap.Qty)>euDiscQty)
                    euDiscToAdd = euDiscToAdd + (Decimal.valueOf(pWrap.Qty) * pWrap.perUnitPrice * euDisc)/100;*/
                    //euDiscToAdd = pWrap.perUnitPrice;
                //End for case # 00047219 - closed by customer
                pWrap.perUnitPrice = 0.0;
                pWrap.totalPrice = 0.0;

                System.debug('in packaged pwrap.ItemID:::::::::'+pwrap.ItemID);
            }

            if (moduleItemPresent) {
            LeaseOrderWizardController.PurchaseOrderLineItemWrapper packagedWrapper = new LeaseOrderWizardController.PurchaseOrderLineItemWrapper();
            packagedWrapper.Name = 'PACKAGED SYSTEMS';
            packagedWrapper.isSmartPack = true;
            packagedWrapper.itemType = SMARTPACK_POITEMTYPE;//done by Jitendra for Case#00058280
            packagedWrapper.itemSource = 'SmartPack';//for Case# 00077093
            packagedWrapper.Qty = '1';
            packagedWrapper.perUnitPrice = totalPrice;
            packagedWrapper.totalPrice = totalPrice;
            packagedWrapper.itemID = packagedSystemItemId;
            if(packagedSystemItem != null)
                packagedWrapper.oracleItemIDRef = packagedSystemItem.Id;
            selectedWrapperList.add(0,packagedWrapper);
            }

            // Case 00042523
            if (discountAvail && serviceCreditSMSItemId != null) {
                LeaseOrderWizardController.PurchaseOrderLineItemWrapper discountWrapper
                        = new LeaseOrderWizardController.PurchaseOrderLineItemWrapper();
                discountWrapper.Name = 'SERVICE CREDIT SMS';
                discountWrapper.isSmartPack = true;
                discountWrapper.itemType = SMARTPACK_POITEMTYPE;//done by Jitendra for Case#00058280
                discountWrapper.itemSource = 'SmartPack';//for Case# 00077093
                discountWrapper.Qty = '1';
                discountWrapper.perUnitPrice = smsPriceToAdd;
                discountWrapper.totalPrice = smsPriceToAdd;
                discountWrapper.itemID = serviceCreditSMSItemId;
                if (serviceCreditSMSItem != null) {
                    discountWrapper.oracleItemIDRef = serviceCreditSMSItem.Id;
                }
                selectedWrapperList.add(1, discountWrapper);
            }

             if (promotionalDiscount>0 && promotionalDiscountAvail && promotionalDiscountItemId != null) {

                LeaseOrderWizardController.PurchaseOrderLineItemWrapper discountWrapper
                        = new LeaseOrderWizardController.PurchaseOrderLineItemWrapper();
                discountWrapper.Name = 'Promotional Service Credit Solar Mount-I';
                discountWrapper.isSmartPack = true;
                discountWrapper.itemType = SMARTPACK_POITEMTYPE;//done by Jitendra for Case#00058280
                discountWrapper.itemSource = 'SmartPack';//for Case# 00077093
                discountWrapper.Qty = '1';
                discountWrapper.perUnitPrice = promotionalDiscount;
                discountWrapper.totalPrice = promotionalDiscount;
                discountWrapper.itemID = promotionalDiscountItemId;
                if (promotionalDiscountItem != null) {
                    discountWrapper.oracleItemIDRef = promotionalDiscountItem.Id;
                }
                selectedWrapperList.add(1, discountWrapper);
            }
            //Start for case # 00047219 - closed by customer
            /*if (euDiscToAdd > 0) {
                LeaseOrderWizardController.PurchaseOrderLineItemWrapper euDiscountWrapper
                        = new LeaseOrderWizardController.PurchaseOrderLineItemWrapper();
                euDiscountWrapper.Name = 'EU DISCOUNT';
                euDiscountWrapper.isSmartPack = true;
                euDiscountWrapper.Qty = '1';
                euDiscountWrapper.perUnitPrice = - euDiscToAdd;
                euDiscountWrapper.totalPrice = - euDiscToAdd;
                selectedWrapperList.add(1, euDiscountWrapper);
            }*/
            //Start for case # 00047219 - closed by customer
        }
        return selectedWrapperList;
    }

    /** This function copy the prices of smart pack items to the selected wrapper list .
     *
     */
    private static void copySmartPackPriceToWrapper(Price_List_Item__c pItem,LeaseOrderWizardController.PurchaseOrderLineItemWrapper pWrap){
        if(pItem == null || pWrap==null) return;
        boolean isEU =false;
        System.debug('*********Record type************'+pItem.RecordType.Name);
        if(pItem.RecordType.Name =='EU')
            isEU =true;
        Double quantity = (pWrap.Qty == null || pWrap.Qty =='')? 0.0 : Double.valueOf(pWrap.Qty);
        System.debug('Debug: quantity ' + quantity);
        System.debug('Debug: pItem.Quantity_1__c ' + pItem.Quantity_1__c);
        System.debug('Debug: pItem.Quantity_2__c ' + pItem.Quantity_2__c);
        System.debug('Debug: pItem.Quantity_3__c ' + pItem.Quantity_3__c);
        System.debug('Debug: pItem.Pricing_1__c ' + pItem.Pricing_1__c);
        System.debug('Debug: pItem.Pricing_2__c ' + pItem.Pricing_2__c);
        System.debug('Debug: pItem.Pricing_3__c ' + pItem.Pricing_3__c);
        System.debug('Debug: pItem.Pricing_4__c ' + pItem.Pricing_4__c);
        //For EU check starts
        if(isEU){
        	//Start for Case# 00088825
        	if(pItem.Quantity_1__c == null && pItem.Quantity_2__c == null && pItem.Quantity_3__c == null)
        		pWrap.perUnitPrice = pItem.Pricing_1__c;
        	//End for Case# 00088825
            else if(pItem.Quantity_1__c != null && pItem.Quantity_1__c >= quantity)
                pWrap.perUnitPrice = pItem.Pricing_1__c;
            else if(pItem.Quantity_2__c != null && pItem.Quantity_2__c >= quantity)
                pWrap.perUnitPrice = pItem.Pricing_2__c;
            else
                pWrap.perUnitPrice = pItem.Pricing_3__c;
        }
        //For EU check ends
        //For NA check starts
        else{
            //Start for case # 00058506
            /*if(pItem.Quantity_1__c != null && pItem.Quantity_1__c >= quantity)
                pWrap.perUnitPrice = pItem.Pricing_1__c;
            else
                pWrap.perUnitPrice = pItem.Pricing_2__c;*/
            if(pItem.Quantity_1__c != null && quantity <= pItem.Quantity_1__c){
                pWrap.perUnitPrice = pItem.Pricing_1__c;
            }else if(pItem.Quantity_1__c != null && pItem.Quantity_2__c != null && quantity >  pItem.Quantity_1__c && quantity <= pItem.Quantity_2__c){
                pWrap.perUnitPrice = pItem.Pricing_2__c;
            }else if(pItem.Quantity_1__c != null && pItem.Quantity_2__c == null && quantity >  pItem.Quantity_1__c){
                pWrap.perUnitPrice = pItem.Pricing_2__c;
            }else if(pItem.Quantity_2__c != null && pItem.Quantity_3__c != null && quantity > pItem.Quantity_2__c && quantity <= pItem.Quantity_3__c){
                pWrap.perUnitPrice = pItem.Pricing_3__c;
            }else if(pItem.Quantity_2__c != null && pItem.Quantity_3__c == null && quantity >  pItem.Quantity_2__c){
                pWrap.perUnitPrice = pItem.Pricing_3__c;
            }else if(pItem.Quantity_3__c != null && quantity >= pItem.Quantity_3__c){
                pWrap.perUnitPrice = pItem.Pricing_4__c;
            }
            //End for case # 00058506
        }//For NA ends
        System.debug('Debug: pItem.unitprice__c ' + pWrap.perUnitPrice);
        //Common Change for populating Total Price
        try{
            pWrap.totalPrice = pWrap.perUnitPrice *  quantity;
            //Now changed as Packaged System and Quantity 1 starts
            //pWrap.perUnitPrice =pWrap.totalPrice;
            //pWrap.Name ='PACKAGED SYSTEM';
            //pWrap.Qty ='1';
            //Now changed as Packaged System and Quantity 1 ends
        }catch(Exception e){
            pWrap.totalPrice = 0.0;
            //Now changed as Packaged System and Quantity 1 starts
            //pWrap.perUnitPrice =pWrap.totalPrice;
            //pWrap.Name ='PACKAGED SYSTEM';
            //pWrap.Qty ='1';
            //Now changed as Packaged System and Quantity 1 ends
        }
    }

    // update the po line items prices if there corresponding Price_List_Item__c are still valid and active
    // By Comparing there effective start date and effective dates with current date and Is_Active__c must be true
    // otherwise delete them
    /** This function update the prices of po line items if there corresponding Price_List_Item__c are still valid and active ,
     *  By Comparing there effective start date and effective end dates with current date and Is_Active__c field of Price_List_Item__c
     *  Is_Active__c field of Price_List_Item__c must be true for a po line item to be active.
     *  if a po line item is inactive or invalid then delete them.
     */
    public static List<String> updatePOLineItems(List<Purchase_Order_Line__c> purchaseOrderList ,String operatingUnit,boolean isSmartPack,Purchase_Order__c purOrder,Boolean isNAUser){//for case # 00047219
    //public static List<String> updatePOLineItems(List<Purchase_Order_Line__c> purchaseOrderList ,String operatingUnit,boolean isSmartPack,Purchase_Order__c purOrder,Boolean isNAUser, Boolean isEUUser){//added for case # 00047219 - closed by customer
        List<String> messages = new List<String>();
        boolean isInActiveFound = false;
        Set<ID> inActiveItemIds = new Set<ID>();
        boolean isInvalidDateFound =false;
        Set<ID> inValidDateItemIds = new Set<ID>();
        boolean isPriceChanedFound =false;
        Map<ID,Purchase_Order_Line__c> alaCartaMap = new Map<ID,Purchase_Order_Line__c>();
        Map<ID,Purchase_Order_Line__c> smartPackMap = new Map<ID,Purchase_Order_Line__c>();

        //Step
        for(Purchase_Order_Line__c pOrder: purchaseOrderList){
        //alaCartaMap.put(pOrder.)


            //Case#00058280
            //if(pOrder.SmartPack_Item__c)
            if(pOrder.Item_Type__c != null && pOrder.Item_Type__c.equalsIgnoreCase(SMARTPACK_POITEMTYPE))
                smartPackMap.put(pOrder.Oracle_Item_ID__c ,pOrder);
            else
                alaCartaMap.put(pOrder.Oracle_Item_ID__c ,pOrder);
        }
        System.debug('Enter in PriceListItemUtilityLease.updatePOLineItems ::Here alaCartaItemsMap::'+alaCartaMap);
        System.debug('Enter in PriceListItemUtilityLease.updatePOLineItems ::Here smartPackMap::'+smartPackMap);
        //If not any item then return
        if((alaCartaMap == null || alaCartaMap.size() ==0 )&& (smartPackMap == null || smartPackMap.size() ==0)){
            messages.add('NOITEMFOUND:NOITEMFOUND');
            return messages;
        }
        Set<ID> itemIDs = new Set<ID>();
        itemIds.addAll(alaCartaMap.keySet());
        itemIds.addAll(smartPackMap.keySet());
        System.debug('Enter in PriceListItemUtilityLease.updatePOLineItems ::Here itemIDs::'+itemIds);
        //Fetching all Price List Items
        Map<ID,Price_List_Item__c> allpriceItems = new Map<ID,Price_List_Item__c>([Select p.Disc_Item_ID__c,p.Disc_Item_Description__c,p.Disc_Item_ID__r.Name,p.is_Active__c,p.ID,p.Type_3_Criteria__c,p.RecordTypeID,p.RecordType.Name,p.Type_2__c, p.Type_1__c, p.Quantity_2__c, p.Quantity_1__c, p.Pricing_2__c, p.Pricing_3__c,p.Pricing_1__c, p.Price_List__r.Expedite_Fee__c ,p.Price_List__r.Oracle_Operating_Unit__c, p.Price_List__r.Packaged_System_Item_ID__c,p.Price_List__r.Service_Credit_SMS_Item_ID__c,p.Price_List__r.Name, p.Price_List__c, p.Item_ID__c, p.Name, p.Effective_Start_Date__c, p.Effective_End_Date__c, p.Item_Description__c, p.Category__c From Price_List_Item__c p where p.Price_List__r.Oracle_Operating_Unit__c = :operatingUnit and p.Item_ID__c in :itemIds]);
        System.debug('Enter in PriceListItemUtilityLease.updatePOLineItems ::Here Map allpriceItems::'+allpriceItems);
        //Now checking Active Validation

        /*******************************************************ACTIVE CHAECK START ***********************/
        //For Ala Carta
        inActiveItemIds.clear();
        for(ID itemID :alaCartaMap.keySet()){
            for(Price_List_Item__c pItem:allpriceItems.values()){
                Purchase_Order_Line__c pOLine = alaCartaMap.get(itemID);
                if(pOLine == null)
                    continue;
                if(pItem.Type_1__c == 'Ala Carte' && pItem.is_Active__c != 'true' && pOLine.Oracle_Item_ID__c == pItem.Item_ID__c){
                    if(!isInActiveFound)
                        isInActiveFound =true;
                    inActiveItemIds.add(pOline.Id);
                }//ends of if(pItem.Type_1__c ='Ala Carta')
            }//ends of for(Price_List_Item__c pItem:allpriceItems)
        } //ends of for(ID itemID :alaCartaMap.keySet())

        System.debug('Enter in PriceListItemUtilityLease.updatePOLineItems ::Here InActiveIDs for AlaCarte::'+inActiveItemIds);

        //For Smart Pack
        if(isSmartPack){
            for(ID itemID :smartPackMap.keySet()){
                for(Price_List_Item__c pItem:allpriceItems.values()){
                    Purchase_Order_Line__c pOLine = smartPackMap.get(itemID);
                    if(pOLine == null)
                        continue;
                    //if(pItem.Type_1__c =='Smart Pack' && pOLine.Purchase_Order__r.SmartPack_Mounting_Type__c == pItem.Type_2__c && pOLine.Purchase_Order__r.SmartPack_Inverter_Type__c == pItem.Type_3_Criteria__c && pItem.is_Active__c != 'true' && pOLine.Oracle_Item_ID__c == pItem.Item_ID__c){
                    if(pItem.RecordType.name =='EU' &&  pItem.Type_1__c =='Smart Pack' && pOLine.Purchase_Order__r.SmartPack_Mounting_Type__c == pItem.Type_2__c && pOLine.Purchase_Order__r.SmartPack_Inverter_Type__c == pItem.Type_3_Criteria__c && pItem.is_Active__c != 'true' && pOLine.Oracle_Item_ID__c == pItem.Item_ID__c){
                        if(!isInActiveFound)
                            isInActiveFound =true;
                        inActiveItemIds.add(pOline.Id);
                    }//ends of if(pItem.Type_1__c ='Ala Carta')
                    else if(pItem.RecordType.name =='NA' && pItem.Type_1__c =='Smart Pack' && pItem.is_Active__c != 'true' && poLine.Oracle_Item_ID__c == pItem.Item_ID__c && ( (purOrder.SmartMount__c && pItem.Type_2__c!= null && pItem.Type_2__c =='SmartMount')|| (!purOrder.SmartMount__c && (pItem.Type_2__c == null ||pItem.Type_2__c == '' )))){
                        if(!isInActiveFound)
                            isInActiveFound =true;
                        inActiveItemIds.add(pOline.Id);
                    }
                }//ends of for(Price_List_Item__c pItem:allpriceItems)
            } //ends of for(ID itemID :smartPackMap.keySet())
        }
    System.debug('Enter in PriceListItemUtilityLease.updatePOLineItems ::Here InActiveIDs for SmartPack::'+inActiveItemIds);
    //...........................POPULATING LINE ITEMS ........................................
    if(isInActiveFound){
        Map<Id,Purchase_order_Line__c> pOLinesNew = new Map<ID,Purchase_order_Line__c>();
        List<Purchase_order_Line__c> pOLinesDeleted = new List<Purchase_order_Line__c>();
        for(Purchase_Order_Line__c p :purchaseOrderList){
            if(inActiveItemIds.contains(p.ID)){
                messages.add('ERROR: Item '+ p.Oracle_Item_ID__r.Name + ' is no longer active and has been removed from this Purchase Order');
                //pOLinesDeleted.add(p);
                  pOLinesNew.put(p.id,p); //Newly Added by Prakash
            }else{
                  pOLinesNew.put(p.id,p);
            }
        }// ends of for loop
        if(pOLinesDeleted != null && pOLinesDeleted.size()>0){
            delete pOLinesDeleted;
        }
        purchaseOrderList.clear();
        if(pOLinesNew != null && pOLinesNew.size()>0){
            purchaseOrderList.addAll(pOLinesNew.values());
        }
    }

    System.debug('Enter in PriceListItemUtilityLease.updatePOLineItems ::Here after deleteion:::');
     for(Purchase_Order_Line__c poLine :purchaseOrderList){
        System.debug('Here the item::'+poLine.Unit_Price__c);
    }

    /****************************************ACTIVE CHAECK ENDS ******************************/

    /****************************************VALIDATE DATE STARTS ******************************/

    //Now checking Date Validation starts
    Date currentDate = Date.today();
    for(Price_List_Item__c pItem : allpriceItems.values()){
        if(!(pItem.Effective_Start_Date__c <= currentDate && currentDate <= pItem.Effective_End_Date__c)){
            for(Purchase_Order_Line__c pOrder: purchaseOrderList){
                /*if(pItem.Type_1__c =='Smart Pack' && pOrder.SmartPack_Item__c && pItem.Item_ID__c == pOrder.Oracle_Item_ID__c && pOrder.Purchase_Order__r.SmartPack_Mounting_Type__c == pItem.Type_2__c && pOrder.Purchase_Order__r.SmartPack_Inverter_Type__c == pItem.Type_3_Criteria__c && !inActiveItemIds.contains(pOrder.Id)){
                    if(!isInvalidDateFound)
                        isInvalidDateFound = true;
                    inValidDateItemIds.add(pOrder.ID);
                    break;
                }// ends of if(pItem.Type_1__c ='Smart Pack' && pOrder.SmartPack_Item__c
                else
                */
                //Case#00058280
                //if(pItem.Type_1__c =='Ala Carte' && !pOrder.SmartPack_Item__c && pItem.Item_ID__c == pOrder.Oracle_Item_ID__c && !inActiveItemIds.contains(pOrder.Id)){
                if(pItem.Type_1__c =='Ala Carte' && (pOrder.Item_Type__c == null || !pOrder.Item_Type__c.equalsIgnoreCase(SMARTPACK_POITEMTYPE)) && pItem.Item_ID__c == pOrder.Oracle_Item_ID__c && !inActiveItemIds.contains(pOrder.Id)){
                    if(!isInvalidDateFound)
                        isInvalidDateFound = true;
                    inValidDateItemIds.add(pOrder.ID);
                    break;
                    }// ends of if(pItem.Type_1__c ='Smart Pack' && pOrder.SmartPack_Item__c
                }//ends of for(Purchase_Order_Line__c pOrder: purchaseOrderList)
            }// ends of if(!(pItem.Effective_Start_Date__c <= currentDate
        }// ends of for(Price_List_Item__c pItem : allpriceItems.values())
    //Now processing for Item Deletion from List here
    System.debug('Enter in PriceListItemUtilityLease.updatePOLineItems ::Here inValidDateItemIds for SmartPack and Alacarte::'+inValidDateItemIds);
    if(isInvalidDateFound){
        Map<Id,Purchase_order_Line__c> pOLinesNew = new Map<Id,Purchase_order_Line__c>();
        List<Purchase_order_Line__c> pOLinesDeleted = new List<Purchase_order_Line__c>();
        for(Purchase_Order_Line__c p :purchaseOrderList){
            if(isInvalidDateFound && inValidDateItemIds.contains(p.ID)){
                messages.add('ERROR: Item '+ p.Oracle_Item_ID__r.Name + ' is no longer Valid and has been removed from this Purchase Order');
                //pOLinesDeleted.add(p);
                 pOLinesNew.put(p.id,p);
            }else{
                 pOLinesNew.put(p.id,p);
            }
        }// ends of for loop
        if(pOLinesDeleted != null && pOLinesDeleted.size()>0){
            delete pOLinesDeleted;
        }
        purchaseOrderList.clear();
        if(pOLinesNew != null && pOLinesNew.size()>0){
            purchaseOrderList.addAll(pOLinesNew.values());
        }
    }
    //Now processing for Item Deletion from List here


    //Now Checking any Price Update Here
    //if(!isInvalidDateFound && !isInActiveFound ) {
    if(isSmartPack){
        boolean isEU = false;
        for(Purchase_Order_Line__c pOrder: purchaseOrderList){
            String itemID = pOrder.Oracle_Item_Id__c;
            for(Price_List_Item__c pItem1 : allpriceItems.values()){
                isEU =false;
                if(itemID == pItem1.Item_ID__c){
                //Ala Carte starts
                    //Case#00058280
                    //if(!pOrder.SmartPack_Item__c && !(pItem1.Type_1__c =='Smart Pack') ){
                    if((pOrder.Item_Type__c == null || !pOrder.Item_Type__c.equalsIgnoreCase(SMARTPACK_POITEMTYPE)) && !(pItem1.Type_1__c =='Smart Pack') ){
                        System.debug('Enter in PriceListItemUtilityLease.updatePOLineItems ::Here for Ala Carte Pice changed 1::');
                        if(pOrder.Unit_Price__c != pItem1.Pricing_1__c){
                            System.debug('Enter in PriceListItemUtilityLease.updatePOLineItems ::Here for Ala Carte Pice changed 2::');
                            if(!isPriceChanedFound){
                                isPriceChanedFound =true;
                                messages.add('PRICECHANGED:PRICECHANGED');
                            }
                            System.debug('Enter in PriceListItemUtilityLease.updatePOLineItems ::Here for Ala Carte before Pice changed 3::' +pOrder.Unit_Price__c);
                            pOrder.Unit_Price__c = pItem1.Pricing_1__c;
                            pOrder.Price__c = pOrder.Unit_Price__c * pOrder.Quantity__c;
                            System.debug('Enter in PriceListItemUtilityLease.updatePOLineItems ::Here for Ala Carte after Price changed 4::' + pOrder.Unit_Price__c);
                        }
                    }//Ala Carte ends
                }// ends of if(itemID == pItem1.Item_ID__c)
            }//ends of for(Price_List_Item__c pItem1 : allpriceItems.values())
        }// ends of for(Purchase_Order_Line__c pOrder: purchaseOrderList)
        /*..................Now check for recaluclating price for Design ITems ................*/
        //Create separate Map for AlaCarte
        Map<ID,Purchase_Order_Line__c> mapAlaCartaTemp = new Map<ID,Purchase_Order_Line__c>();
        Set<String> itemIDsSet = new Set<String>();
        Set<String> aLaCarteItemIDsSet = new Set<String>();//for Case# 00076192
        List<Purchase_Order_Line__c> lstSmartPAckTemp = new List<Purchase_Order_Line__c>();
        String packagedSystemItemId =null;
        currentDate = Date.today();
        for(Purchase_Order_Line__c pLine: purchaseOrderList){
            //Case#00058280
            //if(!pLine.SmartPack_Item__c){
            if(pLine.Item_Type__c == null || !pLine.Item_Type__c.equalsIgnoreCase(SMARTPACK_POITEMTYPE)){
                mapAlaCartaTemp.put(pLine.id,pLine);
            }
        }
        //delete old one
        //List<Purchase_Order_Line__c> pListTemp =[select id from Purchase_Order_Line__c where SmartPack_Item__c = true and purchase_order__c = :purOrder.ID];
        purchaseOrderList.clear();
            //if(pListTemp != null && pListTemp.size()>0) delete pListTemp;
            //Select Design items
            Map <String,Purchase_Order_Line__c>   tempForDesign= new Map <String,Purchase_Order_Line__c>();
            List<Purchase_Order_Line__c> otherThanModule = new List<Purchase_Order_Line__c>();
             SunPower_Design__c sunDesign = null;
             //for(SunPower_Design_Item__c item:[Select s.Oracle_Item_Id__c, s.Oracle_Item_Id__r.Id, s.Oracle_Item_Id__r.Name, s.Item_Description__c, s.SunPower_Design__r.EU_Mounting_Type__c,s.SunPower_Design__r.EU_Inverter_Type__c,s.SunPower_Design__r.SmartMount__c,s.SunPower_Design__r.DealerAccount__c, s.SunPower_Design__r.Purchase_Order_Number__c, s.SunPower_Design__r.Design_Notes__c, s.SunPower_Design__r.system_size__c, s.SunPower_Design__r.Name, s.SunPower_Design__r.SMS_KIT__c, s.SunPower_Design__r.SMS_KIT__r.Effective_Start_Date__c, s.SunPower_Design__r.SMS_KIT__r.Effective_End_Date__c, s.SunPower_Design__r.SMS_KIT__r.Price__c, s.SunPower_Design__c, s.Quantity__c, s.Name, s.Is_Smart_Pack_Item__c, s.Id, s.Component_Type__c From SunPower_Design_Item__c s where SunPower_Design__c =:purOrder.SunPower_Design__c and Oracle_Item_Id__c != null and s.Oracle_Item_Id__r.Active__c = true order by Is_Smart_Pack_Item__c desc]){
             //Start for Case# 00076192
            //for(SunPower_Design_Item__c item:[Select s.Oracle_Item_Id__c, s.Oracle_Item_Id__r.Id, s.Oracle_Item_Id__r.Name, s.Item_Description__c, s.SunPower_Design__r.EU_Mounting_Type__c,s.SunPower_Design__r.EU_Inverter_Type__c,s.SunPower_Design__r.SmartMount__c,s.SunPower_Design__r.DealerAccount__c, s.SunPower_Design__r.Purchase_Order_Number__c, s.SunPower_Design__r.Design_Notes__c, s.SunPower_Design__r.system_size__c, s.SunPower_Design__r.Name, s.SunPower_Design__r.SMS_KIT__c, s.SunPower_Design__r.SMS_KIT__r.Effective_Start_Date__c, s.SunPower_Design__r.SMS_KIT__r.Effective_End_Date__c, s.SunPower_Design__r.SMS_KIT__r.Price__c, s.SunPower_Design__c, s.Quantity__c, s.Name, s.Is_Smart_Pack_Item__c, s.Id, s.Component_Type__c From SunPower_Design_Item__c s where SunPower_Design__c =:purOrder.SunPower_Design__c and Oracle_Item_Id__c != null and s.Oracle_Item_Id__r.Active__c = true and s.Is_Smart_Pack_Item__c = true order by Is_Smart_Pack_Item__c desc]){
            for(SunPower_Design_Item__c item:[Select s.Oracle_Item_Id__c, s.Oracle_Item_Id__r.Id, s.Oracle_Item_Id__r.Name, s.Item_Description__c, s.SunPower_Design__r.EU_Mounting_Type__c,s.SunPower_Design__r.EU_Inverter_Type__c,s.SunPower_Design__r.SmartMount__c,s.SunPower_Design__r.DealerAccount__c, s.SunPower_Design__r.Purchase_Order_Number__c, s.SunPower_Design__r.Design_Notes__c, s.SunPower_Design__r.system_size__c, s.SunPower_Design__r.Name, s.SunPower_Design__r.SMS_KIT__c, s.SunPower_Design__r.SMS_KIT__r.Effective_Start_Date__c, s.SunPower_Design__r.SMS_KIT__r.Effective_End_Date__c, s.SunPower_Design__r.SMS_KIT__r.Price__c, s.SunPower_Design__c, s.Quantity__c, s.Name, s.Is_Smart_Pack_Item__c, s.Id, s.Component_Type__c From SunPower_Design_Item__c s where SunPower_Design__c =:purOrder.SunPower_Design__c and Oracle_Item_Id__c != null and s.Oracle_Item_Id__r.Active__c = true order by Is_Smart_Pack_Item__c desc]){
            //End for Case# 00076192

                sunDesign = item.SunPower_Design__r;

                //Case#00058280
                //Start for Case# 00076192
                //Purchase_Order_Line__c pLine = new Purchase_Order_Line__c(SmartPack_Item__c =true,Oracle_Item_ID__c = item.Oracle_Item_ID__c,Purchase_Order__c = purOrder.ID,Quantity__c = item.Quantity__c);
                //Purchase_Order_Line__c pLine = new Purchase_Order_Line__c(SmartPack_Item__c =item.Is_Smart_Pack_Item__c,Oracle_Item_ID__c = item.Oracle_Item_ID__c,Purchase_Order__c = purOrder.ID,Quantity__c = item.Quantity__c);
                //End for Case# 00076192
                //done for Case#00058280
                String itemType;
                if(item.Is_Smart_Pack_Item__c)
                	itemType = SMARTPACK_POITEMTYPE;
                else
                	itemType = ALACARTE_POITEMTYPE;
                Purchase_Order_Line__c pLine = new Purchase_Order_Line__c(Item_Type__c = itemType ,Oracle_Item_ID__c = item.Oracle_Item_ID__c,Purchase_Order__c = purOrder.ID,Quantity__c = item.Quantity__c);
                //done for Case#00058280
                //Start for Case# 00076192
				pLine.Item_Source__c ='SmartPack';//for Case# 00077093
				if(item.Is_Smart_Pack_Item__c){
	                if(item.Component_Type__c == SMARTPACK_PANELITEM){
	                    itemIDsSet.add(item.Oracle_Item_Id__c);
	                }else{
	                    otherThanModule.add(pLine);
	                }
                }else if(!item.Is_Smart_Pack_Item__c){
                	aLaCarteItemIDsSet.add(item.Oracle_Item_Id__c);
            	}
            //End for Case# 00076192
                tempForDesign.put(item.Oracle_Item_ID__c,pLine);
            }//ends of for Loop
            // Added for Case 00042521
            if (itemIDsSet == null || itemIDsSet.size() == 0) {
                moduleItemPresent = false;
            }
            //Start for Case# 00076192
            if(aLaCarteItemIDsSet == null || aLaCarteItemIDsSet.size() ==0)
            	moduleAlaCarteItemPresent = false;
            //End for Case# 00076192
            String recFoundID = null;
            Double systemSizeLimit = null;//for case # 00062051
            //Start for case # 00062051
            //for(Price_List_Item__c p: [Select p.Disc_Item_ID__c,p.Disc_Item_Description__c,p.Disc_Item_ID__r.Name,p.ID,p.Type_3_Criteria__c,p.RecordTypeID,p.RecordType.Name,p.Type_2__c, p.Type_1__c,  p.Pricing_4__c, p.Quantity_3__c, p.Quantity_2__c, p.Quantity_1__c, p.Pricing_2__c, p.Pricing_3__c,p.Pricing_1__c, p.Price_List__r.Expedite_Fee__c ,p.Price_List__r.Oracle_Operating_Unit__c, p.Price_List__r.Packaged_System_Item_ID__c,p.Price_List__r.Service_Credit_SMS_Item_ID__c,p.Price_List__r.Promotional_Discount_Item_Id__c,p.Price_List__r.Name, p.Price_List__c, p.Item_ID__c,p.Item_ID__r.Id, p.Item_ID__r.Name, p.Name, p.Effective_Start_Date__c, p.Effective_End_Date__c, p.Item_Description__c, p.Category__c From Price_List_Item__c p where p.Price_List__r.Oracle_Operating_Unit__c = :operatingUnit and p.Effective_Start_Date__c <=:currentDate and p.Effective_End_Date__c >=:currentDate and Type_1__c = 'Smart Pack' and Is_Active__c = 'true' and p.Item_ID__c != null and p.Item_ID__c in :itemIDsSet]){
            for(Price_List_Item__c p: [Select p.Disc_Item_ID__c,p.Disc_Item_Description__c,p.Disc_Item_ID__r.Name,p.ID,p.Type_3_Criteria__c,p.RecordTypeID,p.RecordType.Name,p.Type_2__c, p.Type_1__c,  p.Pricing_4__c, p.Quantity_3__c, p.Quantity_2__c, p.Quantity_1__c, p.Pricing_2__c, p.Pricing_3__c,p.Pricing_1__c, p.Price_List__r.Expedite_Fee__c ,p.Price_List__r.Oracle_Operating_Unit__c, p.Price_List__r.Packaged_System_Item_ID__c,p.Price_List__r.Service_Credit_SMS_Item_ID__c,p.Price_List__r.Promotional_Discount_Item_Id__c,p.Price_List__r.Name, p.Price_List__c, p.Item_ID__c,p.Item_ID__r.Id, p.Item_ID__r.Name, p.Name, p.Effective_Start_Date__c, p.Effective_End_Date__c, p.Item_Description__c, p.Category__c, p.Price_List__r.System_Size__c From Price_List_Item__c p where p.Price_List__r.Oracle_Operating_Unit__c = :operatingUnit and p.Effective_Start_Date__c <=:currentDate and p.Effective_End_Date__c >=:currentDate and Is_Active__c = 'true' and p.Item_ID__c != null and ((p.Item_ID__c in :itemIDsSet and Type_1__c = 'Smart Pack') or (p.Item_ID__c in :aLaCarteItemIDsSet and Type_1__c = 'Ala Carte'))]){//for Case# 00076192
            //for(Price_List_Item__c p: [Select p.Disc_Item_ID__c,p.Disc_Item_Description__c,p.Disc_Item_ID__r.Name,p.ID,p.Type_3_Criteria__c,p.RecordTypeID,p.RecordType.Name,p.Type_2__c, p.Type_1__c,  p.Pricing_4__c, p.Quantity_3__c, p.Quantity_2__c, p.Quantity_1__c, p.Pricing_2__c, p.Pricing_3__c,p.Pricing_1__c, p.Price_List__r.Expedite_Fee__c ,p.Price_List__r.Oracle_Operating_Unit__c, p.Price_List__r.Packaged_System_Item_ID__c,p.Price_List__r.Service_Credit_SMS_Item_ID__c,p.Price_List__r.Promotional_Discount_Item_Id__c,p.Price_List__r.Name, p.Price_List__c, p.Item_ID__c,p.Item_ID__r.Id, p.Item_ID__r.Name, p.Name, p.Effective_Start_Date__c, p.Effective_End_Date__c, p.Item_Description__c, p.Category__c From Price_List_Item__c p where p.Price_List__r.Oracle_Operating_Unit__c = :operatingUnit and p.Effective_Start_Date__c <=:currentDate and p.Effective_End_Date__c >=:currentDate and Is_Active__c = 'true' and p.Item_ID__c != null and ((p.Item_ID__c in :itemIDsSet and Type_1__c = 'Smart Pack') or (p.Item_ID__c in :aLaCarteItemIDsSet and Type_1__c = 'Ala Carte'))]){//for Case# 00076192

            //End for case # 00062051
                recFoundID = null;
                Purchase_Order_Line__c pLine = tempForDesign.get(p.Item_ID__c);
                if(pLine == null)
                    continue;
                //else
                    //purchaseOrderList.add(pLine);
                if(packagedSystemItemId == null && moduleItemPresent) //for Case# 00076192
                    packagedSystemItemId = p.Price_List__r.Packaged_System_Item_ID__c;
                if(serviceCreditSMSItemId == null && moduleItemPresent) {//for Case# 00076192
                    serviceCreditSMSItemId = p.Price_List__r.Service_Credit_SMS_Item_ID__c;
                    checkSMSPrice(sunDesign, isNAUser, operatingUnit);
                }
                //Added for case 00057686
                if (promotionalDiscountItemId == null && moduleItemPresent) {//for Case# 00076192
                    promotionalDiscountItemId = p.Price_List__r.Promotional_Discount_Item_Id__c;
                    checkPromotion(sunDesign, isNAUser, operatingUnit);
                }
                //Start for case # 00062051
                if (systemSizeLimit == null && !isNAUser) {
                    systemSizeLimit = p.Price_List__r.System_Size__c;
                    system.debug('-----------------systemSizeLimit'+systemSizeLimit);
                    setOrderType(operatingUnit, systemSizeLimit, purOrder);
                }
                //End for case # 00062051
                //Start for case # 00047219 - closed by customer
                /*if(isEUUser && //for case # 00047219
                        p.Price_List__r.Disc_Quantity__c!=null && p.Price_List__r.Discount__c!=null//for case # 00047219
                        && euDisc == null && euDiscQty ==null//for case # 00047219
                    ){                      //for case # 00047219
                        euDisc = p.Price_List__r.Discount__c;//for case # 00047219
                        euDiscQty = p.Price_List__r.Disc_Quantity__c;//for case # 00047219
                    }*/
                //End for case # 00047219 - closed by customer
                if(p.Type_1__c == 'Smart Pack' && pLine.Oracle_Item_ID__c == p.Item_ID__c){
                    if(p.RecordType.Name =='EU' && p.Type_2__c == purOrder.SmartPack_Mounting_Type__c){
                        if(p.Type_3_Criteria__c == purOrder.SmartPack_Inverter_Type__c){
                            recFoundID = p.ID;
                         }
                    }else if(p.RecordType.Name =='NA'&& ((purOrder.SmartMount__c && p.Type_2__c =='SmartMount') || (!purOrder.SmartMount__c && (p.Type_2__c == null || p.Type_2__c ==''))) ){
                        //working here
                        recFoundID = p.ID;
                    }
                }//If ends
                //Start for Case# 00076192
                else if (p.Type_1__c == 'Ala Carte' && p.Item_ID__c == pLine.Oracle_Item_ID__c) {
                        recFoundID = p.ID;
                        System.debug('Debug: p.Item_ID__r.Name ' + p.Item_ID__r.Name);
                        //break;
                    }
                    System.debug('Debug: recFoundID ' + recFoundID);
                //End for Case# 00076192
                if(recFoundID != null){
                    isEU =false;
                    if(p.RecordType.Name =='EU')
                        isEU =true;
                    Double quantity = pLine.Quantity__c;//(pLine.Quantity__c == null || pLine.Quantity__c =='')? 0.0 : Double.valueOf(pLine.Quantity__c);
                    System.debug('Debug: quantitys ' + quantity);
                    //For EU check starts
                    if(isEU){
                    	//Start for Case# 00088825
			        	if(p.Quantity_1__c == null && p.Quantity_2__c == null && p.Quantity_3__c == null)
			        		pLine.Unit_Price__c = p.Pricing_1__c;
			        	//End for Case# 00088825
                        else if(p.Quantity_1__c != null && p.Quantity_1__c >= quantity)
                            pLine.Unit_Price__c = p.Pricing_1__c;
                        else if(p.Quantity_2__c != null && p.Quantity_2__c >= quantity)
                            pLine.Unit_Price__c = p.Pricing_2__c;
                        else
                            pLine.Unit_Price__c = p.Pricing_3__c;
                    }
                    //For EU check ends
                    //For NA check starts
                    else{
                        //Start for case # 00058506
                        /*if(p.Quantity_1__c != null && p.Quantity_1__c >= quantity)
                            pLine.Unit_Price__c = p.Pricing_1__c;
                        else
                            pLine.Unit_Price__c = p.Pricing_2__c;*/
                        if(p.Quantity_1__c != null && quantity <= p.Quantity_1__c){
                            pLine.Unit_Price__c = p.Pricing_1__c;
                        }else if(p.Quantity_1__c != null && p.Quantity_2__c != null && quantity >  p.Quantity_1__c && quantity <= p.Quantity_2__c){
                            pLine.Unit_Price__c = p.Pricing_2__c;
                        }else if(p.Quantity_1__c != null && p.Quantity_2__c == null && quantity >  p.Quantity_1__c){
                            pLine.Unit_Price__c = p.Pricing_2__c;
                        }else if(p.Quantity_2__c != null && p.Quantity_3__c != null && quantity > p.Quantity_2__c && quantity <= p.Quantity_3__c){
                            pLine.Unit_Price__c = p.Pricing_3__c;
                        }else if(p.Quantity_2__c != null && p.Quantity_3__c == null && quantity >  p.Quantity_2__c){
                            pLine.Unit_Price__c = p.Pricing_3__c;
                        }else if(p.Quantity_3__c != null && quantity >= p.Quantity_3__c){
                            pLine.Unit_Price__c = p.Pricing_4__c;
                        }
                        //End for case # 00058506
                    }//For NA ends
                    //Common Change for populating Total Price
                    try{
                        pLine.Price__c = pLine.Unit_Price__c *  quantity;
                    }catch(Exception e){
                        pLine.Price__c = 0.0;
                    }
                    purchaseOrderList.add(pLine);
                }
                 //purchaseOrderList.add(pLine);
            }
            if(moduleItemPresent && (purchaseOrderList == null || purchaseOrderList.size()==0)){//for Case#00076192
                //purchaseOrderList.clear();
                messages.add('ERROR: Design Items for Design '+ purOrder.SunPower_Design__r.Name +' no longer valid and has been removed from this Purchase Order');
                packagedSystemItemID =null;
                serviceCreditSMSItemId = null;
                system.debug('-----------------This line is error prone ');
            }else{
                purchaseOrderList.addAll(otherThanModule);
            }
            //Add PAckages SystemID
            decimal totalPrice = 0;
           if(packagedSystemItemID != null){
            List<Item__c> itemList = [Select Id,Name,Description__c,Long_Description__c from Item__c where Active__c = true and (Name =:packagedSystemItemId OR Name =:serviceCreditSMSItemId OR Name =:promotionalDiscountItemId)];//added for case 00057686
            Item__c packagedSystemItem = null;
            Item__c serviceCreditSMSItem = null;
            Item__c promotionalDiscountItem = null;
            for (Item__c item : itemList) {
                if(item.Name == packagedSystemItemId) {
                    packagedSystemItem = item;
                } else if (item.Name == serviceCreditSMSItemId) {
                    serviceCreditSMSItem = item;
                }else if(item.Name == promotionalDiscountItemId){//added for case 00057686
                    promotionalDiscountItem = item;
                     system.debug('-----------------Abhay  phase 3 in promotionalDiscountItem '+promotionalDiscountItem);
                }
            }
            if(purchaseOrderList != null && purchaseOrderList.size() > 0){
			        //Start for Case#00088825
			        if (discountAvail == false && promotionalDiscountAvail==false) {
			            totalPrice = smsPriceToAdd;
			        }
			        //End for Case#00088825
                    for(Purchase_Order_Line__c pLine : purchaseOrderList){
                    	if(pLine.Item_Type__c == ALACARTE_POITEMTYPE) continue;//for Case#00088825
                        if(pLine.Price__c != null)
                            totalPrice = totalPrice + pLine.Price__c;
                        pLine.Unit_Price__c = 0.0;
                        pLine.Price__c = 0.0;
                    }

                    //Case#00058280
                    //Purchase_Order_Line__c pLine = new Purchase_Order_Line__c(SmartPack_Item__c =true,Purchase_Order__c = purOrder.ID,Quantity__c = 1,Price__c =totalPrice,Unit_Price__c=totalPrice);
                    Purchase_Order_Line__c pLine = new Purchase_Order_Line__c(Item_Type__c = SMARTPACK_POITEMTYPE ,Purchase_Order__c = purOrder.ID,Quantity__c = 1,Price__c =totalPrice,Unit_Price__c=totalPrice);

                    if(packagedSystemItem != null){
                        pLine.Oracle_Item_ID__c = packagedSystemItem.Id;
                        pLine.Item_Source__c = 'SmartPack';//for Case# 00077093
                    }
                    purchaseOrderList.add(0,pLine);

                    if (discountAvail) {
                        //Case#00058280
                        //Purchase_Order_Line__c discountLine = new Purchase_Order_Line__c(SmartPack_Item__c =true,Purchase_Order__c = purOrder.ID,Quantity__c = 1,Price__c =smsPriceToAdd,Unit_Price__c=smsPriceToAdd);
                        Purchase_Order_Line__c discountLine = new Purchase_Order_Line__c(Item_Type__c = SMARTPACK_POITEMTYPE ,Purchase_Order__c = purOrder.ID,Quantity__c = 1,Price__c =smsPriceToAdd,Unit_Price__c=smsPriceToAdd);
                        if (serviceCreditSMSItem != null) {
                            discountLine.Oracle_Item_ID__c = serviceCreditSMSItem.Id;
                            discountLine.Item_Source__c = 'SmartPack';//for Case# 00077093
                        }
                        purchaseOrderList.add(1, discountLine);
                    }
              }
              if(moduleItemPresent && totalPrice ==0){//for Case# 00076192
                    purchaseOrderList.clear();
                    messages.add('ERROR: Design Items no longer valid and has been removed from this Purchase Order');
                }
            }

        /*..................Starts ends ............................*/
        List<Purchase_Order_Line__c> pListTemp =[select id from Purchase_Order_Line__c where purchase_order__c = :purOrder.ID];
        if(pListTemp != null && pListTemp.size()>0) delete pListTemp;

        for(Purchase_Order_Line__c pLine: mapAlaCartaTemp.values()){
        	if(aLaCarteItemIDsSet.contains(pLine.Oracle_Item_ID__c))//for Case# 00076192
        		continue;//for Case# 00076192
        	//Start for Case# 00077093
        	if(pLine.Item_Source__c == 'SmartPack')
        		continue;
        	//End for Case# 00077093
            if(purchaseOrderList.size() ==0)
                purchaseOrderList.add(pLine);
            else
                purchaseOrderList.add(0,pLine);
        }

    }// ends of if(isSmartPack)
    //Now checking for Price ends here
    System.debug('Here the messages on Mar 5 2010::'+messages);
    for(String m:messages){
        System.debug(m);
    }

    return messages;
    }

    //Check is Billing Shipping same

    public static boolean isBillingShippingAddressSame(Opportunity opp){
        if(opp.Account ==null) return true;
        if(opp.Account.BillingCity == opp.Account.ShippingCity && opp.Account.BillingState == opp.Account.ShippingState && opp.Account.BillingCountry == opp.Account.ShippingCountry && opp.Account.BillingPostalCode == opp.Account.ShippingPostalCode)
            return true;
        return false;
    }
    //Get Formatted Billing Address
    public static String getFormmatedOppBillingAddress(Opportunity opp){
        Account acc= opp.Account;
    if(acc ==null) return '';
        String address='';
        if(acc.BillingStreet !=null) address+=acc.BillingStreet+', ';
        if(acc.BillingCity !=null) address+=acc.BillingCity+', ';
        if(acc.BillingState !=null) address+=acc.BillingState+', ';
        if(acc.BillingCountry !=null) address+=acc.BillingCountry+', ';
        if(acc.BillingPostalCode !=null) address+=acc.BillingPostalCode+' ';
        return address;
    }
    //Get Formatted Shipping Address
    public static String getFormmatedOppShippingAddress(Opportunity opp){
    Account acc= opp.Account;
    if(acc ==null) return '';
        String address='';
        if(acc.ShippingStreet !=null) address+=acc.ShippingStreet+', ';
        if(acc.ShippingCity !=null) address+=acc.ShippingCity+', ';
        if(acc.ShippingState !=null) address+=acc.ShippingState+', ';
        if(acc.ShippingCountry !=null) address+=acc.ShippingCountry+', ';
        if(acc.ShippingPostalCode !=null) address+=acc.ShippingPostalCode+' ';
        return address;
    }
    //Get Valid NA ACccount Type
    public static Set<String> getValidNAAccountType(){
        Set<String> validNAAccountType = new Set<String> ();
        validNAAccountType.add('Authorized-Partner-Residential');
        validNAAccountType.add('Premier-Partner-Residential');
        validNAAccountType.add('Authorized-Partner-Combo');
        validNAAccountType.add('Premier-Partner-Combo');
        validNAAccountType.add('Elite-Partner-Combo');
        validNAAccountType.add('Elite-Partner-Residential');
        return validNAAccountType;
    }
    //Get Contacts in Map

    public static Map<ID,Contact> getContactsInMap(String accid){
        return new Map<ID,Contact>([select id,FirstName,LastName,Phone,Name from Contact where AccountID = :accid Limit 200]);
    }

   //Function ends
    /** This function converts a string value to integer value.
     *  @return Integer
     */
    public static Integer covertStringToInt(String val){
        try{
            return (val == null || val.trim() =='') ? 0 : Integer.valueOf(System.Math.round(System.Math.floor(Double.ValueOf(val))));
        }catch(Exception e){
            return 0;
        }
    }//Function ends

     public static List<SelectOption> getShippingMethods(Price_List__c selectedPriceList){
        List<SelectOption> options = new List<SelectOption>();
        SelectOption optionDefault = new SelectOption('','--None--');
        options.add(optionDefault);
        if(selectedPriceList != null && selectedPriceList.Shipping_Codes__c != null && selectedPriceList.Shipping_Codes__c != ''){
            for(String s :selectedPriceList.Shipping_Codes__c.split('\\;')){
                SelectOption opt = new SelectOption(s,s);
                options.add(opt);
            }
        }
       return options;
   }

   public static void fillWrapperRestFields(List<LeaseOrderWizardController.PurchaseOrderLineItemWrapper> selProductItems){
        if(selProductItems != null && selProductItems.size() > 0){
            Set<ID> itemIDSet  = new Set<ID>();
            Map<ID,Item__c> itemDetailMap ;
            //fetching all Item__c references from the field oracleItemIDRef of wrapper list
            for(LeaseOrderWizardController.PurchaseOrderLineItemWrapper wrap:selProductItems){
                System.debug('item Name : '+wrap.Name + ' ItemID : '+wrap.ItemID);
                if(wrap.oracleItemIDRef != null ){
                    System.debug(' oracle item id : '+wrap.oracleItemIDRef);
                    itemIDSet.add(wrap.oracleItemIDRef);
                }
            }
            // querying the map of ID and Item__c for all itemIDs we have in the set
            itemDetailMap = new Map<ID, Item__c>([Select Id,Name,Description__c,Long_Description__c,Line_Type__c from Item__c where Active__c = true and Id IN :itemIDSet LIMIT 1000]);
            // iterating the list of wrapper and updating there ItemIds and Name(Description)
            for(LeaseOrderWizardController.PurchaseOrderLineItemWrapper wrap:selProductItems){
                if(itemDetailMap != null && itemDetailMap.containsKey(wrap.oracleItemIDRef)){
                    Item__c tempItem = itemDetailMap.get(wrap.oracleItemIDRef);
                    // updating ItemID of wrapper
                    wrap.ItemID = tempItem.Name;
                    // updating Name(Description) of wrapper
                    // if Long_Description is null then Description otherwise Long_Description__c
                    /*if(tempItem.Long_Description__c != null)
                        wrap.Name = tempItem.Long_Description__c;
                    else
                        wrap.Name = tempItem.Description__c;
                    */
                     if(tempItem.Description__c != null)
                        wrap.Name = tempItem.Description__c;
                     else
                        wrap.Name = tempItem.Long_Description__c;

                     //added for Case#00061770
                    wrap.pOrderLine.Oracle_Item_Id__r = tempItem;

                }
            }
        }
   }

   // Done for request to allow ‘EU Residential Installer’ profile to Order only Modulo and Inverter.
   // public static List<SelectOption> getCategories(Purchase_order__c purchaseOrder,Map<String,String> params){
   public static List<SelectOption> getCategories(Purchase_order__c purchaseOrder,Map<String,String> params, Boolean isUserEUResidentialInstaller){
        List<SelectOption> options = new List<SelectOption>();
        Schema.sObjectType t = Price_List_Item__c.sObjectType;
        Schema.DescribeFieldResult f = Schema.sObjectType.Price_List_Item__c.fields.Category__c;
        if((moduleAlaCarteItemPresent && moduleItemPresent) || (params.get('DID') == null && purchaseOrder.SunPower_Design__c == null)){ //for Case# 00076192
            //SelectOption opt1 = new SelectOption('--None--','--None--');
            SelectOption opt1 = new SelectOption(System.Label.POWizardNonePicklistValue,System.Label.POWizardNonePicklistValue);
            options.add(opt1);

            for(picklistEntry a:f.picklistValues){
                // Done for request to allow ‘EU Residential Installer’ profile to Order only Modulo and Inverter.
                if(isUserEUResidentialInstaller ){
                    continue;
                }
                // end request.

                SelectOption opt = new SelectOption(a.getValue(),a.getLabel());
                options.add(opt);
            }

        }else{

            SelectOption opt = new SelectOption(LeaseOrderWizardController.CATEGORY_BOS,LeaseOrderWizardController.CATEGORY_BOS);
            options.add(opt);
             //for case: 00071299 begin
            SelectOption opt1 = new SelectOption(LeaseOrderWizardController.CATEGORY_INVERTER,LeaseOrderWizardController.CATEGORY_INVERTER);
            options.add(opt1);
             //for case: 00071299 end
        }
       return options;
   }

   public static List<Purchase_Order_Line__c> getSortedList(List<Purchase_Order_Line__c> purLines){
        for(Integer index =0 ;index<purLines.size();index++){
            for(Integer nextIndex = index+1; nextIndex < purLines.size();nextIndex++){
                if(covertStringToInt(purLines[index].Order_Line_Number__c) > covertStringToInt(purLines[nextIndex].Order_Line_Number__c)){
                    Purchase_Order_Line__c tmp = purLines[index];
                    purLines.set(index,purLines[nextIndex]);
                    purLines.set(nextIndex,tmp);
                }
            }//inner for ends
        }//for ends
        return purLines;
    }//Function ends

   public static void calculateOrderPrice(Purchase_Order__c purchaseOrder,List<LeaseOrderWizardController.PurchaseOrderLineItemWrapper> selProductItems,String srcCreSMSItemId){
        if (srcCreSMSItemId != null) {
            serviceCreditSMSItemId = srcCreSMSItemId;
        }

        if(purchaseOrder == null) return;
        purchaseOrder.Order_Total__c =0.0;
        if(selProductItems != null){
            for(LeaseOrderWizardController.PurchaseOrderLineItemWrapper pWrap :selProductItems){
                // changed for maintaining currency format
                if(pWrap ==null)
                    continue;
                pWrap.pOrderLine.Price__c = covertStringToInt(pWrap.Qty)* pWrap.perUnitPrice;
                if(pWrap ==null || pWrap.totalPrice == null)
                    continue;
                if ((serviceCreditSMSItemId != null && serviceCreditSMSItemId != '' && serviceCreditSMSItemId == pWrap.itemID)
                        || pWrap.pOrderLine.Oracle_Item_Id__r.Line_Type__c == 'Credit Only') {
                    purchaseOrder.Order_Total__c -= pWrap.totalPrice;
                } else {
                    purchaseOrder.Order_Total__c += pWrap.totalPrice;
                }
            }
        }
        if(purchaseOrder.Order_Total__c != null && purchaseOrder.Order_Total__c != 0.0){
            if(purchaseOrder.Accept_Expedited_Delivery_Charges__c && purchaseOrder.Delivery_Charges__c != null && purchaseOrder.Delivery_Charges__c != 0.0){
                //purchaseOrder.Order_Total__c += purchaseOrder.Delivery_Charges__c;
            }
        }
    }

    /* Added for Sunpower Case # 00032179 */
    private static void deleteExistingLineItems(ID purchaseOrderId) {
        List<Purchase_Order_Line__c> existingLineItems = [SELECT Id FROM Purchase_Order_Line__c
                WHERE Purchase_Order__c = :purchaseOrderId];
        if(existingLineItems != null && existingLineItems.size()>0)
            delete existingLineItems;
    }
    /**************************************/

    public static void insertListAndUpdateWrapper(Purchase_Order__c purchaseOrder, List<Purchase_Order_Line__c> purchaseOrderList,List<LeaseOrderWizardController.PurchaseOrderLineItemWrapper> selProductItems){
    //Function for mainiting Order
        integer index =0;
        List<Purchase_Order_Line__c> purchaseOrderList1 = new List<Purchase_Order_Line__c>();
        System.debug('Debug: Start of purchaseOrderList->'+purchaseOrderList.Size());
        for(LeaseOrderWizardController.PurchaseOrderLineItemWrapper polw : selProductItems){
            Purchase_Order_Line__c poline = purchaseOrderList.get(index++);
            poline.Name = polw.Name;
            if( polw.pOrderLine.Oracle_Warehouse__c != null )
            {
            	poline.Oracle_Warehouse__c = polw.pOrderLine.Oracle_Warehouse__c;
            }
            if( polw.pOrderLine.Oracle_Item_ID__c != null )
            {
	            poline.Oracle_Item_ID__c = polw.pOrderLine.Oracle_Item_ID__c;
            }
            purchaseOrderList1.add(poline);
        }
        /* Added for Sunpower Case # 00032179 */
        // As issue discussed with Gurvinder regarding the duplicate Purchase Order Line Items.
        // Here we are explicitly deleting line items.
        purchaseOrderList = purchaseOrderList1;
        deleteExistingLineItems(purchaseOrder.Id);
        /**************************************/

        insert purchaseOrderList;
        boolean isUpdateRequired=true;
        index =0;
        List <Purchase_Order_Line__c> tempLineItems = new List <Purchase_Order_Line__c>();
        for(Purchase_Order_Line__c item:purchaseOrderList){
            if(item.Child_ID__c != null && item.Child_ID__c !='' && purchaseOrderList.size()>(index+1)){
                item.Child_ID__c = purchaseOrderList.get(index+1).ID;
            }
            index++;
        }
        if(isUpdateRequired)
            update purchaseOrderList;
        updateLineNumbersForOrder(purchaseOrderList);
        Map<String,LeaseOrderWizardController.PurchaseOrderLineItemWrapper> childParentMap = new Map<String,LeaseOrderWizardController.PurchaseOrderLineItemWrapper>();

        // create a map from the order lines' item__c reference to the line,
        // since the wrappers reference the item ids
        Map<Id, Purchase_Order_Line__c> purchaseOrderListMap = new Map<Id, Purchase_Order_Line__c>();
        for( Purchase_Order_Line__c purchaseOrderLine : purchaseOrderList )
        {
        	if( purchaseOrderLine.Oracle_Item_ID__c != null )
        	{
        		purchaseOrderListMap.put( purchaseOrderLine.Oracle_Item_ID__c, purchaseOrderLine );
        	}
        }

		for( Integer wrapperIndex = 0; wrapperIndex < selProductItems.size(); wrapperIndex++ ) {
			LeaseOrderWizardController.PurchaseOrderLineItemWrapper item = selProductItems[ wrapperIndex ];
            if( item.oracleItemIDRef ==  purchaseOrderList.get( wrapperIndex ).Oracle_Item_Id__c )
            {
            	copyItemToWrapper(purchaseOrder,purchaseOrderList.get( wrapperIndex ),item);
            }

            if(item.childID != null)
                childParentMap.put(item.childID,item);
        }
       /*...................Code added for ................*/
            if(childParentMap != null && childParentMap.values().size() >0){
                for(LeaseOrderWizardController.PurchaseOrderLineItemWrapper pWrap:selProductItems){
                    if(childParentMap.get(pWrap.ID) != null){
                        pWrap.isChild=true;
                        pWrap.parentID = childParentMap.get(pWrap.ID).ID;
                    }
                }
            }

        /*...................Code added for ................*/

        //showProductList();
        fillWrapperRestFields(selProductItems);
    }//function ends

    public static void copyItemToWrapper(Purchase_Order__c purchaseOrder,Purchase_Order_Line__c pLine, LeaseOrderWizardController.PurchaseOrderLineItemWrapper pWrap){
        if(pLine.Child_ID__c != null && pLine.Child_ID__c != '')
            pWrap.childID = pLine.Child_ID__c;
        //Quantity
        pWrap.Qty = String.valueOf(pLine.Quantity__c);
        //Line Number
        pWrap.lineNumber = pLine.Order_Line_Number__c;
        //Item Number
        pWrap.ID = pLine.ID;
        // now using Oracle_Item_Id reference
        //pWrap.ItemID = pLine.Item_ID__c;
        pWrap.Name = pLine.Name;//added for case # 00047219 - closed by customer

        if(pLine.Oracle_Item_ID__c != null){
            pWrap.oracleItemIDRef = pLine.Oracle_Item_ID__c;
            pWrap.ItemID = pLine.Oracle_Item_ID__r.Name;
            /*
            if(pLine.Oracle_Item_ID__r.Long_Description__c != null)
                pWrap.Name = pLine.Oracle_Item_ID__r.Long_Description__c;
            else
                pWrap.Name = pLine.Oracle_Item_ID__r.Description__c;
            */

            if(pLine.Oracle_Item_ID__r.Description__c != null)
                pWrap.Name = pLine.Oracle_Item_ID__r.Description__c;
            else
                pWrap.Name = pLine.Oracle_Item_ID__r.Long_Description__c;
        }

        //Case#00058280
        //pWrap.isSmartPack = pLine.SmartPack_Item__c;
        pWrap.itemSource = pLine.Item_Source__c;//for Case#00077093

        pWrap.itemType = pLine.Item_Type__c;//done by Jitendra for Case#00058280
        pWrap.itemCategory = pLine.Category__c;//done by Jitendra for Case#00058280

        pWrap.isSmartPack = (pLine.Item_Type__c != null && pLine.Item_Type__c.equalsIgnoreCase(SMARTPACK_POITEMTYPE));

        pWrap.isFromDesign =false;
        pWrap.isExisting =true;
        pWrap.perUnitPrice = (pLine.Unit_Price__c != null)? pLine.Unit_Price__c :0.0;
        pWrap.totalPrice =  (pLine.Price__c != null) ? pLine.Price__c :0.0;
        // changed for maintaining currency format
        ///For Currency Added @19 Nov,2009
            if(purchaseOrder != null && purchaseOrder.CurrencyIsoCode != null)
                pWrap.pOrderLine.CurrencyIsoCode =purchaseOrder.CurrencyIsoCode;
        ///For Currency Added @19 Nov,2009
        pWrap.pOrderLine.Unit_Price__c = (pLine.Unit_Price__c != null)? pLine.Unit_Price__c :0.0;
        pWrap.pOrderLine.Price__c = (pLine.Price__c != null) ? pLine.Price__c :0.0;
        pWrap.Qty =  (pLine.Quantity__c != null) ? String.valueOf(pLine.Quantity__c) : String.valueOf(0.0);
        pWrap.currencyCode = pLine.CurrencyIsoCode;

        //setCounter(pWrap.lineNumber);
    }


    public static void updateLineNumbersForOrder(List<Purchase_Order_Line__c> purchaseOrderList){
        List<Purchase_Order_Line__c> purNonSmartLines = new List<Purchase_Order_Line__c>();
        List<Purchase_Order_Line__c> purSmartLines = new List<Purchase_Order_Line__c>();
        integer counterLocal = 1;
        for(Purchase_Order_Line__c p:purchaseOrderList){
            //Case#00058280
            //if(!p.SmartPack_Item__c){
            if(p.Item_Type__c == null || !p.Item_Type__c.equalsIgnoreCase(SMARTPACK_POITEMTYPE)){
                p.Order_Line_Number__c = String.valueOf(counterLocal) +'.0';
                purNonSmartLines.add(p);
                counterLocal = counterLocal + 1;
            }
            else purSmartLines.add(p);
        }
        for(Purchase_Order_Line__c p: purSmartLines){
            p.Order_Line_Number__c = String.valueOf(counterLocal) +'.0';
            counterLocal = counterLocal + 1;
        }
        purchaseOrderList.clear();
        purchaseOrderList.addAll(purNonSmartLines);
        purchaseOrderList.addAll(purSmartLines);
    }
     // For case 00057686
   public static void getPromotionalDiscountDetails(){
        Date currentDate = system.today();
        for(Price_List_Item__c p: [Select p.Disc_Item_ID__c,p.Disc_Item_Description__c,p.Disc_Item_ID__r.Name,p.ID,p.Type_3_Criteria__c,p.RecordTypeID,p.RecordType.Name,p.Pricing_1__c, p.Price_List__r.Oracle_Operating_Unit__c, p.Price_List__r.Promotional_Discount_Item_Id__c,p.Price_List__r.Name, p.Price_List__c, p.Item_ID__c,p.Item_ID__r.Id, p.Item_ID__r.Name, p.Name, p.Effective_Start_Date__c, p.Effective_End_Date__c, p.Item_Description__c, p.Category__c From Price_List_Item__c p where /*p.Price_List__r.Oracle_Operating_Unit__c = :operatingUnit and*/ p.Effective_Start_Date__c <=:currentDate and p.Effective_End_Date__c >=:currentDate and Is_Active__c = 'true' and p.Item_ID__c != null and p.Item_ID__r.Name ='135176']){
            if (alaCartapromotionalDiscountItemId == null) {
                alaCartapromotionalDiscountItemId = p.Price_List__r.Promotional_Discount_Item_Id__c;
                alaCartapromotionalDiscountToAdd = p.Pricing_1__c;
                alaCartPromotionalDiscountId=p.ID;
            }
        }
   }

   // For case 00057686
   public static void updatePromotionDiscountPrice(List<LeaseOrderWizardController.PurchaseOrderLineItemWrapper> selProductItems,Integer qty,boolean isUpdate){
    integer kitProductCount=0;
        for(LeaseOrderWizardController.PurchaseOrderLineItemWrapper prodWrapper :selProductItems){
            //if(prodWrapper.itemID!=null && prodWrapper.perUnitPrice)
            if(prodWrapper.itemID=='135176'){
                if(isUpdate){
                    getPromotionalDiscountDetails();
                    for(LeaseOrderWizardController.PurchaseOrderLineItemWrapper kitProd :selProductItems){
                        if(kitProd.itemID=='114556'){
                            qty=qty+covertStringToInt(kitProd.Qty);
                            //kitProductCount=kitProductCount+covertStringToInt(kitProd.Qty);
                            //break;
                        }
                    }
                    prodWrapper.perUnitPrice=qty * alaCartapromotionalDiscountToAdd;
                    prodWrapper.totalPrice=qty * alaCartapromotionalDiscountToAdd;

                    prodWrapper.pOrderLine.Price__c = qty * alaCartapromotionalDiscountToAdd;
                    prodWrapper.pOrderLine.Unit_Price__c = qty * alaCartapromotionalDiscountToAdd;

                }else{
                    getPromotionalDiscountDetails();
                    system.debug('----------Abhay--qty-----'+qty);
                    system.debug('----------Abhay--alaCartapromotionalDiscountToAdd-----'+alaCartapromotionalDiscountToAdd);

                    prodWrapper.perUnitPrice=qty * alaCartapromotionalDiscountToAdd;
                    prodWrapper.totalPrice=qty * alaCartapromotionalDiscountToAdd;

                    prodWrapper.pOrderLine.Price__c = qty * alaCartapromotionalDiscountToAdd;
                    prodWrapper.pOrderLine.Unit_Price__c = qty * alaCartapromotionalDiscountToAdd;
                }
                if(prodWrapper.pOrderLine.Price__c>100){
                    prodWrapper.pOrderLine.Price__c=100;
                    prodWrapper.pOrderLine.Unit_Price__c=100;

                    prodWrapper.perUnitPrice=100;
                    prodWrapper.totalPrice=100;

                }
            }
        }
   }
     // For case 00057686
    public static void addPromotionalDiscount(List<LeaseOrderWizardController.PurchaseOrderLineItemWrapper> selProductItems,String itemId){
            boolean itemExist=false;
             for(LeaseOrderWizardController.PurchaseOrderLineItemWrapper prodWrapper :selProductItems){
                if(prodWrapper.itemID=='135176'){
                    itemExist=true;
                    updatePromotionDiscountPrice(selProductItems,covertStringToInt(prodWrapper.Qty),true);
                    break;
                }
             }
            if(itemId=='114556' && itemExist==false){

              getPromotionalDiscountDetails();
                Item__c promotionalDiscountItem = null;
                for (Item__c item : [Select Id,Name,Description__c,Long_Description__c,Line_Type__c from Item__c where Active__c = true and Name =:alaCartapromotionalDiscountItemId]) {
                    if(item.Name == alaCartapromotionalDiscountItemId){ // Added for case0007686
                        promotionalDiscountItem=item;
                    }
                }

                LeaseOrderWizardController.PurchaseOrderLineItemWrapper discountWrapper = new LeaseOrderWizardController.PurchaseOrderLineItemWrapper();
                discountWrapper.id=alaCartPromotionalDiscountId;
                discountWrapper.Name = 'Promotional Service Credit Solar Mount-I';
                discountWrapper.isSmartPack = false;
                discountWrapper.Qty = '1';
                discountWrapper.itemID = alaCartapromotionalDiscountItemId;

                discountWrapper.perUnitPrice=alaCartapromotionalDiscountToAdd;
                discountWrapper.totalPrice=alaCartapromotionalDiscountToAdd;

                discountWrapper.pOrderLine.Price__c = alaCartapromotionalDiscountToAdd;
                discountWrapper.pOrderLine.Unit_Price__c=alaCartapromotionalDiscountToAdd;
                system.debug('----------------------------------------promotionalDiscountItem.Id'+promotionalDiscountItem.Id);

                //added for Case#00061770
                discountWrapper.pOrderLine.Oracle_Item_Id__r = promotionalDiscountItem;

                if (promotionalDiscountItem != null) {
                    discountWrapper.oracleItemIDRef = promotionalDiscountItem.Id;
                }
                selProductItems.add(discountWrapper);

                system.debug('------------------Abhay----------------------selProductItems'+selProductItems);
            }



    }
    public static void synchQuantity(List<LeaseOrderWizardController.PurchaseOrderLineItemWrapper> selProductItems,String changedQty,String recordSep,String dataSep){
            boolean updatePromotionalDiscount=false;// for case 00057686
            Integer updateQty;// for case 00057686
            if(selProductItems == null || selProductItems.size()==0) return;
            if(changedQty == null || changedQty =='')return;
            Map<String,String> keyValues = new Map<String,String>();
            Map<String,String> childKeyValues = new Map<String,String>();
            for(String s: changedQty.split('\\'+recordSep)){
                String []splitVal = s.split('\\'+dataSep);
                if(splitVal != null && splitVal.size()>=2){
                    keyValues.put(splitVal[0],splitVal[1]);
                }
            }
            for(LeaseOrderWizardController.PurchaseOrderLineItemWrapper prodWrapper :selProductItems){
                if(keyValues.get(prodWrapper.id) != null){
                    prodWrapper.Qty = keyValues.get(prodWrapper.id);
                    if(prodWrapper.childID != null && prodWrapper.childID != '')
                        childKeyValues.put(prodWrapper.Id+dataSep+prodWrapper.childID, prodWrapper.Qty);
                    // changed for maintaining currency format
                    prodWrapper.pOrderLine.Price__c = covertStringToInt(prodWrapper.Qty)* prodWrapper.perUnitPrice;
                    prodWrapper.totalPrice = covertStringToInt(prodWrapper.Qty)* prodWrapper.perUnitPrice;

                    if(prodWrapper.itemID=='114556'){// for case 00057686
                        updatePromotionalDiscount=true;// for case 00057686
                        updateQty=covertStringToInt(prodWrapper.Qty);
                    }
                }
            }

            for(LeaseOrderWizardController.PurchaseOrderLineItemWrapper prodWrapper :selProductItems){
                if(childKeyValues.get(prodWrapper.parentID+dataSep+prodWrapper.ID) != null){
                    prodWrapper.Qty = childKeyValues.get(prodWrapper.parentID+dataSep+prodWrapper.ID);
                }
            }
            system.debug('-----------------------------Abhay---------updateQty----'+updateQty);
            system.debug('-----------------------------Abhay---------updatePromotionalDiscount----'+updatePromotionalDiscount);
            if(updateQty!=null && updatePromotionalDiscount){// for case 00057686
                updatePromotionDiscountPrice(selProductItems,updateQty,false);// for case 00057686
            }

    }//function ends


  public static LeaseOrderWizardController.PurchaseOrderLineItemWrapper addNewDisconnectItem(LeaseOrderWizardController.PurchaseOrderLineItemWrapper parent){
        LeaseOrderWizardController.PurchaseOrderLineItemWrapper child = new LeaseOrderWizardController.PurchaseOrderLineItemWrapper(parent.childID,'0.0',parent.childDescription,parent.prodType,'0.0',parent.currencyCode,0.0,0.0,false,false);
        child.isChild =true;
        child.oracleItemIDRef = parent.childID;
        child.itemID = parent.childName;
        child.Qty = parent.Qty;
        child.parentID=parent.ID;
        return child;
  }
  // Method to get next date after 14 working days
  public static Date getNextWorkingDate(Date startDate, integer daysToAdd){
    integer i=0;
    Date d = startDate;
    integer x = daysToAdd; // days to add
    if(d == d.tostartOfweek() || d == d.tostartOfweek().addDays(6))
      x--;
    while(i<x+1)
    {
      if(d != d.tostartOfweek() && d != d.tostartOfweek().addDays(6))
         i++;
      d= d.adddays(1);
    }
    d = d.adddays(-1);
    system.debug(d);
    return d;
  }

 public static String getTermsDocumentsID(Account dealerAccount){
    String id=null;
    String folderName='Terms and Conditions';
    if(dealerAccount != null && dealerAccount.Oracle_Operating_Unit__c != null){
        String opName= dealerAccount.Oracle_Operating_Unit__c;
        if(opName.length()>4) opName = opName.substring(0,4);
        for(Document d :[select id,DeveloperName,name from Document where DeveloperName = :opName and Folder.Name =:folderName Limit 1]){
            id=d.id;
        }
    }
    return id;
 }

 //Case#00058280
 public static List<Price_List_Item__c> getPVInverterItems(String operatingUnit,Set<String> itemIds){
    List<Price_List_Item__c> lst = new  List<Price_List_Item__c>();
    if(operatingUnit != null && itemIds.size() > 0){
        Date currentDate = Date.today();
        String qry = 'Select p.Disc_Item_ID__c,p.Disc_Item_Description__c,p.Disc_Item_ID__r.Name,p.CurrencyIsoCode,p.Type_2__c, p.Type_1__c, p.Quantity_2__c, p.Quantity_1__c, p.Pricing_3__c,p.Pricing_2__c, p.Pricing_1__c, p.Price_List__r.Expedite_Fee__c , p.Price_List__r.Oracle_Operating_Unit__c, p.Price_List__r.Name, p.Price_List__c, p.Item_ID__c, p.Item_ID__r.Name, p.Name, p.Effective_Start_Date__c, p.Effective_End_Date__c, p.Item_Description__c, p.Category__c From Price_List_Item__c p where p.Price_List__r.Oracle_Operating_Unit__c = :operatingUnit and p.Effective_Start_Date__c <=:currentDate and p.Effective_End_Date__c >=:currentDate and p.Is_Active__c = \'true\' and p.Type_1__c =:PVINVERTER_POITEMTYPE and Item_ID__r.Name IN :itemIds ';
        lst = database.query(qry);
    }
    return lst;
 }

 public static void reEvaluatePVInverterPrice(String operatingUnit,List<LeaseOrderWizardController.PurchaseOrderLineItemWrapper> selProductItems,Integer inverterCount,Map<String, LeaseOrderWizardController.PriceListItemWrapper>mapPVInveterItems){
    system.debug('=========reEvaluatePVInverterPrice=======');
    Set<String> itemIds = new Set<String>();
    for(LeaseOrderWizardController.PurchaseOrderLineItemWrapper prodWrapper :selProductItems){
        if(mapPVInveterItems.containsKey(prodWrapper.itemID) &&  mapPVInveterItems.get(prodWrapper.itemID).getItem(false) == null ){
            itemIds.add(prodWrapper.itemID);
        }
    }


    for(Price_List_Item__c item : getPVInverterItems(operatingUnit,itemIds)){
        mapPVInveterItems.get(item.Item_ID__r.Name).pvInverter = item.Pricing_1__c;
    }

    system.debug('=========inverterCount=======' + inverterCount);

    for(Integer index = selProductItems.size() - 1  ; index >= 0 ; index --){
        LeaseOrderWizardController.PurchaseOrderLineItemWrapper prodWrapper = selProductItems.get(index);
        if(mapPVInveterItems.containsKey(prodWrapper.itemID)){
            Boolean isInverterPrice = inverterCount > 0;
            Decimal priceListItem = mapPVInveterItems.get(prodWrapper.itemID).getItem(!isInverterPrice);
            if(priceListItem != null){
                prodWrapper.pOrderLine.Unit_Price__c = prodWrapper.perUnitPrice = priceListItem;
                prodWrapper.pOrderLine.Price__c = prodWrapper.totalPrice =  calculateTotalPrice(prodWrapper.perUnitPrice, Integer.valueOf(prodWrapper.qty));
                inverterCount--;
                System.debug('isInverterPrice->'+isInverterPrice);
                if(isInverterPrice)
                	prodWrapper.itemType = PVINVERTER_POITEMTYPE ;//done by Jitendra for Case#00058280
                else
                	prodWrapper.itemType = ALACARTE_POITEMTYPE;//done by Jitendra for Case#00058280
                System.debug('prodWrapper.itemType->'+prodWrapper.itemType);
            }
        }
    }
 }

 public static Decimal calculateTotalPrice(decimal unitPrice, integer qty){
        if(unitPrice != null)
            return unitPrice*qty;
        else
            return 0;
 }
 //Case#00058280
}