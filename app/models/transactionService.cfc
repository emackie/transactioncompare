component singleton {

	public function init(){
		return this;
	}

	public function reconcile(required file objFile1, required file objFile2){

		//Find the best matches in each transaction set
		var objFileProcessed1 = resolveTransactions(arguments.objFile1, arguments.objFile2);
		var objFileProcessed2 = resolveTransactions(arguments.objFile2, arguments.objFile1);

		return buildUnmatchedTable(objFileProcessed1, objFileProcessed2);
	}

	private function resolveTransactions(required file objFile1, required file objFile2){

		for (var transaction in arguments.objFile1.getUnmatched()) {

			//For each transaction get an array of the best matches, and assign them to the transaction
			var matchedTransactions = resolveTransaction(local.transaction, arguments.objFile2);

			transaction.appendMatches(matchedTransactions);
		}

		return arguments.objFile1;
	}

	private function resolveTransaction(required transaction objTransaction, required file objFile2){

		var arrScores = [];
		var objHighestMatch = new transaction(); //dummy transaction to start loop

		//Append the dummy transaction into the array
		arrayAppend(arrScores, objHighestMatch);

		for (var match in arguments.objFile2.getUnmatched()) {

			//Score the transactions on how many fields match
			var compareScore = getScore(arguments.objTransaction, local.match);

			//Not interested in transactions that match on less than 4/8 fields
			if (compareScore gte 4) {
				//Check the score is higher than for the existing highest match in the array
				if (compareScore gt local.arrScores[1].getComparisonScore()){
					//assign the compare score to the match.
					local.match.setComparisonScore(compareScore);

					//clear the best matches out of the array, and replace with the new best match
					arrayClear(local.arrScores);
					arrayAppend(local.arrScores, local.match);
				}
				else if (local.match.getComparisonScore eq local.arrScores[1].getComparisonScore()){

					//If the score equals the best, append the transaction to the current array, so the user will see both
					arrayAppend(local.arrScores, local.match);
				}
			}
			
		}

		return local.arrScores;
	}

	private function getScore(required transaction objTransaction1, required transaction objTransaction2) {

		//Compares two transactions, scoring them on fields which match
		var score = 0;

		if(arguments.objTransaction1.getProfileName() eq arguments.objTransaction2.getProfileName()){
			local.score += 1;
		}
		if(arguments.objTransaction1.getTransactionDate() eq arguments.objTransaction2.getTransactionDate()){
			local.score += 1;
		}
		if(arguments.objTransaction1.getTransactionAmount() eq arguments.objTransaction2.getTransactionAmount()){
			local.score += 1;
		}
		if(arguments.objTransaction1.getTransactionNarrative() eq arguments.objTransaction2.getTransactionNarrative()){
			local.score += 1;
		}
		if(arguments.objTransaction1.getTransactionDescription() eq arguments.objTransaction2.getTransactionDescription()){
			local.score += 1;
		};
		if(arguments.objTransaction1.getTransactionID() eq arguments.objTransaction2.getTransactionID()){
			local.score += 1;
		}
		if(arguments.objTransaction1.getTransactionType() eq arguments.objTransaction2.getTransactionType()){
			local.score += 1;
		}
		if(arguments.objTransaction1.getWalletReference() eq arguments.objTransaction2.getWalletReference()){
			local.score += 1;
		}

		return local.score;
	}

	public function buildUnmatchedTable(required file objFile1, required file objFile2){

		var arrUnmatched1 = [];
		var arrUnmatched2 = [];

		//Array from first set
		for(transaction in arguments.objFile1.getUnmatched()){

			//for each match in the set, build a row for the array
			for (match in transaction.getBestMatch()){
				arrayAppend(local.arrUnmatched1, buildUnmatchedRow(transaction, match));
			}
		}

		//Array from second set
		for (transaction in arguments.objFile2.getUnmatched()){

			//for each match in the set, build a row for the array
			for (match in transaction.getBestMatch()){
				arrayAppend(local.arrUnmatched2, buildUnmatchedRow(match, transaction));
			}
		}

		//Remove duplication of rows from the two sets
		arrUnmatched2 = stripDuplicates(arrUnmatched1, arrUnmatched2);

		//Merge the two arrays to create the response
		arrayAppend(arrUnmatched1, arrUnmatched2, true);

		return arrUnmatched1;
	}

	private function stripDuplicates(required array arrTransactionToCompare, required array arrTransactionToClean){

		//Deletes the first match in the second set for each transaction - so any duplicate transactions are still shown in the second set
		for (var transaction in arrTransactionToCompare){
			arrayDelete(arrTransactionToClean, transaction);
		}

		return arrTransactionToClean;
	}

	private function buildUnmatchedRow(required transaction transaction1, required transaction transaction2){

		var stuUnmatched = {
			date1 = arguments.transaction1.getTransactionDate(),
			reference1 = arguments.transaction1.getWalletReference(),
			amount1 = arguments.transaction1.getTransactionAmount(),
			date2 = arguments.transaction2.getTransactionDate(),
			reference2 = arguments.transaction2.getWalletReference(),
			amount2 = arguments.transaction2.getTransactionAmount()
		};

		return stuUnmatched;
	}
}