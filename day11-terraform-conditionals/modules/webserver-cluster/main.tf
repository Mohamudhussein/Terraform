data "aws_subnet" "selected" {
  id = var.subnet_ids[0]
}

locals {
  is_production = var.environment == "production"

  instance_type = local.is_production ? "t2.medium" : "t2.micro"
  min_size      = local.is_production ? 3 : 1
  max_size      = local.is_production ? 10 : 2

  enable_monitoring = local.is_production || var.enable_detailed_monitoring

  merged_tags = merge(
    var.common_tags,
    {
      Environment = var.environment
      Cluster     = var.cluster_name
      Module      = "webserver-cluster"
    }
  )
}

resource "aws_launch_template" "this" {
  name_prefix   = "${var.cluster_name}-"
  image_id      = var.ami
  instance_type = local.instance_type

  vpc_security_group_ids = [var.instance_security_group_id]

  user_data = base64encode(templatefile("${path.module}/user-data.sh", {
    environment  = var.environment
    cluster_name = var.cluster_name
  }))

  tag_specifications {
    resource_type = "instance"

    tags = merge(local.merged_tags, {
      Name = "${var.cluster_name}-instance"
    })
  }
}

resource "aws_lb" "this" {
  name               = substr(replace("${var.cluster_name}-alb", "_", "-"), 0, 32)
  load_balancer_type = "application"
  subnets            = var.subnet_ids
  security_groups    = [var.alb_security_group_id]

  tags = merge(local.merged_tags, {
    Name = "${var.cluster_name}-alb"
  })
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

  tags = merge(local.merged_tags, {
    Name = "${var.cluster_name}-tg"
  })
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
  name                = "${var.cluster_name}-asg"
  min_size            = local.min_size
  max_size            = local.max_size
  desired_capacity    = local.min_size
  vpc_zone_identifier = var.subnet_ids
  health_check_type   = "ELB"
  target_group_arns   = [aws_lb_target_group.this.arn]

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  dynamic "tag" {
    for_each = merge(local.merged_tags, {
      Name = "${var.cluster_name}-asg-instance"
    })

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  count = local.enable_monitoring ? 1 : 0

  alarm_name          = "${var.cluster_name}-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "CPU utilization exceeded 80%"
}