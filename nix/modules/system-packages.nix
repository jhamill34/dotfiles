{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.btop
    pkgs.jq
    pkgs.fd
    pkgs.fzf
    pkgs.imagemagick
    pkgs.stow
    pkgs.tmux
    pkgs.wget
    pkgs.yq

    pkgs.tree-sitter
    pkgs.lua51Packages.lua
    pkgs.lua51Packages.luarocks
  ];
}