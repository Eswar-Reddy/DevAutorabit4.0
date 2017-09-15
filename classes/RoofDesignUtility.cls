//Utility Class for Roof Design
public class RoofDesignUtility {
    
    //Wrapper Class for RoofDesign
    public class RoofDesignWrapper{
        public Roof_Design__c roofDesign{get;set;}
        public EnergyProductionYr1__c energyProdYr1{get;set;}
        public String moduleCount{get;set;}
        public String inverters{get;set;}
        
        public RoofDesignWrapper(Roof_Design__c rDesign,EnergyProductionYr1__c enerProd,String modCount,String inv){
            roofDesign = rDesign;
            energyProdYr1 =enerProd;
            moduleCount = modCount;
            inverters = inv;
        }
    }
    
    //Wrapper Class for Roof Detail
    public class RoofDetailWrapper{
        public Roof_Details__c roofDetail{get;set;}
        public String inverter{get;set;}
        public String module{get;set;}
        public String moduleCount{get;set;}
        
        public RoofDetailWrapper(Roof_Details__c rDetail,String inv,String mod,String modCount){
            roofDetail = rDetail;
            inverter = inv;
            module = mod;
            moduleCount = modCount;
        }
    }
    
}