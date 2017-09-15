public class ProdConfigurationError {

    private static Map <Integer, Error> errorMap = new Map <Integer, Error>{
        800 => new Error(800, 'userId must be specified.'),
        801 => new Error(801, 'state must be specified.'),
        802 => new Error(802, 'sector must be specified.'),
        803 => new Error(803, 'channel must be specified.'),
        804 => new Error(804, 'partnerAccountId must be specified.'),
        805 => new Error(805, 'Module Configuration Id must be specified.'),
        806 => new Error(806, 'Master configuration Ids must be specified.'),
        807 => new Error(807, 'Module count must be specified.'),
        808 => new Error(808, 'Mount Type must be specified.')
    
    };
    
    public static Error getError(Integer statusCode) {
        Error e = new Error();
        if (errorMap.containsKey(statusCode)) {
            e = errorMap.get(statusCode);
        }
        return e;
    }

    public class Error {
        public Integer statusCode;
        public String message;
        Error() {}
        Error(Integer statusCode, String message) {
            this.statusCode = statusCode;
            this.message = message;
        }    
    }

}