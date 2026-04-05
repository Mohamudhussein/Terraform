run "validate_plan" {
  command = plan

  assert {
    condition     = aws_lb.web.load_balancer_type == "application"
    error_message = "The load balancer must be an application load balancer."
  }

  assert {
    condition     = aws_autoscaling_group.web.min_size >= 1
    error_message = "The autoscaling group must have a minimum size of at least 1."
  }

  assert {
    condition     = aws_launch_template.web.instance_type == var.instance_type
    error_message = "The launch template instance type must match the variable value."
  }
}