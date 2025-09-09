{ pkgs, ... }:

{
  home.packages = [
    pkgs.docker
    pkgs.colima
  ];

  programs.lazydocker = {
    enable = true;
    settings = { };
  };
}
