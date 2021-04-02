insert into boards (name, uri) values ('random', 'b');
insert into boards (name, uri) values ('anime', 'a');

CALL new_thread(1, 'thread title', 'body of thread', 'Anonymous');
DO SLEEP(1);
CALL new_reply('comment reply', 'Replying anon', 1);
DO SLEEP(1);
CALL new_reply('comment reply 2', 'Replying anon', 1);

DO SLEEP(1);
CALL new_thread(1, 'another thread', 'ANOTHER THREAD STARTER words', 'Anonymous');
DO SLEEP(1);
CALL new_reply('helo', 'Replying anon', 4);