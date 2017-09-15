/**
 trg_Lead_Convert
      Description:Its an after update trigger
      Created date:4/23/10
      Created By: Accenture
      Last Updated Date: 11/05/10
      Last Updated By:Accenture
      Modification History:  ******

                4/23/10 -Intial Design Framed for trigger-Creating initial version of code which has to be modified  in order to follow
                4/26/10 - Review comment given Review comment for this suggests to add proper documentation, Follow  proper naming Standrads, and clearly depicts each and every method with an user friendly documentation
                4/28/10 - Incorporating those review comments All the review comments have been incorporated as   suggested in the build review document.
                4/28/10 - Creating Apex clases and calling trigger from that Based on the review comments, we are  invoking the apex trigger form inside a trigger.
                6/12/2012- Amit Saha Birlasoft- Case 00132012- if the customer is related to USA/United States and Record type = 'Residential Lease', then in the converted contact need to check 2 fields- Primary and 'Include in Lease Doc ', Also need to update the PrimaryContact field on Converted Opportunity so that it shows the id of the contact which was made primary.This changes is only going to affect
                where country(Standard Field) = USA/United States.

  Updated on 25 Nov 2013 by Amit Saha Birlasoft
  We have removed the condition that Primary_contact__c on Opportunity shoudl only be assigned value WHEN Lease country is USA.
  Now it should be assigned value even for Europe

***/

public class LeadConversion
{
    public static void after_Lead_Update (List<Lead> leadLst){
      User userStatus = Util.currentUser;

      if(userStatus.Web_User__c != True)
       {
        Set<id> leadid = new Set<id>();
        Set<id> accAffid = new Set<id>();
        Set<id> accCompId = new Set<id>();
        Set<id> oppId = new Set<id>();
        Set<id> ContactId = new Set<id>();
        Set<Date> datId = new Set<Date>();
        Set<Date> dat1Id = new Set<Date>();
        Set<string> accAffMan = new Set<string>();
        Set<string> accAggStat = new Set<string>();
        Id IdContact ;

        List<Lead> leadList = new List<Lead>();
        List<Site_Information_Form__c> siteL = new List<Site_Information_Form__c>();
        List<Opportunity_Role__c> oppRList = new List<Opportunity_Role__c>();
        List<Opportunity_Role__c> oppRList1 = new List<Opportunity_Role__c>();
        List<Contact> ContList = new List<Contact>();
        for(Lead led: leadLst)
        {
            if(led.IsConverted == True)
            {
                leadid.add(led.Id);
                accAffid.add(led.Affiliate_Account__c);
                accCompId.add(led.Competitor_Account__c);
                oppId.add(led.ConvertedOpportunityId);
                datId.add(led.Affiliate_Lead_Registered_Date__c);
                dat1Id.add(led.Affiliate_Lead_Expired_Date__c);
                accAffMan.add(led.Affiliate_Account_Manager__c);
                accAggStat.add(led.Affiliate_Agreement_Status__c);
                //ContactId.add(led.ConvertedContactId);
            }
       }
        for(Lead led1: leadLst)
        {
            /* Commented by Amit Saha Birlasoft on 25 Nov
            if(led1.IsConverted == True && (led1.Country == 'United States' || led1.Country == 'USA'))
            */

            if(led1.IsConverted == True)
            {
                ContactId.add(led1.ConvertedContactId);
            }
       }
    //-----------------Case 00132012 Amit Saha 6/12/2012-START
          //To update the Primary__c and Include_in_Lease_Doc__c to true for the converted contact.
            List <Contact> ContactList =[Select id,Primary__c,Include_in_Lease_Doc__c  from Contact where Id IN: ContactId];
            Integer csize = ContactList.size();
            if(csize != null || csize != 0)
            {
                for(Contact s :ContactList)
                 {
                  s.Primary__c = True;
                  s.Include_in_Lease_Doc__c = True;
                  IdContact = s.id;
                  ContList.add(s);
                 }
                update ContList;
            }

            /*
            for(List<Contact> contacts : [SELECT Id FROM Contact WHERE Contact.Id IN : ContactId order by createddate limit 1])
            {
            for(Contact c : contacts)
              {
               IdContact = c.id;
              }
            }
            */

           Set<String> convertedOpp = new Set<String>();

           //id rtype = [select Name,id from RecordType where sObjectType='Lead' and IsActive=true and Name='Residential'].id;
           //We are not considering the RecordType.Also this change should not affect
           //other than USA/UNITED STATES

           for(Lead nextLead :leadLst)
            {
             //if (nextLead.IsConverted == True && (nextLead.Country__c == 'United States' || nextLead.Country__c == 'USA' || nextLead.RecordTypeId==rtype))

             /* Commented by Amit Saha Birlasoft on 25 Nov 2013
             if (nextLead.IsConverted == True && (nextLead.Country == 'United States' || nextLead.Country == 'USA' || nextLead.Theater__c == 'North America'))
             */

             if (nextLead.IsConverted == True)
              {
                convertedOpp.add(nextLead.ConvertedOpportunityId);
              }
            }
            List<Opportunity> opplstToUpdate = new  List<Opportunity>();
            opplstToUpdate =[select id,Primary_Contact__c from Opportunity where id in :convertedOpp ];

            for(Opportunity nextOpp:opplstToUpdate )
                 {
                  if(nextOpp.Primary_Contact__c == null)
                    nextOpp.Primary_Contact__c = IdContact;//Updating with Contact Id whcih has Primary field True
                 }
            if(opplstToUpdate.size()>0)
                 update opplstToUpdate ;

      //-----------------Case 00132012 END-----------------------
        if(leadid.size()>0){ // new code
            //11-may-2010 ,reduce queries- to get record types in once and get specific record type further
            Id record = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Opportunity_Role__c.SobjectType).get('Affiliate');
            Id record1 = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Opportunity_Role__c.SobjectType).get('Competitor');
            Id record2 = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Site_Information_Form__c.SobjectType).get('Standard_Site');

            //Case 00105750 Optimized Code to reduce query
            //leadList = [Select Id,Business_Unit__c,Status,Lead_Approval__c,ConvertedAccountId,ConvertedOpportunityId,IsConverted,Affiliate_Account__c,Competitor_Account__c,Affiliate_Account__r.Name,Affiliate_Account__r.Id,Competitor_Account__r.Name,Competitor_Account__r.Id,Affiliate_Lead_Registered_Date__c,Affiliate_Lead_Expired_Date__c,Affiliate_Account_Manager__c,Affiliate_Agreement_Status__c  From Lead where Id IN :leadid];

            //10may-10 if business unit= components , then update opportunity record type=components
            /*Set<String> convertedOpp = new Set<String>();
            for(Lead nextLead :leadList ){
              // Done for case # 00066557 consolidating business units IBD and Components into 'UPP Intl'.
              // if (nextLead.Business_Unit__c =='Components'){
              if (nextLead.Business_Unit__c =='UPP Intl'){
                 convertedOpp.add(nextLead.ConvertedOpportunityId);
              }
            }

             List<Opportunity> opplstToUpdate = new  List<Opportunity>();
             opplstToUpdate =[select id,recordTypeId from Opportunity where id in :convertedOpp];

             if(componentsOppRecType !=null){
                 for(Opportunity nextOpp:opplstToUpdate ){
                     nextOpp.recordTypeId =componentsOppRecType.Id;
                 }
                 if(opplstToUpdate.size()>0)
                     update opplstToUpdate ;
             }*/

            //site creation and Update

            List <Site_Information_Form__c> siteList =[Select id,Name,Lead__r.ConvertedAccountId,Lead__r.ConvertedOpportunityId  from Site_Information_Form__c where Lead__c IN: leadid];
            Integer nsize = siteList.size();
            if(nsize != null || nsize != 0){
                for(Site_Information_Form__c s :siteList){
                    s.Account__c = s.Lead__r.ConvertedAccountId;
                    s.Opportunity_del__c = s.Lead__r.ConvertedOpportunityId;
                    s.RecordTypeId = record2;
                    siteL.add(s);

                }
                 update siteL;
            }
           //oppRList1 =[select id from Opportunity_Role__c where RecordTypeId IN:recId and (Account__c IN :accAffid OR Account__c IN :accCompId) and Affiliate_Registration_Date__c IN :datId and Opp_Name__c IN :oppId and Affiliate_Expiration_Date__c IN:dat1Id and Affiliate_Account_Manager__c IN :accAffMan and Affiliate_Agreement_Status__c IN :accAggStat ];

            for(Lead l: leadLst){
                if(l.Affiliate_Account__c!= null && l.Competitor_Account__c == null){
                    Opportunity_Role__c oppRole = new Opportunity_Role__c();
                    oppRole.RecordTypeId = record;
                    oppRole.Opp_Name__c = l.ConvertedOpportunityId;
                    oppRole.Affiliate_Registration_Date__c = l.Affiliate_Lead_Registered_Date__c;
                    oppRole.Affiliate_Expiration_Date__c = l.Affiliate_Lead_Expired_Date__c;
                    oppRole.Affiliate_Account_Manager__c =l.Affiliate_Account_Manager__c;
                    oppRole.Affiliate_Agreement_Status__c =l.Affiliate_Agreement_Status__c;
                    oppRole.Account__c = l.Affiliate_Account__c;
                    oppRList.add(oppRole);
                }else if(l.Affiliate_Account__c == null && l.Competitor_Account__c    != null){
                    Opportunity_Role__c oppRole = new Opportunity_Role__c();
                    oppRole.RecordTypeId = record1;
                    oppRole.Opp_Name__c = l.ConvertedOpportunityId;
                    oppRole.Affiliate_Registration_Date__c = l.Affiliate_Lead_Registered_Date__c;
                    oppRole.Account__c = l.Competitor_Account__c;
                    oppRList.add(oppRole);
                }else if(l.Affiliate_Account__c != null && l.Competitor_Account__c != null){
                    Opportunity_Role__c oppRole = new Opportunity_Role__c();
                    oppRole.RecordTypeId = record;
                    oppRole.Opp_Name__c = l.ConvertedOpportunityId;
                    oppRole.Affiliate_Registration_Date__c = l.Affiliate_Lead_Registered_Date__c;
                    oppRole.Affiliate_Expiration_Date__c = l.Affiliate_Lead_Expired_Date__c;
                    oppRole.Affiliate_Account_Manager__c =l.Affiliate_Account_Manager__c;
                    oppRole.Affiliate_Agreement_Status__c =l.Affiliate_Agreement_Status__c;
                    oppRole.Account__c = l.Affiliate_Account__c;
                    oppRList.add(oppRole);

                    Opportunity_Role__c oppRole1 = new Opportunity_Role__c();
                    oppRole1.RecordTypeId = record1;
                    oppRole1.Opp_Name__c = l.ConvertedOpportunityId;
                    oppRole1.Affiliate_Registration_Date__c = l.Affiliate_Lead_Registered_Date__c;
                    oppRole1.Account__c = l.Competitor_Account__c;
                    oppRList.add(oppRole1);
                  }
            }
            if(oppRList.size()>0){
                Insert oppRList;
            }
        }

    }
  }
}