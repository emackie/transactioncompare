component accessors=true {

	property name="filename1";
	property name="filename2";

	//validation
	this.constraints = {
		filename1 = {
			required = true
		},
		filename2 = {
			required = true
		}
	};

	function init(){
		return this;
	}
}