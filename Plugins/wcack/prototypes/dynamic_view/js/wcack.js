// DOM Manipulation

function addFile(file_path) {
	var source   = $("#file-template").html();
	var template = Handlebars.compile(source);
	var data = { 
		file_path: file_path
	};
	$(template(data)).appendTo("body");
}

function addLine(line_number, text, matches) {
	var matchesCopy = JSON.parse(JSON.stringify(matches));
	text = textWithMatchesProcessed(text, 0, matchesCopy);

	var source   = $("#line-template").html();
	var template = Handlebars.compile(source);
	var data = { 
		line_number: line_number,
		text: text
	};
	var list = $('section ul').last();
	$(template(data)).appendTo(list);
}

// String processing

function textWithMatchesProcessed(text, startIndex, matches) {
	if (matches.length > 0) {
		match = matches[0];
		matches.splice(0,1);

		var source = $("#match-template").html();
		var template = Handlebars.compile(source);
		var matchedText = text.substr(match.index, match.length);
		var data = { 
			text: matchedText
		};
		var templatedText = template(data).stripWhitespace();

		var textWithMatchReplaced = text.replaceSubstr(match.index, match.length, templatedText);
		textWithMatchSubstring = textWithMatchReplaced.substring(startIndex, match.index + templatedText.length);

		var nextStartIndex = match.index + match.length;
		return textWithMatchSubstring + textWithMatchesProcessed(text, nextStartIndex, matches)
	}

	return text.substr(startIndex);
}

// Helpers

String.prototype.replaceSubstr=function(start, length, newSubstring) {
     return this.substr(0, start) + newSubstring + this.substr(start + length);
}

String.prototype.stripWhitespace=function() {
	return this.replace(/(^\s+|\s+$)/g, '');
}