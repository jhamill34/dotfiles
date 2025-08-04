{ pkgs, ... }:

{
    home.packages = [
        pkgs.tree-sitter
        pkgs.lua51Packages.lua
        pkgs.lua51Packages.luarocks
        pkgs.neovim
        pkgs.jetbrains.idea-ultimate
    ];
}
