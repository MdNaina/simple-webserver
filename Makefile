TERRAFORM_DIR = infrastructure
ANSIBLE_DIR = ansible
TFVARS_FILE = terraform.tfvars
SSH_KEY_NAME := my_key
SSH_KEY_DIR := ssh_keys

export TF_VAR_SSH_PUBLIC_KEY = $(shell cat $(SSH_KEY_DIR)/$(SSH_KEY_NAME).pub)

.PHONY: init plan apply ansible

init:
	@cd $(TERRAFORM_DIR) && terraform init

plan: init
	@cd $(TERRAFORM_DIR) && terraform plan -var-file=../$(TFVARS_FILE)

apply: init
	@cd $(TERRAFORM_DIR) && terraform apply -var-file=../$(TFVARS_FILE) -auto-approve

console: init
	@cd $(TERRAFORM_DIR) && terraform console -var-file=../$(TFVARS_FILE)

output:
	@cd $(TERRAFORM_DIR) && terraform output

ansible:
	@cd $(ANSIBLE_DIR) && ansible-playbook -i ../inventory.ini playbooks/main.yml

deployment:
	@cd $(ANSIBLE_DIR) && ansible-playbook -i ../inventory.ini playbooks/deployment.yml

generate_ssh_key:
	@mkdir -p $(SSH_KEY_DIR)
	@ssh-keygen -t rsa -b 2048 -f $(SSH_KEY_DIR)/$(SSH_KEY_NAME) -N ""

clean:
	@cd $(TERRAFORM_DIR) && terraform destroy -var-file=../$(TFVARS_FILE)
	@rm -f $(TERRAFORM_DIR)/.terraform/terraform.tfstate*
	@rm -rf $(SSH_KEY_DIR)

help:
	@echo "Available targets:"
	@echo "  make init          - Initialize Terraform"
	@echo "  make plan          - Generate Terraform execution plan"
	@echo "  make apply         - Apply Terraform changes"
	@echo "  make ansible       - Run Ansible playbook"
	@echo "  make clean         - Destroy infrastructure"
	@echo "  make help          - Show this help message"
