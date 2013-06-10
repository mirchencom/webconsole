Mousetrap.bind(['command+n'], function(e) {
    e.preventDefault();
	testCall()
    return false;
});

function testCall() {
	// Add a dom element here
	$("<a/>", {
	    id: 'example-link',
	    href: 'http://www.example.com/',
	    text: 'Example Page'
	}).appendTo("body");
	console.log("test2");
}

// function highlight(line) {
//      var lines = line instanceof Array ? line : [line],
//          i,
//          code;
// 
//      for (i = 0; i < lines.length; ++i) {
//          code = document.getElementById('line-' + lines[i]);
//          code.className = 'highlight';
// 
//          if (timeouts[lines[i]]) {
//              clearTimeout(timeouts[lines[i]]);
//              delete timeouts[lines[i]];
//          }
// 
//          timeouts[lines[i]] = setTimeout(function() {
//              _remove(lines);
//          }, 1500);
//      }
//  }

// window.addEventListener('load', function () { setup(); }, false);
// function setup() {
// 	
// }