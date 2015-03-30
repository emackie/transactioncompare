component accessors="true" {

	property name="directory" type="string" default="" hint="directory the server stores the files on";
	property name="originalfilename" type="string" default="" hint="the filename given by the client";
	property name="filename" type="string" default="" hint="unique filename created by the server, if necessary";

	//init
	function init(
		required string directory = "",
		required string originalfilename = "",
		required string filename = ""
	){

		variables.directory = arguments.directory;
		variables.originalfilename = arguments.originalfilename;
		variables.filename = arguments.filename;

		return this;
	}

	public function getURL(){

		//Provides URL for processing file through cfhttp

		return CGI.HTTP_HOST & "transaction-compare/files" & variables.filename;
	}
}