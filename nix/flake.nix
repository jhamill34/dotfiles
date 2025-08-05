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

        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        mac-app-util.url = "github:hraban/mac-app-util";
    };

    outputs = inputs@{
        self,
        nix-darwin,
        nixpkgs,
        home-manager,
        mac-app-util
    }:
    let
        configuration = { pkgs, config, ... }: {
            imports = [
                ./modules/fonts.nix
                ./modules/networking.nix
            ];

            nixpkgs.config.allowUnfree = true;

            home-manager.backupFileExtension = "bak";

            # Required since we used the "Determinate" distribution
            nix.enable = false;

            system.primaryUser = "joshuahamill";
            users.users.joshuahamill.home = "/Users/joshuahamill";

            # Necessary for using flakes on this system.
            nix.settings.experimental-features = "nix-command flakes";

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
                ];
        };
    };
}
