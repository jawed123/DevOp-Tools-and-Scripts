Smart way of login to aws(,or other cloud) instances
----

About
---

Gist is if you know instance name or id you should not need to know its ip to login from your jump host or form local shell
This is what this simple bash function try to achieve

Create IAM role with RO access on autoscaling groups and ec2 instances and assign it to the instance. If user is created then do configure `~/.aws/` with the same.

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1470902367000",
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeInstanceAttribute",
                "ec2:DescribeInstanceStatus",
                "ec2:DescribeInstances"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "Stmt1470902479000",
            "Effect": "Allow",
            "Action": [
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeAutoScalingInstances",
                "autoscaling:DescribeLoadBalancers",
                "autoscaling:DescribeScalingActivities",
                "autoscaling:DescribeScheduledActions",
                "autoscaling:DescribeTags"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
```


- copy sssh.sh file to `/etc/profile.d/sssh.sh`
- Copy sssh.py to `/home/ubuntu/devops/venv/bin/python`
- install venv and install  `boto3 (1.4.0)` pip package
