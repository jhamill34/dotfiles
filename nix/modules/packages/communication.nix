{ pkgs, ... }:

{
  imports = [
    ./custom/spark-mail.nix
  ];

  # NOTE: Thunderbird is configurable
  # NOTE: Taskwarrior
  home.packages = [
    pkgs.slack
    pkgs.zoom-us
  ];
}
