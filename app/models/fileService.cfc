component singleton {

	public function init(){

		return this;
	}

	public function upload(required string filename){

		//destination to upload file
		var destination = expandPath("../files");

		//If this directory doesn't exist, create it
		checkDirectory(destination);

		uploadResult = fileUpload(destination, arguments.filename, "*", "makeunique");

		//Create an object to handle the file information
		objFile = new models.file(directory = destination, originalfilename = uploadResult.clientFile, filename = uploadResult.serverFile);

		return objFile;
	}

	private function checkDirectory(required string path){

		//Looks for specified path - if it's not there, it creates it
		if(not directoryExists(arguments.path)){
			directoryCreate(arguments.path);
		}
	}

	public function validateFilenames(required string filename1, required string filename2){

		var arrErrors = arrayNew(1);

		if (len(arguments.filename1) eq 0){
			arrayAppend(arrErrors, "File 1 was not provided.");
		}

		if (len(arguments.filename2) eq 0){
			arrayAppend(arrErrors, "File 2 was not provided.");
		}
		
		return arrErrors;
	}

	public function validate(required file objFile1, required file objFile2){

		//Validates file types as CSVs, files do not have the same name
		var arrErrors = arrayNew(1);

		if (arguments.objFile1.getOriginalFileName() eq arguments.objFile2.getOriginalFileName()){
			arrayAppend(arrErrors, "File 1 and File 2 cannot have the same name");
		}
		if (fileGetMimeType(arguments.objFile1.getDirectory() & "/" & arguments.objFile1.getFileName()) neq "text/csv") {
			arrayAppend(arrErrors, "File 1 is not a CSV file");
		}
		if (fileGetMimeType(arguments.objFile2.getDirectory() & "/" & arguments.objFile2.getFileName()) neq "text/csv") {
			arrayAppend(arrErrors, "File 2 is not a CSV file");
		}

		return arrErrors;
	}

	public function delete(required file objFile){

		fileDelete(arguments.objFile.getDirectory() & "/" & arguments.objFile.getFileName());
	}
}