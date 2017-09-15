@IsTest (SeeAllData=true)
public with sharing class TestDealerResult {

    static testMethod void testGeneral() {
        
        DealerResult dr1 = new DealerResult('1','Test','NoType',40.0,40.0,100.0,50.0,'888-888-8888','888-888-8888','125 Corona','Denver','CO','USA','80218','www.sunpowercorp.com','123','none','none',false,null, false, false);
        dr1.isCampaignPartner =true;
        dr1.isAllianceCampaignPartner= false;
        dr1.isWarmTransferPartner =true;
        dr1.bIsExclusiveCampaign =true;
        DealerResult dr2 = new DealerResult('2','Test','NoType',40.0,40.0,99.0,49.0,'888-888-8888','888-888-8888','125 Corona','Denver','CO','USA','80218','www.sunpowercorp.com','123','none','none',false,null, false, false);
        dr2.isCampaignPartner =false;
        dr2.isAllianceCampaignPartner= true;
        dr2.isWarmTransferPartner =false;
        dr2.bIsExclusiveCampaign=false;
        //dr.SORT_FIELD = DealerResult.SortField.Score;
        //dr.sort();
        //dr.SORT_FIELD = DealerResult.SortField.Distance;
        //dr.sort();
        //dr.SORT_FIELD = DealerResult.SortField.Type;
        //dr.sort();
    }        

}