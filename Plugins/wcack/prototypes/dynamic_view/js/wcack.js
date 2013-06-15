function addFile(file_path) {
	var source   = $("#file-template").html();
	var template = Handlebars.compile(source);
	var data = { 
		file_path: file_path
	};
	$(template(data)).appendTo("body");
}

function addLine(line_number, text) {
	var source   = $("#line-template").html();
	var template = Handlebars.compile(source);
	var data = { 
		line_number: line_number,
		text: text
	};
	var list = $('section ul').last();
	$(template(data)).appendTo(list);
}