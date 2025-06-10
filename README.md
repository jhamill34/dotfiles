# Personal Dotfiles

## Nix

To start we need to make sure that Nix is installed. I first did this using the 
["Determinate Nix Installer"](https://github.com/DeterminateSystems/nix-installer?tab=readme-ov-file#determinate-nix-installer). There seems to be a nice CLI way to do it but I opted for doing the GUI one. 


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
- [-] Redoing our Neovim config (mini nvim, snack.nvim, and kickstart)
- [ ] Using home manager to install our dot files
- [ ] Use nix to configure our personal laptop with a user for Amanda
- [-] Try out hammerspoon mac app 
- [-] Try out karabeaner 
- [-] Sketchybar sounds fun
- [x] Add our ghostty config here too
- [x] Configure oh-my-posh look and feel
- [ ] Use Ansible to run playbooks to install / run commands on remote machines (i.e. Amanda's macbook)
- [ ] Continue to look into multi-user homebrew. 


## Multi-user homebrew

This setup is probably best done by having a dedicated homebrew user and then making sure that permissions are configured properly. 

## Ansible 

This tool is typically run over SSH so as long as that is configured initially, I can run ansible playbooks remotely and update Amanda's computer or anyone elses with my own. I could also use this to setup k3s on computers or k8s on VPS. 

