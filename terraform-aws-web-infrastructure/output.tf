output "lb_address" {
  value = aws_lb.alb-01.dns_name
}
output "instance_id" {
  value = [aws_instance.instance-01.id, aws_instance.instance-02.id]

}
