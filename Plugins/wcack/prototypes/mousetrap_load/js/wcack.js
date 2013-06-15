Mousetrap.bind(['command+n'], function(e) {
    e.preventDefault();
	addFile("/Users/robenkleene/Dropbox/Text/Inbox/Web Console/AppleScript Support.md");
    return false;
});


// <section>
// 	<header>
// 		<h5><a href="/Users/robenkleene/Dropbox/Text/Inbox/Web Console/AppleScript Support.md">/Users/robenkleene/Dropbox/Text/Inbox/Web Console/AppleScript Support.md</a></h1>		
// 	</header>
// 	<ul>
// 		<li><strong>138:</strong>&gt; In computer programming, an enumerated type is a data type consisting of a set of named values called elements, members or enumerators of the type. The enumerator names are usually identifiers that behave as constants in the language</li>
// 	</ul>
// </section>

// Add section
// Add header
// Add h5
// 

// Just add HTML from ERB Partial?

// addFileHTML
// Stores the spot to add the line
// addLineHTML

function addFile(filePath) {
	// Add a dom element here
	$("<a/>", {
	    id: 'example-link',
	    href: filePath,
	    text: filePath
	}).appendTo("body");
}