STOW_BIN := /opt/homebrew/bin/stow
STOW_DIR := ./stow
PNPM_UTILS_DIR := ./stow/dot-pnpm-utils
HOSTNAME := $(shell hostname -s)
PLAYBOOK := ./playbook/site.yaml
SECRETS_FILE := ./playbook/secrets.yaml
VAULT_PASSWORD := $(HOME)/.vault-password.txt
# Herdr refuses mod files that resolve outside the mod's folder, so mods are copied, not stowed.
HERDR_MODS_DIR := ./herdr-app/mods
HERDR_MODS_TARGET := $(HOME)/.config/herdr-app/mods
HERDR_MODS_EXCLUDE := --exclude gpui-kit.d.ts --exclude jsconfig.json

export ANSIBLE_PYTHON_INTERPRETER := $(HOME)/.local/bootstrap/bin/python3

stow-install: herdr-mods
	cd $(STOW_DIR) && $(STOW_BIN) --no-fold --dotfiles --target="$$HOME" .

herdr-mods:
	mkdir -p $(HERDR_MODS_TARGET)
	for mod in $(HERDR_MODS_DIR)/*/; do \
		rsync -a $(HERDR_MODS_EXCLUDE) "$$mod" "$(HERDR_MODS_TARGET)/$$(basename $$mod)/"; \
	done

# Copies live edits to tracked mods back into dotfiles.
herdr-mods-pull:
	for mod in $(HERDR_MODS_DIR)/*/; do \
		rsync -a $(HERDR_MODS_EXCLUDE) "$(HERDR_MODS_TARGET)/$$(basename $$mod)/" "$$mod"; \
	done

stow-uninstall:
	cd $(STOW_DIR) && $(STOW_BIN) -D --dotfiles --target="$$HOME" .

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

