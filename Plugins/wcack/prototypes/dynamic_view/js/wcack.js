function addFile(file_path) {
	var source   = $("#some-template").html();
	var template = Handlebars.compile(source);
	var data = { 
		file_path: file_path
	};
	$(template(data)).appendTo("body");
}