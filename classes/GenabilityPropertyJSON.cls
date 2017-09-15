/**
 * Created by cdevarapalli on 3/9/17.
 * JSON for Genability Properties
 */

public class GenabilityPropertyJSON {

    public Map<String,Property> properties;

    public GenabilityPropertyJSON(Map<String,Property> mpropertyMap){
        properties = mpropertyMap;
    }
    
    public class Property {
        public String keyName;
        public String dataType;
        public Date fromDateTime;
        public Date toDateTime;
        public String dataValue;
        public Decimal accuracy;

        public Property(String skeyName,
                Date dfromDateTime,
                Date dtoDateTime,
                String sdataValue,
                Decimal daccuracy){
            keyName = skeyName;
            fromDateTime = dfromDateTime;
            toDateTime = dtoDateTime;
            dataValue = sdataValue;
            accuracy = daccuracy;
        }
    }

}