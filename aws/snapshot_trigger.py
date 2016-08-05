#!/usr/bin/env python
import boto3
import logging
import datetime
import sys

session = boto3.session.Session()
client =  session.client(service_name='elasticache', region_name="ap-southeast-1")
#client = boto3.client('elasticache')

clusters = [ 'redis-benchmark-001' ]


#sys.exit()
print client
timestamp = datetime.datetime.now().strftime('%Y%m%d-%H%M%S')
h_timestamp = datetime.datetime.now()
print "XXXXXXXXX Starting snapshot @%s" % h_timestamp
for cluster in clusters:
    try:
        response = client.create_snapshot(
                CacheClusterId= cluster,
                SnapshotName= cluster + '-' + timestamp
        )
        print "%s - snapshot created" % response['Snapshot']['SnapshotName']
    except Exception as e:
        print "Exception(%s) : %s" % (cluster, str(e))


print "-------- snapshots completed"
