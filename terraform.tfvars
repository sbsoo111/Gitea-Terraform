region              = "ap-southeast-1"  # Replace with your desired region

security_groups     = ["sg-00c2cae763ecdb5bb"]  # Replace with your security group IDs
subnets             = ["subnet-03edf358a37956c7f", "subnet-0480c548e93758c2c"]  # Replace with your subnet IDs

target_group_name   = "Gitea-ALB-TG"  # Replace with your desired target group name

instance_type       = "t2.micro"   # Replace with your desired instance type
subnet_id           = "subnet-03edf358a37956c7f"  # Replace with your desired subnet ID
key_name            = "GiteaEC2-keypair"  # Replace with your key pair name

ssl_cert_path       = "./gitea-docker-config/gitea.crt"  # Path to your SSL certificate file
ssl_key_path        = "./gitea-docker-config/gitea.key"  # Path to your SSL private key file

private_key_path    = "./gitea-docker-config/GiteaEC2-keypair.pem"  # Path to your SSH private key file

certificate_arn     = "arn:aws:acm:ap-southeast-1:211125364515:certificate/c06e93ab-dcb5-4b6c-afcf-d6280358a3c3"  # Replace with your ACM certificate ARN

instance_name       = "SGDC1-S-GITEA001"  # Replace with your desired instance name


alb_arn           = "arn:aws:elasticloadbalancing:ap-southeast-1:211125364515:loadbalancer/app/Gitea-ALB/7a0d54e2dd981f97"
listener_arn      = "arn:aws:elasticloadbalancing:ap-southeast-1:211125364515:listener/app/Gitea-ALB/7a0d54e2dd981f97/a949aff039dad2e7"
target_group_arn  = "arn:aws:elasticloadbalancing:ap-southeast-1:211125364515:targetgroup/Gitea-ALB-TG/1ada57b91e90d3b6"
