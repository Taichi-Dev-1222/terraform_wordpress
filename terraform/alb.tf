resource "aws_lb_target_group" "app" {
  name     = "wordpress-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.main.outputs.vpc_id

  health_check {
    path                = "/wp-admin/install.php"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "wordpress-tg"
  }
}

resource "aws_lb" "this" {
  name               = "wordpress-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [data.terraform_remote_state.main.outputs.sg_elb_id]
  subnets            = [data.terraform_remote_state.main.outputs.public_subnet_1a_id,
  data.terraform_remote_state.main.outputs.public_subnet_1c_id]

  enable_deletion_protection = false

  tags = {
    Name = "wordpress-alb"
  }
}

# HTTPリスナー → HTTPSにリダイレクト
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# HTTPSリスナー
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.this.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate_validation.this.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

resource "aws_lb_target_group_attachment" "app" {
  count = 2

  target_group_arn = aws_lb_target_group.app.arn
  target_id        = aws_instance.wordpress_app[count.index].id
  port             = 80
}