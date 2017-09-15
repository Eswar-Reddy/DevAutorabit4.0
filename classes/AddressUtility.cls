public class AddressUtility {
	
    //method used to format Address to send to Aurora
    public static String formatAccountAddressforAurora(Account acc){
        String address = (acc.ShippingStreet!=null?acc.ShippingStreet:'') + ', ' + (acc.ShippingCity!=null?acc.ShippingCity:'') + ', ' + (acc.ShippingState!=null?acc.ShippingState:'') + ', ' + (acc.ShippingPostalCode!=null?acc.ShippingPostalCode:'');
        return address;
    }
    
    public static String streetCityStateforAurora(Account acc){
        String address = (acc.ShippingStreet!=null?acc.ShippingStreet:'') + ', ' + (acc.ShippingCity!=null?acc.ShippingCity:'') + ', ' + (acc.ShippingState!=null?acc.ShippingState:'');
        return address;
    }
}