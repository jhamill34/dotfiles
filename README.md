# Personal Dotfiles

## Nix

To start we need to make sure that Nix is installed. I first did this using the 
["Determinate Nix Installer"](https://github.com/DeterminateSystems/nix-installer?tab=readme-ov-file#determinate-nix-installer). There seems to be a nice CLI way to do it but I opted for doing the GUI one. 

```bash
curl -fsSL https://install.determinate.systems/nix | sh -s -- install --determinate
```

Then to install the our flake we run 

```bash 
sudo nix nix-darwin switch -- 

```


## Dotfiles

To install the configuration files. We can use: 

```bash 
stow . 
```

## Uninstall

```bash 
stow -D . 
```


## Future Work 

- [x] Redoing our Tmux Config
- [x] Redoing our Neovim config (mini nvim, snack.nvim, and kickstart)
- [x] Using home manager to install our dot files
- [x] Use nix to configure our personal laptop with a user for Amanda
- [x] Try out hammerspoon mac app 
- [x] Try out karabeaner 
- [x] Sketchybar sounds fun
- [x] Add our ghostty config here too
- [x] Configure oh-my-posh look and feel
- [ ] Use Ansible to run playbooks to install / run commands on remote machines (i.e. Amanda's macbook)
- [ ] Continue to look into multi-user homebrew. 


## Multi-user homebrew

This setup is probably best done by having a dedicated homebrew user and then making sure that permissions are configured properly. 

## Ansible 

This tool is typically run over SSH so as long as that is configured initially, I can run ansible playbooks remotely and update Amanda's computer or anyone elses with my own. I could also use this to setup k3s on computers or k8s on VPS. 

## Issues

- [ ] System reboot can't find executables until another `sudo nix nix-darwin switch --flake ~/.config/nix` is ran, seems like something is wonky here. 
- [ ] AeroSpace + Sketchybar on reboot doesn't quite work. 

### Starting AeroSpace and Sketchybar 

```bash
open "$HOME/Applications/Home Manager Trampolines/AeroSpace.app"
sketchybar --reload
```

To kill the aerospace process

```bash 
pgrep "AeroSpace | xargs -I {} kill {}
```

## Apps I want to look into

- Kitty -> Terminal emulator
- Obsidian + Excalidraw -> Notes

## Self Hosting

- Strapi -> CMS for a blog

