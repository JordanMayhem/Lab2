# The below code is for a spot instance fleet. Using lowestPrice allocation strategy 
# it will launch 2 spot instances in 2 different Availability Zones, in the same pool. We can implement 
# lowestPrice in combination with InstancePoolsToUseCount so that the fleet selects the Spot
# pools with the lowest price and launches Spot Instances across the number of Spot
# pools that we specify.  
  
# To create a cheap and diversified fleet, use the lowestPrice strategy in combination with
# InstancePoolsToUseCount. You can use a low or high number of Spot pools across which to
# allocate your Spot Instances. For example, if you run batch processing, we recommend specifying a 
# low number of Spot pools (for example, InstancePoolsToUseCount=2) to ensure that your queue always
# has compute capacity while maximizing savings. If you run a web service, we recommend specifying a
# high number of Spot pools (for example, InstancePoolsToUseCount=10) to minimize the impact if a 
# Spot Instance pool becomes temporarily unavailable.
  
  
resource "aws_spot_fleet_request" "fleetRequest" {
  iam_fleet_role  = "arn:aws:iam::342283246872:role/aws-ec2-spot-fleet-tagging-role"
  spot_price      = "0.005"
  target_capacity = 2
  wait_for_fulfillment = true
# allocation_strategy = "lowestPrice " (current default)
# InstancePoolsToUseCount = 2
# valid_until     = "2019-11-04T20:44:20Z"
# spot_type = "one-time or persistent(default) "

  
# Spot Instance 1 
  launch_specification {
    instance_type     = "t2.micro"
    ami               = "ami-0b2f56158ac6590fe"
    associate_public_ip_address  = true
    key_name          = "newInstanceKey"
    
    availability_zone = "  ----> "${var.availability_zone}"       us-west-2a  <---- "
  
  
    subnet_id     = "${aws_subnet.private_1.id}"
    security_groups = ["${aws_security_group.WebSrvrSG.id}"]
    
    tags = {
      Name = "WebSpotSrvr1"
      Type = "Scheduled"
    }
  }

# Spot Instance 2
  launch_specification {
    instance_type     = "t2.micro"
    ami               = "ami-0b2f56158ac6590fe"
    associate_public_ip_address  = true
    key_name          = "newInstanceKey"
    
    availability_zone = "  ----> "${var.availability_zone}"       us-west-2b <----  "
  
  
    subnet_id     = "${aws_subnet.private_2.id}"
    security_groups = ["${aws_security_group.WebSrvrSG.id}"]
    
    tags = {
      Name = "WebSpotSrvr2"
      Type = "Scheduled"
    }
  }

  tags = {
    Name = "Git-Legion-Spot-Fleet"
  }
}
  
  
#Creating Security Group for the above spot instances.
  
resource "aws_security_group" "WebSrvrSG" {
  vpc_id  = "${aws_vpc.VPC_Official.id}"
  name = "WebSrvrSG"
  description = "WebServerSecurityGroup"
  
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow All Traffic to port 80"
    }
     
   ingress {
    from_port = 443
    protocol = "tcp"
    to_port = 443
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow All Traffic to port 443"
    }
    
   ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow All Traffic to port 443"
    }
    
   egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }    
}
