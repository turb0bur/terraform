resource "aws_lb" "public" {
  name               = var.public_alb_config.name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.public_sg.id]
  subnets            = [for subnet in aws_subnet.public : subnet.id]
}

resource "aws_lb_target_group" "public" {
  name     = var.public_alb_config.tg_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_listener" "public" {
  load_balancer_arn = aws_lb.public.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.public.arn
  }
}

resource "aws_autoscaling_attachment" "public" {
  autoscaling_group_name = aws_autoscaling_group.public.name
  lb_target_group_arn    = aws_lb_target_group.public.arn
}

resource "aws_lb" "private" {
  name               = var.private_alb_config.name
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.private_sg.id]
  subnets            = [for subnet in aws_subnet.private : subnet.id]
}

resource "aws_lb_target_group" "private" {
  name     = var.private_alb_config.tg_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_listener" "private" {
  load_balancer_arn = aws_lb.private.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.private.arn
  }
}

resource "aws_autoscaling_attachment" "private" {
  autoscaling_group_name = aws_autoscaling_group.private.name
  lb_target_group_arn    = aws_lb_target_group.private.arn
}
