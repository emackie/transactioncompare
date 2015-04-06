$(document).ready(function(){

	//Hide the unmatched transactions div by default
	$("#unmatched-transactions").hide();

	var unmatchedTotal = 0;

	//Total up the unmatched counts
	$(".unmatched-count").each(function(){
		unmatchedTotal = unmatchedTotal + parseInt($(this).text(), 10);
	});

	//If there are no unmatched records to display, disable the View Unmatched button
	if(unmatchedTotal === 0){
		$("#view-unmatched").attr("disabled", "disabled");
	}
});

//Bind click event on View Unmatched button, to show Unmatched Transactions div
$("#view-unmatched").click(function(){

	$("#unmatched-transactions").show();

});