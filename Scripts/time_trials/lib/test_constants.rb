TEST_HTML_1 = %{
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
}

TEST_HTML_2 = %{
  <!DOCTYPE html>
  <html lang="en">
  <head>
  	<meta charset="utf-8" />
  	<title>Untitled</title>
  <style>
  header[role="banner"], section, footer {
  	margin: 20px;
  }
  </style>
  </head>
  <body>

  	<header role="banner">
  		<h1>1Percenter</h1>
  		<nav>
  			<ul>
  				<li><a href="#">About</a></li>
  			</ul>
  		</nav>
  	</header>

  	<section>
  		<header>
  			<h1>Content</h1>
  		</header>
  		<p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
  	</section>

  	<footer>
  		&copy;2015 Roben Kleene
  	</footer>

  <!-- 1P -->
  </body>
  </html>
}