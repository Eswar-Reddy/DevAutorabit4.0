/**
	@author Shailendra Singh (Appirio Offshore)
**/
public with sharing class Paginator {
	private List<Object> objectList;
	private Integer pageSize;
	public Integer currentPage{get;set;}
	private Integer totalPages;
	
	public Integer totalRecords{get;set;}
	
	public Paginator(List<Object> objectList,Integer pageSize){
		this.objectList = objectList;
		totalRecords = this.objectList.size();
		this.pageSize = pageSize;
		this.currentPage = 1;
		totalPages = totalRecords/pageSize;
		Integer modVal = Math.mod(totalRecords,pageSize);
		if(modVal != 0)
			totalPages++;
	}
	
	public List<Object> getRecords(){
		List<Object> records = new List<Object>();
		for(Integer i = (currentPage-1)*pageSize; i < totalRecords && i < currentPage*pageSize; i++ ){
				records.add(objectList.get(i));		
		}
		return records;
	}
	
	public void next(){
		currentPage++;	
	}
	public void previous(){
		currentPage--;
	}
	public void first(){
		currentPage = 1 ;
	}
	public void last(){
		currentPage = totalPages;
	} 
	public Boolean getHasNext(){
		if(currentPage != totalPages && totalPages != 0 )
			return true;
		else
			return false;
	}
	
	public Boolean getHasPrevious(){
		if(currentPage != 1)
			return true;
		else
			return false;	
	}
}