public class ChatterNotificationUtility {
    
    public static void createOppAssignmentPost(Opportunity opp, String activity, Id oldUserToMention) {
    
        System.debug('##### COMMUNITY IDs:' + ConnectApi.Communities.getCommunities());
        
        User feedCreator;
         
        List<Account> lAccounts = [SELECT Name, Chatter_Group_Name__c FROM Account WHERE Id = :opp.PartnerAccountId LIMIT 1];
        if(lAccounts.size() == 0 && (!Test.isRunningTest())) return;
        
        Account account = new Account();
        if(!Test.isRunningTest()) account = lAccounts[0];
        else if(Test.isRunningTest()) {
            account = new Account(OwnerId = Userinfo.getUserId(), Name = 'Testo PartnerAccount', Phone = '+19651111111', Chatter_Group_Name__c = 'Sample CG3');
        }
        
        System.Debug('#####Account Chatter:'+account.Chatter_Group_Name__c);        
        if(String.isBlank(account.Chatter_Group_Name__c)) return;
        
        CollaborationGroup chatterGroup = [SELECT Id, Name FROM CollaborationGroup WHERE Name = :account.Chatter_Group_Name__c LIMIT 1];
        System.Debug('#####Chatter Group:'+ chatterGroup.Id);
        
        // Need to make a list or get ID.  ConnectApi.Community internalCommunity = [SELECT Id FROM Community WHERE Name = 'INTERNAL_COMMUNITY' LIMIT 1];
        ConnectApi.Community partnerCommunity;
        String partnerCommunityName; 
        String partnerFeedCreator;
        SunPower_Communities__c communitySettings = SunPower_Communities__c.getValues('Partner Community');
        if (communitySettings != null) {
            partnerCommunityName = communitySettings.Community_Name__c;
            partnerFeedCreator = communitySettings.Feed_Creator__c;
        }
        try {
            feedCreator = [SELECT id, Name FROM User WHERE username = :partnerFeedCreator];
        } catch(Exception fcErr) {
            System.debug('fcErr: ' + fcErr);
        }
        
        if(feedCreator == null) return;
        
        
        System.Debug('#####Feed Creator:'+feedCreator.Id);
        String oppURL;
    
        // Get the specific SunPower Partner Community
        ConnectApi.CommunityPage listCommunities = ConnectApi.Communities.getCommunities();
        if (listCommunities != null){
            for(ConnectApi.Community c: listCommunities.communities){
                if(c.Name == partnerCommunityName){ 
                    System.Debug('#####Community Match Found#####');
                    partnerCommunity = c;
                    //oppURL = c.SiteURL+'/'+ opp.Id;
                    oppURL = communitySettings.CommunityURL__c +'/'+ opp.Id;
                }
            } 
        }
        
        if (partnerCommunity != null){
            postFeedItem(partnerCommunity, opp.Id, opp.OwnerId, chatterGroup, opp.Name, oppURL, feedCreator, activity, oldUserToMention, account.Name);
        }   
    }
    
    //Written by Cloud Sherpas - Sumit
    private static ConnectApi.TextSegmentInput getTextSegment(String text) {
        ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
        textSegment.text = text;
        return textSegment;
    }    
    
    //Written by Cloud Sherpas - Sumit
    private static ConnectApi.MentionSegmentInput getMentionSegment(Id idToMention) {
        ConnectApi.MentionSegmentInput mentionSegment = new ConnectApi.MentionSegmentInput();
        mentionSegment.id = idToMention;
        return mentionSegment;
    } 
    
    //Written by Cloud Sherpas - Sumit    
    private static ConnectApi.LinkAttachmentInput getLinkAttachment(String linkName, String linkURL) {
        ConnectApi.LinkAttachmentInput linkIn = new ConnectApi.LinkAttachmentInput();
        linkIn.urlName = linkName;
        linkIn.url = linkURL;
        return linkIn;
    }
    
    //Written by Cloud Sherpas - Sumit    
    private static ConnectApi.HashtagSegmentInput getHashSegment(String hashtext) {
        ConnectApi.HashtagSegmentInput hashtag = new ConnectApi.HashtagSegmentInput();
        hashtag.tag = hashtext;
        return hashtag;
    }
    
    
    public static void postFeedItem(ConnectApi.Community community, String objectId, Id userToMention, CollaborationGroup groupToMention,String linkName, String linkURL, User feedCreator, String activity, Id oldUserToMention, String PartnerAccountName){
    
        ConnectApi.FeedType feedType = ConnectApi.FeedType.UserProfile;

        ConnectApi.MessageBodyInput messageInput = new ConnectApi.MessageBodyInput();
        messageInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
        
        String whosFeed = 'me';
        
        System.debug(LoggingLevel.INFO, '== postFeedItem activity =='+activity);
        
        if(!String.isBlank(activity) && activity == 'OpportunityAssignment') {
            messageInput.messageSegments.add(getTextSegment('SunPower has assigned new opportunity '));
            messageInput.messageSegments.add(getTextSegment(linkName));
            messageInput.messageSegments.add(getTextSegment(' to '));
            messageInput.messageSegments.add(getMentionSegment(userToMention));
            messageInput.messageSegments.add(getTextSegment(' '));
            messageInput.messageSegments.add(getMentionSegment(groupToMention.Id));
           
        } else if(!String.isBlank(activity) && activity == 'ChangeOwner') {
            
            //User oldUsr = [SELECT Name FROM User WHERE Id =: oldUserToMention];
            messageInput.messageSegments.add(getTextSegment('Opportunity '));
            messageInput.messageSegments.add(getTextSegment(linkName));
            messageInput.messageSegments.add(getTextSegment(' has been '));
            //messageInput.messageSegments.add(getHashSegment('REASSIGNED'));
            messageInput.messageSegments.add(getTextSegment(' RE-ASSIGNED to you for '));
            //messageInput.messageSegments.add(getMentionSegment(userToMention));
            //messageInput.messageSegments.add(getTextSegment(' '));
            messageInput.messageSegments.add(getMentionSegment(groupToMention.Id));
            whosFeed = userToMention;
            
        } else if(!String.isBlank(activity) && activity == 'DeclineOpportunity') {
        
            messageInput.messageSegments.add(getTextSegment('Opportunity '));
            messageInput.messageSegments.add(getTextSegment(linkName));
            messageInput.messageSegments.add(getTextSegment(' has been '));
            //messageInput.messageSegments.add(getHashSegment('DECLINED'));            
            messageInput.messageSegments.add(getTextSegment(' DECLINED by '));
            messageInput.messageSegments.add(getMentionSegment(userToMention));
            messageInput.messageSegments.add(getTextSegment(' '));
            messageInput.messageSegments.add(getMentionSegment(groupToMention.Id));
            messageInput.messageSegments.add(getTextSegment('. Opportunity will no longer be accessible by ' + groupToMention.Name + ' users.'));
            //whosFeed = groupToMention.Id;
        }
        
        
        ConnectApi.FeedItemInput input = new ConnectApi.FeedItemInput();
        input.body = messageInput;

        //Attach Link
        if(!String.isBlank(activity) && (activity == 'OpportunityAssignment' || activity == 'ChangeOwner')) {
            input.attachment = getLinkAttachment(linkName, linkURL);
        }
        
        System.debug(LoggingLevel.INFO, '== community.Id =='+community.Id);
        System.debug(LoggingLevel.INFO, '== feedType =='+feedType);
        System.debug(LoggingLevel.INFO, '== input =='+input);        
        
        try {
            if(!Test.isRunningTest()) ConnectApi.FeedItem feedItemRep = ConnectApi.ChatterFeeds.postFeedItem(community.Id, feedType, whosFeed, input, null);
            
            System.debug(LoggingLevel.INFO, '== feedItemRep inserted ==');
            
            //Create/insert notification record
            Dealer_Notification__c dealerNotification = new Dealer_Notification__c(
                RelatedObjectId__c = objectId , Type__c = 'Chatter', Activity__c = activity);        
            insert dealerNotification;
            System.Debug(LoggingLevel.INFO, '== In postFeedItem dealerNotification captured ==');
           
        }catch (Exception ex) {
            system.debug('== Error =='+ex.getMessage());
        }         
    }
    
    /*public static void createSMSMessage(Opportunity opp, String activity)
    {
    
        List<smagicinteract__smsmagic__c> smsObjectList = new List<smagicinteract__smsmagic__c>();
        String senderId;//SenderId assing to user by default it is'smsMagic'
        String MobilePhone = ''; // Mobile number to whom user want to send sms
        String templateText = 'test SMS by Screen Magic'; // you can fetch the template text by querying the record on smagicinteract__SMS_Template__c object
        smagicinteract__smsMagic__c smsObject = new smagicinteract__smsMagic__c();
        smsObject.smagicinteract__SenderId__c = opp.OwnerId;
        smsObject.smagicinteract__PhoneNumber__c = '6099477155'; //get the phone number from the opp/dealer record
        smsObject.smagicinteract__Name__c = 'kishore'; // records name get the record name from the opportunity
        smsObject.smagicinteract__ObjectType__c = 'Opportunity'; // record type - get the proper record type
        smsObject.smagicinteract__disableSMSOnTrigger__c = 0; // this field either be 0 or 1, if you specify the value as 1 then sms will not get send but entry of sms will get create under SMS History object
        smsObject.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
        smsObject.smagicinteract__SMSText__c = templateText;
        smsObjectList.add(smsObject);
       
        String responseText = smagicinteract.ApexAPI.pushSMSCallout(smsObjectList);
        insert smsObjectList;
        
    }*/
}