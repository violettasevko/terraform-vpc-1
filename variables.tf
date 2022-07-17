variable "AMI1" {
    type = map
    default = {
        al-arm64 = "ami-0ceb85bb30095410b"
        ubuntu-arm64 = "ami-07f16fb14274bfc76"
    }
}

variable "AWS_Region" {
    default = "eu-central-1"
}

variable "instance_type" {
    default = "t4g.micro"
}

variable "vpc_cidr_block" {
    default = "10.60.0.0/16"
}

variable "availability_zones" {
    default = {
        eu-central-1a = 1
        eu-central-1b = 2
        eu-central-1c = 3
    }
}

variable "web_key_name" {
    default = "key123"
}
