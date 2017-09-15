public with sharing class NoteView
{
	public final Note myNote{get;set;}
    public Id parentId{get;set;}

    public NoteView(ApexPages.StandardController stdController)
    {
        this.myNote = [select Id, Title, ParentId, Owner.Name, OwnerId, Body, IsPrivate, CreatedBy.Name, CreatedDate from Note where Id =: stdController.getId()];
        parentId = this.myNote.parentId;
    }

    public PageReference deleteNote()
    {
        delete this.myNote;

        PageReference p = new PageReference('/'+parentId);
        p.setRedirect(true);
        return p;
    }
}