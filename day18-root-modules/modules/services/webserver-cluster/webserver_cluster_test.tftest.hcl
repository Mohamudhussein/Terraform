variables {
  cluster_name     = "web-platform"
  instance_type    = "t2.micro"
  min_size         = 1
  max_size         = 2
  desired_capacity = 1
  environment      = "dev"
  server_port      = 8080
  vpc_id           = "vpc-000000000000"
  subnet_ids       = ["subnet-000000", "subnet-111111"]
  project_name     = "platform-dev"
}

run "validate_asg_name" {
  command = plan

  assert {
    condition     = startswith(aws_autoscaling_group.this.name, "web-platform-dev")
    error_message = "ASG name must include cluster name and environment"
  }
}

run "validate_instance_type" {
  command = plan

  assert {
    condition     = aws_launch_template.this.instance_type == "t2.micro"
    error_message = "Instance type mismatch"
  }
}

run "validate_target_group_port" {
  command = plan

  assert {
    condition     = aws_lb_target_group.this.port == 8080
    error_message = "Target group port must match server_port"
  }
}

run "validate_listener_port" {
  command = plan

  assert {
    condition     = aws_lb_listener.http.port == 80
    error_message = "ALB listener must listen on port 80"
  }
}