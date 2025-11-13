# Personal Dotfiles

## Homebrew 

Install homebrew then run 

```bash

make brew-install
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


## TODO

- [x] Map CapsLock to Escape
- [x] Default screencapture directory 
- [x] Fix fzf-tab
- [x] Fix transient prompt
- [ ] Install actual language runtimes

### Nix snippet 

```nix
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };
  system.defaults.screencapture = {
    include-date = true;
    show-thumbnail = false;
    location = "~/Notes/Screen-Shots";
    target = "file";
  };
```
