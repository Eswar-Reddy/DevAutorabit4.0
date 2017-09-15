/**
 * Created by cdevarapalli on 3/20/17.
 */

public class GenabilitykWhJSON {

    public String status {get; set;}
    public Integer count {get; set;}
    public String type {get; set;}
    public List<kWhResult> results {get; set;}

    public class kWhResult{
        public kWhSummary summary {get; set;}
    }

    public class kWhSummary{
        public Double kWh {get; set;}
    }

}