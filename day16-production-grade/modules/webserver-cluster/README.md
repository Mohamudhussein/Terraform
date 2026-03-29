# Webserver Cluster Module

This module creates a production-style webserver cluster on AWS using:
- Application Load Balancer
- Auto Scaling Group
- Launch Template
- Security Groups
- SNS Topic for alerts
- CloudWatch CPU alarm
- CloudWatch Log Group

## Inputs
- aws_region
- cluster_name
- environment
- project_name
- team_name
- vpc_id
- subnet_ids
- instance_type
- server_port
- alb_port
- min_size
- max_size
- desired_capacity
- cpu_alarm_threshold
- cpu_alarm_period
- cpu_alarm_evaluation
- app_log_retention_days
- user_data

## Outputs
- alb_dns_name
- asg_name
- sns_topic_arn