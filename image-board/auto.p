@auto[]
^use[/cfg.p]

@dbconnect[code]
^connect[$connect_string]{$code}

@main[]
^if(def $form:fields.board){
	^dbconnect{
		$board[^table::sql{SELECT * FROM boards WHERE uri='$form:fields.board'}]
		$board_vanity[/$board.uri/ - $board.name]
	}
}
^header[]
^body[]
^footer[]

@header[]
<!DOCTYPE html>
<html>
	<head>
		<title>$board_vanity</title>
		<link rel="stylesheet" href="/style.css">
	</head>
	<body>
	^if($board){
		<h1><center>$board_vanity</center></h1>
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
				<td colspan="2"><textarea name="comment"></textarea></td>
			</tr>
		</tbody>
	</table>
	</form>
^if(def $form:comment){
	^dbconnect{
		^void:sql{CALL new_thread(
			$board.id,
			^if(def $form:title){'$form:title'}{NULL},
			'$form:comment',
			^if(def $form:name){'$form:name'}{'Anonymous'}
		)}
	}
}

@thread_preview[thread][op]
	<div>
	^dbconnect{
		$op[^table::sql{CALL get_thread_op($thread.id)}]
		$replies[^table::sql{CALL get_thread_replies($thread.id)}]
	}
	^postop[$op;$thread]
	^replies.foreach[pos;elem]{
		^postreply[$elem]
	}
	</div>

@postop[op;thread]
	^post[$op;1;$thread]

@postreply[reply]
	^post[$reply;0]

@post[post;op;thread]
	<div id="p$post.id" class="post ^if($op){op}{reply}">
		<div class="postInfo">
			^if($op){<span class="subject">$thread.title</span>}
			<span class="name">$post.author</span>
			<span class="date">$post.date_posted</span>
			<span class="postNum">
				<a href="$board.uri/thread/$post.thread#p$post.id">No.</a>
				<a>$post.id</a>
			</span>
		</div>
		<blockquote>$post.comment</blockquote>
	</div>

@404[]
	<h1><center>ERROR - 404</center><h1>

@footer[]
		<h3><center>$board_name</center></h3>
	</body>
</html>