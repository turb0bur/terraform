resource "aws_key_pair" "deployer" {
  key_name   = var.ssh_keys_config.name
  public_key = file(var.ssh_keys_config.path)
}

resource "aws_launch_template" "public" {
  name_prefix   = local.public_instance_prefix_name
  image_id      = var.public_instances_config.ami
  instance_type = local.public_instance_type
  key_name      = aws_key_pair.deployer.key_name

  iam_instance_profile {
    name = aws_iam_instance_profile.ssm_instance_profile.name
  }

  network_interfaces {
    security_groups = [aws_security_group.public_sg.id]
  }

  block_device_mappings {
    device_name = var.public_instances_config.root_volume_name
    ebs {
      volume_size           = local.public_instance_ebs_size
      volume_type           = var.public_instances_config.ebs_volume.type
      delete_on_termination = var.public_instances_config.ebs_volume.delete_on_termination
    }
  }
  user_data = filebase64("${path.module}/templates/public_user_data.sh")
}

resource "aws_autoscaling_group" "public" {
  name                = local.public_asg_name
  desired_capacity    = local.public_asg_desired_capacity
  max_size            = local.public_asg_max_size
  min_size            = var.public_asg_config.min_size
  vpc_zone_identifier = [for subnet in aws_subnet.public : subnet.id]
  launch_template {
    id      = aws_launch_template.public.id
    version = var.public_asg_config.launch_template_version
  }
  health_check_type         = var.public_asg_config.health_check_type
  health_check_grace_period = var.public_asg_config.health_check_grace_period

  dynamic "tag" {
    for_each = local.public_asg_ec2_tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

resource "aws_launch_template" "private" {
  name_prefix   = local.private_instance_prefix_name
  image_id      = var.private_instances_config.ami
  instance_type = local.private_instance_type
  key_name      = aws_key_pair.deployer.key_name

  iam_instance_profile {
    name = aws_iam_instance_profile.ssm_instance_profile.name
  }

  network_interfaces {
    security_groups = [aws_security_group.private_sg.id]
  }

  block_device_mappings {
    device_name = var.private_instances_config.root_volume_name
    ebs {
      volume_size           = local.private_instance_ebs_size
      volume_type           = var.private_instances_config.ebs_volume.type
      delete_on_termination = var.private_instances_config.ebs_volume.delete_on_termination
    }
  }
}

resource "aws_autoscaling_group" "private" {
  name                = local.private_asg_name
  desired_capacity    = local.private_asg_desired_capacity
  max_size            = local.private_asg_max_size
  min_size            = var.private_asg_config.min_size
  vpc_zone_identifier = [for subnet in aws_subnet.private : subnet.id]
  launch_template {
    id      = aws_launch_template.private.id
    version = var.private_asg_config.launch_template_version
  }
  health_check_type         = var.private_asg_config.health_check_type
  health_check_grace_period = var.private_asg_config.health_check_grace_period

  dynamic "tag" {
    for_each = local.private_asg_ec2_tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

resource "aws_launch_template" "nat" {
  name_prefix   = local.nat_instance_prefix_name
  image_id      = var.nat_instances_config.ami
  instance_type = local.nat_instance_type
  key_name      = aws_key_pair.deployer.key_name

  iam_instance_profile {
    name = aws_iam_instance_profile.ssm_instance_profile.name
  }

  network_interfaces {
    security_groups = [aws_security_group.nat_sg.id]
  }

  block_device_mappings {
    device_name = var.nat_instances_config.root_volume_name
    ebs {
      volume_size           = var.nat_instances_config.ebs_volume.size
      volume_type           = var.nat_instances_config.ebs_volume.type
      delete_on_termination = var.nat_instances_config.ebs_volume.delete_on_termination
    }
  }
}

resource "aws_autoscaling_group" "nat" {
  name                = local.nat_asg_name
  desired_capacity    = var.nat_asg_config.desired_capacity
  max_size            = var.nat_asg_config.max_size
  min_size            = var.nat_asg_config.min_size
  vpc_zone_identifier = [for subnet in aws_subnet.public : subnet.id]
  launch_template {
    id      = aws_launch_template.nat.id
    version = var.nat_asg_config.launch_template_version
  }
  health_check_type         = var.nat_asg_config.health_check_type
  health_check_grace_period = var.nat_asg_config.health_check_grace_period

  dynamic "tag" {
    for_each = local.nat_asg_tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}
