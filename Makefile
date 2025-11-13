STOW_DIR := ./stow

stow-install: 
	cd $(STOW_DIR) && stow --dotfiles --target="$$HOME" .

stow-uninstall:
	cd $(STOW_DIR) && stow -D --dotfiles --target="$$HOME" .

brew-install:
	brew bundle install --global

init-notes:
	cp -R ./Notes $(HOME)

init-screenshots:
	defaults write com.apple.screencapture location $(HOME)/Notes/Screen-Shots
	defaults write com.apple.screencapture target "file"
	defaults write com.apple.screencapture show-thumbnail -bool false
	killall SystemUIServer
