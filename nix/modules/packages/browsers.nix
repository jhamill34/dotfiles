{ pkgs, ... }:

{
  # TODO: qutebrowser...
  # NOTE: Firefox is customizable...
  imports = [
    ./custom/brave-apps.nix
  ];
}
