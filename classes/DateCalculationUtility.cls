/******************************/
//Name: DateCalculationUtility
//Author: Anuradha Suthar
//Date: 7 Dec, 2010
//Description: Utility class for date calculations
/******************************/
public class DateCalculationUtility {	
	public static Date getWorkingDay(Date d1, integer numberWorkDays){
		Date d2 = d1.addDays(numberWorkDays);				 
		if(numberWorkDays>0){
			Date weekStartDated1 = d1.toStartOfWeek();
			integer noDaysFromWeekStartDated1 = weekStartDated1.daysBetween(d1);	
			
			while(!check_WeekDay(noDaysFromWeekStartDated1)){
				d1 = d1.addDays(1);
				weekStartDated1 = d1.toStartOfWeek();
				noDaysFromWeekStartDated1 = weekStartDated1.daysBetween(d1);
			}
		
			integer a1 = numberWorkDays / 5;
			integer numberDaysAdd = 2 * a1;
			a1 = math.mod(numberWorkDays, 5);
			d2 = d1.addDays(a1);
			Date weekStartDated2 = d2.toStartOfWeek();
			if(weekStartDated2 != weekStartDated1 && check_WeekDay(noDaysFromWeekStartDated1)){
				numberDaysAdd = numberDaysAdd + 2;
			}							
			d2 = d1.addDays(numberWorkDays + numberDaysAdd);		
			weekStartDated2 = d2.toStartOfWeek();
			Integer noDaysFromWeekStartDated2 = weekStartDated2.daysBetween(d2);
			while(!check_WeekDay(noDaysFromWeekStartDated2)){
				d2 = d2.addDays(1);
				weekStartDated2 = d2.toStartOfWeek();
				noDaysFromWeekStartDated2 = weekStartDated2.daysBetween(d2);
			}					
		}
		return d2;
	}
	public static Boolean check_WeekDay(Integer value){
		if(Userinfo.getLocale() == 'en_GB'){
			if(value == 5 || value == 6){
				return false;
			}
		}else{
			if(value == 0 || value == 6){
				return false;
			}
		}
		return true;
	}
	//Start for case# 00066693
	public static DateTime getWorkingDay(DateTime d1, integer numberWorkDays){
		DateTime d2 = d1.addDays(numberWorkDays);				 
		if(numberWorkDays>0){
			Date weekStartDated1 = d1.Date().toStartOfWeek();
			integer noDaysFromWeekStartDated1 = weekStartDated1.daysBetween(d1.Date());	
			
			while(!check_WeekDay(noDaysFromWeekStartDated1)){
				d1 = d1.addDays(1);
				weekStartDated1 = d1.Date().toStartOfWeek();
				noDaysFromWeekStartDated1 = weekStartDated1.daysBetween(d1.Date());
			}
		
			integer a1 = numberWorkDays / 5;
			integer numberDaysAdd = 2 * a1;
			a1 = math.mod(numberWorkDays, 5);
			d2 = d1.addDays(a1);
			Date weekStartDated2 = d2.Date().toStartOfWeek();
			if(weekStartDated2 != weekStartDated1 && check_WeekDay(noDaysFromWeekStartDated1)){
				numberDaysAdd = numberDaysAdd + 2;
			}							
			d2 = d1.addDays(numberWorkDays + numberDaysAdd);		
			weekStartDated2 = d2.Date().toStartOfWeek();
			Integer noDaysFromWeekStartDated2 = weekStartDated2.daysBetween(d2.Date());
			while(!check_WeekDay(noDaysFromWeekStartDated2)){
				d2 = d2.addDays(1);
				weekStartDated2 = d2.Date().toStartOfWeek();
				noDaysFromWeekStartDated2 = weekStartDated2.daysBetween(d2.Date());
			}					
		}		
		return d2;
	}	
	//End for case# 00066693
}