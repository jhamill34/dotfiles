FLAKE_DIR := ./nix
FLAKE_NAME := josh-macbook-pro
STOW_DIR := ./stow

stow-install: 
	cd $(STOW_DIR) && stow --dotfiles --target="$$HOME" .

stow-uninstall:
	cd $(STOW_DIR) && stow -D --dotfiles --target="$$HOME" .

# Apply configuration changes (requires sudo)
nix-switch:
	sudo darwin-rebuild switch --flake "$(FLAKE_DIR)#$(FLAKE_NAME)"

# Build without switching (no sudo needed)
nix-build:
	darwin-rebuild build --flake "$(FLAKE_DIR)#$(FLAKE_NAME)"

# Update flake inputs (no sudo needed)
nix-update:
	sudo nix flake update --flake "$(FLAKE_DIR)"

# Clean old generations (requires sudo)
nix-clean:
	sudo nix-collect-garbage --delete-older-than 7d

nix-rollback:
	sudo darwin-rebuild rollback

# Show generations (no sudo needed)
nix-generations:
	sudo darwin-rebuild --list-generations


