public class AuroraRedirectMessageController {

    public Boolean isPartnerUser {get {return SPCommunityUtility.isPartnerUser();}}
    public String message {get; private set;}
    
    public AuroraRedirectMessageController() {
        message = getProblemWithTheSystem();
        if (isPartnerUser == false) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, message));
        }
    }
    private static String getProblemWithTheSystem() {
        return SPCommunityErrorUtility.errMessage;
    }
}