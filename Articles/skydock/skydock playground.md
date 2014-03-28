# Service discovery playground using skydns and skydock on top of Docker

ifconfig : docker0 ip > 172.17.42.1

docker -d -dns 172.17.42.1

docker -d -D -s aufs -H unix:///var/run/docker.sock  -H=http://0.0.0.0:4273 -dns 172.17.42.1


### Run skydns

``` bash
docker pull crosbymichael/skydns
docker run -d -p 172.17.42.1:53:53/udp --name skydns crosbymichael/skydns -nameserver 8.8.8.8:53 -domain sahilsk.com
```

nameserver: if we don't specify nameserver then other query won't work.(apt-get update, google.com etc)
domain: your doman name

### Run skydock
Docker version > 0.7

``` bash
docker pull crosbymichael/skydock
docker run -d -v /var/run/docker.sock:/docker.sock --name skydock -link skydns:skydns crosbymichael/skydock -ttl 30 -environment dev -s /docker.sock -domain sahilsk.com
```
bind to docker unix socket << Only skydock will have access to docker api and no other do. It's safe rather than using tcp port
link : to our skydns container to talk to skydns container as well
ttl: we insert new dns this is good for 30 second. If we don't get heartbeat then remove from dns answer



### Inspect DNS using dig

dig @172.17.42.1  dev.sahilsk.com

### Specific query 

dig @172.17.42.1  skydns.dev.sahilsk.com

NOTE: NOTE skydns ip address

### Set skydns env

```
set -x SKYDNS "http://172.17.0.2:8080   
```

Where we put skydns ip address we get form dig query


### Running redis server

```
docker pull crosbymichael/redis
docker run -d -name redis1 crosbymichael/redis
```

### Run redis-cli

```
docker run -rm -t -i crosbymichael/redis-cli -h redis.dev.sahilsk.com
```
