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
					// myWindow = window;
					testCase.window = window;
					// console.log(this.window);
					// console.log(window.document.documentElement.outerHTML);
					done();
				}
			});
		});
    },
    "Something works": function () {
		var matches = [
			{
				index: 0,
				length: 5
			},
			{
				index: 20,
				length: 10
			}
		];

		var text = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
		var testString = this.window.textWithMatchesProcessed(text, 0, matches);
		console.log(testString);


        assert(true);
    }
});