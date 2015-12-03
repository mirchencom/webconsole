# Sample Data

## Load HTML

	<!DOCTYPE html>
	<html lang="en">
	<head>
	<meta charset="utf-8" />
	<title></title>
	<link rel="stylesheet" href="css/raster.css" />
	<link rel="stylesheet" href="css/style.css" />
	<script id="file-template" type="text/x-handlebars-template">
	<section>
	<header>
	<h5><a href="file://{{filePath}}">{{displayFilePath}}</a></h5>
	</header>
	<ul>
	</ul>
	</section>
	</script>
	<script id="line-template" type="text/x-handlebars-template">
	<li><strong>{{number}}:</strong>{{{text}}}</li>
	</script>
	<script id="match-template" type="text/x-handlebars-template"><strong>{{text}}</strong></script>
	<script type="text/javascript" src="js/handlebars.js"></script>
	<script type="text/javascript" src="js/zepto.js"></script>
	<script type="text/javascript" src="js/wcsearch.js"></script>
	<script type="text/javascript" src="js/bullets.js"></script>
	</head>
	<body>
	</body>
	</html>

## Do JavaScript

	addFile('/Users/robenkleene/Development/Projects/Cocoa/Web Console/Web Console/Plugins/Search.wcplugin/Contents/Resources/test/data/testfile.txt', 'testfile.txt');	

## Do JavaScript

	var matches = [
	{
	index: 65,
	length: 7
	},
	{
	index: 91,
	length: 12
	}
	];
	addLine(1, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt eiussfdsfmod ut labore et dolore magna aliqua.', matches);

## Do JavaScript

	var matches = [
	{
	index: 65,
	length: 7
	}
	];
	addLine(4, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', matches);

## Do JavaScript

	var matches = [
	{
	index: 65,
	length: 7
	}
	];
	addLine(6, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', matches);

## Do JavaScript

	var matches = [
	{
	index: 65,
	length: 7
	}
	];
	addLine(8, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', matches);

## Do JavaScript 

	addFile('/Users/robenkleene/Development/Projects/Cocoa/Web Console/Web Console/Plugins/Search.wcplugin/Contents/Resources/test/data/testfile2.txt', 'testfile2.txt');

## Do JavaScript

	var matches = [
	{
	index: 65,
	length: 7
	},
	{
	index: 91,
	length: 12
	}
	];
	addLine(1, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt eiussfdsfmod ut labore et dolore magna aliqua.', matches);

## Do JavaScript

	var matches = [
	{
	index: 8,
	length: 7
	},
	{
	index: 16,
	length: 7
	}
	];
	addLine(4, '<string>eiusmod/eiusmod.rb</string>', matches);

## Do JavaScript

	var matches = [
	{
	index: 57,
	length: 7
	}
	];
	addLine(6, 'WCSEARCH_FILE = File.join(File.dirname(__FILE__), "..", \'eiusmod.rb\')', matches);

## Do JavaScript

	var matches = [
	{
	index: 4,
	length: 7
	},
	{
	index: 63,
	length: 7
	}
	];
	addLine(8, ' eiusmod_tests_file = File.join(File.dirname(__FILE__), "tc_eiusmod.rb")', matches);

## Do JavaScript

	var matches = [
	{
	index: 0,
	length: 9
	},
	{
	index: 9,
	length: 7
	},
	{
	index: 17,
	length: 7
	},
	{
	index: 27,
	length: 10
	}
	];
	addLine(10, '<eiusmod>eiusmod/eiusmod.rb</eiusmod>', matches);

## Do JavaScript

	var matches = [
	{
	index: 4,
	length: 7
	}
	];
	addLine(12, ' eiusmod self.gsub("\'", "\\\\\\\\\'")', matches);

## Do JavaScript

	var matches = [
	{
	index: 65,
	length: 7
	}
	];
	addLine(14, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', matches);

## Do JavaScript

	var matches = [
	{
	index: 65,
	length: 7
	}
	];
	addLine(16, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', matches);

## Do JavaScript

	var matches = [
	{
	index: 65,
	length: 7
	}
	];
	addLine(18, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', matches);

## Do JavaScript: 

	function DOMToJSON() {
		var matches = [];
		$('section').each(function () {
		a = $('a' , this).first()
		var displayFilePath = a.text();
		var filePath = a.attr("href").replace('file://','');
		$('li', this).each(function () {
		var strongElements = $('strong', this).toArray();
		var numberElement = strongElements.shift();
		var lineNumber = $(numberElement).text().replace(':','');
		$(strongElements).each(function () {
		matchedText = $(this).text();
		var match = new Object();
		match.display_file_path = displayFilePath;
		match.file_path = filePath;
		match.line_number = lineNumber;
		match.matched_text = matchedText;
		matches.push(match);
		});
		});
		});
		return JSON.stringify(matches);
	}
	DOMToJSON();