/* **************************************************************************************
* Class Name     : Dealer_fee_calculation_Utility
* Version        : 1.0
* Created Date   : 12 Aug 2015
* Function       : It's a class to calculate different Dealer's Fee

* Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------
* Ankit                        12 Aug 2015          Original Version
*************************************************************************************/
public class Dealerfee_cal_Utility_ModelBased {

  public static List<Opportunity> lstOpp;
  public static List<Quote> lstQuote;
  public static Map<Id,Installation_Model__c> mInstallationModel ;
  public static Map<Id,Account> mAccounts ;
  public static Map<string,Id> mPartnerRoleWithAccId;
  public static Fee_Distribution__c fdTPS;

/*
@Name        : fIdentifiedRoleAndRelatedPartners
@description : It's function to identify OpportunityTeamMember Partner and thier Role. It call the fucntion to calcualte the Fee and return the Quote.
@parameters  :  List <Quote> lQuote
@returns     :  List <Quote> lQuote.
*/
public static Set<Quote> fIdentifiedRoleAndRelatedPartners (Map <Id,Quote> mQuote){
        System.debug('----->Inside fIdentifiedRoleAndRelatedPartners');
        set<Id> sRelatedUserId  = new set<Id>();   //  Set to store the UserId of all OpportunityTeamMember
        set<Id> sRelatedModelId = new set<Id> ();
        set<Id> sRelatedPartnerId = new set<Id>();  // set to store the related partner Id for a OpportunityTeamMember
        set<Id> sOppId = new set<Id> (); // set to store all the Opportunities Id related to a quote.
        set<Id> sAccId = new set<Id>();
        lstQuote = mQuote.values();  // assign the list of Quote to Static variable for later use
        mPartnerRoleWithAccId = new Map<string,Id> ();
        set<Quote> sQuoteToUpdate = new set<Quote> ();

        for (Quote Q : lstQuote){    //  Looping through the Quote and populte the set of Opportuniyt.
             sRelatedModelId.add(Q.Installation_Model__c);
          }

        mInstallationModel = new Map<Id,Installation_Model__c>([select id,name,Financing_Option__c,Partner__c,Roles__c,Type__c from Installation_Model__c where Id IN : sRelatedModelId ]);
        system.debug('installation' + mInstallationModel);

        if(mInstallationModel.isEmpty())
             return null ;

        for(Quote Q : lstQuote){
           if(mInstallationModel.get(Q.Installation_Model__c).Type__c <> 'Auto')
               sOppId.add(Q.OpportunityId);
           }

       if(sOppId.isEmpty())
            return null;

        // Querying the data frmo Oppteammember, Opp and Related Quotes.
        lstOpp = [select Id,name,Partner_Account_Id__c,Partner_Account_Id__r.NH_SSE_Type__c,Account.BillingState,
                                    (select Id,OpportunityId, TeamMemberRole,User.ContactId,User.Contact.AccountId from OpportunityTeamMembers where User.ContactId <> Null),
                                    (select Id,Name,opportunityId,Maximum_Rated_Capacity__c,Installation_Model__c,QuoteType__c,System_Cost__c,System_Model__c,
                                      Maximum_Rated_Capacity_Watts__c,Is_Locked__c,Is_Quote_Locked__c from Quotes where Id IN : mQuote.keySet())
                                     from Opportunity where Id =: sOppId ];

          for(Opportunity opp : lstOpp){
              for(OpportunityTeamMember oOTM : opp.OpportunityTeamMembers){
                sAccId.add(oOTM.User.Contact.AccountId);
              }
          }

         mAccounts = new map<Id,Account> ([select id,name,billingState,(select Commision__c,
                                                     Deal_Type__c, Name, Fixed_Fee__c,  Partner_Name__c,
                                                     Partner_Role__c, Id,Split_Percentage__c,MaxFit_Reduction__c,Module_Configuration__r.Name,State__c,Selling_Price_Max__c, Selling_Price_Min__c FROM Fees_Distribution__r where Deal_Type__c=:lstQuote[0].QuoteType__c) from Account where Id IN : sAccId]);

        system.debug('---mAccounts---' + mAccounts);

        for(Opportunity opp : lstOpp){

                    for(Quote Q : opp.Quotes){
                            Quote otriggerQuote = mQuote.get(Q.Id);
                            for(OpportunityTeamMember oOTM : opp.OpportunityTeamMembers){
                                    boolean bIsError = true;
                                    mPartnerRoleWithAccId.put(oOTM.TeamMemberRole=='Opportunity Owner'?'TPS':oOTM.TeamMemberRole,oOTM.User.Contact.AccountId);
                                 if(mAccounts.get(oOTM.user.contact.accountId).Fees_Distribution__r == Null || mAccounts.get(oOTM.user.contact.accountId).Fees_Distribution__r.size() == 0)
                                     otriggerQuote.addError('Fee distribution are not setup for ' + mAccounts.get(oOTM.user.contact.accountId).Name);
                                 for(Fee_Distribution__c oFD : mAccounts.get(oOTM.user.contact.accountId).Fees_Distribution__r){
                                        system.debug('==TeamMemberRole===' + oOTM.TeamMemberRole +'==oFD.Partner_Role__c===' + oFD.Partner_Role__c  );
                                        system.debug('---state account---' + opp.account.BillingState + '----state FD----' + oFD.state__c );
                                        system.debug('---QUOTE Model------' + otriggerQuote.System_Model__c +'-----FD Model-----'+oFD.Module_Configuration__r.Name);
                                    if( ((oFD.Partner_Role__c == oOTM.TeamMemberRole &&  mInstallationModel.get(otriggerQuote.Installation_Model__c).Roles__c.contains(oOTM.TeamMemberRole))|| (oOTM.TeamMemberRole == 'Opportunity Owner' && oFD.Partner_Role__c == Label.TPS_Partner_Role)) && otriggerQuote.System_Model__c == oFD.Module_Configuration__r.Name && opp.account.BillingState == oFD.state__c) {
                                              sQuoteToUpdate.add(fcalculateFees((Quote)Trigger.newMap.get(otriggerQuote.Id),oFD,oOTM.TeamMemberRole));
                                              system.debug('==Inside===' + oOTM.TeamMemberRole);
                                              bIsError = false;
                                        }
                                 }
                            if(bIsError)
                              fDetectErrors(otriggerQuote,opp);
                          }
                      }
                   }
             system.debug('---TPS Debug----'+ mQuote);
             return sQuoteToUpdate;
       }

/*
@Name        :  fCalculateFees
@description :  It's function to calculate the fee based on Partner role in the related opp.
@parameters  :  Quote Q,Fee_Distribution__c oFD,String sPartnerRole
@returns     :  Quote
*/

  static Quote fCalculateFees(Quote Q,Fee_Distribution__c oFD,String sPartnerRole){
            if(oFD.Partner_Role__c=='TPS')
                fdTPS=oFD;
             system.debug('--------' + Q.Maximum_Rated_Capacity_Watts__c + '------' + oFD.Split_Percentage__c);
            if(Q.Maximum_Rated_Capacity_Watts__c <> Null && oFD.Split_Percentage__c <> Null ){

              decimal iPricePerWatt = (Q.System_Cost__c - Q.Adder_Fee__c)/ Q.Maximum_Rated_Capacity_Watts__c;
                system.debug('----------' + iPricePerWatt);
                if(iPricePerWatt >= oFD.Selling_Price_Min__c){
                    system.debug('----------' + oFD.Fixed_Fee__c+'----------' +Q.Maximum_Rated_Capacity_Watts__c+'----------' +oFD.Commision__c+'----------' +iPricePerWatt+'----------' +oFD.Selling_Price_Min__c+'----------' +oFD.Split_Percentage__c+'----------' +oFD.MaxFit_Reduction__c);
                     double dfees = (oFD.Fixed_Fee__c + (Q.Maximum_Rated_Capacity_Watts__c * ((oFD.Commision__c +((iPricePerWatt - oFD.Selling_Price_Min__c) * oFD.Split_Percentage__c)/100) - oFD.MaxFit_Reduction__c))) ;
                    Q.put(Quote_Fees_Fields_API__c.getInstance(sPartnerRole=='Opportunity Owner'?'TPS':sPartnerRole).Field_API_Name__c,dfees) ;
                  system.debug('-----dfee-----' + dfees + '----sPatnerRole----'+ sPartnerRole);
                }
            }

      return Q;
    }

    /*
    @Name        :  fCalculateFees
    @description :  It's function to calculate the fee based on Partner role in the related opp.
    @parameters  :  Quote Q,Fee_Distribution__c oFD,String sPartnerRole
    @returns     :  Quote
    */

    static void fDetectErrors (Quote oQuote, Opportunity oOpp){

          string sfinalError = ''; boolean bisError = true;
          Map<string,OpportunityTeamMember> mOppTeamMem = new Map<string,OpportunityTeamMember> ();

          for(OpportunityTeamMember oOppTeamMember : oOpp.OpportunityTeamMembers){
                 if(!mOppTeamMem.containsKey(oOppTeamMember.TeamMemberRole))
                     mOppTeamMem.put(oOppTeamMember.TeamMemberRole,oOppTeamMember);
            }

          for(OpportunityTeamMember oOTM : mOppTeamMem.values()){
                   boolean bModuleFound = true; boolean bStatefound = true;  boolean bPartnerRole = true;
                   string sError;
                   for(Fee_Distribution__c oFD : mAccounts.get(oOTM.user.contact.accountId).Fees_Distribution__r){
                          if(oFD.Module_Configuration__r.Name == oQuote.System_Model__c)
                                bModuleFound = false;
                          if(oFD.state__c == oOpp.account.billingState)
                                bStatefound = false;
                          if(oFD.Partner_Role__c == oOTM.TeamMemberRole || oFD.Partner_Role__c == 'TPS')
                                bPartnerRole = false;
                      }
                  if(bModuleFound){
                      bisError = true;
                      sfinalError = sfinalError + oQuote.System_Model__c +' Module not defined in FD for for Account: ' + mAccounts.get(oOTM.user.contact.accountId).Name + ';';
                     }
                  if(bStatefound){
                      bisError = true;
                      sfinalError = sfinalError + oOpp.account.billingState +' State not defined in FD for Account: ' + mAccounts.get(oOTM.user.contact.accountId).Name + ';';
                   }
                  if(bPartnerRole){
                      bisError = true;
                      sfinalError = sfinalError + oOTM.TeamMemberRole +' Role not defined in FD for Account: ' + mAccounts.get(oOTM.user.contact.accountId).Name + ';';
                   }
          }
        if(bIsError){
            if(sfinalError <> null && sfinalError <> '')
              oQuote.addError(sfinalError);
            else
              oQuote.addError('Fee distribution is not defined for related module,state,and Partner role.');
         }
      }

   /*
     @Name        :  fMinSellingPriceCheck
     @description : function to check the minimum price for the Quote
     @parameters  :  Quote
     @returns     :  boolean
   */
   public static boolean fMinSellingPriceCheck ( Quote Q){
            system.debug('----Quote-Ankit------' + Q);
              if(Q.adder_fee__c == Null )
                  Q.adder_fee__c = 0;
              double QuoteSellingPrice =  (Q.System_Cost__c - Q.adder_fee__c)/(double.valueof(Q.Module_Oracle_Item_Number__r.Item_Category_3__c) * Q.Module_Count__c);
            // double sFDMinSellingPrice = [select Selling_Price_Min__c from Fee_Distribution__c where Partner_Name__c =: Q.Opportunity.Partner_Account_Id__c AND Deal_Type__c =:Q.QuoteType__c AND Rank__c = '1'].Selling_Price_Min__c;
              List<Fee_Distribution__c> lstFD = [select Selling_Price_Min__c from Fee_Distribution__c where Partner_Name__c =: Q.Opportunity.Partner_Account_Id__c AND Deal_Type__c =:Q.QuoteType__c AND State__c =: Q.Opportunity.Account.BillingState AND Module_Configuration__r.Name =: Q.System_Model__c Limit 1];
             // system.debug('---QuoteSellingPrice----'+ QuoteSellingPrice + '-------sFDMinSellingPrice------' + sFDMinSellingPrice);
              system.debug('----lstFD------' + lstFD);
             if (lstFD <> Null && lstFD.size() > 0) {
                   if (QuoteSellingPrice < lstFD[0].Selling_Price_Min__c )
                          return true;
                      else
                         return false;
               }
               else {
                       ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Error,Label.TPS_Fee_Distribution_does_not_exist) );
                       return true;
                     }
         }
  }