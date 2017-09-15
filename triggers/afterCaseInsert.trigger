trigger afterCaseInsert on Case (after insert) {
    if(UserInfo.getUserId()=='00580000003XtZw' || UserInfo.getUserId()=='00580000003Xtm2' ||UserInfo.getUserId()=='00580000003XrG4')
	{
		return;
	}
    CaseManagement.afterCaseInsert(Trigger.New,Trigger.Old);
}