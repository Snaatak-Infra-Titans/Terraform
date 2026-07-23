packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1.3"
    }
  }
}

source "amazon-ebs" "notification" {

  region        = var.aws_region
  instance_type = var.instance_type
  ssh_username  = "ubuntu"

  ami_name = "${var.ami_name}-${formatdate("YYYYMMDD-HHmmss", timestamp())}"

  source_ami_filter {

    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
      virtualization-type = "hvm"
      root-device-type    = "ebs"
    }

    owners      = ["099720109477"] # Canonical
    most_recent = true
  }

  subnet_id = var.subnet_id

  security_group_ids = [
    var.security_group_id
  ]

  associate_public_ip_address = true

  tags = {
    Name        = var.ami_name
    Environment = var.environment
    Application = "notification"
    CreatedBy   = "Packer"
  }
}

build {

  name = "notification-ami"

  sources = [
    "source.amazon-ebs.notification"
  ]

  provisioner "shell" {
    script = "install.sh"
  }

  provisioner "file" {
    source      = "notification-api.service"
    destination = "/tmp/notification-api.service"
  }

  provisioner "file" {
    source      = "elasticsearch.yml"
    destination = "/tmp/elasticsearch.yml"
  }

  provisioner "shell" {
    script = "configure.sh"
  }

  provisioner "shell" {
    script = "validate.sh"
  }

}
