resource "aws_ecs_cluster" "petclinic" {
  name = format(local.resource_name, var.ecs_cluster_config.name)

  tags = {
    Name = format(local.resource_name, var.ecs_cluster_config.name)
  }
}

resource "aws_ecs_task_definition" "petclinic" {
  family                   = format(local.resource_name, var.ecs_cluster_config.task_definitions.petclinic.family)
  network_mode             = var.ecs_cluster_config.task_definitions.petclinic.network_mode
  requires_compatibilities = var.ecs_cluster_config.task_definitions.petclinic.requires_compatibilities
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = templatefile(("${path.module}/container_definitions/petclinic.json.tftpl"),
    {
      petclinic_image = local.petclinic_image
      container_name = var.ecs_cluster_config.task_definitions.petclinic.container_name
      container_port = var.ecs_cluster_config.task_definitions.petclinic.container_port
    }
  )

  tags = {
    Name = format(local.resource_name, var.ecs_cluster_config.task_definitions.petclinic.family)
  }
}

resource "aws_ecs_service" "petclinic" {
  name            = format(local.resource_name, var.ecs_cluster_config.services.petclinic.name)
  cluster         = aws_ecs_cluster.petclinic.id
  task_definition = aws_ecs_task_definition.petclinic.arn
  desired_count   = var.ecs_cluster_config.services.petclinic.desired_count

  load_balancer {
    target_group_arn = aws_lb_target_group.petclinic.arn
    container_name   = var.ecs_cluster_config.task_definitions.petclinic.container_name
    container_port   = var.ecs_cluster_config.task_definitions.petclinic.container_port
  }

  tags = {
    Name = format(local.resource_name, var.ecs_cluster_config.services.petclinic.name)
  }
}