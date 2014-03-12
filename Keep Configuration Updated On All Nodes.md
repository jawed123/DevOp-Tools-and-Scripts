#### Install etcd and confd


### Up your nodes and make it part of cluster

1) Register with etcd

#### First node(server):
```
./bin/etcd -peer-addr x1.x1.x1.x1:7001 -addr x.x.x.x:4001 -data-dir machines/machine1 -name machine1
```

#### Second node:
```
./bin/etcd -peer-addr x2.x2.x2.x2:7001 -addr x2.x2.x2.x2:4001 -peers x1.x1.x1.x1:7001 -data-dir machines/machine1  -name machine2
```

##### Confirm if nodes are up and running

```
 curl -L http://x.x.x.x:4001/v2/keys/_etcd/machines
```

Result will show you all nodes that are part of clusters.

2) Set redis configuration

```
etcdctl set /runnable/redis/url 14.219.217.19
etcdctl set /runnable/redis/port 6379
```

------------------

### Create confd  config and template 

1) Create data directory (if not there)

```
sudo mkdir -p /etc/confd/{conf.d,templates}
```

2) Create template config file
	Save it as  /etc/confd/conf.d/redis_db.toml

``` toml
[template]
src = "redis.conf.tmpl"
dest = "/tmp/redis_db.conf"
keys = [
  "/runnable/redis/url",
  "/runnable/redis/port",
]

```
3) make source template  : redis.conf.tmpl

``` toml
# This a comment
[myconfig]
database_url = {{ .runnable_redis_url }}
database_user = {{ .runnable_redis_port }}

```

### Now  run conf to get updated redis configuration file
``` bash
confd -verbose -onetime -node 'http://50.18.15.145:4001' -confdir /etc/confd
```

#### To run and poll every 2 second to keep redis conf always updated we can ues -interval argument

``` bash
confd -verbose -interval 2  -node 'http://50.18.15.145:4001' -confdir /etc/confd
```
Result:
```
[etcd] Mar 12 08:32:59.989 INFO      | URLs: docker1 / docker1 (http://0.0.0.0:4001,http://54.219.80.190:4001)
2014-03-12T08:32:59Z ip-10-191-183-12 confd[22254]: ERROR 100: Key not found (/runnable/redis_db)
2014-03-12T08:32:59Z ip-10-191-183-12 confd[22254]: INFO Target config /tmp/redis_db.conf out of sync
2014-03-12T08:32:59Z ip-10-191-183-12 confd[22254]: INFO Target config /tmp/redis_db.conf has been updated
```
open /tmp/redis_db.conf to see the updated file

```
[redis]
database_url = 54.219.217.19
database_user = 6378
```


----
#### References
1) https://github.com/coreos/etcd
2) https://github.com/coreos/etcdctl/
3) https://github.com/kelseyhightower/confd
