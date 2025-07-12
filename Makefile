install: 
	cd ./stow && stow --dotfiles --target="$$HOME" .

uninstall:
	cd ./stow && stow -D --dotfiles --target="$$HOME" .

