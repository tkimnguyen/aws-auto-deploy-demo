# Create salt master
resource "aws_instance" "salt_master" {
  instance_type = "t3.small"
  key_name = "cloud-conf-demo-sfup"
  ami = "ami-0a313d6098716f372"
  iam_instance_profile = "${aws_iam_instance_profile.read_ec2_tags.id}"
  associate_public_ip_address = true
  availability_zone = "${var.region}a"
  subnet_id = "${aws_subnet.servers.id}"
  user_data = "${file("templates/master-userdata.tmpl")}"
  vpc_security_group_ids = [
    "${aws_security_group.salt-acl.id}",
    "${aws_security_group.ssh-acl.id}"
  ]
  root_block_device {
    volume_size = 20
  }
  tags = {
    Name = "salt-master"
    Managed = "terraform"
  }
}

# Create EC2 instances based on info from variables.tf
resource "aws_instance" "demo_servers" {
  instance_type = "${lookup(var.instance_size, element(var.vm_names, count.index), "t3.small")}"
  key_name = "cloud-conf-demo-sfup"
  count = "${length(var.vm_names)}"
  ami = "${lookup(var.instance_ami, element(var.vm_names, count.index), "ami-0de53d8956e8dcf80")}"
  availability_zone = "${var.region}a"
  subnet_id = "${aws_subnet.servers.id}"
  iam_instance_profile = "${aws_iam_instance_profile.read_ec2_tags.id}"
  user_data = "${data.template_file.init.rendered}"
  vpc_security_group_ids = [
    "${aws_security_group.web-acl.id}",
    "${aws_security_group.ssh-acl.id}"
  ]
  # Pull disk size from variables file
  root_block_device {
    volume_size = "${lookup(var.data_disk_size, element(var.vm_names, count.index), 100)}"
  }
  tags = {
    Name = "${element(var.vm_names, count.index)}"
    Managed = "terraform"
    Roles = "${lookup(var.role, element(var.vm_names, count.index))}"
  }
}

# Render the minion userdata script with the correct info
data "template_file" "init" {
  template = "${file("${path.module}/templates/minion-userdata.tmpl")}"
  vars = {
    salt_master = "${aws_instance.salt_master.private_ip}"
  }
}

