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
  key_name = aws_key_pair.demo_key.key_name

  vpc_security_group_ids = [
    aws_security_group.my_security_group.id
  ]

  instance_type = "t3.micro"
  ami           = "ami-0011550b539717e2a"

  subnet_id = "subnet-06e5b20132fa8cb5e"

  root_block_device {
    volume_size = 15
    volume_type = "gp3"
  }

  tags = {
    Name = "Demo-EC2"
  }
}
