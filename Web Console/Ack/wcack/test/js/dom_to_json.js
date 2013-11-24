function DOMToJSON(root) {
  // var result = {};
// $('section').first().('a')

  $('section').each(function () {
	  text = $('a' , this).first().text();

	  return text
	  // console.log(text);
  });

  // return result;
}