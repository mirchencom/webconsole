function addCode(code, source) {

	var template = Handlebars.compile(source);
	var data = { 
		code: code
	};

	var $newcode = $(template(data)).appendTo("body");	
	// $(document).ready(function() {
	//   $newcode.each(function(i, e) {
	// 	  hljs.highlightBlock(e);
	//   });
	// });
}

function addInput(code) {
	var source = $("#input-template").html();
	addCode(code, source);
}

function addOutput(code) {
	var source = $("#output-template").html();
	addCode(code, source);
}

