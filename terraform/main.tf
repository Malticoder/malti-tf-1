data "template_file" "userdata" {
  template = file("./userdata.sh")
  vars = {
    BRANCH_NAME = var.branch_name
  }
}


resource "aws_instance" "web" { 
  ami = "ami-05ab12222a9f39021"
  instance_type = "t2.micro"
  security_groups = [ aws_security_group.app_sg.name ]
  user_data_replace_on_change = true
  key_name = "ssh-key-terraform"
  #user_data = file("./userdata.sh")
  user_data = "${base64encode(data.template_file.userdata.rendered)}"
  tags = {
  	Name = "web-server-${var.branch_name}"
  }
connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("./id_rsa")
    host        = self.public_ip
  }
  provisioner "file" {
    source = "../project-code"
    destination = "/home/ec2-user"
  }
  }


resource "aws_security_group" "app_sg" {
  name        = "security-group-${var.branch_name}"
  description = "Allow SSH and HTTP"

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


#output "Publi_Ip_Of_Ec2" {
#  value = aws_instance.web.public_ip 
#}

#output "EC2_Arn" {
#  value = aws_instance.web.arn  
#}

output "_____what_is_next_step_____" {
  value = "Please wait for 4-5 minutes while we get the website ready.\n\nYou can open the website at http://${aws_instance.web.public_ip}"
}