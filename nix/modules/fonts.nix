{ pkgs, ... }:

{
  fonts.packages = [
    pkgs.nerd-fonts.terminess-ttf
    pkgs.nerd-fonts.fira-mono
    pkgs.sketchybar-app-font
  ];
}