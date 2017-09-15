/**************************************************
**Created By- dev2_accenture
**Created On- May 25 2010 
**Last Modified- 
**Last Modified On- June 06 2010  
**Desciption- Quote Formula Fields
*****************************************************/

public class QuoteFieldvalues{

//Call before update and insert of QuoteLineItem
public static void beforeInsertUpdate(List<QuoteLineItem> quoteLine){
    //Update Estimate info on QuoteLineItem to reflect the product added to Design on Estimate
    UpdateQuoteInfo(quoteLine);
}

public static void afterInsertUpdate(List<QuoteLineItem> quoteLine){
    
    
    Set<Id> qid=new Set<Id>();
    Set<String> qLineid=new Set<String>();//for Case#00080702
     
    Set<ID> setDesignID = new Set<ID>();
    for(QuoteLineItem qitem:quoteLine){
        //These fields are set same on workflow so to avoid two time  calling of methods put this if check
        if(qitem.Total_Cost__c!=qitem.Total_Cost_new__c){
            continue;
        }
        
        if(qitem != null){
        qid.add(qitem.Id);
        qLineid.add(qitem.QuoteId);
        }
        if(qitem.Design__c!=null){
            setDesignID.Add(qitem.Design__c);
        }       
    }
    if(qLineid.size()==0){
        return;
    }
    UpdateDesignInfo(setDesignID);
    System.debug(qLineid+'----qLineid--');  
    if(qLineid.size()>0){
        updateQuotes(qLineid);
    }
}


//Code moved to future method because if user wants to update the quote 
//Which hold more then 1000 quote line items then in trigger it will give exception 
//Of too many SOQL queries. for getting rid of this we moved the code in future method.

@Future 
public static void updateQuotes(Set<String> qLineid){//for Case#00080702
   List<Quote> qlist=new List<Quote>();    
   List<Quote> qlistfinal=new List<Quote>();
   
   qlist = [select Id,System_Size_PV__c,TotalPrice,System_Size_BOS__c,Total_Development_Cost__c,Total_BOS_Cost__c,Total_PV_Cost__c ,(Select Id,Quantity,TotalPrice,Cost__c,Product_Type__c,Product_Family__c,Total_Cost__c,kWp_Components__c,Quote.Pricebook2.Name from QuoteLineItems)  from Quote where Id in : qLineid];
   for(Quote q:qlist){    
        List<QuoteLineItem> qline = q.QuoteLineItems;   
        Double qone = 0;
        Double Totalcost = 0;
        Double TotalcostBOS = 0;
        Double TotalcostPV = 0;
        Double PVQuantity = 0;
        Double BOSQuantity = 0;
        Double Amount = 0;
        Double Mountingcost = 0;
        Double TotalMountcost = 0;
        
        for(QuoteLineItem qli:qline){
            if(qli.Cost__c == null){
            qli.Cost__c = 0;
            }
        
            if(qli.Product_Type__c == 'PV Module' && qli.Quote.Pricebook2.Name == 'Systems Price Book'){
                qone = qone+qli.Quantity;
              //TotalcostPV = TotalcostPV+qli.TotalPrice;
                TotalcostPV = TotalcostPV+qli.Total_Cost__c;
                PVQuantity = TotalcostPV/(qone*1000);
            }
            else if(qli.Product_Type__c == 'PV Module' && qli.Quote.Pricebook2.Name == 'Components Price Book'){
                if(qli.kWp_Components__c == null){
                qli.kWp_Components__c = 0;
                qone = qone+qli.kWp_Components__c;
                }
                if(qli.kWp_Components__c != null){
                qone = qone+qli.kWp_Components__c;
                }
              //TotalcostPV = TotalcostPV+qli.TotalPrice;
                TotalcostPV = TotalcostPV+qli.Total_Cost__c;
                if( qone == 0){
                PVQuantity  = 0;
                }
                if( qone != 0){
                PVQuantity = TotalcostPV/(qone*1000);
                }
            }
            else if(qli.Product_Type__c == 'Development'){
                //Totalcost = Totalcost+qli.TotalPrice;
                Totalcost = Totalcost+qli.Total_Cost__c;
            }
            else if(qli.Product_Type__c == 'BOS' || qli.Product_Type__c == 'Balance of System'){
                //TotalcostBOS = TotalcostBOS+qli.TotalPrice;
                TotalcostBOS = TotalcostBOS+qli.Total_Cost__c;
                
            }
            if(qli.Quote.Pricebook2.Name == 'Systems Price Book' &&(qli.Product_Family__c == 'Mounting Systems - Parking' || qli.Product_Family__c == 'Mounting Systems - Roof' || qli.Product_Family__c == 'Mounting Systems - Ground')){
                BOSQuantity = BOSQuantity+qli.Quantity;
                Mountingcost = Mountingcost+qli.Total_Cost__c;
                TotalMountcost = Mountingcost/(BOSQuantity*1000);
            }
            else if(qli.Quote.Pricebook2.Name == 'Components Price Book' && (qli.Product_Family__c == 'Mounting Systems - Parking' || qli.Product_Family__c == 'Mounting Systems - Roof' || qli.Product_Family__c == 'Mounting Systems - Ground')){
                if(qli.kWp_Components__c == null){
                qli.kWp_Components__c = 0;
                BOSQuantity = BOSQuantity+qli.kWp_Components__c;
                }
                if(qli.kWp_Components__c != null){
                BOSQuantity = BOSQuantity+qli.kWp_Components__c;
                }
                
                Mountingcost = Mountingcost+qli.Total_Cost__c;
                if(BOSQuantity == 0){
                TotalMountcost = 0;
                }
                if(BOSQuantity != 0){
                TotalMountcost = Mountingcost/(BOSQuantity*1000);
                }
            }

            if(qone > 0){
                //Amount = qone/(qli.TotalPrice*1000);
                  //Amount = (TotalcostPV+Totalcost+TotalcostBOS)/qone*1000;
                  Amount = (q.TotalPrice)/(qone*1000);
            }
            if(qone <= 0){
                    if(BOSQuantity == 0){
                        Amount = 0;
                    }
                    if(BOSQuantity != 0){
                        Amount = (q.TotalPrice)/(BOSQuantity*1000);
                    }
            }
            
        }
        q.System_Size_PV__c = qone;
        q.Total_Development_Cost__c = Totalcost;
        q.Total_BOS_Cost__c = TotalcostBOS;
        q.Total_PV_Cost__c = TotalcostPV;
        q.PV_w__c = PVQuantity;
        q.System_Size_BOS__c = BOSQuantity;
        //q.ASP1__c = Amount;
        q.BOS_w__c = TotalMountcost;
        qlistfinal.add(q);
    }
    
    if(qlistfinal.size() > 0){
        update qlistfinal;
    }
   
}
//Done corresponding to the case-00037275
//Requirement - Products from Design need to display(associated) on the Estimate
//Update Estimate info on QuoteLineItem to reflect the product added to Design on Estimate
public static void UpdateQuoteInfo(List<QuoteLineItem> quoteLine){
    //Prepare set of DesignID   
    Set<String> setDesign =new Set<String>();
    for(QuoteLineItem li : quoteLine){
        if(li.Design__c != null){
            setDesign.Add(li.Design__c);
        }
    }
    
    //Prepare the map of Design with Estimate 
    //with the check if Estimate is primary and Estimate has related Design and both(Estimate and Design) are related to the same PSR   
    Map<String,String> mapDesignEstimate = new Map<String,String>();
    for(Estimate__c estimate :[Select id,Design__c,PSR__c,Primary_PSR_Estimate__c,Design__r.PSR__c from Estimate__c where Design__c in :setDesign and Primary_PSR_Estimate__c=true]){
        if(estimate.PSR__c!=null && estimate.Design__c!=null && estimate.PSR__c==estimate.Design__r.PSR__c){
            mapDesignEstimate.put(estimate.Design__c,estimate.ID);
        }
    }
    
    //Set Estimate info on QuoteLineItem
    for(QuoteLineItem li : quoteLine){
        if(mapDesignEstimate.get(li.Design__c)!=null && li.Estimate__c!=mapDesignEstimate.get(li.Design__c)){
            li.Estimate__c = mapDesignEstimate.get(li.Design__c);
        }
    }   
}

//Update related design to populate correct roll up data
public static void UpdateDesignInfo(Set<ID> setDesignID){
    List<Design__c> lstDesign = new List<Design__c>([select Id,(select Id,System_Size_PV__c,System_Size_BOS__c from Quote_Line_Items__r) from Design__c where Id in : setDesignID]);
    List<Design__c> lstDesignToUpdate = new List<Design__c>();
    
    for(Design__c d:lstDesign){
        Design__c dNew = new Design__c(ID=d.ID);
        List<QuoteLineItem> lstQline = d.Quote_Line_Items__r;
        Double TotalSystemSizePV = 0;
        Double TotalSystemSizeBOS = 0;
        for(QuoteLineItem Qline:lstQline){
            TotalSystemSizePV = TotalSystemSizePV + Qline.System_Size_PV__c;
            TotalSystemSizeBOS = TotalSystemSizeBOS + Qline.System_Size_BOS__c;
        }
        Boolean isUpdate = false;
        if(dNew.actual_System_Size_PV__c != TotalSystemSizePV || dNew.actual_System_Size_BOS__c != TotalSystemSizeBOS){
            isUpdate = true;
        }
        dNew.actual_System_Size_PV__c = TotalSystemSizePV;
        dNew.actual_System_Size_BOS__c = TotalSystemSizeBOS;
        if(isUpdate)
            lstDesignToUpdate.Add(dNew);
    }
     
    if(lstDesignToUpdate.size()>0){
        update lstDesignToUpdate;
    }
}
}