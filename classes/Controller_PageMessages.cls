public with sharing class Controller_PageMessages {

    public String CustomPageMessages_ClosableErrorsRenderPlaceHolder {
        get { 
            if(CustomPageMessages_ClosableErrorsRenderPlaceHolder == null) CustomPageMessages_ClosableErrorsRenderPlaceHolder = ''; 
            return CustomPageMessages_ClosableErrorsRenderPlaceHolder; 
        }
        private set;
    } 

    public List<PageMessages.PageMessage> getPageMessages() {
        system.debug('==pagemess ctrl===>'+PageMessages.getMessages());
        return PageMessages.getMessages();
    }
    
}