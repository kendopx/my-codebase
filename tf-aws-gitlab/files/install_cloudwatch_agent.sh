#!/bin/bash
# Update the instance and install required packages
yum update -y

# Install Amazon CloudWatch Agent
yum install -y amazon-cloudwatch-agent

# Create CloudWatch agent configuration file
cat <<EOF > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
{
    "agent": {
        "metrics_collection_interval": 60,
        "run_as_user": "root"
    },
    "metrics": {
        "append_dimensions": {
            "InstanceId": "\${aws:InstanceId}",
            "AutoScalingGroupName": "\${aws:AutoScalingGroupName}"
        },
        "metrics_collected": {
            "disk": {
                "measurement": [
                    "used_percent"
                ],
                "metrics_collection_interval": 60,
                "resources": [
                    "*"
                ]
            },
            "mem": {
                "measurement": [
                    "mem_used_percent"
                ],
                "metrics_collection_interval": 60
            }
        }
    },
    "logs": {
        "logs_collected": {
            "files": {
                "collect_list": [
                    {
                        "file_path": "/var/log/messages",
                        "log_group_name": "/aws/ec2/logs/messages",
                        "log_stream_name": "{instance_id}",
                        "timezone": "UTC"
                    },
                    {
                        "file_path": "/var/log/cloud-init.log",
                        "log_group_name": "/aws/ec2/logs/cloud-init",
                        "log_stream_name": "{instance_id}",
                        "timezone": "UTC"
                    }
                ]
            }
        },
        "log_stream_name": "cloudwatch-agent-logs",
        "force_flush_interval": 5
    }
}
EOF

# Start CloudWatch Agent with the configuration
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
    -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json -s


# sudo yum install -y collectd

