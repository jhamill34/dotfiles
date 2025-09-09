{ pkgs, ... }:

{
    home.packages = [
        pkgs.openapi-generator-cli
        pkgs.rustup

        pkgs.nodejs_22 # NodeJS
    ];


    programs.gradle = {
        enable = true;
        home = ".gradle";

        # initScripts = {};
        # settings = {};
    };
    programs.pyenv = {
        enable = true;
        enableZshIntegration = false;
    };

    programs.rbenv = {
        enable = true;
        enableZshIntegration = false;

        # plugins = [ ];
    };

    programs.go = {
        enable = true;

        # packages = {
        #     "github.com/..." = builtins.fetchGit "";
        # };
    };

    programs.java = {
        enable = true;
        package = pkgs.temurin-bin-23;
    };
}
