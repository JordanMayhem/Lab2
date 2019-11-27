resource "aws_spot_instance_request" "web" {

  availability_zone = "${var.availability_zone}"
  
  ami = "ami-0b2f56158ac6590fe"
  
  instance_type = "t2.micro"
  
  subnet_id     = "${aws_subnet.private_1.id}"
  
  security_groups = ["${aws_security_group.WebSrvrSG.id}"]
  
  associate_public_ip_address  = true
  
  key_name      = "newInstanceKey"
  
  
  
  spot_price = "${var.spot_price}"
  
  wait_for_fulfillment = true
  
  spot_type = "one-time"

  root_block_device {
    volume_size = "${var.root_ebs_size}"
  }
