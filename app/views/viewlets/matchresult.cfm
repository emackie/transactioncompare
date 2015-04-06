<cfoutput>
	<div class="row">
		<div class="panel panel-default">
			<div class="panel-heading">
				<h3 class="panel-title">Comparison Results</h3>
			</div>
			<div class="panel-body">
				#renderView(view="viewlets/matches", args = prc.response.objFile1)#
				#renderView(view="viewlets/matches", args = prc.response.objFile2)#
				<div class="text-center">
					<button class="btn btn-default" id="view-unmatched" type="button">
						View Unmatched Transactions
					</button>
				</div>
			</div>
		</div>
	</div>
</cfoutput>


