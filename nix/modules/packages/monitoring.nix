{ pkgs, ... }:

{
  # TODO: update btop
  home.packages = [
    pkgs.btop
  ];
}
