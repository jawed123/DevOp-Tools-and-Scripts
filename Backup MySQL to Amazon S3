# Backup MySQL to Amazon S3

This is a simple way to backup your MySQL tables to Amazon S3 for a nightly backup - this is all to be done on your server :-)

***Sister Document - [Restore MySQL from Amazon S3](https://gist.github.com/2209819) - read that next***

## 1 - Install s3cmd

*this is for Centos 5.6, see http://s3tools.org/repositories for other systems like ubuntu etc*

    # Install s3cmd
    cd /etc/yum.repos.d/
    wget http://s3tools.org/repo/CentOS_5/s3tools.repo
    yum install s3cmd
    # Setup s3cmd
    s3cmd --configure
        # You’ll need to enter your AWS access key and secret key here, everything is optional and can be ignored :-)

## 2 - Add your script

Upload a copy of [s3mysqlbackup.sh](#file_s3mysqlbackup.sh) (it will need some tweaks for your setup), make it executable and test it

    # Add the executable bit
    chmod +x s3mysqlbackup.sh
    # Run the script to make sure it's all tickety boo
    ./s3mysqlbackup.sh

## 3 - Run it every night with CRON

Assuming the backup script is stored in /var/www/s3mysqlbackup.sh we need to add a crontask to run it automatically:

    # Edit the crontab
    env EDITOR=nano crontab -e
        # Add the following lines:
        # Run the database backup script at 3am
        0 3 * * * bash /var/www/s3mysqlbackup.sh >/dev/null 2>&1

## 4 - Don't expose the script!

If for some reason you put this script in a public folder (not sure why you would do this), you should add the following to your .htaccess or httpd.conf file to prevent public access to the files:

    ### Deny public access to shell files
    <Files *.sh>
        Order allow,deny
        Deny from all
    </Files>
