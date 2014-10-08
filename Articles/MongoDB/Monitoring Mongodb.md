Monitoring Mongodb
======================


Four main key metrics:

1. Oplog replication lag

    The replication built into MongoDB through replica sets has worked very well in our experience. However, by default writes only need to be accepted by the primary member and replicate down to other secondaries asynchronously i.e. [MongoDB is eventually consistent by default](http://docs.mongodb.org/manual/applications/replication/). This means there is usually a short window where data might not be replicated should the primary fail.
	
	This is a known property, so for critical data, you can adjust the [write concern](http://docs.mongodb.org/manual/core/replica-set-write-concern/) to return only when data has reached a certain number of secondaries. For other writes, you need to know when secondaries start to fall behind because this can indicate problems such as network issues or insufficient hardware capacity.
	
	![Write operation to a replica set with write concern level of w:2 or write to the primary and at least one secondary.](https://blog.serverdensity.com/wp-content/uploads/2014/09/crud-write-concern-w2.png)

	Replica secondaries can sometimes fall behind if you are moving a large number of chunks in a sharded cluster. As such, we only alert if the replicas fall behind for more than a certain period of time e.g. if they recover within 30min then we don’t alert.
	
2. Replica state

	In normal operation, one member of the replica set will be primary and all the other members will be secondaries. This rarely changes and if there is a member election, we want to know why. Usually this happens within seconds and the condition resolves itself but we want to investigate the cause right away because there could have been a hardware or network failure.

	Flapping between states should not be a normal working condition and should only happen deliberately e.g. for maintenance or during a valid incident e.g. hardware failure.
	
3. lock percentage

	As of MongoDB 2.6, locking is on a database level, with work ongoing for document level locking in MongoDB 2.8. Writes take a global database lock so if this situation happens too often then you will start seeing performance problems as other operations (including reads) get backed up in the queue.
	
	We’ve seen high effective lock % be a symptom of other issues within the database e.g. poorly configured indexes, no indexes, disk hardware failures and bad schema design. This means it’s important to know when the value is high for a long time, because it can cause the server to slow down (and become unresponsive, triggering a replica state change) or the oplog to start to lag behind.

	However, it can trigger too often, so you need to be careful. Set long delays e.g. if the lock remains above 75% for more than 30 minutes and if you have alerts on replica state and oplog lag, you can actually set this as a non-critical alert.

4. Disk IO % utilization

	 Approaching 100% indicates your disks are at capacity and you need to upgrade them i.e. spinning disk to SSD. If you are using SSDs already then you can provide more RAM or you need to split the data into shards

	 
========================
	 
1. Oplog Replication lag

    Apply when you use replica sets.

	- Replica sets: Master/Slave
	- Async. ie. eventually consistent
        
        Replication work on mongodb asynchronously
        First update on master and then changes cascading down to slaves. i.e Eventually consistent.

    - Write Concern
        
        You can get ack from master that write has been done. ACK return if it's replicated to replicas.

    - Falling behind
    
        Reason for repl falling behind:
        
        - Network Problmes
        - Hardware problems
        - Shard chunk migrations
        - MongoDb bugs
        

2. Replica State

    - Primary/Secondary
        
    - Alert on State Change

3. Lock %

    - Database Locking (2.6)
    
        Locking granularity is at db level
    
    - Sometimes a problem:
        
        - nearing 100%
        - Constantly high
        - slows replication and slow queries < Symptoms
        
    With increase in lock%, you would be increasing hardware (ssd and ram). 
    Symptoms:  slow query and replication
    If locking is hight your mongodb is waiting for resources a lot.
    
    Need monitoring at constant basis.
    
    >  General Metric: 70%
    >  This will give us time to increase capacity.
     
4. Disk i/o % utilization
    
    Mainly concerned with hardware

    - Hardware limits
    - Nearing 100%
    
        You're reaching 100%, then it's reaching the limit of physical disk 
    
    - constantly high
      
      If you see constantly high, you might think of upgrading your disk
        
    - Spinning -> SSD
      
        Move to SSD from spinning        
        SSD cheaper than ram and give significant performance improvement.
    
        General rule of thumb: Have enough Ram as Index Size. Not feasible most of the time.  So, give SSD's.     SSD's are three times faster 
    
    - slow queries, hangs, slow replication < Symptoms
    
    > General metric: 70 %, for non-critical basis.
    > Use 'iostat' to use % utilization
    

## Non Critical Metrics to Watch

- Memory usage
	
	Memory is probably the most important resource you can give MongoDB and so you want to make sure you always have enough! The rule of thumb is to always provide sufficient RAM for all of your indexes to fit in memory, and where possible, enough memory for all your data too.
	
	Resident memory is the key metric here – [MongoDB provides some useful statistics[(http://docs.mongodb.org/manual/reference/command/serverStatus/#memory-status) to show what it is doing with your memory.

- Page fault
    
	Page faults are related to memory because a page fault happens when MongoDB has to go to disk to find the data rather than memory. More page faults indicate that there is insufficient memory, so you should consider increasing the available RAM.
	
    
- NO. of connection

    Every connection has overhead. 
    Every connection to MongoDB has an overhead which contributes to the required memory for the system. This is initially limited by the [Unix ulimit settings](http://docs.mongodb.org/manual/reference/ulimit/) but then will become limited by the server resources, particularly memory.
	
	High numbers of connections can also indicate problems elsewhere e.g. requests backing up due to high lock % or a problem with your application code opening too many connections.


- Shard chunk distribution

	MongoDB will try and balance chunks equally around all your shards but this can start to lag behind if there are constraints on the system e.g. high lock % slowing down moveChunk operations. You should regularly keep an eye on how balanced the cluster is.


    [serverdensity/Mongodb-balance-check](https://github.com/serverdensity/mongodb-balance-check)
        Script provides an easy way to find out if your MongoDB shard cluster is property balanced or not.
        

# Tools to monitor MongoDB

- Mongostat
    
	This shows key metrics like opcounts, lock %, memory usage and replica set status updating every second. It is useful for real time troubleshooting because you can see what is going on right now.
    What's going on on individual shardsserver.
    
    > Inserts | Query | Update | Delete | Faults | Locked %  | Miss %

     > Miss % : Caused by increase in no. of connection, as driver try to open the connection to get access to db.
    
- Mongotop

	whereas mongostat shows global server metrics, mongotop looks at the metrics on a collection level, specifically in relation to reads and writes. This helps to show where the most activity is.

        
    This connect to mongod.
    > Total | Read | Write
    
    YOu can put databse in different directory. For archieve data, it cna goes into spinning disk, and other mounted directory can be ssd
    
    
- rs.status()

	This shows the status of the replica set from the viewpoint of the member you execute the command on. It’s useful to see the state of members and their oplog lag.
        
    State of server, how far behind slaves are from primary(lastHeartbeat)
    
- sh.status()

	This shows the status of your sharded cluster, in particular the number of chunks per shard so you can see if things are balanced or not.
    
    Sharding status:
        Basic state of sharded cluster.
        No. of Chunks on each cluster
        
        
-----------

## MONGO SHELL HEALTH CHECK COMMANDS

``` bash
db.serverStatus()
db.stats()
db.mycoll.count()
db.mycoll.totalSize()
db.mycoll.state()
db.mycoll.validate({full:true}) // WARNING:  Degrade performance !!
``` 

## UNIX SHELL CONTINUOUS PERFORMANCE MONITORING COMMANDS

``` bash
$ mongostat  # When single server
$ mongostate --discover --port 37300
$ top	# Press '1' key for individual CPU Core usage
$ iostat -xmt 1 # Useful for the disk utilization of spinning disk
```

## DB PROFILING USE VIA MONGO SHELL

``` bash
// Enable Profiling
db.setProfilingLevel(2)
//Show last 3 operation on collection (change namespace to match your db.coll name)
db.system.profile.find({"ns"  :"mydb.mycoll"}).sort({ts:-1}).limit(3).pretty()
//Disable profiling
db.setProfilingLevel(0)
```


# Backup Recovery Options

 
|		        		|	Mongodump	|	File-System		|		MMM Backup  |
|----------------------:|--------------:|------------------:|------------------:|
|Initial Complexity		|	Medium		|	High			|		Low			|
|Point In Time Recovery	|	No			|	No				|		YES			|
|System Overhead			|	High		|	Can be slow		|		Low         |
|Scalable				|	No			|	With Work		|		Yes         |
|Shard Consistency		|	Difficult	|	Difficult		|		Yes         |


===============

### ServerDensity Stats:
	
	- MongoDB Updates
	- MongoDB Load
	- MongoDB Index Size
	- Web Server Memory
	- Web Server load (connections)
	- Disk Usage
	
### Critical Alerts on key metrics

-> Oplog replication lag
-> Replica lag
	 To know what goes wrong
-> Lock %
	ram or ssd up/down decision
-> Disk io % utilization

### Watch Non-Critical 
	
		- Memory usage
		- shard distribution
		
### Setup a monitoring product: Server Density, Data Dog, NewRelic


### References:

- http://docs.mongodb.org/manual/administration/monitoring/ 
- https://blog.serverdensity.com/monitor-mongodb 
- https://blog.serverdensity.com
-  http://www.slideshare.net/serverdensity/how-tomonitormongodb?ref=https://blog.serverdensity.com/monitor-mongodb/		
		

