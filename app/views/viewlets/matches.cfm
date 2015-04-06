<cfoutput>
	<div class="col-sm-6">
		<div class="panel panel-default">
			<div class="panel-body">
				<h3>#args.getOriginalFilename()#</h3>
				<table>
					<tr>
						<td>Transactions in File:</td>
						<td class="text-right">#args.getTransactions()#</td>
					</tr>
					<tr>
						<td>Transactions Matched:</td>
						<td class="text-right">#args.getMatches()#</td>
					</tr>
					<tr>
						<td>Unmatched Transactions:</td>
						<td class="unmatched-count text-right">#args.getUnmatchedCount()#</td>
					</tr>
				</table>	
			</div>
		</div>
	</div>
</cfoutput>