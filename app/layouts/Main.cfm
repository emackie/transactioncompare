<cfoutput>
#html.doctype()#
<html lang="en">
<head>
	<meta charset="utf-8">
	<meta name="description" content="Transaction Comparison Project">
    <meta name="author" content="Ewan Mackie">

    <!---Base URL --->
	<base href="#getSetting("HTMLBaseURL")#" />
	<!---css --->
	<link href="includes/css/bootstrap.min.css" rel="stylesheet">
	<!---js --->
    <script src="includes/js/jquery.js"></script>
	<script src="includes/js/bootstrap.min.js"></script>
</head>
<body data-spy="scroll">
	<!---Container And Views --->
	<div class="container">#renderView()#</div>

	<script src="includes/js/compare.js"></script>
</body>
</html>
</cfoutput>