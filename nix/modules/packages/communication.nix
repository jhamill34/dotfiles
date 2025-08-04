{ pkgs, ... }:

{
    imports = [
        ./custom/spark-mail.nix
    ];

    home.packages = [
        pkgs.slack
        pkgs.zoom-us
    ];
}
