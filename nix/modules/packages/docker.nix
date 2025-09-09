{ pkgs, ... }:

{
  # TODO: Update docker, lazydocker 
  home.packages = [
    pkgs.docker
    pkgs.colima
    pkgs.lazydocker
  ];
}
