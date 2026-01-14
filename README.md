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
  - [ ] Prebuilt binaries
  - [ ] DMG applications
  - [ ] PKG applications
  - [ ] Manually built
  - [ ] plist services XML files
- [ ] Work on a neovim config from scratch (clean up and learn about how LSP works)

## Custom Build Notes

We'll follow the homebrew pattern and create a directory called `/opt/jhamill/bin` to contain our executables 
and source code can be downloaded to `/opt/jhamill/src` to be built. Our executable will be moved or linked to the sibling bin folder. 
