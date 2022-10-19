resource "null_resource" "command_1" {
  provisioner "local-exec" {
    command = "echo Terraform START: $(date) >> log.txt"
  }
}

resource "null_resource" "command_2" {
  provisioner "local-exec" {
    command = "ping -c5 google.com"
  }
}

resource "null_resource" "command_3" {
  provisioner "local-exec" {
    command = "print('My name is Vova')"
    interpreter = ["python3", "-c"]
  }
}

resource "null_resource" "command_4" {
  provisioner "local-exec" {
    command = "echo $MATE1 $MATE2 $MATE3 $MATE4 >> team.txt"
    environment = {
      MATE1 = "Yura"
      MATE2 = "Oleks"
      MATE3 = "Volodya"
      MATE4 = "Lubko"
    }
  }
}

provider "aws" {}

resource "aws_instance" "my_server" {
  ami = "ami-05ff5eaef6149df49"
  instance_type = "t3.micro"
  provisioner "local-exec" {
    command = "echo Hello World from EC2 instance creating!"
  }
}

resource "null_resource" "command_6" {
  provisioner "local-exec" {
    command = "echo Terraform END: $(date) >> log.txt"
  }
  depends_on = [null_resource.command_1, null_resource.command_2, null_resource.command_3, null_resource.command_4, aws_instance.my_server]
}