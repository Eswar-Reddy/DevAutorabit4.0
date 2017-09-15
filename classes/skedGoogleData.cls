global class skedGoogleData {
    
    public virtual class baseResult {
        public boolean hasError {get;set;}
		public string errorMessage {get;set;}
        public string status { get; set; }
        
        public baseResult() {
            this.hasError = false;
        }
    }
    
    /*GOOGLE DISTANCE MATRIX*/
    public class distanceMatrixResult extends baseResult {
        public List<Row> rows { get; set; }
        
        public distanceMatrixResult() {
            super();
        }
    }
    
    public class Distance {
        public integer value { get; set; }
    }
    
    public class Duration {
        public integer value { get; set; }
    }
    
    public class Element {
        public Distance distance { get; set; }
        public Duration duration { get; set; }
        public string status { get; set; }
    }
    
    public class Row {
        public List<Element> elements { get; set; }
    }
    
    /*GEOCODE*/    
    public class geocodeResult extends baseResult {
        public List<geocodeResultItem> results { get; set; }
        
        public geocodeResult() {
            super();
        }
    }
    
    public class geocodeResultItem {
        public Geometry geometry { get; set; }
    }
    
    public class Geometry {
        public GeoLocation location { get; set; }
    }
    
    public class GeoLocation {
        public double lat { get; set; }
        public double lng { get; set; }
    }

}