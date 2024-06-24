provider "aws" {
  region = var.region
}

# Define the AWS ALB
resource "aws_lb" "gitea_alb" {
  name                           = "Gitea-ALB"
  internal                       = false
  load_balancer_type             = "application"
  security_groups                = var.security_groups
  subnets                        = var.subnets

  enable_deletion_protection     = false  
  enable_cross_zone_load_balancing = true
  enable_http2                   = true
  idle_timeout                   = 60
  ip_address_type                = "ipv4"
  xff_header_processing_mode     = "append"

  tags = {
    Name = "Gitea-ALB"
  }
}

# Define the AWS ALB Target Group
resource "aws_lb_target_group" "gitea_tg" {
  name                              = var.target_group_name
  port                              = 443
  protocol                          = "HTTPS"
  vpc_id                            = aws_lb.gitea_alb.vpc_id  # Use ALB's VPC ID
  target_type                       = "instance"

  health_check {
    enabled             = true
    interval            = 30
    port                = "traffic-port"
    protocol            = "HTTPS"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}

# Define the AWS EC2 instance
resource "aws_instance" "gitea_instance" {
  ami                          = "ami-04c913012f8977029"
  instance_type                = var.instance_type
  subnet_id                    = var.subnet_id
  key_name                     = var.key_name
  security_groups              = ["sg-00c2cae763ecdb5bb"]
  associate_public_ip_address  = true
  tags = {
    Name = var.instance_name
  }

  # Copy the setup script
  provisioner "file" {
    source      = "gitea-docker-config/docker-compose.yml"
    destination = "/home/ec2-user/docker-compose.yml"
  }

  provisioner "file" {
    source      = "gitea-docker-config/setup_gitea.sh"
    destination = "/home/ec2-user/setup_gitea.sh"
  }


  provisioner "file" {
    source      = "gitea-docker-config/app.ini"
    destination = "/home/ec2-user/app.ini"
  }


  # Provisioner to copy SSL certificate and key during instance creation
  provisioner "file" {
    source      = var.ssl_cert_path
    destination = "/home/ec2-user/gitea.crt"
  }

  provisioner "file" {
    source      = var.ssl_key_path
    destination = "/home/ec2-user/gitea.key"
  }

  # Provisioner to execute setup script after file transfer
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.private_key_path)
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 400 /home/ec2-user/gitea.key",
      "chmod +x /home/ec2-user/setup_gitea.sh",
      "sudo sh setup_gitea.sh"
    ]
  }
}

# Add the instance to the target group after it's created
resource "aws_lb_target_group_attachment" "gitea_tg_attachment" {
  target_group_arn = aws_lb_target_group.gitea_tg.arn
  target_id        = aws_instance.gitea_instance.id
  port             = 443
}

# Create HTTPS listener for ALB
resource "aws_lb_listener" "gitea_alb_listener443" {
  load_balancer_arn = aws_lb.gitea_alb.arn
  certificate_arn   = var.certificate_arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"

  tags = {
    Application = "Gitea"
  }

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.gitea_tg.arn
  }
}

# Create HTTP listener for ALB
resource "aws_lb_listener" "gitea_alb_listener80" {
  load_balancer_arn = aws_lb.gitea_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# Define outputs for easy access to instance details
output "instance_public_ip" {
  value = aws_instance.gitea_instance.public_ip
}

output "instance_private_ip" {
  value = aws_instance.gitea_instance.private_ip
}

output "alb_dns_name" {
  value = aws_lb.gitea_alb.dns_name
}