locals {
  merged_tags = merge(
    var.common_tags,
    {
      Cluster = var.cluster_name
      Module  = "zero-downtime-webserver"
    }
  )
}

resource "random_id" "blue" {
  keepers = {
    version = var.blue_version
  }

  byte_length = 4
}

resource "random_id" "green" {
  keepers = {
    version = var.green_version
  }

  byte_length = 4
}

resource "aws_launch_template" "blue" {
  name_prefix   = "${var.cluster_name}-blue-"
  image_id      = var.ami
  instance_type = var.instance_type

  vpc_security_group_ids = [var.instance_security_group_id]

  user_data = base64encode(templatefile("${path.module}/user-data.sh", {
    version      = var.blue_version
    cluster_name = var.cluster_name
    environment  = "blue"
  }))

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(local.merged_tags, {
      Name    = "${var.cluster_name}-blue"
      Version = var.blue_version
    })
  }
}

resource "aws_launch_template" "green" {
  name_prefix   = "${var.cluster_name}-green-"
  image_id      = var.ami
  instance_type = var.instance_type

  vpc_security_group_ids = [var.instance_security_group_id]

  user_data = base64encode(templatefile("${path.module}/user-data.sh", {
    version      = var.green_version
    cluster_name = var.cluster_name
    environment  = "green"
  }))

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(local.merged_tags, {
      Name    = "${var.cluster_name}-green"
      Version = var.green_version
    })
  }
}

resource "aws_lb" "this" {
  name               = substr(replace("${var.cluster_name}-alb", "_", "-"), 0, 32)
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_id]
  subnets            = var.subnet_ids

  tags = merge(local.merged_tags, {
    Name = "${var.cluster_name}-alb"
  })
}

resource "aws_lb_target_group" "blue" {
  name     = substr(replace("${var.cluster_name}-blue-tg", "_", "-"), 0, 32)
  port     = var.server_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = merge(local.merged_tags, {
    Name = "${var.cluster_name}-blue-tg"
  })
}

resource "aws_lb_target_group" "green" {
  name     = substr(replace("${var.cluster_name}-green-tg", "_", "-"), 0, 32)
  port     = var.server_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = merge(local.merged_tags, {
    Name = "${var.cluster_name}-green-tg"
  })
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = var.active_environment == "blue" ? aws_lb_target_group.blue.arn : aws_lb_target_group.green.arn
  }
}

resource "aws_autoscaling_group" "blue" {
  name_prefix         = "${var.cluster_name}-blue-${random_id.blue.hex}-"
  min_size            = var.min_size
  max_size            = var.max_size
  desired_capacity    = var.desired_capacity
  vpc_zone_identifier = var.subnet_ids
  target_group_arns   = [aws_lb_target_group.blue.arn]
  health_check_type   = "ELB"

  launch_template {
    id      = aws_launch_template.blue.id
    version = "$Latest"
  }

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "${var.cluster_name}-blue"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "green" {
  name_prefix         = "${var.cluster_name}-green-${random_id.green.hex}-"
  min_size            = var.min_size
  max_size            = var.max_size
  desired_capacity    = var.desired_capacity
  vpc_zone_identifier = var.subnet_ids
  target_group_arns   = [aws_lb_target_group.green.arn]
  health_check_type   = "ELB"

  launch_template {
    id      = aws_launch_template.green.id
    version = "$Latest"
  }

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "${var.cluster_name}-green"
    propagate_at_launch = true
  }
}