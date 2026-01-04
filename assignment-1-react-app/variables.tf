variable "ami_id" {
  type        = string
  description = "The ami id"
  default     = "ami-099400d52583dd8c4"
}
variable "instance_type" {
  type        = string
  description = "EC2 instance type for the web server"
  default     = "t3.micro"
}
