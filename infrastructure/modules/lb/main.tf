resource "aws_lb" "payaza_test_lb" {
  name               = "payaza-test-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.payaza_test_lb_sg
  subnets            = var.public_subnets

  enable_deletion_protection = false

  tags = {
    Name = "payaza_test-lb"
  }
}

resource "aws_lb_listener" "payaza_test_lb_listener" {
  load_balancer_arn = aws_lb.payaza_test_lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.payaza_test_simple_api_tg.arn
  }
}



resource "aws_lb_target_group" "payaza_test_simple_api_tg" {
  name        = "payaza-test-simple-api-tg"
  port        = 8000
  protocol    = "HTTP"
  vpc_id      = var.payaza_test_vpc_id
  target_type = "ip"
  lifecycle {
    create_before_destroy = false
    ignore_changes        = [name]
  }
  health_check {
    healthy_threshold   = var.elb_healthy_threshold
    unhealthy_threshold = var.elb_unhealthy_threshold
    timeout             = var.elb_timeout
    interval            = var.elb_interval
    path                = "/api/message"
  }
}

