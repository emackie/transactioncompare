component {

	//Dependency injection
	property name="fileService" inject="fileService";

	public function init(){

		return this;
	}

	public function match(required string file1, required string file2){

		objFile1 = fileService.upload(file1);
		
		return fileService.upload();
	}
}