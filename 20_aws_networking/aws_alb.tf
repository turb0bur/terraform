resource "aws_lb" "public_frontend" {
  name               = var.public_frontend_alb_config.name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.public_sg.id]
  subnets            = [for subnet in aws_subnet.public : subnet.id]
}

resource "aws_lb_target_group" "public_frontend" {
  name     = var.public_frontend_alb_config.tg_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_listener" "public_frontend" {
  load_balancer_arn = aws_lb.public_frontend.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.public_frontend.arn
  }
}

resource "aws_autoscaling_attachment" "public_frontend" {
  autoscaling_group_name = aws_autoscaling_group.public_frontend.name
  lb_target_group_arn    = aws_lb_target_group.public_frontend.arn
}

resource "aws_lb" "private_api" {
  name               = var.private_api_alb_config.name
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.private_sg.id]
  subnets            = [for subnet in aws_subnet.private : subnet.id]
}

resource "aws_lb_target_group" "private_api" {
  name     = var.private_api_alb_config.tg_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_listener" "private_api" {
  load_balancer_arn = aws_lb.private_api.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.private_api.arn
  }
}

resource "aws_autoscaling_attachment" "private_api" {
  autoscaling_group_name = aws_autoscaling_group.private_api.name
  lb_target_group_arn    = aws_lb_target_group.private_api.arn
}
