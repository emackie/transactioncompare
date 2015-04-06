component {

	//Inject models
	property name="fileService" inject="fileService";
	property name="transactionService" inject="transactionService";
	//Inject messagebox
	property name="messagebox" inject="messagebox@cbmessagebox";

	function index(event, rc, prc){

		prc.welcomeMessage = "Compare Transaction Files";
		prc.result = "";
		prc.unmatchedcontainer = "";
		
		event.setView(view="main/index");
	}

	function match(event, rc, prc){

		var arrErrors = [];

		prc.result = "";
		prc.unmatchedcontainer = "";

		try {

			prc.response = {};

			//Check filenames exist
			fileService.validateFilenames(rc.filename1, rc.filename2);
			//Upload files to server
			var objFile1 = fileService.upload("Form.filename1");
			var objFile2 = fileService.upload("Form.filename2");

			//validate the files and file formats
			fileService.validate(objFile1, objFile2);

			//Match transactions in files
			prc.response = fileService.match(objFile1, objFile2);

			//Create unmatched response
			prc.response.unmatched = transactionService.reconcile(prc.response.objFile1, prc.response.objFile2);

			//Render the match results into a container
			prc.result = renderView("viewlets/matchresult");

			//Render the unmatched transactions into a container
			prc.unmatchedcontainer = renderView("viewlets/unmatched");

			//Remove the files when we're done with them
			fileService.delete(objFile1);
			fileService.delete(objFile2);
 		}
 		//Error handling - populate messagebox with error
		catch (any e) {

			messagebox.error(e.message & " - " & e.detail);
		}

		event.setView(view="main/index");
	}

	/************************************** IMPLICIT ACTIONS *********************************************/

	function onAppInit(event,rc,prc){

	}

	function onRequestStart(event,rc,prc){

	}

	function onRequestEnd(event,rc,prc){

	}

	function onSessionStart(event,rc,prc){

	}

	function onSessionEnd(event,rc,prc){
		var sessionScope = event.getValue("sessionReference");
		var applicationScope = event.getValue("applicationReference");
	}

	function onException(event,rc,prc){
		//Grab Exception From private request collection, placed by ColdBox Exception Handling
		var exception = prc.exception;
		//Place exception handler below:

	}

	function onMissingTemplate(event,rc,prc){
		//Grab missingTemplate From request collection, placed by ColdBox
		var missingTemplate = event.getValue("missingTemplate");

	}
}