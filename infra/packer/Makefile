PACKER_VARS = vars.pkrvars.json
PACKER_SECRETS = secrets.pkrvars.json
RHSM_PASSWORD = rhsm-password.yml
RHEL_KICKSTART = ks.cfg

tmp_secrets:
	$(eval TMP_SECRETS := $(shell mktemp -d))
	sops -d $(PACKER_SECRETS) > $(TMP_SECRETS)/$(PACKER_SECRETS)

http: tmp_secrets
	$(eval HTTP_SERVER := $(shell mktemp -d))
	sops -d http/$(RHSM_PASSWORD) > $(HTTP_SERVER)/$(RHSM_PASSWORD)
	cp http/$(RHEL_KICKSTART) $(HTTP_SERVER)/$(RHEL_KICKSTART)

init:
	packer init .

validate: tmp_secrets
	packer validate -var-file=$(PACKER_VARS) -var-file=$(TMP_SECRETS)/$(PACKER_SECRETS) .

build: validate http
	packer build -var-file=$(PACKER_VARS) -var-file=$(TMP_SECRETS)/$(PACKER_SECRETS) -var "http_server=$(HTTP_SERVER)" .

.PHONY: tmp_secrets init validate build http