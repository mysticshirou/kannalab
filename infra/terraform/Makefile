TF_VARS = vars.tfvars.json
TF_SECRETS = secrets.tfvars.json

tmp_secrets:
	$(eval TMP_SECRETS := $(shell mktemp -d))
	sops -d $(TF_SECRETS) > $(TMP_SECRETS)/$(TF_SECRETS)

init:
	terraform init

validate:
	terraform validate

plan: tmp_secrets validate
	terraform plan -var-file=$(TF_VARS) -var-file=$(TMP_SECRETS)/$(TF_SECRETS)

apply: tmp_secrets validate
	terraform apply -var-file=$(TF_VARS) -var-file=$(TMP_SECRETS)/$(TF_SECRETS) -auto-approve

destroy: tmp_secrets
	terraform destroy -var-file=$(TF_VARS) -var-file=$(TMP_SECRETS)/$(TF_SECRETS) -auto-approve