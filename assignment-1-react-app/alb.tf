# Application Load Balancer (ALB) deployed in public subnets with a security group
resource "aws_lb" "react-app-lb" {
  name                       = "react-app-lb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.alb_sg.id]
  subnets                    = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]
  enable_deletion_protection = true

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "react-app" {
  load_balancer_arn = aws_lb.react-app-lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}


# Target group defining the backend EC2 instances and health checks
resource "aws_lb_target_group" "target_group" {
  name        = "tf-example-lb-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.vpc-01.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

# Attach EC2 instance 1 to the target group
resource "aws_lb_target_group_attachment" "instance1" {
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = aws_instance.react-app-1.id
  port             = 80
}

# Attach EC2 instance 2 to the target group
resource "aws_lb_target_group_attachment" "instance2" {
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = aws_instance.react-app-2.id
  port             = 80
}
