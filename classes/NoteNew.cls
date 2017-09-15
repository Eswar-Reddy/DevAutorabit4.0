public with sharing class NoteNew
{
	public Id parentId{get;set;}
	public Id existingNoteId{get;set;}
	public Note existingNote{get;set;}
	public Boolean isPrivate{get;set;}
	public String title{get;set;}
	public String body{get;set;}
	public String errorMsg{get;set;}

	public NoteNew()
	{
		parentId = ApexPages.currentPage().getParameters().get('parentId');
		existingNoteId = ApexPages.currentPage().getParameters().get('existingNoteId');
		isPrivate = false;
		errorMsg = null;

		if(existingNoteId != null) // have note already
		{
			try
			{
				existingNote = [select Id, Title, ParentId, OwnerId, Body, IsPrivate from Note where Id =: existingNoteId];
				body = existingNote.Body;
				title = existingNote.Title;
				isPrivate = existingNote.IsPrivate;
			}
			catch(Exception e)
			{
				errorMsg = 'Existing Note record could not be found.';
			}
		}
	}

	public PageReference submit()
	{
		if(existingNoteId == null) // create new note
		{
			if(title!=null && title.length() > 0)
			{
				try
				{
					Note nt = new Note();
					nt.ParentId = parentId;
					nt.OwnerId = UserInfo.getUserId();
					nt.Body = body;
					nt.Title = title;
					nt.IsPrivate = isPrivate;
					insert nt;
				}
				catch(Exception e)
				{
					errorMsg = 'There was a problem creating the Note. Error: '+e.getMessage();
					return null;
				}

				PageReference p = new PageReference('/'+parentId);
	            p.setRedirect(true);

	            return p;
			}
			else
			{
				errorMsg = 'A Note Title is required.';
				return null;
			}
		}
		else //update existing note
		{
			if(title!=null && title.length() > 0)
			{
				try
				{
					existingNote.Body = body;
					existingNote.Title = title;
					existingNote.IsPrivate = isPrivate;

					update existingNote;

					PageReference p = new PageReference('/'+parentId);
		            p.setRedirect(true);

		            return p;
		        }
				catch(Exception e)
				{
					errorMsg = 'There was a problem updating the Note. Error: '+e.getMessage();
					return null;
				}
	        }
	        else
			{
				errorMsg = 'A Note Title is required.';
				return null;
			}
		}
	}

	public PageReference cancel()
	{
		PageReference p = new PageReference('/'+parentId);
        p.setRedirect(true);

        return p;
	}
}