## Extensions (maybe we can do this in nix?)

- Vimium
- Tree Style Tab
- Multi-Account Containers
- React Developer Tools
- Catppuccin Mocha theme 

Use the `vimium-options.json` in this directory to import our keybindings into vimium. 

I'm sure there is a way for nix to do this for us but to hide the top nav

1. Open `about:support` in firefox. 
2. Locate the profile directory
3. copy the `chrome` directory inside this directory over there. This includes css that will hide the top navbar. 

Note that hiding this navbar is only useful in the event we are using the Tree Style Tab. 

