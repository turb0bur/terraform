provider "aws" {
  region = "eu-central-1"
}

resource "aws_default_vpc" "my_vpc" {}

resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.all.names[0]

  #  tags = {
  #    Name = "Default subnet for ${data.aws_availability_zones.all.names[0]}"
  #  }
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = data.aws_availability_zones.all.names[1]

  #  tags = {
  #    Name = "Default subnet for ${data.aws_availability_zones.all.names[1]}"
  #  }
}

resource "aws_autoscaling_group" "my_asg" {
  name                 = "ASG-${aws_launch_configuration.my_asg_config.name}"
  launch_configuration = aws_launch_configuration.my_asg_config.name
  min_size             = 2
  max_size             = 2
  min_elb_capacity     = 2
  health_check_type    = "ELB"
  vpc_zone_identifier  = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
  load_balancers       = [aws_elb.my_classic_lb.name]

  dynamic "tag" {
    for_each = {
      "Name"  = "Web Server in ASG"
      "Owner" = "Volodymyr Butko"
    }
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "my_asg_config" {
  name_prefix     = "Highly-Available-Web-Server-LC"
  image_id        = data.aws_ami.latest_amazon_linux.id
  instance_type   = "t3.micro"
  security_groups = [aws_security_group.web.id]
  user_data       = file("user_data.sh")

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elb" "my_classic_lb" {
  name               = "highly-available-web-server-LB"
  availability_zones = [data.aws_availability_zones.all.names[0], data.aws_availability_zones.all.names[1]]
  security_groups    = [aws_security_group.web.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  health_check {
    healthy_threshold   = 2
    interval            = 10
    target              = "HTTP:80/"
    timeout             = 3
    unhealthy_threshold = 2
  }
  tags = {
    Name = "Highly Available Web Server CLB"
  }
}

resource "aws_security_group" "web" {
  name        = "Highly-Available-Web-Server-SG"
  vpc_id      = aws_default_vpc.my_vpc.id
  description = "Security group for EC2 instance"

  dynamic "ingress" {
    for_each = [80, 443]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EC2 Security Group"
  }
}
