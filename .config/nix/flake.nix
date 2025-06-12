##############################################################
# Documentation
# - https://search.nixos.org/packages
# - https://nix-darwin.github.io/nix-darwin/manual/index.html
##############################################################
 
{
  description = "Personal nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-felixkratz = {
      url = "github:FelixKratz/homebrew-formulae";
      flake = false;
    };
    homebrew-koekeishiya = {
      url = "github:koekeishiya/homebrew-formulae";
      flake = false;
    };
    homebrew-nikitabobko = {
      url = "github:nikitabobko/homebrew-tap";
      flake = false;
    };
  };

  outputs = inputs@{
    self,
    nix-darwin,
    nixpkgs,
    nix-homebrew,
    homebrew-core,
    homebrew-cask,
    homebrew-felixkratz,
    homebrew-koekeishiya,
    homebrew-nikitabobko,
		home-manager
  }:
  let
    configuration = { pkgs, config, ... }: {
      nixpkgs.config.allowUnfree = true;

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [
            pkgs.aws-sam-cli
            pkgs.awscli2
            pkgs.fd
            pkgs.fzf
            pkgs.gh
            pkgs.git-spice
            pkgs.go
            pkgs.gradle
      pkgs.imagemagick
            pkgs.jq
            pkgs.k3d
            pkgs.k9s
            pkgs.kind
            pkgs.kubectl
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
            pkgs.stow
            pkgs.tmux
            pkgs.typst
            pkgs.wget
            pkgs.yq
            pkgs.zoxide
        ];

      fonts.packages = [
          pkgs.nerd-fonts.fira-mono
          pkgs.sketchybar-app-font
        ];


      homebrew = {
          enable = true;
          brews = [
            "nvm"
            "jabba"
            {
              name = "dnsmasq";
              start_service = true;
            }
            {
              name = "sketchybar";
              start_service = true;
            }
            {
              name = "borders";
              start_service = true;
            }
          ];
          casks = [
            "clickhouse"
            "ghostty"
            "slack"
            "zoom"
            "notion-calendar"
            "sunsama"
            "google-chrome"
            "spotify"
            "jetbrains-toolbox"
            "docker"
            "hammerspoon"
            "karabiner-elements"
            "aerospace"
          ];
          masApps = {
            "Spark" = 6445813049;
          };
          taps = [
            "homebrew/core"
            "homebrew/cask"
            "FelixKratz/formulae"
            "koekeishiya/formulae"
            "nikitabobko/tap"
          ];

          onActivation.cleanup = "zap";
          onActivation.autoUpdate = true;
          onActivation.upgrade = true;

          global = {
            brewfile = true;
          };
        };

      users.users.joshuahamill.home = "/Users/joshuahamill";
      home-manager.backupFileExtension = "bak";
			nix.configureBuildUsers = true;

      # Required since we used the "Determinate" distribution
      nix.enable = false;

      system.primaryUser = "joshuahamill";
      system.defaults = {
          dock.autohide = true;
          dock.persistent-apps = [
            "/System/Applications/Messages.app"
            "/System/Applications/Passwords.app"
            "/Applications/Sunsama.app"
            "/Applications/Spark\ Desktop.app"
            "/Applications/Notion\ Calendar.app"
            "/Applications/Slack.app"
            "/Applications/Ghostty.app"
            "/Applications/Google\ Chrome.app"
            "/Applications/Spotify.app"
            "/Applications/zoom.us.app"
          ];
          finder.FXPreferredViewStyle = "clmv";
          NSGlobalDomain.AppleInterfaceStyle = "Dark";
      };

      networking.dns = [
          "1.1.1.1"
          "8.8.8.8"
      ];

      networking.knownNetworkServices = [
          "Wi-Fi"
          "Thunderbolt Ethernet Slot 2"
          "Thunderbolt Bridge"
      ];

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Joshuas-MacBook-Pro
    darwinConfigurations."Joshuas-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      modules =
        [
          configuration
          home-manager.darwinModules.home-manager {
							home-manager.useGlobalPkgs = true;
							home-manager.useUserPackages = true;
							home-manager.users.joshuahamill = import ./home.nix;
          }
          nix-homebrew.darwinModules.nix-homebrew {
              nix-homebrew = {
                  # Install Homebrew under the default prefix
                  enable = true;

                  # Apple Silicon Only: Also install Homebrew under the default
                  enableRosetta = true;

                  # User owning the homebrew prefix
                  user = "joshuahamill";

                  taps = {
                    "homebrew/homebrew-core" = homebrew-core;
                    "homebrew/homebrew-cask" = homebrew-cask;
                    "FelixKratz/homebrew-formulae" = homebrew-felixkratz;
                    "koekeishiya/homebrew-formulae" = homebrew-koekeishiya;
                    "nikitabobko/homebrew-tap" = homebrew-nikitabobko;
                  };

                  # Only allow taps to be added declaratively
                  mutableTaps = false;
              };
          }
        ];
    };
  };
}
