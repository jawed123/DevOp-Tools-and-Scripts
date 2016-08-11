#!/usr/bin/env python
import subprocess
import boto3
import re
import sys


def is_instance_id( param):
	p = re.compile('^i-(.*){8}$', re.IGNORECASE)
	if p.match(param) == None:
		return False
	else:
		return True

def is_ip(param):
	aa=re.match(r"^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$", param)
	if aa == None:
		return False
	else:
		return True
	

def get_instance_ip( param, public=False):
	s_param = param.strip()
	ec2 = boto3.resource('ec2')
	
	if is_instance_id( s_param):
		base = ec2.instances.filter(InstanceIds=[s_param])
		for instance in base:
			return instance.private_ip_address

	elif is_ip(s_param):
		return s_param
	else:
		base = ec2.instances	
		filters = [{
		    'Name': 'tag:Name',
		    'Values': [s_param]
		}]
		filtered = base.filter(Filters=filters)
		for instance in filtered:
			return instance.private_ip_address



def sssh(ip):
	prog = subprocess.Popen(["ssh", ip ], stderr=subprocess.PIPE)
	errdata = prog.communicate()[1]
	print errdata


if __name__=="__main__":
	param = sys.argv[1]
	ip = get_instance_ip( param)
	if ip != None:	
		sssh(ip)
