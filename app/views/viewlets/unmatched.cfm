<cfoutput>
	<div class="row" id="unmatched-transactions">
		<div class="panel panel-default">
			<div class="panel-heading">
				<h3 class="panel-title">Unmatched Report</h3>
			</div>
			<div class="panel-body">
				<table class="table">
					<thead>
						<tr>
							<th colspan="3">
								#prc.response.objFile1.getOriginalFilename()#
							</th>
							<th colspan="3">
								#prc.response.objFile2.getOriginalFilename()#
							</th>
						</tr>
						<tr>
							<th>Date</th>
							<th>Reference</th>
							<th>Amount</th>
							<th>Date</th>
							<th>Reference</th>
							<th>Amount</th>
					</thead>
					<tbody>
						#renderView(view="viewlets/transaction", collection=prc.response.unmatched)#
					</tbody>
				</table>
			</div>
		</div>
	</div>
</cfoutput>