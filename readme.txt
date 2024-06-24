note: 

1. this repository had removed all the confidential information, you need to generate your own:
    a. ssl cert and it's private key for HTTPS
    b. GiteaEC2-keypair.pem and GiteaEC2-keypair.ppk for the setup_gitea.sh script to remote execute in the instance
2. you need to install aws cli before running the terraform script.
3. run aws config to enter your aws access id and key.
4. run terraform init to initialize the enviroment.
5. that's few AWS component need to be manually created such as vpc_id, subnet_id, security_groups.
   please refer to terraform.tfvars for refer on which need to get ready.
6. you need to change the variable in the terraform.tfvars to match with your infra enviroment.
7. run "terraform plan" from the directory of this project folder.
8. if that's no error, you are now ready to execute "terraform apply".
9. if the script run successfully, you may get the ALB dns name of the ALB and create the cname in the domain name.
10. check the site https://yourdomain.com should able to access the initial gitea web setup form. 

you may check the sample: https://gitea.cloudki.com


What does this script created?
1. ALB
2. EC2 instance
3. ALB Listhener
4. ALB Target group
5. Attach the new instance into ALB target group
6. copy few setup files into the new EC2 instance
7. Setup docker and docker-compose gitea in the new EC2 Instance.
8. configure the basic for https and gitea docker container setup site.
9. clean up the folder in the ec2 instance (docker host). 