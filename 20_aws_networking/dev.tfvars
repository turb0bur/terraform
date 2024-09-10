vpc_env_settings = {
  cidr = "10.0.0.0/16"
}

subnet_env_settings = {
  public = {
    subnet1 = {
      cidr = "10.0.1.0/24"
    }
    subnet2 = {
      cidr = "10.0.2.0/24"
    }
  }

  private = {
    subnet1 = {
      cidr = "10.0.10.0/24"
    }
    subnet2 = {
      cidr = "10.0.20.0/24"
    }
  }
}

public_instances_env_config = {
  instance_type = "t2.micro"
  ebs_volume = {
    size = 8
  }
}

public_asg_env_config = {
  desired_capacity = 2
  max_size         = 2
  min_size         = 1
}

private_instances_env_config = {
  instance_type = "t2.micro"
  ebs_volume = {
    size = 8
  }
}

private_asg_env_config = {
  desired_capacity = 2
  max_size         = 2
  min_size         = 1
}

nat_instances_env_config = {
  instance_type = "t2.micro"
}