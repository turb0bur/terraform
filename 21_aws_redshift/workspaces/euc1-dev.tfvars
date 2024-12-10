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
      cidr                    = "10.0.10.0/24"
    }
  }
  data = {
    subnet1 = {
      map_public_ip_on_launch = false
      name                    = "data-subnet-1"
      cidr                    = "10.0.1.0/24"
    }
    subnet2 = {
      map_public_ip_on_launch = false
      name                    = "data-subnet-2"
      cidr                    = "10.0.2.0/24"
    }
  }
}

redshift_cluster_settings = {
  subnet_group_name = "redshift-subnet-group"
  name              = "redshift-cluster"
  type              = "single-node"
  node_type         = "ra3.large"
  node_count        = 1
}