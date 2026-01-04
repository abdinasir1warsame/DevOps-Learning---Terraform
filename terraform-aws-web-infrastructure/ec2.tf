resource "aws_instance" "instance-01" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.instance-sg.id]
  subnet_id              = aws_subnet.private_subnet1.id
  user_data_base64       = filebase64("${path.module}/user-data.yaml")
  tags                   = { Name = "app-ec2-1" }
  iam_instance_profile   = aws_iam_instance_profile.ssm_profile.name


}

resource "aws_instance" "instance-02" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.instance-sg.id]
  subnet_id              = aws_subnet.private_subnet2.id
  user_data_base64       = filebase64("${path.module}/user-data.yaml")
  tags                   = { Name = "app-ec2-2" }
  iam_instance_profile   = aws_iam_instance_profile.ssm_profile.name


}
