Smart way of login to aws(,or other cloud) instances
----

About
---

Gist is if you know instance name or id you should not need to know its ip to login from your jump host or form local shell
This is what this simple bash function try to achieve



- copy sssh.sh file to `/etc/profile.d/sssh.sh`
- Copy sssh.py to `/home/ubuntu/devops/venv/bin/python`
- install venv and install pip `boto3 (1.4.0)`
