FLAKE_DIR := ./nix
STOW_DIR := ./stow

stow-install: 
	cd $(STOW_DIR) && stow --dotfiles --target="$$HOME" .

stow-uninstall:
	cd $(STOW_DIR) && stow -D --dotfiles --target="$$HOME" .

# Apply configuration changes (requires sudo)
nix-switch:
	sudo darwin-rebuild switch --flake $(FLAKE_DIR)

# Build without switching (no sudo needed)
nix-build:
	darwin-rebuild build --flake $(FLAKE_DIR)

# Update flake inputs (no sudo needed)
nix-update:
	nix flake update $(FLAKE_DIR)

# Clean old generations (requires sudo)
nix-clean:
	sudo nix-collect-garbage -d

nix-rollback:
	sudo darwin-rebuild rollback

# Show generations (no sudo needed)
nix-generations:
	darwin-rebuild --list-generations


