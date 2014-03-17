## Redis-server Install Script


``` bash

# Download tar 
echo "1) Downloading redis server 2.8.3 tar..."
wget http://download.redis.io/releases/redis-2.8.3.tar.gz 

# Extract and move to /var/opt directory
tar -xvzf redis-2.8.3.tar.gz -C  /var/opt


cd /var/opt/redis-2.8.3

echo "3) Running Make..."
make 
echo "4) Running make test..."
make test

#SYSTEM WIDE REDIS-INSTALL
echo "5) System wide install starting..."
sudo make install 

cd ./utils

# Default settings 
## Uncomment this lines to make install script use default settings without manual interruption.
### echo "" | sudo ./install_server.sh 

echo "5.1) Running interactive install script..."
sudo ./install_server.sh 

echo "6) Redis installation finished. Start it using `sudo service redis-server start/stop `. Or use `sudo /etc/init.d/redid-server` "
