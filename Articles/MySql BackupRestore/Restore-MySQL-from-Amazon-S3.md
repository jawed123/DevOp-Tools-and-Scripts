
<!-- saved from url=(0105)https://gist.githubusercontent.com/oodavid/2209819/raw/19e1cad365e6ea5320c20a1c713c8c0b6c70824d/README.md -->
<html><script id="tinyhippos-injected">if (window.top.ripple) { window.top.ripple("bootstrap").inject(window, document); }</script><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8"></head><body style=""><pre style="word-wrap: break-word; white-space: pre-wrap;"># Restore MySQL from Amazon S3

This is a hands-on way to pull down a set of MySQL dumps from Amazon S3 and restore your database with it

***Sister Document - [Backup MySQL to Amazon S3](https://gist.github.com/2206527) - read that first***

## 1 - Set your MySQL password and S3 bucket, make a temp dir, get a list of snapshots

    # Set our variables
    export mysqlpass="ROOTPASSWORD"
    export bucket="s3://bucketname"
    # Get a list of the snapshot dates, newest at the bottom
    s3cmd ls $bucket | sort

## 2 - Download all the snapshots in the S3 folder, extract them, run them through mysql

    # Set the name of the directory you want to use (ie "1332796733 - Monday 26 March 2012 @ 2218")
    export s3folder="1234567890 - DAY DD MONTH YYYY @ HHMM"
    # Create a temporary directory and change to it
    cd $(mktemp -d)
    # Download all the snapshots
    s3cmd ls "$bucket"/"$s3folder"/ | grep -o "s3://.*\.sql\.gz" | xargs -n 1 -P 10 -I {} s3cmd get {} .
    # Unzip all the files
     ls | grep "sql.gz" | xargs -n 1 -P 10 -I {} gunzip {} .
    # Run each file through mysql
    find . -name '*.sql' | awk '{ print "source",$0 }' | mysql -u root -p$mysqlpass --batch

## 3 - Check it all went smoothly

    # Login to MySQL and have a poke
    mysql -u root -p$mysqlpass</pre><div id="window-resizer-tooltip"><a href="https://gist.githubusercontent.com/oodavid/2209819/raw/19e1cad365e6ea5320c20a1c713c8c0b6c70824d/README.md#" title="Edit settings" style="background-image: url(chrome-extension://kkelicaakdanhinjdeammmilcgefonfh/images/icon_19.png);"></a><span class="tooltipTitle">Window size: </span><span class="tooltipWidth" id="winWidth"></span> x <span class="tooltipHeight" id="winHeight"></span><br><span class="tooltipTitle">Viewport size: </span><span class="tooltipWidth" id="vpWidth"></span> x <span class="tooltipHeight" id="vpHeight"></span></div></body></html>