resource "aws_instance" "react-app-1" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  security_groups = [aws_security_group.react-app-sg.id]
  tags = {
    Name = "app-ec2-1"
  }
  subnet_id = aws_subnet.private_subnet1.id
}
resource "aws_instance" "react-app-2" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  security_groups = [aws_security_group.react-app-sg.id]
  tags = {
    Name = "app-ec2-2"
  }
  subnet_id = aws_subnet.private_subnet2.id
}
