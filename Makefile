STOW_DIR := ./stow
PNPM_UTILS_DIR := ./stow/dot-pnpm-utils
HOSTNAME := $(shell hostname -s)
PLAYBOOK := ./playbook/site.yaml
SECRETS_FILE := ./playbook/secrets.yaml
VAULT_PASSWORD := $(HOME)/.vault-password.txt

stow-install: 
	cd $(STOW_DIR) && stow --dotfiles --target="$$HOME" .

stow-uninstall:
	cd $(STOW_DIR) && stow -D --dotfiles --target="$$HOME" .

$(SECRETS_FILE): 
	ansible-vault create \
		$(SECRETS_FILE)

$(VAULT_PASSWORD): 
	touch $(VAULT_PASSWORD)

ansible-install: $(SECRETS_FILE) $(VAULT_PASSWORD)
	ansible-playbook $(PLAYBOOK) \
		--extra-vars "@$(SECRETS_FILE)" \
		--connection=local \
		--vault-password-file $(VAULT_PASSWORD) \
		-i "$(HOSTNAME),"

init-notes:
	cp -R ./Notes $(HOME)

