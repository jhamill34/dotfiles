{ pkgs, ... }:

{
    home.packages = [
        pkgs.gh
        pkgs.lazygit

        pkgs.jujutsu
        pkgs.lazyjj

        pkgs.git-spice # if jj works out, I'll be removing this.
    ];
}
