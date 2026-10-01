resource "aws_instance" "practice_ec2" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  tags = {
    Name = "practice-app-${var.environment}"
  }
  vpc_security_group_ids = [aws_security_group.practice_ec2_sg.id]
  user_data              = filebase64("userdata.sh")
}