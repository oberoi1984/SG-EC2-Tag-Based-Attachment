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

data "aws_network_interface" "instance_eni" {                         # Data block to retrieve network interfaces attached to each running instance identified by the specified tags.
  count = length(data.aws_instances.target_instances.ids)             # Using count to dynamically create multiple entries based on the number of instances found.
  filter {                                                            # Filter to find network interfaces attached to each instance by its ID.
    name   = "attachment.instance-id"
    values = [data.aws_instances.target_instances.ids[count.index]]   # Accesses each instance ID found in the "target_instances" data block using count.index.
  }
}

resource "aws_network_interface_sg_attachment" "attach_sg" {                       # Resource block to attach a security group to each network interface found for the specified instances.
  count              = length(data.aws_instances.target_instances.ids)             # The count is used to iterate over each network interface found.
  security_group_id  = var.security_group_id                                       # Specifies the security group ID to attach, passed in as a variable.
  network_interface_id = data.aws_network_interface.instance_eni[count.index].id   # Specifies the ID of the network interface for each instance, using the count index to match.
}

