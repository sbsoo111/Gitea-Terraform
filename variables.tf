variable "region" {
  description = "AWS region"
  type        = string
}

variable "security_groups" {
  description = "Security groups for the Application Load Balancer and EC2 instance"
  type        = list(string)
}

variable "subnets" {
  description = "Subnets for the Application Load Balancer"
  type        = list(string)
}

variable "target_group_name" {
  description = "Name of the target group"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for the EC2 instance"
  type        = string
}

variable "key_name" {
  description = "Key pair name for accessing the EC2 instance"
  type        = string
}

variable "ssl_cert_path" {
  description = "Path to the SSL certificate file"
  type        = string
}

variable "ssl_key_path" {
  description = "Path to the SSL private key file"
  type        = string
}

variable "private_key_path" {
  description = "Path to the private key for SSH access to EC2 instance"
  type        = string
}

variable "certificate_arn" {
  description = "ARN of the ACM certificate for HTTPS listener on ALB"
  type        = string
}

variable "instance_name" {
  description = "Name of the EC2 instance"
  type        = string
}
