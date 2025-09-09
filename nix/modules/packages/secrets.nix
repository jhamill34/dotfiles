{ pkgs, ... }:

{
  # TODO: look into password-store...
  home.packages = [
    pkgs._1password-cli
  ];
}
