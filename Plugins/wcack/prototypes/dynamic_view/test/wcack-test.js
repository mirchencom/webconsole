var buster = require("buster");

buster.testCase("Test string methods", {
    setUp: function () {
		require("../js/wcack.js")
    },
    "Replace subString works": function () {
		var testString = "Replace foo with bar";
		testString = testString.replaceSubstr(8, 3, "bar");
        assert.equals(testString, "Replace bar with bar");
    },
    "Strip white space works": function () {
		var testString = " \n\n\t    White space begone    \n\n\t";
		testString = testString.stripWhitespace();
        assert.equals(testString, "White space begone");
    }
});

buster.testCase("Test handlebars methods", {
    setUp: function (done) {
		var testCase = this;
		this.timeout = 3000;

		var path = require('path');
		var loadViewCommand = path.join(__dirname, 'loadview.rb');
		var exec = require("child_process").exec;
		exec('"' + loadViewCommand + '"', function (err, stdout, stderr) {
			var html = stdout;
			var projectPath = path.resolve(__dirname, '..');
			var rootURL = "file://" + encodeURI(projectPath) + "/";
			var jsdom = require("jsdom");
			jsdom.env({
				html: html,
				src: [""], // An empty JavaScript src forces external scripts to be processed before the callback fires.
				url: rootURL,
				features: {
					FetchExternalResources   : ['script'],
					ProcessExternalResources : ['script'],
					MutationEvents           : "2.0"
				},
				done: function (errors, window) {
					testCase.window = window;
					done();
				}
			});
		});
    },
    "Text with matches processed works": function () {
		window = this.window;
		
		// Real test data
		var matches = [
			{
				index: 0,
				length: 4
			},
			{
				index: 35,
				length: 4
			}
		];
		var text = "This should be matched, as well as this."
		var testString = window.textWithMatchesProcessed(text, 0, matches);
		
		// Fake test data
		var source = window.$("#match-template").html();
		var template = window.Handlebars.compile(source);
		var data = { 
			text: "This"
		};
		var templatedText1 = template(data).stripWhitespace();
		data = { 
			text: "this"
		};
		var templatedText2 = template(data).stripWhitespace();
		var fakeTestString = templatedText1 + " should be matched, as well as " + templatedText2 + ".";

        assert.equals(testString, fakeTestString);
    }
});