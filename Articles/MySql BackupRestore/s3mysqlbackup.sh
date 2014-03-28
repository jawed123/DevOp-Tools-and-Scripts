
<!-- saved from url=(0112)https://gist.githubusercontent.com/oodavid/2206527/raw/8f13b604e236066c6a97a1eec67a6a64bdfe5019/s3mysqlbackup.sh -->
<html><script id="tinyhippos-injected">if (window.top.ripple) { window.top.ripple("bootstrap").inject(window, document); }</script><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8"></head><body style=""><pre style="word-wrap: break-word; white-space: pre-wrap;">#!/bin/bash

# Based on https://gist.github.com/2206527

# Be pretty
echo -e " "
echo -e " .  ____  .    ______________________________"
echo -e " |/      \|   |                              |"
echo -e "[| \e[1;31m♥    ♥\e[00m |]  | S3 MySQL Backup Script v.0.1 |"
echo -e " |___==___|  /                © oodavid 2012 |"
echo -e "              |______________________________|"
echo -e " "

# Basic variables
mysqlpass="ROOTPASSWORD"
bucket="s3://bucketname"

# Timestamp (sortable AND readable)
stamp=`date +"%s - %A %d %B %Y @ %H%M"`

# List all the databases
databases=`mysql -u root -p$mysqlpass -e "SHOW DATABASES;" | tr -d "| " | grep -v "\(Database\|information_schema\|performance_schema\|mysql\|test\)"`

# Feedback
echo -e "Dumping to \e[1;32m$bucket/$stamp/\e[00m"

# Loop the databases
for db in $databases; do

  # Define our filenames
  filename="$stamp - $db.sql.gz"
  tmpfile="/tmp/$filename"
  object="$bucket/$stamp/$filename"

  # Feedback
  echo -e "\e[1;34m$db\e[00m"

  # Dump and zip
  echo -e "  creating \e[0;35m$tmpfile\e[00m"
  mysqldump -u root -p$mysqlpass --force --opt --databases "$db" | gzip -c &gt; "$tmpfile"

  # Upload
  echo -e "  uploading..."
  s3cmd put "$tmpfile" "$object"

  # Delete
  rm -f "$tmpfile"

done;

# Jobs a goodun
echo -e "\e[1;32mJobs a goodun\e[00m"</pre><div id="window-resizer-tooltip"><a href="https://gist.githubusercontent.com/oodavid/2206527/raw/8f13b604e236066c6a97a1eec67a6a64bdfe5019/s3mysqlbackup.sh#" title="Edit settings" style="background-image: url(chrome-extension://kkelicaakdanhinjdeammmilcgefonfh/images/icon_19.png);"></a><span class="tooltipTitle">Window size: </span><span class="tooltipWidth" id="winWidth"></span> x <span class="tooltipHeight" id="winHeight"></span><br><span class="tooltipTitle">Viewport size: </span><span class="tooltipWidth" id="vpWidth"></span> x <span class="tooltipHeight" id="vpHeight"></span></div></body></html>