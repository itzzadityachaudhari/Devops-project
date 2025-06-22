terraform {
    required_provider{
        aws = {
            source = "hasicorp/aws"
            version = "~>4.0"
        }
    }
     backend "s3"{
        key = "aws/ec2-deploy/terraform.tfstate"
     }
}

provider "aws"{
    region = var.region
}
resource "aws_instance" "name" {
    ami = "ami-020cba7c55df1f615"
    instance_type = "t2.micro"
    key_name = aws_key_pair.deployer.key_name
    vpc_security_group_ids = [aws_security_group.maingroup.id]
    iam_instance_profile = aws_iam_instance_profile.ec2-profile.name
    connection{
        type = "ssh"
        host = self.public_ip
        user = "ubuntu"
        private_key = var.private_key
        timeout = "4n"
    }
    tags = {
        "name" = "Deployaadi"
    }
    resource "aws_iam_instance_profile" "ec2-profile"
    name = "ec2-instance"
    role = "aadi"
}
resource "aws_seccurity_group" "maingroup"{
    egress = [
        cidr_blocks = ["0.0.0.0/0"]
        description = ""
        from_port = 0
        ipv6_cidr_blocks = []
        prifix_list_ids = []
        protocol = "-1"
        seccurity_group = []
        self = false
        to_port = 0

    ]
    ingress = [
        {
        cidr_blocks = ["0.0.0.0/0", ]
        description = ""
        from_port = 22
        ipv6_cidr_blocks = []
        prifix_list_ids = []
        protocol = "tcp"
        seccurity_group = []
        self = false
        to_port = 22
        },
        {
        cidr_blocks = ["0.0.0.0/0", ]
        description = ""
        from_port = 80
        ipv6_cidr_blocks = []
        prifix_list_ids = []
        protocol = "tcp"
        seccurity_group = []
        self = false
        to_port = 22

        }


    ]
}
resource "aws_key_pair" "deployer"{
    key_name = var.key_name
    public_key = var.public_key
}
output "instance_public_ip"{
    value = aws_instance.server.public_ip
    sensitive = true
}
