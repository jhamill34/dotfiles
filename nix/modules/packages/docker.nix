{ pkgs, ... }:

{
    home.packages = [
        pkgs.docker
        pkgs.colima
        pkgs.lazydocker
    ];
}
