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

        mac-app-util.url = "github:hraban/mac-app-util";

        homebrew-core = {
            url = "github:homebrew/homebrew-core";
            flake = false;
        };
        homebrew-cask = {
            url = "github:homebrew/homebrew-cask";
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
        home-manager,
        mac-app-util
    }:
    let
        configuration = { pkgs, config, ... }: {
            nixpkgs.config.allowUnfree = true;

            # List packages installed in system profile. To search by name, run:
            # $ nix-env -qaP | grep wget
            environment.systemPackages = [
                    pkgs.jq
                    pkgs.fd
                    pkgs.fzf
                    pkgs.imagemagick
                    pkgs.stow
                    pkgs.tmux
                    pkgs.wget
                    pkgs.yq

                    pkgs.tree-sitter
                    pkgs.lua51Packages.lua
                    pkgs.lua51Packages.luarocks
                ];

            fonts.packages = [
                    pkgs.nerd-fonts.fira-mono
                    pkgs.sketchybar-app-font
                ];

            homebrew = {
                    enable = true;
                    casks = [
                        # NOTE: We'll use the homebrew cask for now, spent too much 
                        #  time trying to get lima/colima working with test containers
                        "docker"
                        "loom"
                    ];
                    taps = [
                        "homebrew/core"
                        "homebrew/cask"
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

            # Required since we used the "Determinate" distribution
            nix.enable = false;

            system.primaryUser = "joshuahamill";
            system.defaults = {
                    dock.autohide = true;
                    dock.persistent-apps = [
                        "/System/Applications/Messages.app"
                        "/System/Applications/Passwords.app"
                        "${pkgs.slack}/Applications/Slack.app"
                        "${pkgs.thunderbird}/Applications/Thunderbird.app"
                        "${pkgs.jetbrains.idea-ultimate}/Applications/IntelliJ IDEA.app"
                        "${pkgs.kitty}/Applications/kitty.app"
                        "${pkgs.firefox}/Applications/Firefox.app"
                        "${pkgs.zoom-us}/Applications/zoom.us.app"
                        "${pkgs.spotify}/Applications/Spotify.app"
                    ];
                    finder.FXPreferredViewStyle = "clmv";
                    NSGlobalDomain.AppleInterfaceStyle = "Dark";
                    screencapture.location = "~/Pictures/Screen Captures";
            };

            networking.dns = [
                    "1.1.1.1" # Cloudflare DNS
                    "8.8.8.8" # Google DNS
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
        darwinConfigurations."josh-macbook-pro" = nix-darwin.lib.darwinSystem {
            modules =
                [
                    configuration
                    mac-app-util.darwinModules.default
                    home-manager.darwinModules.home-manager {
                        home-manager.useGlobalPkgs = true;
                        home-manager.useUserPackages = true;
                        home-manager.users.joshuahamill = import ./home.nix;
                        home-manager.sharedModules = [
                            mac-app-util.homeManagerModules.default
                        ];
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
                                    };

                                    # Only allow taps to be added declaratively
                                    mutableTaps = false;
                            };
                    }
                ];
        };
    };
}
