@isTest
private class TestNotesRedirect
{
	@isTest
	static void testNoteView()
	{
		Account testPartner = TestClassFactory.CreateDealer('TestDealer', 'North America');
		Note myNote = new Note();
		myNote.ParentId = testPartner.Id;
		myNote.Title = 'Title';
		insert myNote;

		ApexPages.StandardController sc = new ApexPages.StandardController(myNote);

		NoteView redirect = new NoteView(sc);
		PageReference pr = redirect.deleteNote();
		System.assert(pr != null);
	}

	@isTest
	static void testNewNote()
	{
		Account testPartner = TestClassFactory.CreateDealer('TestDealer', 'North America');
		
		PageReference pageRef = new PageReference('/apex/NoteNew?parentId=' + testPartner.Id);
        Test.setCurrentPage(pageRef);

        NoteNew nn = new NoteNew();
        nn.title = 'Title';
        nn.body = 'Body';
        nn.isPrivate = true;

        nn.submit();

        PageReference pr = nn.cancel();
        System.assert(pr!=null);
	}

	@isTest
	static void testNewNoteWithErrors()
	{
		Account testPartner = TestClassFactory.CreateDealer('TestDealer', 'North America');
		
		PageReference pageRef = new PageReference('/apex/NoteNew?parentId=' + testPartner.Id);
        Test.setCurrentPage(pageRef);

        NoteNew nn = new NoteNew();
        nn.body = 'Body';
        nn.isPrivate = true;

        nn.submit();
	}

	@isTest
	static void testExistingNote()
	{
		Account testPartner = TestClassFactory.CreateDealer('TestDealer', 'North America');
		Note myNote = new Note();
		myNote.ParentId = testPartner.Id;
		myNote.Title = 'Title';
		insert myNote;

		PageReference pageRef = new PageReference('/apex/NoteNew?parentId=' + testPartner.Id+'&existingNoteId='+myNote.Id);
        Test.setCurrentPage(pageRef);

        NoteNew nn = new NoteNew();
        nn.title = 'Title';
        nn.body = 'Body';
        nn.isPrivate = true;

        nn.submit();
	}

	@isTest
	static void testExistingNoteWithErrors()
	{
		Account testPartner = TestClassFactory.CreateDealer('TestDealer', 'North America');
		Note myNote = new Note();
		myNote.ParentId = testPartner.Id;
		myNote.Title = 'Title';
		insert myNote;

		PageReference pageRef = new PageReference('/apex/NoteNew?parentId=' + testPartner.Id+'&existingNoteId='+myNote.Id);
        Test.setCurrentPage(pageRef);

        NoteNew nn = new NoteNew();
        nn.title = null;
        nn.body = 'Body';
        nn.isPrivate = true;

        nn.submit();
	}
}