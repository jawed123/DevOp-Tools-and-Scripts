# /etc/profile.d/sssh.sh
sssh(){
  /home/ubuntu/devops/venv/bin/python /home/ubuntu/devops/sssh.py "$1"
}
