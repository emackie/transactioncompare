component {

	//Inject models
	property name="fileService" inject="fileService";
	//Inject messagebox
	property name="messagebox" inject="messagebox@cbmessagebox";

	function index(event, rc, prc){
		event.setView("compare/index");
	}

	function match(event, rc, prc){

		var arrErrors = [];

		//Check filenames have been supplied
		arrayAppend(arrErrors, fileService.validateFilenames(rc.filename1, rc.filename2), true);
		
		if(len(rc.filename1) eq 0 or len(rc.filename2) eq 0){
			arrayAppend(arrErrors, "File name not supplied");
		}
		else {
			//Upload files to server
			var objFile1 = fileService.upload("Form.filename1");
			var objFile2 = fileService.upload("Form.filename2");

			//validation of file types - append any errors to the error array
			arrayAppend(arrErrors, fileService.validate(objFile1, objFile2), true);

			//Remove the files when we're done with them
			fileService.delete(objFile1);
			fileService.delete(objFile2);
 		}

 		//If files validate correctly, and all is good, carry on. Else, return errors through MessageBox
 		if(arrayIsEmpty(arrErrors)){
 			messagebox.info("File Upload Successful");
 		}
 		else {
 			messagebox.error(messageArray=arrErrors);
 		}

		event.setView("compare/index");
	}
}