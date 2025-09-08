{ pkgs, ... }:

{
    programs.jujutsu = {
        enable = true;
        settings = {
            user = {
                name = "Joshua Hamill";
                email = "joshrasmussen34@gmail.com";
            };

            git = {
                private-commits = "description(glob:\"private:*\")";
            };

            revset-aliases = {
                wip = "description(glob:\"wip:*\") & mutable()";
                private = "description(glob:\"private:*\")";
                linear = "description(regex:\".*OSC-[0-9]+.*\") & mutable()";
                dev = "wip | private | present(@)";
            };

            ui = { 
                pager = ":builtin";
            };
        };
    };

    programs.lazygit = {
        enable = true;
    };

    programs.gh = {
        enable = true;
        hosts = {
            "github.com" = {
                user = "jhamill34";
            };
            settings = {
                git_protocol = "ssh";
                editor = pkgs.neovim;
                aliases = {
                    co = "pr checkout";
                    pv = "pr view";
                };
            };
        };
    };

    # programs.gh-dash = {
    #     enable = true;
    # };

    programs.git = {
        enable = true;
        userName = "Joshua Hamill";
        userEmail = "joshrasmussen34@gmail.com";

        ignores = [
            "DO_NOT_COMMIT_*"
            ".joshua"
            ".claude/"
            ".crush/"
        ];

        # includes = [
        #     {
        #         path = "${config.xdg.configHome}/git/personal.gitconfig";
        #         condition = "${config.home.homeDirectory}/Code/Personal";
        #     }
        #     {
        #         path = "${config.xdg.configHome}/git/work.gitconfig";
        #         condition = "${config.home.homeDirectory}/Code/Work";
        #     }
        # ];

        extraConfig = {
            core = {
                autocrlf = "input";
            };
            push = {
                autoSetupRemote = true;
                default = "current";
            };
        };

        aliases = {
            lg1 = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all
    ";
            lg2 = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(auto)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)'
    ";
            lg = "lg1";
            co = "checkout";
        };

        # hooks = {
        #     pre-commit = "...";
        # };

        # signing = {
        #     signByDefault = true;
        #     format = "openpgp";
        # };

        # maintenance = {
        #     enable = true;
        #     timers = {
        #         daily = "Mon..Fri *-*-* 9:00:00";
        #     };
        #     repositories = [];
        # };
    };

    # programs.git-cliff = {
    #     enable = true;
    #     settings = {};
    # };
}
