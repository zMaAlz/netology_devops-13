variable "YC_TOKEN" {
  default = ""
}

variable "YC_CLOUD_ID" {
  default = ""
}

variable "YC_FOLDER_ID" {
  default = ""
}

variable "subnet_public_cidr" {
  default = "192.168.10.0/24"
}

variable "subnet_private_cidr" {
  default = "192.168.20.0/24"
}

variable "nat_instance_ip" {
  default = "192.168.10.254"
}
