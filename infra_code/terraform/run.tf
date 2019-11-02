provider "aws" {
  shared_credentials_file = "~/.aws/credentials"
  profile = "${var.profile}"
  region = "${var.aws_region}"
}

data "aws_ami" "jenkins_server" {
  most_recent      = true
  owners           = ["self"]

  filter {
    name   = "name"
    values = ["jenkins_master_ami*"]
  }
}

# userdata for the Jenkins server ...
data "template_file" "jenkins_server" {
  template = "${file("scripts/jenkins_server.sh")}"

  vars {
    env = "dev"
    jenkins_admin_password = "jenkins_secret_password"
  }
}

# the Jenkins server 
resource "aws_instance" "jenkins_server" {
  ami                       = "${data.aws_ami.jenkins_server.image_id}"
  instance_type             = "t3.medium"
  key_name                  = "asif-admin-test"
  subnet_id                 = "subnet-7b863d27"
  vpc_security_group_ids    = ["sg-05a7f272c27c0959d","sg-82ecfac8"]
  iam_instance_profile      = "PPNSADM"
  user_data                 = "${data.template_file.jenkins_server.rendered}"

  tags {
    "Name" = "jenkins_server",
    "adsk:moniker" = "N2O-S-UE1"
  }

  root_block_device {
    delete_on_termination = true
  }
}

output "jenkins_server_ami_name" {
    value = "${data.aws_ami.jenkins_server.name}"
}

output "jenkins_server_ami_id" {
    value = "${data.aws_ami.jenkins_server.id}"
}

output "jenkins_server_public_ip" {
  value = "${aws_instance.jenkins_server.public_ip}"
}

output "jenkins_server_private_ip" {
  value = "${aws_instance.jenkins_server.private_ip}"
}


data "local_file" "jenkins_worker_pem" {
  filename = "${path.module}/scripts/asif-admin-test.pem"
}


# the Jenkins slave servers in autoscaling mechanism

data "template_file" "userdata_jenkins_worker_linux" {
  template = "${file("scripts/jenkins_worker_linux.sh")}"

  vars {
    env         = "dev"
    region      = "us-east-1"
    datacenter  = "us-east-1"
    node_name   = "us-east-1-jenkins_worker_linux"
    domain      = ""
    device_name = "eth0"
    server_ip   = "${aws_instance.jenkins_server.private_ip}"
    worker_pem  = "${data.local_file.jenkins_worker_pem.content}"
    jenkins_username = "admin"
    jenkins_password = "jenkins_secret_password"
  }
}


resource "aws_launch_configuration" "jenkins_worker_linux" {
  name_prefix                 = "jenkins-worker-linux"
  image_id                    = "${data.aws_ami.jenkins_server.image_id}"
  instance_type               = "t3.medium"
  iam_instance_profile        = "PPNSADM"
  key_name                    = "asif-admin-test"
  security_groups             = ["sg-05a7f272c27c0959d","sg-82ecfac8"]
  user_data                   = "${data.template_file.userdata_jenkins_worker_linux.rendered}"
  associate_public_ip_address = false

  root_block_device {
    delete_on_termination = true
    volume_size = 100
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "jenkins_worker_linux" {
  name                      = "jenkins-worker-linux"
  min_size                  = "1"
  max_size                  = "2"
  desired_capacity          = "2"
  health_check_grace_period = 60
  health_check_type         = "EC2"
  vpc_zone_identifier       = ["subnet-3c65db5b","subnet-7b863d27"]
  launch_configuration      = "${aws_launch_configuration.jenkins_worker_linux.name}"
  termination_policies      = ["OldestLaunchConfiguration"]
  wait_for_capacity_timeout = "10m"
  default_cooldown          = 60

  tags = [
    {
      key                 = "Name"
      value               = "jenkins_worker_linux"
      propagate_at_launch = true
    },
    {
      key                 = "class"
      value               = "enkins_worker_linux"
      propagate_at_launch = true
    },
  ]
}