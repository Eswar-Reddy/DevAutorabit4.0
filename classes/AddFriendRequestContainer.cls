public class AddFriendRequestContainer {

        public String SiteID;
        public String token;
        public List<RequestWrapper> sObjects;

        public AddFriendRequestContainer(List<sObject> objects)
        {
            sObjects = new List<RequestWrapper>();

            for(sObject sObj : objects)
            {
                sObjects.add(new RequestWrapper(sObj));
            }
        }

        public String getJSONString()
        {
            return JSON.serialize(this);
        }

        public static AddFriendRequestContainer convertToContainer(String jsonString) {
            return (AddFriendRequestContainer)JSON.deserialize(jsonString, AddFriendRequestContainer.class);
        }

        public class RequestWrapper {
            public String SharerID;
            public String stat_id;
            public String email;
            public String first_name;
            public String last_name;
            public String salesforceId;
            public String FriendID;
            public String DealerID;

            public RequestWrapper(sObject obj)
            {
                FriendID = '';
                DealerID = '';

                if(obj instanceof Lead){
                    SharerID = (String)obj.get('Sharer_Id__c');
                    stat_id = (String)obj.get('stat_id__c');
                    email = (String)obj.get('Email');
                    first_name = (String)obj.get('FirstName');
                    last_name = (String)obj.get('LastName');
                    salesforceId = (String)obj.Id;

                }else if(obj instanceof Opportunity){
                    SharerID = (String)obj.get('Sharer_Id__c');
                    stat_id = (String)obj.get('stat_id__c');
                    email = (String)obj.get('Primary_Contact_Email__c');
                    first_name = (String)obj.get('Primary_Contact_First_Name__c');
                    last_name = (String)obj.get('Primary_Contact_Last_Name__c');
                    salesforceId = (String)obj.Id;
                }
            }
        }
    }