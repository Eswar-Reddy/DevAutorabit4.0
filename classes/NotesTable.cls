public with sharing class NotesTable
{
	public Id objectParentId;
	public List<Note> notes{get;set;}

	public ID getObjectParentId()
    {
    	return objectParentId;
    }

    public void setObjectParentId(ID s)
    {
        objectParentId = s;
        getNotes();
    }

	public void getNotes()
	{
		System.debug('**** objectParentId: '+objectParentId);
		notes = [select Id, Title, LastModifiedDate, CreatedBy.Name from Note where ParentId =: objectParentId];

		if(notes == null)
			notes = new List<Note>();
	}
}