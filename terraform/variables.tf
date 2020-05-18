# Default region
variable "region" {
  type = string
  default = "us-east-1"
}

# List of all VMs to be managed, human readable
variable "vm_names" {
  default = [
    "plone-app01",
  ]
}

# How much storage the server should have, defaults to 100GB
variable "data_disk_size" {
  type = map(string)
  default = {
    plone-app01 = "150"
  }
}

# Instance sizes, defaults to t3.small
variable "instance_size" {
  type = map(string)
  default = {
#    plone-app01 = "t3.medium"
    plone-app01 = "t3.small"
  }
}

# The AMI to use for each instance.  Defaults to Amazon Linux 2
variable "instance_ami" {
  type = map(string)
  default = {
    plone-app01 = "ami-0a313d6098716f372" # Ubuntu 18.04
    static-site = "ami-0a313d6098716f372" # Ubuntu 18.04
  }
}

# Determines what type of server is created
variable "role" {
  type = map(string)
  default = {
    static-site = "static"
    plone-app01 = "plone"
  }
}
