resource "aws_vpc" "main" {
  cidr_block           = local.vpc_cidr
  enable_dns_support   = var.vpc_settings.enable_dns_support
  enable_dns_hostnames = var.vpc_settings.enable_dns_hostnames

  tags = {
    Name = local.vpc_name
  }
}

resource "aws_subnet" "public" {
  for_each   = var.subnet_settings.public
  vpc_id     = aws_vpc.main.id
  cidr_block = local.public_subnet_cidrs[each.key]
  availability_zone = element(data.aws_availability_zones.available.names, index(keys(var.subnet_settings.public), each.key))

  map_public_ip_on_launch = each.value.map_public_ip_on_launch

  tags = {
    Name = local.public_subnet_names[each.key]
  }
}

resource "aws_subnet" "private" {
  for_each   = var.subnet_settings.private
  vpc_id     = aws_vpc.main.id
  cidr_block = local.private_subnet_cidrs[each.key]
  availability_zone = element(data.aws_availability_zones.available.names, index(keys(var.subnet_settings.private), each.key))

  tags = {
    Name = local.private_subnet_names[each.key]
  }
}

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = local.igw_name
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.public_route_table_settings.routes.internet.cidr_block
    gateway_id = aws_internet_gateway.main_igw.id
  }

  tags = {
    Name = local.public_rt_name
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

#   TODO Add dynamic assigning of NAT instance to the private route table on ASG events

  tags = {
    Name = local.private_rt_name
  }
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}
