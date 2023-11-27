variable "vpc_id" {}
variable "public_subnet" {}

resource "aws_lb" "main" {
  name               = "my-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["sg-0123456789abcdef0"]
  subnets            = [var.public_subnet]

  enable_deletion_protection       = false
  enable_http2                     = true
  enable_cross_zone_load_balancing = true
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      status_code  = "200"
      message_body = "OK"
    }
  }
}

resource "aws_lb_target_group" "main" {
  name     = "my-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path = "/"
  }
}
