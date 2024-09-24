resource "aws_launch_template" "petclinic" {
  name_prefix   = var.petclinic_instances_config.template_prefix_name
  image_id      = data.aws_ami.amazon_linux_ecs.image_id
  instance_type = var.petclinic_instances_config.instance_type

  block_device_mappings {
    device_name = var.petclinic_instances_config.root_volume_name
    ebs {
      volume_size           = var.petclinic_instances_config.ebs_volume.size
      volume_type           = var.petclinic_instances_config.ebs_volume.type
      delete_on_termination = var.petclinic_instances_config.ebs_volume.delete_on_termination
    }
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.petclinic_profile.name
  }

  metadata_options {
    http_tokens = "required"
  }

  network_interfaces {
    security_groups = [aws_security_group.petclinic_sg.id]
  }

  user_data = base64encode(
    templatefile(("${path.module}/templates/app_user_data.sh.tftpl"),
      {
        ECS_CLUSTER_NAME = aws_ecs_cluster.petclinic.name
      }
    )
  )
}

resource "aws_autoscaling_group" "petclinic_asg" {
  name                = format(local.resource_name, var.petclinic_asg_config.name)
  desired_capacity    = var.petclinic_asg_config.desired_capacity
  max_size            = var.petclinic_asg_config.max_size
  min_size            = var.petclinic_asg_config.min_size
  vpc_zone_identifier = [for subnet in aws_subnet.private : subnet.id]
  launch_template {
    id      = aws_launch_template.petclinic.id
    version = var.petclinic_asg_config.launch_template_version
  }
  health_check_type         = var.petclinic_asg_config.health_check_type
  health_check_grace_period = var.petclinic_asg_config.health_check_grace_period

  dynamic "tag" {
    for_each = local.petclinic_asg_ec2_tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}
