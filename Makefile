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
HERDR_MODS_EXCLUDE := --exclude gpui-kit.d.ts --exclude jsconfig.json --exclude node_modules
# Kanso-style layouts rewrite themselves with live session state, so dotfiles keeps a starting
# copy and installs it only where none exists yet.
HERDR_LAYOUTS_DIR := ./herdr-app/layouts
HERDR_LAYOUTS_TARGET := $(HOME)/.config/herdr-app/layouts

export ANSIBLE_PYTHON_INTERPRETER := $(HOME)/.local/bootstrap/bin/python3

stow-install: herdr-mods herdr-layouts
	cd $(STOW_DIR) && $(STOW_BIN) --no-fold --dotfiles --target="$$HOME" .

herdr-layouts:
	mkdir -p $(HERDR_LAYOUTS_TARGET)
	cp -n $(HERDR_LAYOUTS_DIR)/*.json $(HERDR_LAYOUTS_TARGET)/ || true

herdr-mods:
	mkdir -p $(HERDR_MODS_TARGET)
	for mod in $(HERDR_MODS_DIR)/*/; do \
		rsync -a $(HERDR_MODS_EXCLUDE) "$$mod" "$(HERDR_MODS_TARGET)/$$(basename $$mod)/"; \
	done
	# A mod's Node helpers (e.g. jhamill-kanso-panel's mermaid renderer) install where they run.
	for lock in $(HERDR_MODS_TARGET)/*/*/package-lock.json; do \
		[ -f "$$lock" ] || continue; dir=$$(dirname "$$lock"); \
		[ -d "$$dir/node_modules" ] || npm ci --prefix "$$dir" --omit=dev --no-audit --no-fund; \
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

