.PHONY: default validate plan apply destroy

IAM_ROLE="none"

default:
	@echo ""
	@echo "Runs Terraform validate, plan, and apply wrapping the workspace to use"
	@echo ""
	@echo "The following commands are available:"
	@echo " - plan               : runs terraform plan for an environment"
	@echo " - apply              : runs terraform apply for an environment"
	@echo " - destroy            : will delete the entire project's infrastructure"
	@echo ""
	@echo "The "ENV" environment variable needs to be set to dev, test, or prod."
	@echo ""
	@echo "Exmple usage:"
	@echo "  ENV=dev make plan"
	@echo ""


validate:
	$(call check_defined, ENV, Please set the ENV to plan for. Values should be dev, test, or prod)

	@echo "Initializing Terraform ..."
	@terraform init
	
	@echo 'Creating the $(value ENV) workspace ...'
	@-terraform workspace new $(value ENV)

	@echo 'Switching to the [$(value ENV)] environment ...'
	@terraform workspace select $(value ENV)

	@terraform validate

plan:
	$(call check_defined, ENV, Please set the ENV to plan for. Values should be dev, test, or prod)

	@echo "Initializing Terraform ..."
	@terraform init
	
	@echo 'Creating the $(value ENV) workspace ...'
	@-terraform workspace new $(value ENV)

	@echo 'Switching to the [$(value ENV)] workspace ...'
	@terraform workspace select $(value ENV)

	@terraform plan  \
  	  -var-file="accounts/$(value ENV)/main.tfvars" -input=false \
  	  -out $(value ENV).plan


apply:
	$(call check_defined, ENV, Please set the ENV to apply. Values should be dev, test, or prod)

	@echo 'Creating the $(value ENV) workspace ...'
	@-terraform workspace new $(value ENV)

	@echo 'Switching to the [$(value ENV)] workspace ...'
	@terraform workspace select $(value ENV)

	@terraform apply -auto-approve -input=false \
	  -var-file="accounts/$(value ENV)/main.tfvars"


destroy:
	$(call check_defined, ENV, Please set the ENV to apply. Values should be dev, test, or prod)
  
	@echo "Initializing Terraform ..."
	@terraform init
	
	@echo 'Creating the $(value ENV) workspace ...'
	@-terraform workspace new $(value ENV)

	@echo 'Switching to the [$(value ENV)] workspace ...'
	@terraform workspace select $(value ENV)

	@echo "## 💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥 ##"
	@echo "Are you really sure you want to completely destroy [$(value ENV)] environment ?"
	@echo "## 💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥 ##"
	@read -p "Press enter to continue"
	@terraform destroy \
		-var-file="accounts/$(value ENV)/main.tfvars"


# Check that given variables are set and all have non-empty values,
# die with an error otherwise.
#
# Params:
#   1. Variable name(s) to test.
#   2. (optional) Error message to print.
check_defined = \
    $(strip $(foreach 1,$1, \
        $(call __check_defined,$1,$(strip $(value 2)))))
__check_defined = \
    $(if $(value $1),, \
      $(error Undefined $1$(if $2, ($2))))