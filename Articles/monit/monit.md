wget  http://mmonit.com/monit/dist/monit-5.9.tar.gz
tar -xvzf monit-5.9.tar.gz

### Install dependencies
	#PAM : pluggin authenication module
   sudo apt-get install libpam0g-dev

cd monit-5.9

```
./configure --sysconfdir /var/monit
make
make install
cp monitrc  /etc/monitrc
chmod 0700  /etc/monitrc
```

Edit monitrc file to bind monit to correct ip and update login credentials

```
set httpd port 2812 and
    use address 199.127.219.76 # only accept connection from localhost
#   allow 0.0.0.0    # allow localhost to connect to the server and
    allow admin:monit      # require user 'admin' with password 'monit'
    allow @monit           # allow users of group 'monit' to connect (rw)
    allow @users readonly  # allow users of group 'users' to connect readonly
	
```

NOTE: Basic auth is insecure as credentails are sent plainly. Use SSL to secure web interface

Uncomment or add this line:

```
include /etc/monit.d/*.cfg
```
Set log file

set logfile /var/log/monit.log


Now /etc/monit.d  directory will contain our monit configurations

Add mail server for sending alerts

```
#
 set mailserver mail.stackexpress.com port 587  username dailyreportmail@stackexpress.com password "iw!UuOGgOEes" 
```

set global alerts recipient mail id
```
 set alert  sonu.k.meena@stackexpress.com
 set alert  sonu.k.meena@apyl.com
# < Add more if required >
# set alert foo@bar only on { timeout, nonexist }
#  set alert foo@bar but not on { instance }

```
More here: http://mmonit.com/monit/documentation/monit.html#alert_messages

Set eventqueue , in case mail server not responds

```
set eventqueue basedir /var/monit slots 5000

```


Check your config:

$ monit -t

visit monit:  http://199.127.219.76:2812/


Commands:

`
Start : monit
stop:  monit quit
`

Sample Config files
===============


```
# My website
check host dailyReportApp with address 199.127.219.76
	if failed port 80 protocol http then alert

#Docker
check process docker with pidfile /var/run/docker.pid
	start program = "/sbin/start docker"
	stop program = "/sbin/stop docker"

#mysql
check process mysql with pidfile /var/run/mysqld/mysqld.pid
        group database
        start program = "/etc/init.d/mysql start"
        stop program = "/etc/init.d/mysql stop"
        if failed unix "/var/run/mysqld/mysqld.sock" then restart
        if cpu > 60% for 2 cycles then alert
        if cpu > 80% for 5 cycles then restart
        if totalmem > 150 MB for 5 cycles then restart
        if loadavg(5min) greater than 10 for 8 cycles then stop
        if 5 restarts within 5 cycles then timeout

#nginx
check process nginx with pidfile /var/run/nginx.pid
        start program = "/etc/init.d/nginx start"
        stop  program = "/etc/init.d/nginx stop"

#Monitor process eg. backendUpdater
check process backendUpdater with pidfile  /var/run/backendUpdater.pid
        start program = "/etc/init.d/backendUpdater start"
        stop  program = "/etc/init.d/backendUpdater stop"

Reference: 

- http://mmonit.com/monit/documentation/monit.html
