#### Distributed key-value store: etcd, and confd installation
=======

Pre-requisite:
1) Instances will be launched from ami 
2) AMI will have following components installed
	*go 1.2.1
	* etcd
	* nodejs
	*  docker

### Install go >1.2.1 
https://github.com/moovweb/gvm

```
bash < <(curl -s https://raw.github.com/moovweb/gvm/master/binscripts/gvm-installer)
source $HOME/.gvm/scripts/gvm
apt-get install -y mercurial
apt-get install -y bison
gvm install go1.2.1	
gvm use go1.2.1
```

### Install etcd

```
git clone https://github.com/coreos/etcd
cd etcd
./build
```

### Install etcdctl

```
git clone https://github.com/coreos/etcdctl.git
cd etcdctl
./build
alias etcdctl=/home/ubuntu/SK_WKSP/distributed/etcdctl/bin/etcdctl
```

### Install confd

```
wget -O confd_0.2.0_linux_amd64.tar.gz https://github.com/kelseyhightower/confd/releases/download/v0.2.0/confd_0.2.0_linux_amd64.tar.gz
tar -zxvf confd_0.2.0_linux_amd64.tar.gz
sudo mv confd /usr/local/bin/confd

```

###  Create data directory

``` bash
sudo mkdir -p /etc/confd/{conf.d,templates}
```


