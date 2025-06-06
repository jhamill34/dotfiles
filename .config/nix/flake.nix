{
  description = "Personal nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };

    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, homebrew-core, homebrew-cask }:
  let
    configuration = { pkgs, config, ... }: {
      nixpkgs.config.allowUnfree = true;

      # https://search.nixos.org/packages
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ 
            pkgs.aws-sam-cli
            pkgs.awscli2
            pkgs.clickhouse
            pkgs.dnsmasq
            pkgs.fd
            pkgs.fzf
            pkgs.gh
            pkgs.git-spice
            pkgs.gradle
            pkgs.jq
            pkgs.k3d
            pkgs.k9s
            pkgs.kind
            pkgs.kubectl
            pkgs.kubernetes-helm
            pkgs.luajit
            pkgs.luajitPackages.luarocks
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
            pkgs.stow
            pkgs.tmux
            pkgs.wget
            pkgs.yq
            pkgs.zoxide
        ];

      # TODO: Jabba  https://github.com/shyiko/jabba

      # TODO: NVM  https://github.com/nvm-sh/nvm

      fonts.packages = [
          pkgs.nerd-fonts.fira-mono
        ];

      # system.activationScripts.applications.text = let 
      #   env = pkgs.buildEnv {
      #       name = "system-applications";
      #       paths = config.environment.systemPackages;
      #       pathsToLink = "/Applications";
      #   };
      # in 
      #   pkgs.lib.mkForce ''
      #       # Setup applications.
      #       echo "setting up /Applications..." >&2
      #       rm -rf /Applications/Nix\ Apps
      #       mkdir -p /Applications/Nix\ Apps
      #       find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
      #       while read -r src; do 
      #         app_name=$(basename "$src")
      #         echo "copying $src" >&2
      #         ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
      #       done
      #   '';
      

      # Required since we used the "Determinate" distribution
      nix.enable = false;

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
          nix-homebrew.darwinModules.nix-homebrew 
          {
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
                  };

                  # Only allow taps to be added declaratively
                  mutableTaps = false;
              };
          }
        ];
    };
  };
}
