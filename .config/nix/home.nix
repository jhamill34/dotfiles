{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "joshuahamill";
  home.homeDirectory = "/Users/joshuahamill";
  home.stateVersion = "25.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = [
    pkgs.cowsay
  ];

  home.file = {
    ".zshrc".source = ./home/.zshrc;
    ".tmux.conf".source = ./home/.tmux.conf;
    ".aerospace.toml".source = ./home/.aerospace.toml;
    ".gitconfig".source = ./home/.gitconfig;
    ".config" = {
        source = ./home/.config;
	recursive = true;
     };
    ".hammerspoon" = {
        source = ./home/.hammerspoon;
	recursive = true;
     };


    "Code/Personal/README.md".text = ''
      # Personal Work
      This directory is intended to be used for personal projects. 
    '';
    "Code/Work/README.md".text = ''
      # Work
      This directory is intended to be used for work projects only. 
    '';
    "Code/Test/README.md".text = ''
      # Test
      This directory is just a test to see if the directory gets created
    '';
  };
}
