component accessors="true" {

	property name="profileName" type="string" default="";
	property name="transactionDate" type="string" default="";
	property name="transactionAmount" type="string" default="";
	property name="TransactionNarrative" type="string" default="";
	property name="TransactionDescription" type="string" default="";
	property name="TransactionID" type="string" default="";
	property name="TransactionType" type="string" default="";
	property name="WalletReference" type="string" default="";
	property name="comparisonScore" type="numeric" default=0 hint="holds score for comparison with other objects";
	property name="bestMatch" type="string" default="" hint="holds best-scored matches for this transaction";

	function init(
		required string profileName = "",
		required string transactionDate = "",
		required string transactionAmount = "",
		required string TransactionNarrative = "",
		required string TransactionDescription = "",
		required string TransactionID = "",
		required string TransactionType = "",
		required string WalletReference = "",
		required numeric comparisonScore = 0,
		required string bestMatch = ""
	){
		variables.profileName = arguments.profileName;
		variables.transactionDate = arguments.transactionDate;
		variables.transactionAmount = arguments.transactionAmount;
		variables.transactionNarrative = arguments.transactionNarrative;
		variables.transactionDescription = arguments.transactionDescription;
		variables.transactionID = arguments.transactionID;
		variables.transactionType = arguments.transactionType;
		variables.WalletReference = arguments.WalletReference;
		variables.comparisonScore = arguments.comparisonScore;
		variables.bestMatch = arrayNew(1);

		return this;
	}

	public function appendMatches(required array objTransaction){
		arrayAppend(variables.bestMatch, arguments.objTransaction, true);
	}
}