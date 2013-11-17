function addKeyValue(key, value) {
	var source   = $("#output-template").html();
	var template = Handlebars.compile(source);
	var data = { 
		key: key,
		value: value
	};
	$(template(data)).appendTo("dl");
}

function valueForKey(key) {
	return $('#' + key).text()
}