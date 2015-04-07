component extends="coldbox.system.testing.BaseTestCase" appMapping="/root" {

	function beforeAll(){

		//my stuff goes here
		super.beforeAll();
	}

	function afterAll(){

		//my stuff goes here
		super.afterAll();
	}

	function run(){

		describe("Compare Handler", function(){

			beforeEach(function(currentSpec){

				setup();
			});

			it( "+main renders", function(){
				var event = execute( event="main.index", renderResults=true );
				expect(	event.getValue( name="welcomemessage", private=true ) ).toBe( "Compare Transaction Files" );
			});
		});

		describe("+Test Domain objects", function(){

			describe("+Test File object", function(){

				it("Initialises file object", function(){

					var objFile = new transactioncompare.app.models.file();

					expect(objFile).toBeTypeOf("component");

				});

				describe("Test variables", function(){

					beforeEach(function(){

						objFile = new transactioncompare.app.models.file();
					});	

					it("Directory default", function(){

						expect(objFile.getDirectory()).toBe("");
					});

					it("Originalfilename default", function(){

						expect(objFile.getOriginalFilename()).toBe("");
					});

					it("filename default", function(){

						expect(objFile.getFilename()).toBe("");
					});

					it("transactions default", function(){

						expect(objFile.getTransactions()).toBe(0);
					});

					it("matches default", function(){
						
						expect(objFile.getMatches()).toBe(0);
					});

					it("unmatched default", function(){

						expect(objFile.getUnmatched()).toBeTypeOf("array");
						expect(arrayLen(objFile.getUnmatched())).toBe(0);
					});
				});

				describe("test methods", function(){

					beforeEach(function(){

						objFile = new transactioncompare.app.models.file();
					});

					it("getFullPath should return concatenation of variables and file", function(){

						objFile.setDirectory("directory");
						objFile.setFilename("filename");

						expect(objFile.getFullPath()).toBe("directory/filename");
					});

					it("getUnmatchedCount returns length of array in unmatched", function(){

						expect(objFile.getUnmatchedCount()).toBe(0);
					});

					it("appendUnmatched - adds a transaction to the unmatched array", function(){

						arrTransaction = ["Test"];

						objFile.appendUnmatched(arrTransaction);

						expect(objFile.getUnmatchedCount()).toBe(1);
					});

					it("fileToArray - opens a file, turns it to an array", function(){

						//Use a test file to create our array
						objFile = new transactioncompare.app.models.file(
							directory = expandPath("../../sampleData"),
							Originalfilename = "ClientMarkoffFile20140113_singlematch.csv",
							filename = "ClientMarkoffFile20140113_singlematch.csv"
						);

						arrTransaction = objFile.fileToArray();

						//Array length should be 2 (header row + 1 transaction)
						expect(arrayLen(arrTransaction)).toBe(2);
					});
				});
			});

			describe("+Test transaction object", function(){

				it("Initialises transaction object", function(){

					objTransaction = new transactioncompare.app.models.transaction();

					expect(objTransaction).toBeTypeOf("component");
				});

				describe("Test variables", function(){

					beforeEach(function(){

						var objTransaction = new transactioncompare.app.models.transaction();
					});

					it("profileName default", function(){

						expect(objTransaction.getProfileName()).toBe("");
					});

					it("transactionDate default", function(){

						expect(objTransaction.getTransactionDate()).toBe("");
					});

					it("transactionAmount default", function(){

						expect(objTransaction.getTransactionAmount()).toBe("");
					});

					it("transactionNarrative default", function(){

						expect(objTransaction.getTransactionNarrative()).toBe("");
					});

					it("transactionDescription default", function(){

						expect(objTransaction.getTransactionDescription()).toBe("");
					});

					it("transactionID default", function(){

						expect(objTransaction.getTransactionID()).toBe("");
					});

					it("transactionType default", function(){

						expect(objTransaction.getTransactionType()).toBe("");
					});

					it("walletReference default", function(){

						expect(objTransaction.getWalletReference()).toBe("");
					});

					it("comparisonScore default", function(){

						expect(objTransaction.getComparisonScore()).toBe(0);
					});

					it("bestMatch default - empty array", function(){

						expect(arrayLen(objTransaction.getBestMatch())).toBe(0);
					});
				});

				describe("Test methods", function(){

					beforeEach(function(){

						objTransaction = new transactioncompare.app.models.transaction();
					});

					it("append matches - adds an item to the bestMatch array", function(){

						var arrTest = arrayNew(1);
						arrayAppend(arrTest, "test item");

						objTransaction.appendMatches(arrTest);

						expect(arrayLen(objTransaction.getBestMatch())).toBe(1);
					});
				});
			});
		});

		describe("Test Service objects", function(){
		
			describe("fileService", function(){

				it("fileServiceInit", function(){

					var objFileService = new transactioncompare.app.models.fileService();

					expect(objFileService).toBeTypeOf("component");
				});

				describe("validateFileNames method", function(){

					it("passing both filenames gives no error", function(){

						var testMessage = "True";

						try {

							objFileService = new transactioncompare.app.models.fileService();

							objFileService.validateFilenames("test.txt", "test2.txt");
						}
						catch (any e){
							testMessage = e.message;
						}
						expect(testMessage).toBe("True");
					});

					it("missing out first name throws the expected error", function(){

						var testMessage = "True";

						try {

							objFileService = new transactioncompare.app.models.fileService();

							objFileService.validateFilenames("", "test2.txt");
						}
						catch (any e){
							testMessage = e.detail;
						}
						expect(testMessage).toBe("File 1 was not provided");
					});

					it("missing out first name throws the expected error", function(){

						var testMessage = "True";

						try {

							objFileService = new transactioncompare.app.models.fileService();

							objFileService.validateFilenames("test.txt", "");
						}
						catch (any e){
							testMessage = e.detail;
						}
						expect(testMessage).toBe("File 2 was not provided");
					});
				});
				
				describe("validate method", function(){

					beforeEach(function(){
						objFileService = new transactioncompare.app.models.fileService();

						objFile1 = new transactioncompare.app.models.file(
							directory = expandPath("../../sampleData"),
							filename = "ClientMarkoffFile20140113_singlematch.csv"
						);
						objFile2 = new transactioncompare.app.models.file(
							directory = expandPath("../../sampleData"),
							filename = "ClientMarkoffFile20140113_singlenomatch.csv"
						);
					});

					it("both files are csv, no error thrown", function(){

						var testMessage = "True";

						try {
							objFileService.validate(objFile1, objFile2);
						}
						catch (any e){
							testMessage = e.message;
						}

						expect(testMessage).toBe("True");
					});

					it("1st file is not a CSV, expected error thrown", function(){

						var testMessage = "True";

						try {
							objFile1.setFilename("ClientMarkoffFile20140113_single.numbers");

							objFileService.validate(objFile1, objFile2);
						}
						catch (any e){
							testMessage = e.detail;
						}

						expect(testMessage).toBe("File 1 is not a CSV file");
					});

					it("1st file is not a CSV, expected error thrown", function(){

						var testMessage = "True";

						try {
							objFile1.setFilename("ClientMarkoffFile20140113_single.numbers");

							objFileService.validate(objFile1, objFile2);
						}
						catch (any e){
							testMessage = e.detail;
						}

						expect(testMessage).toBe("File 1 is not a CSV file");
					});

					it("2nd file is not a CSV, expected error thrown", function(){

						var testMessage = "True";

						try {
							objFile2.setFilename("ClientMarkoffFile20140113_single.numbers");

							objFileService.validate(objFile1, objFile2);
						}
						catch (any e){
							testMessage = e.detail;
						}

						expect(testMessage).toBe("File 2 is not a CSV file");
					});
				});

				describe("validateColumns method", function(){

					beforeEach(function(){
						objFileService = new transactioncompare.app.models.fileService();

						makePublic(objFileService, "validateColumns");
					});

					it("Both strings match the expected columns - no error given", function(){
						var testMessage = "True";

						var strColumns1 = "ProfileName,TransactionDate,TransactionAmount,TransactionNarrative,TransactionDescription,TransactionID,TransactionType,WalletReference";

						var strColumns2 = "ProfileName,TransactionDate,TransactionAmount,TransactionNarrative,TransactionDescription,TransactionID,TransactionType,WalletReference";

						try {
							objFileService.validateColumns(strColumns1, strColumns2);
						}
						catch(any e){
							testMessage = e.message;
						}

						expect(testMessage).toBe("True");
					});


					it("1st set had invalid columns - expected error thrown", function(){
						var testMessage = "True";

						var strColumns1 = "This a really wrong set of columns.";

						var strColumns2 = "ProfileName,TransactionDate,TransactionAmount,TransactionNarrative,TransactionDescription,TransactionID,TransactionType,WalletReference";

						try {
							objFileService.validateColumns(strColumns1, strColumns2);
						}
						catch(any e){
							testMessage = e.detail;
						}

						expect(testMessage).toBe("File 1 not a valid transaction file");
					});

					it("Both strings match the expected columns - no error given", function(){
						var testMessage = "True";

						var strColumns1 = "ProfileName,TransactionDate,TransactionAmount,TransactionNarrative,TransactionDescription,TransactionID,TransactionType,WalletReference";

						var strColumns2 = "This is a really wrong set of columns";

						try {
							objFileService.validateColumns(strColumns1, strColumns2);
						}
						catch(any e){
							testMessage = e.detail;
						}

						expect(testMessage).toBe("File 2 not a valid transaction file");
					});
				});

				describe("processArray method", function(){

					beforeEach(function(){

						objFileService = new transactioncompare.app.models.fileService();

						makePublic(objFileService, "processArray");
					});

					it("Two arrays that perfectly match - returns two empty arrays", function(){

						arrTest1 = ["A"];
						arrTest2 = ["A"];

						stuResult = objFileService.processArray(arrTest1, arrTest2);

						expect(arrayLen(stuResult.arrUnmatchedInFirst)).toBe(0);
						expect(arrayLen(stuResult.arrUnmatchedInSecond)).toBe(0);
					});

					it("1st array has one unmatched record", function(){

						arrTest1 = [
							"Card Campaign,2014-01-11 22:27:44,-20000,*MOLEPS ATM25             MOLEPOLOLE    BW,DEDUCT,0584011808649511,1,P_NzI2ODY2ODlfMTM4MjcwMTU2NS45MzA5,", 
							"Card Campaign,2014-01-11 22:39:11,-10000,*MOGODITSHANE2            MOGODITHSANE  BW,DEDUCT,0584011815513406,1,P_NzI1MjA1NjZfMTM3ODczODI3Mi4wNzY5,"
						];
						arrTest2 = ["Card Campaign,2014-01-11 22:27:44,-20000,*MOLEPS ATM25             MOLEPOLOLE    BW,DEDUCT,0584011808649511,1,P_NzI2ODY2ODlfMTM4MjcwMTU2NS45MzA5,"];

						stuResult = objFileService.processArray(arrTest1, arrTest2);

						expect(arrayLen(stuResult.arrUnmatchedInFirst)).toBe(1);
						expect(arrayLen(stuResult.arrUnmatchedInSecond)).toBe(0);
					});

					it("2nd array has one unmatched record", function(){

						arrTest1 = [
							"Card Campaign,2014-01-11 22:27:44,-20000,*MOLEPS ATM25             MOLEPOLOLE    BW,DEDUCT,0584011808649511,1,P_NzI2ODY2ODlfMTM4MjcwMTU2NS45MzA5,"
						];
						arrTest2 = [
							"Card Campaign,2014-01-11 22:27:44,-20000,*MOLEPS ATM25             MOLEPOLOLE    BW,DEDUCT,0584011808649511,1,P_NzI2ODY2ODlfMTM4MjcwMTU2NS45MzA5,", 
							"Card Campaign,2014-01-11 22:39:11,-10000,*MOGODITSHANE2            MOGODITHSANE  BW,DEDUCT,0584011815513406,1,P_NzI1MjA1NjZfMTM3ODczODI3Mi4wNzY5,"
						];

						stuResult = objFileService.processArray(arrTest1, arrTest2);

						expect(arrayLen(stuResult.arrUnmatchedInFirst)).toBe(0);
						expect(arrayLen(stuResult.arrUnmatchedInSecond)).toBe(1);
					});

					it("Both arrays have one unmatched record", function(){

						arrTest1 = [
							"Card Campaign,2014-01-11 22:27:44,-20000,*MOLEPS ATM25             MOLEPOLOLE    BW,DEDUCT,0584011808649511,1,P_NzI2ODY2ODlfMTM4MjcwMTU2NS45MzA5,"
						];
						arrTest2 = [
							"Card Campaign,2014-01-11 22:39:11,-10000,*MOGODITSHANE2            MOGODITHSANE  BW,DEDUCT,0584011815513406,1,P_NzI1MjA1NjZfMTM3ODczODI3Mi4wNzY5,"
						];

						stuResult = objFileService.processArray(arrTest1, arrTest2);

						expect(arrayLen(stuResult.arrUnmatchedInFirst)).toBe(1);
						expect(arrayLen(stuResult.arrUnmatchedInSecond)).toBe(1);
					});		
				});

				describe("match method", function(){

					beforeEach(function(){

						objFileService = new transactioncompare.app.models.fileService();

						objFile1 = new transactioncompare.app.models.file(
							directory = expandPath("../../sampleData"),
							filename = "ClientMarkoffFile20140113_singlematch.csv"
						);
						objFile2 = new transactioncompare.app.models.file(
							directory = expandPath("../../sampleData"),
							filename = "ClientMarkoffFile20140113_singlenomatch.csv"
						);
					});

					it("two files match perfectly", function(){

						var result = objFileService.match(objFile1, objFile1);

						//Expected results for first file object
						expect(result.objFile1.getTransactions()).toBe(1);
						expect(result.objFile1.getMatches()).toBe(1);
						expect(arrayLen(result.objFile1.getUnmatched())).toBe(0);

						//Expected results for second file object
						expect(result.objFile2.getTransactions()).toBe(1);
						expect(result.objFile2.getMatches()).toBe(1);
						expect(arrayLen(result.objFile2.getUnmatched())).toBe(0);
					});

					it("files don't match", function(){
						var result = objFileService.match(objFile1, objFile2);

						//Expected results for first file object
						expect(result.objFile1.getTransactions()).toBe(1);
						expect(result.objFile1.getMatches()).toBe(0);
						expect(arrayLen(result.objFile1.getUnmatched())).toBe(1);

						//Expected results for second file object
						expect(result.objFile2.getTransactions()).toBe(1);
						expect(result.objFile2.getMatches()).toBe(0);
						expect(arrayLen(result.objFile2.getUnmatched())).toBe(1);
					});
				});
			});

			describe("transactionService", function(){

				it("transactionServiceInit", function(){

					var objTransactionService = new transactioncompare.app.models.transactionService();

					expect(objTransactionService).toBeTypeOf("component");
				});

				describe("reconcile", function(){

					beforeEach(function(){

						objTransactionService = new transactioncompare.app.models.transactionService();

						objFile1 = new transactioncompare.app.models.file(
							directory = expandPath("../../sampleData"),
							filename = "ClientMarkoffFile20140113_singlematch.csv"
						);

						objFile2 = new transactioncompare.app.models.file(
							directory = expandPath("../../sampleData"),
							filename = "ClientMarkoffFile20140113_singlenomatch.csv"
						);

						objFileService = new transactioncompare.app.models.fileService();

						//get results to use in reconcile function
						result = objFileService.match(objFile1, objFile2);
					});

					it("call reconcile function - return an array to the user", function(){

						var arrResponse = objTransactionService.reconcile(result.objFile1, result.objFile2);

						expect(arrResponse).toBeTypeOf("array");
					});
				});

				describe("resolveTransaction - no close match", function(){

					beforeEach(function(){

						objTransactionService = new transactioncompare.app.models.transactionService();

						makePublic(objTransactionService, "resolveTransactions");

						objFile1 = new transactioncompare.app.models.file(
							directory = expandPath("../../sampleData"),
							filename = "ClientMarkoffFile20140113_singlematch.csv"
						);

						objFile2 = new transactioncompare.app.models.file(
							directory = expandPath("../../sampleData"),
							filename = "ClientMarkoffFile20140113_singlenomatch.csv"
						);

						objFileService = new transactioncompare.app.models.fileService();

						//get results to use in resolve functions
						matchResult = objFileService.match(objFile1, objFile2);
					});

					it("returns a file object", function(){

						var result = objTransactionService.resolveTransactions(matchResult.objFile1, matchResult.objFile2);

						expect(result).toBeTypeOf("component");
					});

					describe("resolveTransaction - single instance with no match", function(){

						beforeEach(function(){

							makePublic(objTransactionService, "resolveTransaction");
						});

						it("returns an array, and no close match", function(){

							var objTransaction = matchResult.objFile1.getUnmatched()[1];

							var resolveResult = objTransactionService.resolveTransaction(local.objTransaction, matchResult.objFile2);

							expect(resolveResult).toBeTypeOf("array");

							//The closest match should be the default with a score of 0
							expect(resolveResult[1].getComparisonScore()).toBe(0);
						});
					});
				});

				describe("resolveTransaction - close match", function(){

					beforeEach(function(){

						objTransactionService = new transactioncompare.app.models.transactionService();

						makePublic(objTransactionService, "resolveTransactions");

						objFile1 = new transactioncompare.app.models.file(
							directory = expandPath("../../sampleData"),
							filename = "ClientMarkoffFile20140113_singlematch.csv"
						);

						objFile2 = new transactioncompare.app.models.file(
							directory = expandPath("../../sampleData"),
							filename = "ClientMarkoffFile20140113_closematch.csv"
						);

						objFileService = new transactioncompare.app.models.fileService();

						//get results to use in resolve functions
						matchResult = objFileService.match(objFile1, objFile2);
					});

					it("returns a file object", function(){

						var result = objTransactionService.resolveTransactions(matchResult.objFile1, matchResult.objFile2);

						expect(result).toBeTypeOf("component");
					});

					describe("resolveTransaction - single instance with close match", function(){

						beforeEach(function(){

							makePublic(objTransactionService, "resolveTransaction");
						});

						it("returns an array, with a close match (score greater than 4)", function(){

							var objTransaction = matchResult.objFile1.getUnmatched()[1];

							var resolveResult = objTransactionService.resolveTransaction(local.objTransaction, matchResult.objFile2);

							expect(resolveResult).toBeTypeOf("array");

							//The closest match should have a score of 7
							expect(resolveResult[1].getComparisonScore()).toBe(7);
						});
					});
				});

				describe("getScore", function(){

					beforeEach(function(){
						objTransactionService = new transactioncompare.app.models.transactionService();

						makePublic(objTransactionService, "getScore");

						objTransaction1 = new transactioncompare.app.models.transaction(
							profilename = "A",
							transactionDate = "B",
							transactionAmount = "C",
							transactionNarrative = "D",
							transactionDescription = "E",
							transactionID = "F",
							transactionType = "G",
							walletReference = "H"
						);

						objTransaction2 = new transactioncompare.app.models.transaction(
							profilename = "I",
							transactionDate = "J",
							transactionAmount = "K",
							transactionNarrative = "L",
							transactionDescription = "M",
							transactionID = "N",
							transactionType = "O",
							walletReference = "P"
						);
					});

					it("all scoring matches are fired - max score 8", function(){

						var numScore = objTransactionService.getScore(objTransaction1, objTransaction1);

						expect(numScore).toBe(8);
					});

					it("no scoring matches are fired - score 0", function(){

						var numScore = objTransactionService.getScore(objTransaction1, objTransaction2);

						expect(numScore).toBe(0);
					});
				});

				describe("buildUnmatchedTable", function(){

					beforeEach(function(){

						objTransactionService = new transactioncompare.app.models.transactionService();

						makePublic(objTransactionService, "resolveTransactions");
						makePublic(objTransactionService, "buildUnmatchedTable");

						objFile1 = new transactioncompare.app.models.file(
							directory = expandPath("../../sampleData"),
							filename = "ClientMarkoffFile20140113_singlematch.csv"
						);

						objFile2 = new transactioncompare.app.models.file(
							directory = expandPath("../../sampleData"),
							filename = "ClientMarkoffFile20140113_singlenomatch.csv"
						);

						objFileService = new transactioncompare.app.models.fileService();

						//get results to use in resolve functions
						result = objFileService.match(objFile1, objFile2);

						//Now reconcile the results for use in test
						objReconciled1 = objTransactionService.resolveTransactions(result.objFile1, result.objFile2);
						objReconciled2 = objTransactionService.resolveTransactions(result.objFile2, result.objFile1);
					});

					it("returns an array", function(){

						var response = objTransactionService.buildUnmatchedTable(objReconciled1, objReconciled2);

						expect(local.response).toBeTypeOf("array");
					});

					it("returns an array of length 2", function(){

						var arrResponse = objTransactionService.buildUnmatchedTable(objReconciled1, objReconciled2);

						expect(arrayLen(local.arrResponse)).toBe(2);
					});

				});

				describe("stripDuplicates", function(){

					beforeEach(function(){
						objTransactionService = new transactioncompare.app.models.transactionService();

						makePublic(objTransactionService, "stripDuplicates");
					});

					it("matching arrays - empty array should be returned", function(){

						var arr1 = [1, 2];
						var arr2 = [1, 2];

						arrResponse = objTransactionService.stripDuplicates(arr1, arr2);

						expect(arrayLen(arrResponse)).toBe(0);
					});

					it("non-matching arrays - array with 2 records returned", function(){

						var arr1 = [1, 2];
						var arr2 = [3, 4];

						arrResponse = objTransactionService.stripDuplicates(arr1, arr2);

						expect(arrayLen(arrResponse)).toBe(2);
					});
				});

				describe("buildUnmatchedRow", function(){

					beforeEach(function(){
						objTransactionService = new transactioncompare.app.models.transactionService();

						makePublic(objTransactionService, "buildUnmatchedRow");

						objTransaction1 = new transactioncompare.app.models.transaction(
							profilename = "A",
							transactionDate = "B",
							transactionAmount = "C",
							transactionNarrative = "D",
							transactionDescription = "E",
							transactionID = "F",
							transactionType = "G",
							walletReference = "H");
						objTransaction2 = new transactioncompare.app.models.transaction(
							profilename = "I",
							transactionDate = "J",
							transactionAmount = "K",
							transactionNarrative = "L",
							transactionDescription = "M",
							transactionID = "N",
							transactionType = "O",
							walletReference = "P"
						);
					});

					it("check row is formed of correct values", function(){

						var stuRow = objTransactionService.buildUnmatchedRow(objTransaction1, objTransaction2);

						expect(stuRow.date1).toBe("B");
						expect(stuRow.reference1).toBe("H");
						expect(stuRow.amount1).toBe("C");

						expect(stuRow.date2).toBe("J");
						expect(stuRow.reference2).toBe("P");
						expect(stuRow.amount2).toBe("K");
					});
				});
			});
		});
	}
}