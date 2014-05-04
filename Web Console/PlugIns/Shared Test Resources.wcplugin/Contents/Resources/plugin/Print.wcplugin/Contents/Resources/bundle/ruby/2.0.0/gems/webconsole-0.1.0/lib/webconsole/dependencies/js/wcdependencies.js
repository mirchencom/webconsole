function addMissingDependency(name, type, installationInstructions) {
	var source   = $("#dependency-template").html();
	var template = Handlebars.compile(source);
	var data = { 
		name: name,
		type: type,
    installationInstructions: installationInstructions
	};
	$(template(data)).appendTo("body");
}
