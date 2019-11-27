resource "aws_spot_instance_request" "web" {

  availability_zone = "${var.availability_zone}"
  
  ami = "ami-0b2f56158ac6590fe"
  
  instance_type = "${var.instance_type}"
  
  spot_price = "${var.spot_price}"
  
  wait_for_fulfillment = true
  
  spot_type = "one-time"

  root_block_device {
    volume_size = "${var.root_ebs_size}"
  }
