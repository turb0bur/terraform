resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.amazon_linux_bastion.image_id
  instance_type               = var.bastion_host_settings.instance_type
  subnet_id                   = aws_subnet.public["subnet1"].id
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.bastion_profile.name
  associate_public_ip_address = true

  tags = {
    Name = format(local.resource_name, var.bastion_host_settings.name)
  }
}