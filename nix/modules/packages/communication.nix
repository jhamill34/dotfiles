{ pkgs, ... }:

{
  imports = [
    ./custom/spark-mail.nix
  ];

  # NOTE: Thunderbird is configurable
  # TODO: Taskwarrior
  home.packages = [
    pkgs.slack
    pkgs.zoom-us
  ];
}
