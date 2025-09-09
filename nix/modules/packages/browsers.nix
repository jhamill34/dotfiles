{ pkgs, ... }:

{
  # NOTE: qutebrowser...
  # NOTE: Firefox is customizable...
  imports = [
    ./custom/brave-apps.nix
  ];
}
