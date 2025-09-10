{ pkgs, ... }:

{
    home.packages = [
        pkgs.tree-sitter
        pkgs.lua51Packages.lua
        pkgs.lua51Packages.luarocks
        pkgs.jetbrains.idea-ultimate
    ];

    programs.neovim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
    };
}
