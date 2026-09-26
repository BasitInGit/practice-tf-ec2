resource "aws_security_group" "practice_ec2_sg" {
  name        = "practice-ec2-sg"
  description = "security group for practice app"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "practice_ec2_sg_ssh" {
  type              = "ingress"
  description       = "ssh access"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.practice_ec2_sg.id
}

resource "aws_security_group_rule" "practice_ec2_sg_http" {
  type              = "ingress"
  description       = "http access"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.practice_ec2_sg.id
}

resource "aws_security_group_rule" "practice_ec2_sg_outbound" {
  type              = "egress"
  description       = "outbound access"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.practice_ec2_sg.id
}