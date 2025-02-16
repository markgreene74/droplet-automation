.PHONY: help
help:
	@echo "Use the autocomplete (<TAB>) to show the available commands."; \
	echo "To pass additional arguments to the droplet-* commands use:"; \
	echo "  make droplet-show-plan VARFILE=my-new-droplet.tfvars"

.PHONY: droplet-show-plan
droplet-show-plan:
	@cd terraform && \
	terraform init && \
	terraform plan -var "do_token=$$(cat ../.credentials/do_token)" \
      -var-file="${VARFILE}"

.PHONY: droplet-create
droplet-create:
	@cd terraform && \
	terraform init && \
	terraform apply -var "do_token=$$(cat ../.credentials/do_token)" \
      -var-file="${VARFILE}"
	$(MAKE) ansible-test
	$(MAKE) ansible-run

.PHONY: droplet-destroy
droplet-destroy:
	@cd terraform && \
	terraform init && \
	terraform destroy -var "do_token=$$(cat ../.credentials/do_token)" \
      -var-file="${VARFILE}"

.PHONY: droplet-print-ip
droplet-print-ip:
	@terraform -chdir="./terraform" output droplet_ip_address

.PHONY: ansible-run
ansible-run:
	@cd ansible && \
	ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook \
	  -u root -i $$(terraform -chdir="../terraform" output droplet_ip_address), \
	  main.yml

.PHONY: ansible-test
ansible-test:
	@cd ansible && \
	ANSIBLE_HOST_KEY_CHECKING=False ansible \
	  -u root -i $$(terraform -chdir="../terraform" output droplet_ip_address), \
	  -m ping all
