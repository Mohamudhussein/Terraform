locals {
  instance_type = var.environment == "production" ? "t2.medium" : "t2.micro"

  merged_tags = merge(
    var.common_tags,
    {
      Environment = var.environment
      Module      = "webserver-cluster"
      Cluster     = var.cluster_name
    }
  )
}

resource "aws_launch_template" "this" {
  name_prefix   = "${var.cluster_name}-"
  image_id      = var.ami
  instance_type = local.instance_type

  vpc_security_group_ids = [var.instance_security_group_id]

  user_data = base64encode(templatefile("${path.module}/user-data.sh", {
    server_port  = var.server_port
    environment  = var.environment
    cluster_name = var.cluster_name
  }))

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      local.merged_tags,
      {
        Name = "${var.cluster_name}-instance"
      }
    )
  }
}

resource "aws_lb" "this" {
  name               = substr(replace("${var.cluster_name}-alb", "_", "-"), 0, 32)
  load_balancer_type = "application"
  subnets            = var.subnet_ids
  security_groups    = [var.alb_security_group_id]

  tags = merge(
    local.merged_tags,
    {
      Name = "${var.cluster_name}-alb"
    }
  )
}

resource "aws_lb_target_group" "this" {
  name     = substr(replace("${var.cluster_name}-tg", "_", "-"), 0, 32)
  port     = var.server_port
  protocol = "HTTP"
  vpc_id   = data.aws_subnet.selected.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = merge(
    local.merged_tags,
    {
      Name = "${var.cluster_name}-tg"
    }
  )
}

data "aws_subnet" "selected" {
  id = var.subnet_ids[0]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = var.alb_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_autoscaling_group" "this" {
  name                      = "${var.cluster_name}-asg"
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  vpc_zone_identifier       = var.subnet_ids
  health_check_type         = "ELB"
  target_group_arns         = [aws_lb_target_group.this.arn]
  wait_for_capacity_timeout = "10m"

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  dynamic "tag" {
    for_each = merge(
      local.merged_tags,
      {
        Name = "${var.cluster_name}-asg-instance"
      }
    )

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

resource "aws_autoscaling_policy" "scale_out" {
  count = var.enable_autoscaling ? 1 : 0

  name                   = "${var.cluster_name}-scale-out"
  autoscaling_group_name = aws_autoscaling_group.this.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 300
}

resource "aws_autoscaling_policy" "scale_in" {
  count = var.enable_autoscaling ? 1 : 0

  name                   = "${var.cluster_name}-scale-in"
  autoscaling_group_name = aws_autoscaling_group.this.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 300
}