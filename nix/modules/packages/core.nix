{ pkgs, ... }:

{
  # TODO: update kitty, tmux, starship
  home.packages = [
    pkgs.kitty
    pkgs.mkalias
    pkgs.stow
    pkgs.tmux
    pkgs.starship
  ];
}
