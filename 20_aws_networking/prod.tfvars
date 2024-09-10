vpc_env_settings = {
  cidr = "10.1.0.0/16"
}

subnet_common_settings = {
  public = {
    subnet1 = {
      cidr = "10.1.1.0/24"
    }
    subnet2 = {
      cidr = "10.1.2.0/24"
    }
  }

  private = {
    subnet1 = {
      cidr = "10.1.10.0/24"
    }
    subnet2 = {
      cidr = "10.1.20.0/24"
    }
  }
}

public_instances_env_config = {
  instance_type = "t2.small"
  ebs_volume = {
    size = 20
  }
}

public_asg_env_config = {
  desired_capacity = 2
  max_size         = 4
  min_size         = 1
}

private_instances_env_config = {
  instance_type = "t2.small"
  ebs_volume = {
    size = 20
  }
}

private_asg_env_config = {
  desired_capacity = 2
  max_size         = 4
  min_size         = 1
}

nat_instances_env_config = {
  instance_type = "t2.small"
}