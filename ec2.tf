# Key-Pair for SSH
resource aws_key_pair demo_key{
    public_key = file("ec2_key.pub")
    key_name = "ec2_key"
}


# VPC 

resource "aws_default_vpc" "default"{

}

#Security Group

resource aws_security_group my_security_group{
    name = "automate-sg"
    vpc_id = aws_default_vpc.default.id #interpolation
    
    #inbound rules 

    ingress{
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSh traffic allow"
    }

    ingress{
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow http traffic"
    }

    egress{
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow all outbound traffic"
    }


    tags = {
        Name = "automate-sg"
    }
}



#EC2

resource "aws_instance" "my_ec2" {

  #Meta Arguments
  for_each = tomap({
    Demo-EC2-1 = "t3.micro"
    Demo-EC2-2 = "t3.micro"
  })

 depends_on = [
  aws_security_group.my_security_group
 ]

  key_name = aws_key_pair.demo_key.key_name

  vpc_security_group_ids = [
    aws_security_group.my_security_group.id
  ]

  instance_type = each.value
  ami = var.ec2_ami

  subnet_id = var.ec2_subnet_id

  root_block_device {
    volume_size = var.ec2_storage_size
    volume_type = "gp3"
  }

  user_data = file("install_nginx.sh")

  tags = {
    Name = each.key
  }
}
