region      = "eu-central-1"
environment = "dev"

vpc_settings = {
  name                 = "main-vpc"
  cidr                 = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

subnet_settings = {
  public = {
    subnet1 = {
      map_public_ip_on_launch = true
      name                    = "public-subnet-1"
      cidr                    = "10.0.1.0/24"
    }
    subnet2 = {
      map_public_ip_on_launch = true
      name                    = "public-subnet-2"
      cidr                    = "10.0.2.0/24"
    }
  }

  app = {
    subnet1 = {
      name = "app-subnet-1"
      cidr = "10.0.10.0/24"
    }
    subnet2 = {
      name = "app-subnet-2"
      cidr = "10.0.20.0/24"
    }
  }

  db = {
    subnet1 = {
      name = "db-subnet-1"
      cidr = "10.0.30.0/24"
    }
    subnet2 = {
      name = "db-subnet-2"
      cidr = "10.0.40.0/24"
    }
  }
}

petclinic_instances_config = {
  instance_type        = "t2.small"
  template_prefix_name = "private-instance-"
  root_volume_name     = "/dev/xvda"
  ebs_volume = {
    size                  = 30
    type                  = "gp3"
    delete_on_termination = true
  }
}

petclinic_asg_config = {
  name                      = "petclinic-asg"
  desired_capacity          = 2
  max_size                  = 2
  min_size                  = 1
  launch_template_version   = "$Latest"
  health_check_type         = "EC2"
  health_check_grace_period = 300
  tags = {
    Name = "private-asg-instance"
  }
}

nat_instances_config = {
  instance_type        = "t2.micro"
  template_prefix_name = "nat-instance-"
  root_volume_name     = "/dev/xvda"
  ebs_volume = {
    size                  = 8
    type                  = "gp3"
    delete_on_termination = true
  }
}

ecs_cluster_config = {
  name = "petclinic-cluster"
  task_definitions = {
    petclinic = {
      family                   = "petclinic-task"
      network_mode             = "bridge"
      requires_compatibilities = ["EC2"]
      container_name           = "petclinic"
      container_port           = 8081
    }
  }
  services = {
    petclinic = {
      name          = "petclinic-service"
      desired_count = 2
      deployment = {
        min_percent = 50
        max_percent = 200
      }
    }
  }
}

rds_instance_config = {
  name                    = "petclinic-db"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.small"
  parameter_group_name    = "default.mysql8.0"
  allocated_storage       = 20
  storage_type            = "gp3"
  publicly_accessible     = false
  skip_final_snapshot     = true
  multi_az                = true
  backup_retention_period = 7
  subnet_group_name       = "petclinic-db-subnet-group"
}