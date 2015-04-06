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

		//Checks filenames have been passed in - must be done before file upload
		//Errors are rethrown to the catch in the handler
		try {
			if (len(arguments.filename1) eq 0){
				throw(message="Error", detail = "File 1 was not provided");
			}

			if (len(arguments.filename2) eq 0){
				throw(message="Error", detail = "File 2 was not provided");
			}
		}
		catch (any e) {
			rethrow;
		}
	}

	public function validate(required file objFile1, required file objFile2){

		//validation on the file and file types
		//Errors are rethrown to the catch in the handler
		try {

			if (fileGetMimeType(arguments.objFile1.getDirectory() & "/" & arguments.objFile1.getFileName()) neq "text/csv") {
				throw(message="Error", detail="File 1 is not a CSV file");
			}
			if (fileGetMimeType(arguments.objFile2.getDirectory() & "/" & arguments.objFile2.getFileName()) neq "text/csv") {
				throw(message="Error", detail="File 2 is not a CSV file");
			}
		}
		catch(any e){
			rethrow;
		}
	}

	public function delete(required file objFile){

		//Deletes the physical file
		fileDelete(arguments.objFile.getDirectory() & "/" & arguments.objFile.getFileName());
	}

	private function validateColumns(required string strColumns1, required string strColumns2){

		//Check the file is a transaction file by checking the header line is as expected
		//If fails, throw error to the error handler
		var strExpectedColumns = "ProfileName,TransactionDate,TransactionAmount,TransactionNarrative,TransactionDescription,TransactionID,TransactionType,WalletReference";

		try {
			if(local.strExpectedColumns neq arguments.strColumns1){
				throw(message="Error", detail="File 1 not a valid transaction file");
			}
			if(local.strExpectedColumns neq arguments.strColumns2){
				throw(message="Error", detail="File 2 not a valid transaction file");
			}
		}
		catch(any e){
			rethrow;
		}
	}

	public function match(required file objFile1, required file objFile2){

		//container for returning objects with update results
		var results = {
			objFile1 = arguments.objFile1,
			objFile2 = arguments.objFile2
		};

		var arrTransactions1 = arguments.objFile1.fileToArray();
		var arrTransactions2 = arguments.objFile2.fileToArray();

		//Validate transaction files are correctly formatted
		validateColumns(local.arrTransactions1[1], local.arrTransactions2[1]);

		//delete header row
		arrayDeleteAt(local.arrTransactions1, 1);
		arrayDeleteAt(local.arrTransactions2, 1);

		//Match up the transactions
		var matchResults = processArray(local.arrTransactions1, local.arrTransactions2);

		results.objFile1.setTransactions(arrayLen(local.arrTransactions1));
		results.objFile1.setMatches(arrayLen(local.arrTransactions1) - arrayLen(local.matchResults.arrUnmatchedInFirst));
		results.objFile1.appendUnmatched(local.matchResults.arrUnmatchedInFirst);

		results.objFile2.setTransactions(arrayLen(local.arrTransactions2));
		results.objFile2.setMatches(arrayLen(local.arrTransactions2) - arrayLen(local.matchResults.arrUnmatchedInSecond));
		results.objFile2.appendUnmatched(local.matchResults.arrUnmatchedInSecond);
		
		return results;
	}

	private function processArray(required array transactions1, required array transactions2){

		//create arrays for unmatched transactions in struct for returning results.
		var stuUnmatched = {
			arrUnmatchedInFirst = [],
			arrUnmatchedInSecond = []
		};

		//For each record in the first set of transactions, loop through the second set, deleting the first perfect match found. If no perfect match is found, create a transaction instance and add it to the unmatched array
		for (transaction1 in arguments.transactions1){

			if(not arrayDelete(arguments.transactions2, transaction1)) {
				
				objTransaction = transactionToObject(transaction1);

				arrayAppend(stuUnmatched.arrUnmatchedInFirst, objTransaction);
			}
		}

		//Unmatched records from the second set will be what is left in the second array after perfect matches are deleted
		for (transaction2 in arguments.transactions2){

			objTransaction = transactionToObject(transaction2);

			arrayAppend(stuUnmatched.arrUnmatchedInSecond, objTransaction);
		}

		return local.stuUnmatched;
	}

	private function transactionToObject(required string transaction){

		var objTransaction = new transaction(profileName = listGetAt(arguments.transaction,1), transactionDate = listGetAt(arguments.transaction,2), transactionAmount = listGetAt(arguments.transaction,3), transactionNarrative = listGetAt(arguments.transaction,4), transactionDescription = listGetAt(arguments.transaction,5), transactionID = listGetAt(arguments.transaction,6), transactionType = listGetAt(arguments.transaction,7), walletReference = listGetAt(arguments.transaction,8));

		return local.objTransaction;
	}
}