provider "aws" {
  region     = var.access[2]
}

variable "access" {
  type = list(string)
}

##########################################################################
# EC2 instance - EBS
##########################################################################

resource "aws_instance" "static-app" {
  ami                    = "ami-08333bccc35d71140"
  instance_type          = "t2.micro"
  key_name               = "k1"
  user_data              = "${file("setup.sh")}"
  iam_instance_profile   = aws_iam_instance_profile.apache-main-profile.name
  depends_on             = [aws_network_interface.net-interface]
  network_interface {
    network_interface_id = aws_network_interface.net-interface.id
    device_index         = 0
  }
  tags = {
    Name = "static-app"
    environment = "dev"
  }
}

resource "aws_ebs_volume" "xvdb" {
  availability_zone = var.avail_zone
  size              = 5
}

resource "aws_volume_attachment" "xvdb_attachment" {
  device_name = "/dev/xvdb"
  volume_id   = aws_ebs_volume.xvdb.id
  instance_id = aws_instance.static-app.id
}