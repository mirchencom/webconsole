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

function addLineWithMatchesTest(line_number, text) {
	var matches = [
		{
			index: 20,
			length: 10
		},
		{
			index: 30,
			length: 10
		}
	];

	textWithMatchesProcessed(text, 0, matches);
}

String.prototype.replaceSubstr=function(start, length, newSubstring) {
     return this.substr(0, start) + newSubstring + this.substr(start + length);
}

String.prototype.stripWhitespace=function() {
	return this.replace(/(^\s+|\s+$)/g, '');
}

function textWithMatchesProcessed(text, startIndex, matches) {

	if (matches.length > 0) {
		match = matches[0];
		matches.splice(0,1);

		var source   = $("#match-template").html();
		var template = Handlebars.compile(source);
		var matchedText = text.substr(match.index, match.length);
		var data = { 
			text: matchedText
		};
		var templatedText = template(data);

		var textWithMatchReplaced = text.replaceSubstr(match.index, match.length, templatedText);
		

		textWithMatchSubstring = textWithMatchReplaced.substring(startIndex, match.index + templatedText.length);


		console.log(textWithMatchSubstring);


		// textToNextStartIndex = text.substr(startIndex, nextStartIndex)
		// 
		// 
		// 
		// var nextStartIndex = match.index + match.length;

		// textWithMatchesProcessed(text, nextStartIndex, matches);
	}






		
		
		
	

		
		// return textReplace.substr(0, text.)
		// console.log(templatedMatchedText);
			    //Do something
}


// String.prototype.replaceAt=function(index, character) {
//    return this.substr(0, index) + character + this.substr(index + character.length);
// }