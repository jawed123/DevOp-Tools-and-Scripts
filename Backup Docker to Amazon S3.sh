#!/bin/bash
## 
## Usage  : ./s3dockerbackup.sh
## Author : Markus Stefanko <markus@stefanxo.com>
## From   : http://blog.stefanxo.com/category/docker/
##
## Saves all running docker containers, and syncs with Amazon S3 Bucket
##

# Set the Amazon S3 bucket you want to upload the backups to
# Find out which buckets you have access to with : s3cmd ls
bucket="s3://bucket"

# Delete old backups? Any files older than $daystokeep will be deleted on the bucket
# Don't use this option on buckets which you use for other purposes as well
# Default option     : 0
# Recommended option : 1
purgeoldbackups=0

# How many days should we keep the backups on Amazon before deletion?
daystokeep="7"

# How many worker threads to use ( check how many CPUs you have available )
# This uploads faster due to parallelization
# Make sure you don't use all your CPU workers for the backup, and remember that
# the cronjob has all the time in the world
workers=8

# This directory should have enough space to hold all docker containers at the same time
# Subdirectories will be automatically created and deleted after finish
tmpbackupdir="/tmp"

# Based on S3 MYSQL backup at https://gist.github.com/2206527

echo -e ""
echo -e "\e[1;31mAmazon S3 Backup Docker edition\e[00m"
echo -e "\e[1;33m"$(date)"\e[00m"
echo -e "\e[1;36mMore goodies at http://blog.stefanxo.com/category/docker/\e[00m"
echo -e ""

# We only continue if bucket is configured
if [[ -z "$bucket" || $bucket != *s3* || "$bucket" = "s3://bucket" ]]
then
        echo "Please set \$bucket to your bucket."
        echo -e "The bucket should be in the format : \e[1;36ms3://bucketname\e[00m"
        echo "You can see which buckets you have access to with : \e[1;33ms3cmd ls\e[00m"
        exit 1
fi

# Timestamp (sortable AND readable)
stamp=`date +"%Y_%M_%d"`

# Feedback
echo -e "Dumping to \e[1;32m$bucket/$stamp/\e[00m"

# List all running docker instances
instances=`docker ps -q -notrunc` 

tmpdir="$tmpbackupdir/docker$stamp"
mkdir $tmpdir

# Loop the instances
for container in $instances; do

    # Get info on each Docker container
    instancename=`docker inspect --format='{{.Name}}' $container | tr '/' '_'`
    imagename=`docker inspect --format='{{.Config.Image}}' $container | tr '/' '_'`

    # Define our filenames
    filename="$stamp-$instancename-$imagename.docker.tar.gz"
    tmpfile="$tmpdir/$filename"
    objectdir="$bucket/$stamp/"

    # Feedback
    echo -e "backing up \e[1;36m$container\e[00m"
    echo -e " container \e[1;36m$instancename\e[00m"
    echo -e " from image \e[1;36m$imagename\e[00m"

    # Dump and gzip
    echo -e " creating \e[0;35m$tmpfile\e[00m"
    docker export "$container" | gzip -c > "$tmpfile"

done;

# Upload all files
echo -e " \e[1;36mSyncing...\e[00m"
s3cmd --parallel --workers $workers sync "$tmpdir" "$objectdir"

# Clean up
rm -rf "$tmpdir"

# Purge old backups
# Based on http://shout.setfive.com/2011/12/05/deleting-files-older-than-specified-time-with-s3cmd-and-bash/

if [[ "$purgeoldbackups" -eq "1" ]]
then
    echo -e " \e[1;35mRemoving old backups...\e[00m"
    olderThan=`date -d "$daystokeep days ago" +%s`

    s3cmd --recursive ls $bucket | while read -r line;
    do
        createDate=`echo $line|awk {'print $1" "$2'}`
        createDate=`date -d"$createDate" +%s`
        if [[ $createDate -lt $olderThan ]]
        then 
            fileName=`echo $line|awk {'print $4'}`
            echo -e " Removing outdated backup \e[1;31m$fileName\e[00m"
            if [[ $fileName != "" ]]
            then
                s3cmd del "$fileName"
            fi
        fi
    done;
fi

# We're done
echo -e "\e[1;32mThank you for flying with Docker\e[00m"
