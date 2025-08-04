{ pkgs, ... }:

{
    home.packages = [
        pkgs.nur.repos.charmbracelet.crush
    ];
}
