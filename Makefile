STOW_DIR := ./stow
PNPM_UTILS_DIR := ./stow/dot-pnpm-utils

stow-install: 
	cd $(STOW_DIR) && stow --dotfiles --target="$$HOME" .

stow-uninstall:
	cd $(STOW_DIR) && stow -D --dotfiles --target="$$HOME" .

ansible-install:
	ansible-playbook ./playbook/site.yaml

init-notes:
	cp -R ./Notes $(HOME)

