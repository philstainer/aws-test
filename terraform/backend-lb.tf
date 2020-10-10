resource "aws_alb" "backend" {
  name               = "backend"
  load_balancer_type = "application"
  subnets = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id,
    aws_subnet.public_c.id
  ]
  security_groups = [aws_security_group.load_balancer_security_group.id]

  tags = {
    Name = "backend"
  }
}

resource "aws_alb_target_group" "backend" {
  name        = "backend"
  port        = "80"
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.main.id

  health_check {
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
    interval            = "30"
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "5"
  }

  tags = {
    Name = "backend"
  }
}

resource "aws_alb_listener" "backend" {
  load_balancer_arn = aws_alb.backend.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.backend.arn
  }
}
