{ pkgs, ... }:

{
    home.packages = [
        pkgs.go
        pkgs.gradle
        pkgs.openapi-generator-cli
        pkgs.pyenv
        pkgs.rbenv
        pkgs.rustup

        pkgs.nodejs_22 # NodeJS
    ];

    programs.java = {
        enable = true;
        package = pkgs.temurin-bin-23;
    };
}
