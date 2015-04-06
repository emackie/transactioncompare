component accessors="true" {

	property name="directory" type="string" default="" hint="directory the server stores the files on";
	property name="originalfilename" type="string" default="" hint="the filename given by the client";
	property name="filename" type="string" default="" hint="unique filename created by the server, if necessary";
	property name="transactions" type="numeric" default=0 hint="number of transactions in file";
	property name="matches" type="numeric" default=0 hint="number of perfectly matched transactions in file";
	property name="unmatched" type="string" default="" hint="array of unmatched transaction objects";

	//init
	function init(
		required string directory = "",
		required string originalfilename = "",
		required string filename = "",
		required string transactions = 0,
		required string matches = 0,
		required string unmatched = ""
	){	
		variables.directory = arguments.directory;
		variables.originalfilename = arguments.originalfilename;
		variables.filename = arguments.filename;
		variables.transactions = 0;
		variables.matches = arguments.matches;
		variables.unmatched = arrayNew(1);
		return this;
	}

	public function getFullPath(){

		//Provides URL for processing file through cfhttp

		return variables.directory & "/" & variables.filename;
	}

	public function getUnmatchedCount(){

		//returns number of unmatched transactions

		return arrayLen(variables.unmatched);
	}

	public function appendTransaction(required string transaction){

		arrayAppend(variables.transactions, arguments.transaction);
	}

	public function appendUnmatched(required array objTransaction){

		//adds unmatched transaction objects to the array
		arrayAppend(variables.unmatched, objTransaction, true);
	}

	public function fileToArray(){

		var fileTransactions = fileOpen(getFullPath());
		var arrTransactions = buildTransactionArray(fileTransactions);

		fileClose(fileTransactions);

		return arrTransactions;
	}

	private function buildTransactionArray(required any fileTransactions){

		//Build an array of transactions from the file passed in
		var arrTransactions = [];

		//Read the file into the array line by line, sanitising empty list values, and stripping out duplicates
		while(not fileIsEOF(arguments.fileTransactions)){

			//replace empty list items with 0s
			var fileLine = Replace(fileReadLine(arguments.fileTransactions), ",,", ",0,", "all");
			
			//Add the file to the array
			arrayAppend(local.arrTransactions, local.fileLine);
			
		}

		return arrTransactions;
	}
}