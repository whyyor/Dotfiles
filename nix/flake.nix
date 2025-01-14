{
  description = "Darwin System Flake for Whyyor";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew }:
  let
    configuration = { pkgs, config, ... }: {
      nixpkgs.config.allowUnfree = true;

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [
          pkgs.git
          pkgs.neovim
          pkgs.lazygit
          pkgs.mkalias
          pkgs.tmux
          pkgs.localsend
          pkgs.fzf
          pkgs.ripgrep
          pkgs.xclip
          pkgs.pngpaste
          pkgs.cocoapods
          pkgs.spicetify-cli
          pkgs.openjdk17
        ];

      homebrew = {
        enable = true;
        brews = [
          "oh-my-posh"
          "koekeishiya/formulae/yabai"
          "koekeishiya/formulae/skhd"
          "yt-dlp"
          "node"
          "python@3.11"
          "pyenv"
          "n"
          "mas"
          "dart"
        ];
        taps = [
          "dart-lang/dart"
        ];
        casks = [
          "aldente"
          "chatgpt"
          "caffeine"
          "lookaway"
          "zen-browser"
          "ghostty"
          "appcleaner"
          "mac-mouse-fix"
          "sioyek"
          "flux"
          "keyboardcleantool"
          "automattic-texts"
          "slack"
          "hiddenbar"
          "android-studio"
          "postman"
          "microsoft-teams"
          "spotify"
        ];
        masApps = {
          "xcode" = 497799835;
        };
        onActivation = {
          cleanup = "zap";
          autoUpdate = true;
          upgrade = true;
        };
      };

      fonts.packages = [
          pkgs.nerd-fonts.jetbrains-mono
      ];

      services = {
        skhd.enable = true;
        yabai.enable = true;
      };

      system.activationScripts.applications.text = let
        env = pkgs.buildEnv {
          name = "system-applications";
          paths = config.environment.systemPackages;
          pathsToLink = "/Applications";
        };
      in
        pkgs.lib.mkForce ''
        # Set up applications.
        echo "setting up /Applications..." >&2
        rm -rf /Applications/Nix\ Apps
        mkdir -p /Applications/Nix\ Apps
        find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
        while read -r src; do
          app_name=$(basename "$src")
          echo "copying $src" >&2
          ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
        done
      '';

      system.defaults = {
        dock.autohide = true;
        dock.persistent-apps = [
          "/Applications/Zen Browser.app"
          "/Applications/Ghostty.app"
          "/Applications/ChatGPT.app"
          "/Applications/Texts.app"
        ];
        dock.show-recents = false;
        loginwindow.GuestEnabled = false;
        NSGlobalDomain.AppleInterfaceStyle = "Dark";
        NSGlobalDomain.KeyRepeat = 2;
      };

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."whyyormac" = nix-darwin.lib.darwinSystem {
      modules = [ 
        configuration 
        nix-homebrew.darwinModules.nix-homebrew
           {
            nix-homebrew = {
            # Install Homebrew under the default prefix
            enable = true;
            # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
            enableRosetta = true;
            # User owning the Homebrew prefix
            user = "keshavkhatri";
            # Automatically migrate existing Homebrew installations, remove when installing fresh(maybe idk)
            autoMigrate = true;
          };
        }
      ];
    };
  };
}
