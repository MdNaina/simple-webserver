# Simple webserver changelog

## 2024-01-10

### Summary
 - create simple web server using terraform and ansible
 - terraform for infrastructure
 - ansible for configuration management
 - create ec2 instance with opened ports 22, 80, and 443
 - install apache using ansible


## 2024-01-11

### Summary
 - create resueable web_server terraform module
 - move the exiting using `terraform state mv source destination` this command
    - `terraform state mv aws_instance.webserver module.web_server.aws_instance.webserver`
    - `terraform state mv aws_security_group.sg module.web_server.aws_security_group.sg`
 - update main.tf with outputs and data blocks
 - on the ansible create deployment playbook and role
    - to copy local src/index.html to remote /var/www/html/index.html
 - add deployment script in Makefile to ease the deployment


## 2024-01-15

### Summary
 - Create a s3 backend and migrate state (S3 and DynamoDB)
 - migrate local state to s3 using `terraform init -migrate-state -lock=false`
