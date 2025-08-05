{ pkgs, ... }:

{
    home.packages = [
        pkgs.gh
        pkgs.jujutsu
        pkgs.lazygit

        pkgs.git-spice # if jj works out, I'll be removing this.
    ];
}
