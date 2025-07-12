{ config, pkgs, ... }:
let
  makeBraveApp = { name, profileName, displayName, userDataDir }: pkgs.stdenv.mkDerivation {
    pname = name;
    version = "1.0.0";

    buildCommand = ''
      mkdir -p "$out/Applications/${displayName}.app/Contents/MacOS"
      mkdir -p "$out/Applications/${displayName}.app/Contents/Resources"

      cat > "$out/Applications/${displayName}.app/Contents/Info.plist" << EOF
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>CFBundleExecutable</key>
        <string>${name}</string>
        <key>CFBundleIdentifier</key>
        <string>com.brave.${name}</string>
        <key>CFBundleName</key>
        <string>${displayName}</string>
        <key>CFBundleVersion</key>
        <string>1.0.0</string>
      </dict>
      </plist>
      EOF

      cat > "$out/Applications/${displayName}.app/Contents/MacOS/${name}" << 'EOF'
      #!/bin/bash
      exec ${pkgs.brave}/bin/brave \
        --user-data-dir="${userDataDir}" \
        --profile-directory="${profileName}" \
        --class="${displayName}" \
        --window-name="${displayName}" "$@"
      EOF

      chmod +x "$out/Applications/${displayName}.app/Contents/MacOS/${name}"
    '';
  };
in
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
    pkgs.lazydocker
    pkgs.lazygit
    pkgs.mkalias
    pkgs.mkcert
    pkgs.neovim
    pkgs.ngrok
    pkgs.nss
    pkgs.oh-my-posh
    pkgs.openapi-generator-cli
    pkgs.parallel
    pkgs.pokemon-colorscripts-mac
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

    # pkgs.clickhouse
    pkgs.dnsmasq
 
    # NOTE: 
    #  We'll use the homebrew cask for now, spent too much 
    #  time trying to get lima/colima working with test containers
    #
    # pkgs.docker # <- just the docker cli
    # pkgs.colima # <- keep for now, its a wrapper around lima
    # pkgs.lima 

    pkgs.nodejs_22 # NodeJS
    # pkgs.claude-code

    pkgs._1password-cli
    pkgs.aerospace
    pkgs.brave
    (makeBraveApp { 
      name = "brave-personal"; 
      profileName = "Personal"; 
      displayName = "Brave Personal";
      userDataDir = "${config.xdg.dataHome}/brave-personal";
    })
    (makeBraveApp { 
      name = "brave-work"; 
      profileName = "Work"; 
      displayName = "Brave Work";
      userDataDir = "${config.xdg.dataHome}/brave-work";
    })
    pkgs.jankyborders
    pkgs.jetbrains.idea-ultimate
    pkgs.kitty
    pkgs.sketchybar
    pkgs.slack
    pkgs.spotify
    pkgs.zoom-us
  ];

  xdg.enable = true;
  # system.defaults = {
  #         dock.autohide = true;
  #         dock.persistent-apps = [
  #             "${pkgs.slack}/Applications/Slack.app"
  #             "${pkgs.jetbrains.idea-ultimate}/Applications/IntelliJ IDEA.app"
  #             "${pkgs.kitty}/Applications/kitty.app"
  #             "${pkgs.zoom-us}/Applications/zoom.us.app"
  #             "${pkgs.spotify}/Applications/Spotify.app"
  #         ];
  #         finder.FXPreferredViewStyle = "clmv";
  #         NSGlobalDomain.AppleInterfaceStyle = "Dark";
  #         screencapture.location = "~/Pictures/Screen Captures";
  # };

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
    ".zshrc".source = ./home/dot-zshrc;
    ".tmux.conf".source = ./home/dot-tmux.conf;
    ".aerospace.toml".source = ./home/dot-aerospace.toml;
    ".gitconfig".source = ./home/dot-gitconfig;
    ".config" = {
        source = ./home/dot-config;
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
