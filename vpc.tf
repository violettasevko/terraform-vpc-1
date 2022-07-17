provider "aws" {
    region = var.AWS_Region
}

resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr_block
  assign_generated_ipv6_cidr_block = "true"

  tags = {
    Name = "vpc"
    owner = "violetta"
  }
}

resource "aws_subnet" "subnet_public" {
    for_each = var.availability_zones

    vpc_id = "${aws_vpc.vpc.id}"


    availability_zone = each.key
    cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, each.value)
    ipv6_cidr_block   = cidrsubnet(aws_vpc.vpc.ipv6_cidr_block, 8, each.value + 6)
 
    map_public_ip_on_launch = "true" //it makes this a public subnet
    assign_ipv6_address_on_creation = true

    tags = {
        Name = "subnet-public-${each.value}"
        owner = "violetta"
    }
}

resource "aws_subnet" "subnet_private" {
    for_each = var.availability_zones

    vpc_id = "${aws_vpc.vpc.id}"

    availability_zone = each.key
    cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, each.value + 10)

    map_public_ip_on_launch = "true" //it makes this a private subnet

    tags = {
        Name = "subnet-private-${each.value}"
        owner = "violetta"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = "${aws_vpc.vpc.id}"
    tags = {
        Name = "igw"
        owner = "violetta"
    }
}

resource "aws_route_table" "public-rt" {
    vpc_id = "${aws_vpc.vpc.id}"
    
    route {
        //associated subnet can reach everywhere
        cidr_block = "0.0.0.0/0"
        //CRT uses this IGW to reach internet
        gateway_id = "${aws_internet_gateway.igw.id}" 
    }
    
    tags = {
        Name = "public-rt"
        owner = "violetta"
    }
}

resource "aws_route_table_association" "rta-public-subnet"{
#    count = length(aws_subnet.subnet_public)
    for_each = var.availability_zones

#    subnet_id = aws_subnet.subnet_public[count.index].id
    subnet_id = aws_subnet.subnet_public[each.key].id
    route_table_id = "${aws_route_table.public-rt.id}"
}

resource "aws_security_group" "webserver" {
    vpc_id = "${aws_vpc.vpc.id}"
    name = "Webserver"
    
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
        description = "access all ipv4"
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        ipv6_cidr_blocks = ["::/0"]
        description = "access all ipv6"
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        // This means, all ip address are allowed to ssh ! 
        // Do not do it in the production. 
        // Put your office or home address in it!
        cidr_blocks = ["0.0.0.0/0"]
        description = "SSH port for all ipv4"
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        // This means, all ip address are allowed to ssh ! 
        // Do not do it in the production. 
        // Put your office or home address in it!
        ipv6_cidr_blocks = ["::/0"]
        description = "SSH port for all ipv6"
    }
    //If you do not add this rule, you can not reach the NGIX  
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "HTTP port for all ipv4"
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        ipv6_cidr_blocks = ["::/0"]
        description = "HTTP port for all ipv6"
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "HTTPS port"
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        ipv6_cidr_blocks = ["::/0"]
        description = "HTTPS port"
    }
    tags = {
        Name = "webserver"
        owner = "violetta"
    }
}




