TEST_HTML = %{
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
