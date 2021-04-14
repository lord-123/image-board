@auto[]
^use[/cfg.p]

@dbconnect[code]
^connect[$connect_string]{$code}

@404[]
^use[/404.html]
^page[]

@get_board[]
^dbconnect{
	$board[^table::sql{SELECT * FROM boards WHERE uri='$form:fields.board'}]
}

@main[]
^setup[]
^if($setup_worked){
	$board_vanity[/$board.uri/ - $board.name]
	^execute_form[]
	^header[]
	^body[]
	^footer[]
}{
	^404[]
}

@header[]
<!DOCTYPE html>
<html>
	<head>
		<title>^title[]</title>
		<link rel="stylesheet" href="/style.css">
	</head>
	<body>

@thread_form[]
<form method="post" enctype="multipart/form-data">
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
			<tr>
				<td>File</td>
				<td><input type="file" name="image"></td>
			</tr>
		</tbody>
	</table>
	</form>

@execute_thread_form[]
^if(def $form:comment && def $form:image){
	^try{
		$image[^image::measure[$form:image]]
		^dbconnect{
			$id[^int:sql{CALL new_thread(
				$board.id,
				^if(def $form:title){'$form:title'}{NULL},
				'$form:comment',
				^if(def $form:name){'$form:name'}{'Anonymous'},
				'$form:image.name'
			)}]
		}
		^form:image.save[binary;/images/${id}.^file:justext[$form:image.name]]
		$f[^file::exec[/compress.sh;;${id}.^file:justext[$form:image.name];${id}c.jpg;250x250>]]
	}{
		$exception.handled(true)
		<h1>Thread creation failed.</h1>
	}
}

@display_thread_preview[thread]
^display_thread[$thread]

@display_thread[thread;preview][op]
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

@postFile[post]
^dbconnect{
	$file[^table::sql{SELECT * FROM images WHERE id=$post.id}]
}
^if(def $file){
	$filesrc[/images/${file.id}.^file:justext[$file.name]]
	$thumbsrc[/images/${file.id}c.jpg]
	^if(-f $filesrc && -f $thumbsrc){
		$image[^image::measure[$filesrc]]
		$stats[^file::stat[$filesrc]]
		<div class="file">
			<div class="fileInfo">
				<span>File:</span>
				<a href="$filesrc" class="fileName">$file.name</a>
				<span>(${stats.size}b, ${image.width}x$image.height)</span>
			</div>
			<input type="checkbox" class="imageExpander" id="check${file.id}"/>
			<label class="btn" for="check${file.id}">
				<img class="thumbnail" src="$thumbsrc">
				<img class="fullImage" loading="lazy" src="$filesrc">
			</a>
		</div>
	}
}

@postop[op;thread]
	^post[$op;1;$thread]

@postreply[reply]
	^post[$reply;0]

@post[post;op;thread]
	^if($op){
		^postFile[$post]
	}
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
		^if(!$op){^postFile[$post]}
		<blockquote>$post.comment</blockquote>
	</div>

@footer[]
		<h3><center>$board_name</center></h3>
	</body>
</html>