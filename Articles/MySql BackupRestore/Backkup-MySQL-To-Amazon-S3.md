
<!-- saved from url=(0105)https://gist.githubusercontent.com/oodavid/2206527/raw/4e2248989d1050892e06ec6fb0a8a05b808a2eb7/README.md -->
<html><script id="tinyhippos-injected">if (window.top.ripple) { window.top.ripple("bootstrap").inject(window, document); }</script><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8"></head><body style=""><pre style="word-wrap: break-word; white-space: pre-wrap;"># Backup MySQL to Amazon S3

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
        0 3 * * * bash /var/www/s3mysqlbackup.sh &gt;/dev/null 2&gt;&amp;1

## 4 - Don't expose the script!

If for some reason you put this script in a public folder (not sure why you would do this), you should add the following to your .htaccess or httpd.conf file to prevent public access to the files:

    ### Deny public access to shell files
    &lt;Files *.sh&gt;
        Order allow,deny
        Deny from all
    &lt;/Files&gt;</pre><div id="window-resizer-tooltip"><a href="https://gist.githubusercontent.com/oodavid/2206527/raw/4e2248989d1050892e06ec6fb0a8a05b808a2eb7/README.md#" title="Edit settings" style="background-image: url(chrome-extension://kkelicaakdanhinjdeammmilcgefonfh/images/icon_19.png);"></a><span class="tooltipTitle">Window size: </span><span class="tooltipWidth" id="winWidth"></span> x <span class="tooltipHeight" id="winHeight"></span><br><span class="tooltipTitle">Viewport size: </span><span class="tooltipWidth" id="vpWidth"></span> x <span class="tooltipHeight" id="vpHeight"></span></div></body></html>