provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

#data "aws_availability_zones" "available" {}


#-------------VPC-----------

resource "aws_vpc" "springpc_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "springpc_vpc"
  }
}

#internet gateway

resource "aws_internet_gateway" "springpc_internet_gateway" {
  vpc_id = aws_vpc.springpc_vpc.id

  tags = {
    Name = "springpc_igw"
  }
}

# Route tables

resource "aws_route_table" "springpc_public_rt" {
  vpc_id = aws_vpc.springpc_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.springpc_internet_gateway.id
  }

  tags = {
    Name = "springpc_public"
  }
}

resource "aws_default_route_table" "springpc_private_rt" {
  default_route_table_id = aws_vpc.springpc_vpc.default_route_table_id

  tags = {
    Name = "springpc_private"
  }
}

resource "aws_subnet" "springpc_public1_subnet" {
  vpc_id                  = aws_vpc.springpc_vpc.id
  cidr_block              = var.cidrs["public1"]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "springpc_public1"
  }
}


#

# Subnet Associations

resource "aws_route_table_association" "springpc_public_assoc" {
  subnet_id      = aws_subnet.springpc_public1_subnet.id
  route_table_id = aws_route_table.springpc_public_rt.id
}

#Security groups

resource "aws_security_group" "springpc_jenk_sg" {
  name        = "springpc_jenk_sg"
  description = "Used for access to the dev instance"
  vpc_id      = aws_vpc.springpc_vpc.id

  #SSH

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.localip]
  }

  #HTTP

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.localip]
  }
    ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = [var.localip]
  }
    ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = [var.localip]
  }
   
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#-----JENK SERVER--------

#key pair

resource "aws_key_pair" "wp_auth" {
	key_name = var.key_name
	public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCq5bqH/YT4BT//zqkcstJHOajtZXpS+2xKQau0XbaN5JTBjLNm9dxUrUdvBSghJVxenJqzAQrFJnhXZ9RIX8welMSdbN4EC9545VUxwONWwYGKl66lZF/gITUOv9s1QIGIKCDVHxz6HgCEulrsjkrcwRy/HNhGMOpQ9I1DGjpq454ZC3mSAFQrYE+Q7vcFa6KfHQYnncBKFlSlb5UMmC6ckxgkq/xtE3ZGk9JdUynBpOahDFn0EmWd7d5kQDoeD0+mGxI9vF8ZgkGZQv/JgYyeN0Zlb+FOTcRjwhqUXY4c6auEQXkzAUJol3JHIqsR1vtHgYjD/4fr6E3U4j/nXCLp v@v-VirtualBox"	
}

resource "aws_instance" "springpc_jenk" {
  instance_type = var.dev_instance_type
  ami           = var.dev_ami

  tags = {
    Name = "springpc_jenk"
  }

  key_name               = aws_key_pair.wp_auth.id
  vpc_security_group_ids = [aws_security_group.springpc_jenk_sg.id]
  #iam_instance_profile   = aws_iam_instance_profile.s3_access_profile.id
  subnet_id              = aws_subnet.springpc_public1_subnet.id

    provisioner "local-exec" {
    command = <<EOD
cat <<EOF > jenk-host
[jenk] 
${aws_instance.springpc_jenk.public_ip} 
EOF
EOD
}
}