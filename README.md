# Personal Dotfiles

## Homebrew 

Install homebrew and then ansible then run 

```bash
make ansible-install
```

## Dotfiles

To install the configuration files. We can use: 

```bash 
make stow-install 
```

## Uninstall

```bash 
stow stow-uninstall 
```


# Todos

- [ ] Migrate to sbarlua
- [ ] Convert my bash scripts to nushell
- [ ] Create a second theme
- [ ] Fix some default keybinds in nushell
- [ ] Use the built-in completions stuff
- [ ] Look into nushell overlays
- [ ] Finalze new setup by gutting old configs
- [ ] Look into side stepping homebrew on some tools (i.e. directly installing using ansible. Particularlly for things like python or node)
