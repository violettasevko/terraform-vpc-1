resource "aws_instance" "al-arm64" {
    #for_each = var.availability_zones

    ami = "${lookup(var.AMI1, "al-arm64")}"
    instance_type = var.instance_type
    # VPC
    subnet_id = aws_subnet.subnet_public["eu-central-1a"].id
    # Security Group
    vpc_security_group_ids = ["${aws_security_group.webserver.id}"]
    # the Public SSH key
    key_name = var.web_key_name
    #user_data = file("autoloadhttpd")
    
    tags = {
        Name = "al-arm64"
        owner = "violetta"        
    }
}