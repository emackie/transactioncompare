<cfoutput>
	<h2>Compare Transactions</h2>
	<div class="row">
		<div class="col-sm-6">
			<div class="panel panel-default">
				<div class="panel-heading">
					<h3 class="panel-title">Specify files to compare</h3>
				</div>
				<div class="panel-body">
					#getInstance("messagebox@cbmessagebox").renderIt()#
					<form enctype="multipart/form-data" method="post" action="#event.buildLink('compare.match')#">
						<div class="form-group">
							<label for="file-1">Select File 1:</label>
							<input type="file" id="file-1" name="filename1">
						</div>
						<div class="form-group">
							<label for="file-2">Select File 2:</label>
							<input type="file"id="file-2" name="filename2">
						</div>
						<button type="submit" class="btn btn-primary">Compare</button>
					</form>
				</div>
			</div>
		</div>
	</div>
	<cfif structKeyExists(prc,"response")>
		<!--- Compare response container --->
		<div class="row">
			<div class="panel panel-default">
				<div class="panel-heading">
					<h3 class="panel-title">Results</h3>
				</div>
				<div class="panel-body">
					<cfdump var="#prc.response#">
					<div class="col-sm-6">
						<div class="panel panel-default">
							<div class="panel-body">
								<h3>#prc.response.objFile1.getOriginalFilename()#</h3>
							</div>
						</div>
					</div>
					<div class="col-sm-6">
						<div class="panel panel-default">
							<div class="panel-body">
								<h3>#prc.response.objFile1.getOriginalFilename()#</h3>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</cfif>
</cfoutput>