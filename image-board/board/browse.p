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
^generic_form_execution(def $form:comment && def $form:image)[250x250][
CALL new_thread(
	$board.id,
	^if(def $form:title){'$form:title'}{NULL},
	'$form:comment',
	^if(def $form:name){'$form:name'}{'Anonymous'},
	'$form:image.name',
	INET6_ATON('$env:REMOTE_ADDR')
)]

@title[]
/$board.uri/ - $board.name

@display_form[]
<h1>Post a new thread</h1>
^thread_form[]