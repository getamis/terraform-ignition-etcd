TF_DOCS := $(shell which terraform-docs 2> /dev/null)
TF_FILES = $(shell find . -type f -name "*.tf" -exec dirname {} \; | sort -u)
TF_EXAMPLES = $(shell find ./examples -type f -name "*.tf" -exec dirname {} \;|sort -u)

define terraform-docs
	$(if $(TF_DOCS),,$(error "terraform-docs revision >= a8b59f8 is required (https://github.com/segmentio/terraform-docs)"))

	@echo '<!-- DO NOT EDIT. THIS FILE IS GENERATED BY THE MAKEFILE. -->' > $1
	@echo '# Terraform variables inputs and outputs' >> $1
	@echo $2 >> $1
	terraform-docs markdown --no-required --no-providers --no-requirements $3 $4 $5 $6 >> $1
endef

.PHONY: validate
validate:
	@for m in $(TF_EXAMPLES); do terraform init "$$m" > /dev/null 2>&1; echo "$$m: "; terraform validate "$$m"; done

.PHONY: validate-ign
validate-ign:
	@(cd examples && \
	  terraform init > /dev/null 2>&1 && \
	  terraform apply -auto-approve && \
	  (ignition-validate output/etcd.ign && echo "√ output/etcd.ign: Success! The ignition configuration is valid."))
	
.PHONY: fmt
fmt:
	@for m in $(TF_FILES); do (terraform fmt -diff "$$m" && echo "√ $$m"); done

.PHONY: docs
docs:
	$(call terraform-docs, docs/variables.md, \
		'This document gives an overview of variables used in the Ignition of the etcd module.\n', \
		./)