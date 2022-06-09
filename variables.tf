variable "AMI1" {
    type = map
    default = {
        al-arm64 = "ami-0adfc82c1ad9f327b"
        ubuntu-arm64 = "ami-0d7beeabef1d43e86"
    }
}

variable "AWS_Region" {
    default = "eu-north-1"
}

variable "instance_type" {
    default = "t4g.micro"
}

variable "vpc_cidr_block" {
    default = "10.10.0.0/16"
}

variable "availability_zones" {
    default = {
        eu-north-1a = 1
        eu-north-1b = 2
        eu-north-1c = 3
    }
}

variable "web_key_name" {
    default = "lunakey"
}
