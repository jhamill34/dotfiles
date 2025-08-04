{ pkgs, ... }:

{
    home.packages = [
        pkgs.gh
        pkgs.git-spice
        pkgs.lazygit
    ];
}
