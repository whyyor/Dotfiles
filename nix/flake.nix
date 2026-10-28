{
  description = "Darwin System Flake for Whyyor";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    darwin-custom-icons.url = "github:ryanccn/nix-darwin-custom-icons";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # nix-homebrew.url = "git+https://github.com/zhaofengli/nix-homebrew?ref=refs/pull/71/merge";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, darwin-custom-icons, home-manager }:
  let
    # the only machine-specific values; flakes eval purely, so these can't be auto-detected
    user = "whyyor";
    home = "/Users/${user}";
    dotfiles = "${home}/Configration";
    vars = { inherit user home dotfiles; };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild switch --flake .#whyyor
    darwinConfigurations.${user} = nix-darwin.lib.darwinSystem {
      specialArgs = vars;
      modules = [
        ./modules/packages.nix
        ./modules/homebrew.nix
        ./modules/services.nix
        ./modules/system.nix
        ./modules/shell.nix
        nix-homebrew.darwinModules.nix-homebrew
        darwin-custom-icons.darwinModules.default
        home-manager.darwinModules.home-manager
        {
          users.users.${user}.home = home;
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            # existing ~/.config links get renamed to *.hm-bak instead of aborting the switch
            backupFileExtension = "hm-bak";
            extraSpecialArgs = vars;
            users.${user} = import ./modules/home.nix;
          };
        }
        {
          # Set Git commit hash for darwin-version (needs `self`, so it stays here)
          system.configurationRevision = self.rev or self.dirtyRev or null;

          nix-homebrew = {
            # Install Homebrew under the default prefix
            enable = true;
            # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
            enableRosetta = true;
            # User owning the Homebrew prefix
            inherit user;
            # Automatically migrate existing Homebrew installations, remove when installing fresh(maybe idk)
            autoMigrate = true;
          };
        }
      ];
    };
  };
}
