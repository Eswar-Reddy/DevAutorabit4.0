/**
 * Created by cdevarapalli on 3/8/17.
 */

public class GenabilityErrorJSON {

    public String error {get; set;}
    public Integer count {get; set;}
    public List<Error> results {get; set;}

    public class Error{
        public String code {get; set;}
        public String message {get; set;}
        public String objectName {get; set;}
        public String propertyName {get; set;}
        public String propertyValue {get; set;}
    }
}