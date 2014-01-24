function addCode(code) {
	var source   = $("#output-template").html();
	var template = Handlebars.compile(source);
	var data = { 
		code: code
	};

	var $newcode = $(template(data)).appendTo("body");	
	$(document).ready(function() {
	  $newcode.each(function(i, e) {
		  console.log("e = " + e);
		  hljs.highlightBlock(e);
	  });
	});
}

