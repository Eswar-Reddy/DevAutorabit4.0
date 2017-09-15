//JSON Utility class for Aurora Design Integration
public class AuroraJSONUtil {
    
    public class ProjectRequest{
        public String AuroraKey;
        public String Timestamp;
        public String Signature;
        public Project project;
        //public String tenant_id;
    }
    
    public class Project{
        public String external_provider_id;
        public String name;
        public String customer_salutation;
        public String customer_first_name;
        public String customer_last_name;
        public String customer_address;
        public String address;
        
        
        public Project(String expvID,String nm,String cs,String cfn,String csn,String caddr,String addr){
            external_provider_id=expvID;
            name=nm;
            customer_salutation=cs;
            customer_first_name=cfn;
            customer_last_name=csn;
            customer_address=caddr;
            address=addr;
        }
    }
    
    public class DesignRequest{
        public String AuroraKey;
        public String Timestamp;
        public String Signature;
        public Design design;
    }
    
    public class Design{
        
        public String external_provider_id;
        public String project_id;
        public String name;
        
        public Design(String designId,String projId,String nm){
            external_provider_id = designId;
            project_id = projId;
            name = nm;
        }
    }
    
}