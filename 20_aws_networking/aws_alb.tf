resource "aws_lb" "petclinic_app" {
  name                   = var.public_alb_config.name
  internal               = false
  load_balancer_type     = "application"
  enable_xff_client_port = true
  security_groups        = [aws_security_group.public_alb_sg.id]
  subnets                = [for subnet in aws_subnet.public : subnet.id]
}

resource "aws_lb_target_group" "petclinic" {
  name     = var.public_alb_config.tg_name
  port     = var.ecs_cluster_config.task_definitions.petclinic.container_port
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 10
    healthy_threshold   = 5
    unhealthy_threshold = 5
  }
}

resource "aws_lb_listener" "petclinic" {
  load_balancer_arn = aws_lb.petclinic_app.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.petclinic.arn
  }
}

resource "aws_autoscaling_attachment" "petclinic" {
  autoscaling_group_name = aws_autoscaling_group.petclinic_asg.name
  lb_target_group_arn    = aws_lb_target_group.petclinic.arn
}
