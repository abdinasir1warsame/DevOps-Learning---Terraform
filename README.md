# Terraform AWS Infrastructure – High Availability ALB & EC2 Setup

## Overview

This Terraform project provisions a **highly available web application architecture** in AWS, following best practices using **modules, variables, and outputs**. The setup allows me to manage, scale, and reuse resources effectively.

- **VPC with public and private subnets** across two availability zones (AZs)
- **Internet Gateway** for public access
- **NAT Gateways** for private subnet internet access
- **Security groups** for EC2 and ALB
- **Application Load Balancer (ALB)** for distributing traffic
- **EC2 instances** in private subnets
- **IAM Role & SSM Agent** for secure instance management

The architecture is designed for **high availability** by distributing resources across **two AZs**, ensuring no single point of failure.

---

## Architecture Diagram (Text-Based)

```
                          Internet
                             |
                        [Internet Gateway]
                             |
                   -------------------------
                   |                       |
            Public Subnet 1           Public Subnet 2
                   |                       |
           [ALB - Application Load Balancer]
                   |
           -----------------------
           |                     |
    Private Subnet 1       Private Subnet 2
           |                     |
      EC2 Instance 1         EC2 Instance 2
           |                     |
       [SSM Enabled]         [SSM Enabled]
```

**High Availability (HA) Highlights:**

- Two **public subnets** across AZ1 & AZ2 for ALB & NAT gateways.
- Two **private subnets** across AZ1 & AZ2 for EC2 instances.
- ALB spreads traffic evenly across **EC2 instances in different AZs**.
- **NAT Gateways** in each AZ ensure outbound internet access even if one AZ fails.

---

## Step-by-Step Terraform Implementation

### 1. Provider Configuration

Configured AWS provider in `provider.tf`:

```hcl
provider "aws" {
  region = "eu-west-2"
}
```

### 2. Module Implementation

In `main.tf`, I call the module to deploy all resources:

```hcl
module "web_infra" {
  source = "./terraform-aws-web-infrastructure"
}
```

Outputs are retrieved from the module:

```hcl
output "lb_address" {
  value = module.web_infra.lb_address
}
output "instance_id" {
  value = module.web_infra.instance_id
}
```

### 3. Variables

All configurable parameters are defined in `variables.tf`:

```hcl
variable "ami_id" {
  type        = string
  description = "AMI ID for EC2 instances"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
}
```

This ensures flexibility and reuse across multiple environments.

### 4. Networking

VPC, subnets, IGW, NAT gateways, and route tables are defined in `network.tf` and `route-tables.tf`.

### 5. Security

Security groups are defined in `security_group.tf`, controlling inbound/outbound traffic for ALB and EC2.

### 6. IAM and SSM

IAM roles, policies, and instance profiles are defined in `iam.tf` to enable SSM connectivity.

### 7. EC2 and ALB

EC2 instances and ALB with target groups and listeners are defined in `ec2.tf` and `alb.tf`. User data is applied via `user-data.yaml`.

### 8. User Data Script

Installed nginx and SSM agent, enabled services, and created a simple HTML page:

```yaml
#cloud-config
package_update: true
package_upgrade: true
packages:
  - nginx
  - amazon-ssm-agent
runcmd:
  - [systemctl, enable, nginx]
  - [systemctl, start, nginx]
  - [systemctl, enable, amazon-ssm-agent]
  - [systemctl, start, amazon-ssm-agent]
write_files:
  - path: /usr/share/nginx/html/index.html
    content: |
      <!DOCTYPE html>
      <html>
      <head><title>React App Instance</title></head>
      <body>
        <h1>Random Nginx Page: $(date +%s%N | sha256sum | head -c 20)</h1>
        <p>Instance ID: $(curl -s http://169.254.169.254/latest/meta-data/instance-id)</p>
        <p>Launch Time: $(date)</p>
      </body>
      </html>
    owner: root:root
    permissions: '0644'
```

### 9. Outputs

All important outputs like ALB DNS and EC2 instance IDs are defined in `output.tf` for easy reference.

### 10. Deployment Workflow

1. `terraform init` → Initialize providers and modules
2. `terraform plan` → Preview changes
3. `terraform apply` → Deploy resources
4. `terraform destroy` → Clean up resources

---

## Notes

- This setup follows **Terraform best practices** using modules, variables, and outputs.
- High availability is ensured by distributing resources across **two AZs**.
- Private EC2 instances are accessible via **SSM**.
- ALB provides HTTP load balancing with health checks.
- Security groups restrict access appropriately.
