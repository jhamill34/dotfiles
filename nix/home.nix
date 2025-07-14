{ config, pkgs, ... }:

{
  imports = [
    ./modules/home-packages.nix
    ./modules/brave-apps.nix
    ./modules/launchd.nix
    ./modules/home-files.nix
    ./modules/clickhouse.nix
  ];
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "joshuahamill";
  home.homeDirectory = "/Users/joshuahamill";
  home.stateVersion = "25.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;


  xdg.enable = true;
  # system.defaults = {
  #         dock.autohide = true;
  #         dock.persistent-apps = [
  #             "${pkgs.slack}/Applications/Slack.app"
  #             "${pkgs.jetbrains.idea-ultimate}/Applications/IntelliJ IDEA.app"
  #             "${pkgs.kitty}/Applications/kitty.app"
  #             "${pkgs.zoom-us}/Applications/zoom.us.app"
  #             "${pkgs.spotify}/Applications/Spotify.app"
  #         ];
  #         finder.FXPreferredViewStyle = "clmv";
  #         NSGlobalDomain.AppleInterfaceStyle = "Dark";
  #         screencapture.location = "~/Pictures/Screen Captures";
  # };


}
