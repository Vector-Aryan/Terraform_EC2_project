variable "ec2_instance_type"{
    default = "t3.micro"
    type = string
}

variable "ec2_storage_size"{
    default = 15
    type = number
}

variable "ec2_ami"{
    default = "ami-0011550b539717e2a"
    type = string
}

variable "ec2_subnet_id"{
    default = "subnet-06e5b20132fa8cb5e"
    type = string
}