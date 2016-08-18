Install elasticsearch
-------------

Insall java


    sudo add-apt-repository -y ppa:webupd8team/java
    sudo apt-get update
    sudo apt-get -y install oracle-java8-installer
    java -version


Download debian package and install it

link: https://www.elastic.co/downloads/elasticsearch


    wget https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/deb/elasticsearch/2.3.5/elasticsearch-2.3.5.deb
    dpkg -i elasticsearch-2.3.5.deb
    sudo service elasitcsearch restart



Install Kibana
-----------------

link: https://www.elastic.co/downloads/kibana

    wget https://download.elastic.co/kibana/kibana/kibana_4.5.4_amd64.deb
    dpkg -i kibana_4.5.4_amd64.deb
    sudo service kibana restart
    

-------

Instruction to restore elasticsearch snapshot to another cluster
-------


## Restore snapshot to another cluster

### Create registery

Add file system registry

    mkdir -p /mount/backups

edit __/etc/elasticsearch/elasticsearch.yml__ file

    #Add backup directory
    path.repo: ["/mount/backups"]

Restart elasticsearch

    sudo service elasticsearch restart
  
Now create Registry

    curl -XPUT 'http://localhost:9200/_snapshot/my_backup' -d '{
        "type": "fs",
        "settings": {
            "location": "/mount/backups/my_backup",
            "compress": true
        }
    }'


### Copy backups to `/mount/backups/my_backup` folder

    cp <your backup> /mount/backups/my_backup

```
    .backups
    └── my_backup
        ├── indices
        │   ├── logstash-2016.03.17
        │   │   ├── 0 [97 entries exceeds filelimit, not opening dir]
        │   │   ├── 1 [109 entries exceeds filelimit, not opening dir]
        │   │   ├── 2 [103 entries exceeds filelimit, not opening dir]
        │   │   ├── 3 [111 entries exceeds filelimit, not opening dir]
        │   │   ├── 4 [117 entries exceeds filelimit, not opening dir]
        │   │   └── snapshot-logstash-2016.03.17
        │   └── snapshot-logstash-2016.03.17
        ├── metadata-logstash-2016.03.17
        └── snapshot-logstash-2016.03.17
```

### Restore now

    curl  -XPOST 'http://localhost:9200/_snapshot/my_backup/logstash-2016.03.17/_restore'

### Checking progress

    curl  -XGET http://localhost:9200/logstash-2016.03.17/_recovery?pretty | grep "%"

  All should be 100%


------

One shot script
------

Above steps are automatically executed for you by following little friendly project. Do give it a try.

- https://github.com/sahilsk/elk-snapshot-restore


References
-----

- https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-snapshots.html
- https://www.elastic.co/guide/en/elasticsearch/guide/current/_restoring_from_a_snapshot.html
