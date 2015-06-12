Instructions
-----------


Export  
-------


- Create tunnel

		ssh -f -L3310:localhost:3306 user@remote.server -N

- Test connection
	
		telnet localhost 3310

- Connect with mysql

		mysqldump -P 3310 -h 127.0.0.1 -u mysql_user -p database_name table_name --result-file=dump_timestamp.sql

 
Import  
---------


		mysql -u root -p < dump_timestamp.sql



Extras
------

Mysql remote dump may time. So, poor or inconsistent network connectivity may interrupt your long running ssh session. To avoid such failurs please use `screen` or `tmux`


### Using screen


- Start screen session

	screen

- Attach to already running screen session

	screen -r <session_id>

 	# Do your mysql stuff here

- Detach screen session

	ctrl + a  -> d

