var buster = require("buster");

require("../js/wcack.js")

// Require jquery
// Load dom
// Require handlebars


buster.testCase("Test string methods", {
    "Replace subString works": function () {
		var testString = "Replace foo with bar";
		testString = testString.replaceSubstr(8, 3, "bar");
        assert.equals(testString, "Replace bar with bar");
    },
    "Strip white space works": function () {
		var testString = " \n\n\t    White space begone    \n\n\t";
		console.log(testString);
		testString = testString.stripWhitespace();
		console.log(testString);
        assert.equals(testString, "White space begone");
    }
});

buster.testCase("Test handlebars methods", {
    setUp: function () {
		console.log("running setup")
    },
    "Something works": function () {
        assert(true);
    }
});