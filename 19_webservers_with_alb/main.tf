provider "aws" {
  region = "us-east-1"
}

resource "aws_default_subnet" "my_subnets" {
  count             = var.subnet_count
  availability_zone = data.aws_availability_zones.available.names[count.index]
}
#resource "aws_subnet" "my_subnets" {
#  count             = var.subnet_count
#  cidr_block        = cidrsubnet(data.aws_vpc.default.cidr_block, 16, count.index + )
#  vpc_id            = data.aws_vpc.default.id
#  availability_zone = local.my_azs[count.index % length(local.my_azs)]
#  tags              = {
#    Name = "MySubnet${count.index}"
#  }
#}

resource "aws_lb" "my_alb" {
  name               = "my-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.my_security_group.id]
  subnets            = aws_default_subnet.my_subnets.*.id
  #  subnets            = [for subnet in aws_default_subnet.my_subnets : subnet.id]

  access_logs {
    bucket  = aws_s3_bucket.my_alb_logs.id
    prefix  = local.alb_bucket_logs_prefix
    enabled = true
  }

  #  tags = {
  #    Environment = "dev"
  #  }
}

resource "aws_lb_cookie_stickiness_policy" "foo" {
  name                     = "foo-policy"
  load_balancer            = aws_elb.lb.id
  lb_port                  = 80
  cookie_expiration_period = 600
}

resource "aws_security_group" "my_security_group" {
  name_prefix = "my_security_group"
  vpc_id      = data.aws_vpc.default.id

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
}

resource "aws_instance" "my_ec2_instances" {
  count                  = var.subnet_count
  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = "t3.micro"
  subnet_id              = aws_default_subnet.my_subnets[count.index].id
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
    user_data              = templatefile("user_data.sh.tpl", {
      first_name = "Volodymyr"
      last_name  = "Butko"
    })

  tags = {
    Name = "MyWebServer${count.index + 1}"
  }
}

resource "aws_lb_target_group" "my_target_group" {
  name        = "MyTargetGroup"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.default.id
  target_type = "instance"
}


resource "aws_alb_target_group_attachment" "my_tg_attachments" {
  count            = var.subnet_count
  target_group_arn = aws_lb_target_group.my_target_group.arn
  target_id        = aws_instance.my_ec2_instances[count.index].id
}

resource "aws_lb_listener" "web_server" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = 80
  protocol          = "HTTP"
#  ssl_policy        = "ELBSecurityPolicy-2016-08"
#  certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_target_group.arn
  }
}

resource "aws_s3_bucket" "my_alb_logs" {
  bucket        = "my-alb-access-logs-bucket-${formatdate("YYYY-MM-DD", timestamp())}"
  force_destroy = true

  tags = {
    Name = "MyAlbLogsBucket"
  }
}

resource "aws_s3_bucket_acl" "my_acl" {
  bucket = aws_s3_bucket.my_alb_logs.id
  acl    = "private"
}

resource "aws_s3_bucket_policy" "alb_logs_bucket_policy" {
  bucket = aws_s3_bucket.my_alb_logs.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AllowALBAccess",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "delivery.logs.amazonaws.com"
        },
        "Action" : "s3:*",
        "Resource" : "${aws_s3_bucket.my_alb_logs.arn}/${local.alb_bucket_logs_prefix}/*",
        "Condition" : {
          "StringEquals" : {
            "s3:x-amz-acl" : "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}