/********************************************************************************************
Name   : AttachmentNotesManagement
Author : Jitendra Kothari
Date   : July 08, 2011
Usage  : Class for triggers on Attachment and Note Object to disallowing insert/update/delete on approved design.
Case   : 00068744
********************************************************************************************/
public class AttachmentNotesManagement {
	private static String designKeyPrefix = Design__c.SObjectType.getDescribe().getKeyPrefix();
	private static Set<Id> designIds = new Set<Id>();
	private static Map<Id, Design__c> designMap;
	public static void checkDesignAttach(List<Attachment> attachList){
		if(checkUser()) return;//for case# 00070140
		for(Attachment attach : attachList){
			String designId = attach.ParentId;
			if(designId.Contains(designKeyPrefix)){
				designIds.add(attach.ParentId);
			}
		}
		if(designIds.isEmpty()) return; 
		getDesigns();
		for(Attachment attach : attachList){
			if(designMap.containsKey(attach.ParentId)){
				attach.addError('Can\'t insert/update/delete Attachments for approved Design.');
			}
		}
	}
	
	public static void checkDesignNote(List<Note> noteList){
		if(checkUser()) return;//for case# 00070140
		for(Note note : noteList){
			String designId = note.ParentId;
			if(designId.Contains(designKeyPrefix)){
				designIds.add(note.ParentId);
			}
		}
		if(designIds.isEmpty()) return; 
		getDesigns();
		for(Note note : noteList){
			if(designMap.containsKey(note.ParentId)){
				note.addError('Can\'t insert/update/delete Notes for approved Design.');
			}
		}
	}
	public static void getDesigns(){
		designMap =  new Map<Id, Design__c>([Select Id, Status__c from Design__c where Status__c = 'Completed' and Id in :designIds]);
	}
	//Start for case# 00070140
	public static Boolean checkUser(){
		for(User u : [Select Profile.Name from User where Id =: Userinfo.getUserId() limit 1]){
			if(u.Profile.Name == 'System Administrator' || u.Profile.Name == 'Design Management')
				return true;
		}
		return false;
	}
	//End for case# 00070140
}