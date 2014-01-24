function addCode(code) {
	var source   = $("#output-template").html();
	var template = Handlebars.compile(source);
	var data = { 
		code: code
	};
	$(template(data)).appendTo("body");
}