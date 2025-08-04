{ pkgs, ... }:

{
    home.packages = [
        pkgs.kitty
        pkgs.mkalias
        pkgs.stow
        pkgs.tmux
        pkgs.oh-my-posh
    ];
}
