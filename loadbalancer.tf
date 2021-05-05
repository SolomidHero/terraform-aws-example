# Create network load balancer
resource "aws_lb" "example_lb" {
  name = "Example-LoadBalancer"
  security_groups    = [aws_security_group.example_sgp.id]
  subnets            = aws_subnet.example_subnet.*.id
  load_balancer_type = "application"
}

# Create listener for load balancer http
resource "aws_lb_listener" "example_lb_listener" {
  load_balancer_arn = aws_lb.example_lb.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code = 404
    }
  }
}

# Create target group lb
resource "aws_lb_target_group" "example_lb_tg" {
  name = "Example-TargetGroup"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.example_vpc.id

  health_check {
    path = "/"
    protocol = "HTTP"
    matcher = "200"
    interval = 10
    timeout = 3
    healthy_threshold = 3
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener_rule" "asg" {
  listener_arn = aws_lb_listener.example_lb_listener.arn
  priority = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.example_lb_tg.arn
  }
}

# Add instance to load balancer
locals {
  instances = [aws_instance.nginx_server, aws_instance.apache_server]
}

resource "aws_lb_target_group_attachment" "example_lb_tga" {
  count = length(local.instances)

  target_group_arn = aws_lb_target_group.example_lb_tg.arn
  target_id        = local.instances[count.index].id
  port             = 80
}
