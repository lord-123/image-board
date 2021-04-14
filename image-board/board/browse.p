@setup[]
$setup[0]
^if(def $form:fields.board){
	^get_board[]
	^if($board > 0){
		$setup_worked[1]
		^dbconnect{
			$threads[^table::sql{CALL get_board_threads($board.id)}]
		}
	}
}
$browser(true)

@execute_form[]
^execute_thread_form[]

@thread_form[]
^generic_form[^table::create{title	options	type	end
Name	name="name" placeholder="Anonymous"
Subject	name="title" /><input type="submit" value="Post" name="posted"
Comment	name="comment"	textarea	</textarea>
File	type="file" name="image"	
}]

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

@title[]
/$board.uri/ - $board.name

@display_form[]
<h1>Post a new thread</h1>
^thread_form[]