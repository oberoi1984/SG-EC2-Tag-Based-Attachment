provider "aws" {
  region  = "ap-south-1"  # Replace with your desired region
  profile = "default"     # Replace with your actual AWS profile if you want to use a named profile
}

# Fetch details about EC2 instances with specific tags
data "aws_instances" "target_instances" {
  filter {
    name   = "tag:${var.instance_tag_key}"
    values = [var.instance_tag_value]
  }
  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
}

data "aws_network_interface" "instance_eni" {
  count = length(data.aws_instances.target_instances.ids)
  filter {
    name   = "attachment.instance-id"
    values = [data.aws_instances.target_instances.ids[count.index]]
  }
}

resource "aws_network_interface_sg_attachment" "attach_sg" {
  count              = length(data.aws_instances.target_instances.ids)
  security_group_id  = var.security_group_id
  network_interface_id = data.aws_network_interface.instance_eni[count.index].id
}

