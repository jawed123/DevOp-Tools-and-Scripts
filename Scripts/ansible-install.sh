### Install Ansible-core

echo "Installing ansible-core..."

echo "Cloning ansible (https://github.com/sahilsk/ansible) ..."
git clone https://github.com/sahilsk/ansible
cd ./ansible
echo "setting environment..."
source ./hacking/env-setup
sudo apt-get install python-setuptools -y
sudo easy_install pip -y
sudo pip install paramiko PyYAML jinja2 httplib2 -y
echo  `ansible --version`



