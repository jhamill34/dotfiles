{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "joshuahamill";
  home.homeDirectory = "/Users/joshuahamill";
  home.stateVersion = "25.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = [
    pkgs.aws-sam-cli
    pkgs.awscli2
    pkgs.confluent-platform
    pkgs.d2
    pkgs.gh
    pkgs.git-spice
    pkgs.go
    pkgs.gradle
    pkgs.k3d
    pkgs.k9s
    pkgs.kafkactl
    pkgs.kind
    pkgs.kubectl
    pkgs.kubectx
    pkgs.kubernetes-helm
    pkgs.mkalias
    pkgs.mkcert
    pkgs.neovim
    pkgs.ngrok
    pkgs.nss
    pkgs.oh-my-posh
    pkgs.parallel
    pkgs.postgresql
    pkgs.pulumi
    pkgs.pulumictl
    pkgs.pyenv
    pkgs.rbenv
    pkgs.redis
    pkgs.ripgrep
    pkgs.rustup
    pkgs.typst
    pkgs.tilt
    pkgs.zoxide

    pkgs.clickhouse
    pkgs.dnsmasq
 
    # NOTE: 
    #  We'll use the homebrew cask for now, spent too much 
    #  time trying to get lima/colima working with test containers
    #
    # pkgs.docker # <- just the docker cli
    # pkgs.colima # <- keep for now, its a wrapper around lima
    # pkgs.lima 

    pkgs.nodejs_22 # NodeJS

    pkgs.kitty
    pkgs.slack
    pkgs.spotify
    pkgs.google-chrome
    pkgs.zoom-us
    pkgs.aerospace
    pkgs.sketchybar
    pkgs.jankyborders
    pkgs.jetbrains.idea-ultimate
    pkgs.code-cursor
    pkgs.firefox
    pkgs.thunderbird
  ];

  launchd.agents.jankyBordersAgent = {
    enable = true;
    config = {
        EnvironmentVariables = {
            PATH = "${pkgs.jankyborders}/bin:/usr/bin:/bin:/usr/sbin:/sbin";
        };
        Label = "tech.jhamill.jankyborders";
        ProgramArguments = [
            "${pkgs.jankyborders}/bin/borders"
        ];
        KeepAlive = true;
        RunAtLoad = true;
        StandardOutPath = "/tmp/borders.out.log";
        StandardErrorPath = "/tmp/borders.err.log";
        ProcessType = "Interactive";
        LimitLoadToSessionType = [
                "Aqua"
                "Background"
                "LoginWindow"
                "StandardIO"
                "System"
        ];
    };
  };


  launchd.agents.sketchybarAgent = {
    enable = true;
    config = {
        EnvironmentVariables = {
            PATH = "${pkgs.sketchybar}/bin:${pkgs.aerospace}/bin:/usr/bin:/bin:/usr/sbin:/sbin";
        };
        Label = "tech.jhamill.sketchybar";
        ProgramArguments = [
            "${pkgs.sketchybar}/bin/sketchybar"
        ];
        KeepAlive = true;
        RunAtLoad = true;
        StandardOutPath = "/tmp/sketchybar.out.log";
        StandardErrorPath = "/tmp/sketchybar.err.log";
        ProcessType = "Interactive";
        LimitLoadToSessionType = [
                "Aqua"
                "Background"
                "LoginWindow"
                "StandardIO"
                "System"
        ];
    };
  };

  home.file = {
    ".zshrc".source = ./home/.zshrc;
    ".tmux.conf".source = ./home/.tmux.conf;
    ".aerospace.toml".source = ./home/.aerospace.toml;
    ".gitconfig".source = ./home/.gitconfig;
    ".config" = {
        source = ./home/.config;
        recursive = true;
     };

    "Code/Personal/README.md".text = ''
      # Personal Work
      This directory is intended to be used for personal projects. 
    '';
    "Code/Work/README.md".text = ''
      # Work
      This directory is intended to be used for work projects only. 
    '';
  };
}
