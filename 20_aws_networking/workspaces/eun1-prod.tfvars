region      = "eu-north-1"
environment = "prod"

vpc_settings = {
  name                 = "main-vpc"
  cidr                 = "10.11.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

subnet_settings = {
  public = {
    subnet1 = {
      map_public_ip_on_launch = true
      name                    = "public-subnet-1"
      cidr                    = "10.11.1.0/24"
    }
    subnet2 = {
      map_public_ip_on_launch = true
      name                    = "public-subnet-2"
      cidr                    = "10.11.2.0/24"
    }
  }

  private = {
    subnet1 = {
      name = "private-subnet-1"
      cidr = "10.11.10.0/24"
    }
    subnet2 = {
      name = "private-subnet-2"
      cidr = "10.11.20.0/24"
    }
  }
}

public_instances_config = {
  ami                  = "ami-0c6da69dd16f45f72"
  instance_type        = "t2.small"
  template_prefix_name = "public-instance-"
  root_volume_name     = "/dev/xvda"
  ebs_volume = {
    size                  = 20
    type                  = "gp3"
    delete_on_termination = true
  }
}

public_asg_config = {
  name                      = "public-asg"
  desired_capacity          = 2
  max_size                  = 4
  min_size                  = 1
  launch_template_version   = "$Latest"
  health_check_type         = "EC2"
  health_check_grace_period = 300
  tags = {
    Name = "public-asg-instance"
  }
}

private_instances_config = {
  ami                  = "ami-0c6da69dd16f45f72"
  instance_type        = "t2.small"
  template_prefix_name = "private-instance-"
  root_volume_name     = "/dev/xvda"
  ebs_volume = {
    size                  = 20
    type                  = "gp3"
    delete_on_termination = true
  }
}

private_asg_config = {
  name                      = "private-asg"
  desired_capacity          = 2
  max_size                  = 4
  min_size                  = 1
  launch_template_version   = "$Latest"
  health_check_type         = "EC2"
  health_check_grace_period = 300
  tags = {
    Name = "private-asg-instance"
  }
}

nat_instances_config = {
  ami                  = "ami-0722e6faf26e7a8aa"
  instance_type        = "t2.small"
  template_prefix_name = "nat-instance-"
  root_volume_name     = "/dev/xvda"
  ebs_volume = {
    size                  = 8
    type                  = "gp3"
    delete_on_termination = true
  }
}