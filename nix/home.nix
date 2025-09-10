{ config, pkgs, ... }:

{
  imports = [
    ./modules/home-packages.nix
    ./modules/home-files.nix
  ];
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "joshuahamill";
  home.homeDirectory = "/Users/joshuahamill";
  home.stateVersion = "25.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  xdg.enable = true;
}
