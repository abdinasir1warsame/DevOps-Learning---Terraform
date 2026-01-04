output "lb_address" {
  value = aws_lb.react-app-lb.dns_name
}
output "instance_id" {
  value = [aws_instance.react-app-1.id, aws_instance.react-app-2.id]

}
