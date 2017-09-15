public class OrgUtil {
    
    public static Boolean runningInASandbox() {
  		return [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
	}

}