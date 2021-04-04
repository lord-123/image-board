@auto[]
^use[/cfg.p]

@dbconnect[code]
^connect[$connect_string]{$code}

@main[]
^header[]
^body[]
^footer[]

@header[]
<!DOCTYPE html>
<html>
	<head>
		<title>^title[]</title>
		<link rel="stylesheet" href="/style.css">
	</head>
	<body>

@footer[]
		<h3><center>$board_name</center></h3>
	</body>
</html>