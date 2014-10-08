Nginx Monitoring
=====================

- Can be used as load balancer, proxy to api's or web server

### Key Metrics

- Requests
	
	No. of requests you're getting
	
- Connections
	
	No. of connections to your server
	
- Status Codes
		
	Status code backend returning to customers
		
- Server performance

	
### Requests & connections

How many request, concurrent connection you're processing?

__Benchmark__ nginx before deploying to know its limit.

ngx_http_stub_status_module

Install this module while compiling. `--with-http_stub_status_module`
Default output gives you basic information:

	Active connections: 291
	Server accepts handled requests: 
	16630948 16630948  31070465
	Reading: 6  Writing: 179 waiting: 106
	
	If no. of requests > no. accept requests, then there's a problem somewhere. 

### Status Codes

What is returned by your nginx.

	2xx = Success
	3xx = Redirect
	4xx = Client Error
	5xx = Server Error
	
4xx & 5xx errors are more critical one and you should dig them whenever you come across. 
5xx: Problem with infrastructure, or php etc doing something

- Most 2xx/3xx
- Sudden spikes?  
		Any unusal pattern
		
Make use of access_log directive in nginx config.

`ngxtop` : python script to read nginx log in human readable format

### Server Performance

- Cpu /Load average
	
	Key metrics for web server performance. It hel you understand more of the load pattern. As load incrase, response time increases with increase in resource usages

- Networking(connections)
	
	Each connection has an overhead as it has to maintain a open socket with the server.100 and 1000s of open connection to server are typical.
	
	
References:

- http://nginx.org/en/docs/http/ngx_http_stub_status_module.html
- http://nginx.org/en/docs/http/ngx_http_status_module.html
- http://blog.serverdensity.com/monitor-nginx
