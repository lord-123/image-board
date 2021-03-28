#@USE

@auto[]
^use[/cfg.p]


@dbconnect[code]
^connect[$connect_string]{$code}

@main[]
^if(def $form:fields.board){
	^dbconnect{
		$board[^table::sql{SELECT * FROM boards WHERE directory='$form:fields.board'}]
	}
}
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
	<body bgcolor="bisque">
	^if($board){
		<h1><center>/$board.directory/ - $board.name</center></h1>
	}

@body_board[]
		^body_form[]
		^body_posts[]

@body_form[]
		<form method="POST">
		<table>
			<tbody>
				<tr>
					<td>Name</td>
					<td><input name="name" placeholder="Anonymous"></td>
				</tr>
				<tr>
					<td>Subject</td>
					<td><input name="title"></td>
					<td><input type="submit" value="Post" name="posted"></td>
				</tr>
				<tr>
					<td>Body</td>
					<td colspan="2"><textarea name="body"></textarea></td>
				</tr>
			</tbody>
		</table>
		</form>
^if(def $form:body){
	^if(def $form:name){
		$poster_name[$form:name]
	}{
		$poster_name[Anonymous]
	}
	^if(def $form:title){
		$post_title['$form:title']
	}{
		$post_title[NULL]
	}
	^dbconnect{
		^void:sql{INSERT INTO posts
			(board, name, title, body, newthread, date_bumped)
		VALUES
			($board.id, '$poster_name', $post_title, '$form:body', TRUE, now())
		}
	}
}

@post[post]
		<div class="^if(!$post.newthread){post}">
			<p><b>$post.title $post.name</b> $post.date_posted <a 
				href="/thread?board=$board.directory&thread=$post.id">No.</a>$post.id</p>
			<blockquote>$post.body</blockquote>
		</div>

@404[]
	<h1><center>ERROR - 404</center><h1>

@footer[]
		<h3><center>$board_name</center></h3>
	</body>
</html>