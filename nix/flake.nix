{
  description = "Darwin System Flake for Whyyor";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    darwin-custom-icons.url = "github:ryanccn/nix-darwin-custom-icons";
    # nix-homebrew.url = "git+https://github.com/zhaofengli/nix-homebrew?ref=refs/pull/71/merge";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, darwin-custom-icons }:
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
          pkgs.openjdk17
          pkgs.ffmpeg
          pkgs.wget
          pkgs.mpv
          pkgs.jira-cli-go
          pkgs.typioca
          pkgs.termusic
          pkgs.firefox
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
          "taskell"
          "imagemagick"
          "openai-whisper"
          "jq"
          "md2pdf"
          "opencode"
          "go"
          "yarn"
          "maven"
          "tailscale"
        ];
        taps = [
          "dart-lang/dart"
          "sst/tap"
        ];
        casks = [
          "aldente"
          "chatgpt"
          "caffeine"
          "lookaway"
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
          "microsoft-auto-update"
          "mongodb-compass"
          "stremio"
          "obs"
          "windscribe"
          "monitorcontrol"
          "karabiner-elements"
          "betterdisplay"
          "scoot"
          "yt-music"
          "beeper"
          "raspberry-pi-imager"
        ];
        masApps = {
          "xcode" = 497799835;
          "Davinci Resolve" = 571213070;
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

      environment.customIcons = {
        enable = true;
          icons = [
            {
              path = "/Applications/Ghostty.app";
              icon = "/Users/keshavkhatri/Configration/icons/ghostty.webp";
            }
            {
              path = "/Applications/Nix Apps/mpv.app";
              icon = "/Users/keshavkhatri/Configration/icons/mpv.icns";
            }
            {
              path = "/Applications/Stremio.app";
              icon = "/Users/keshavkhatri/Configration/icons/stremio.icns";
            }
            {
              path = "/Applications/Beeper Desktop.app";
              icon = "/Users/keshavkhatri/Configration/icons/beeper.icns";
            }];
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
          ln -sf "$src" "/Applications/Nix Apps/$app_name"
        done
      '';

      system.defaults = {
        dock.autohide = true;
        dock.persistent-apps = [
          "/Applications/Nix Apps/Firefox.app"
          "/Applications/Ghostty.app"
          "/Applications/Beeper Desktop.app"
        ];
        dock.show-recents = false;
        loginwindow.GuestEnabled = false;
        NSGlobalDomain = {
          AppleShowAllExtensions = true;
          ApplePressAndHoldEnabled = false;
          AppleInterfaceStyle = "Dark";

          KeyRepeat = 2;
          InitialKeyRepeat = 15;

          "com.apple.mouse.tapBehavior" = 1;
          "com.apple.sound.beep.volume" = 0.0;
          "com.apple.sound.beep.feedback" = 0;
        };
        trackpad = {
          Clicking = true;
          TrackpadThreeFingerDrag = true;
        };
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

      # Set primary user for nix-darwin
      system.primaryUser = "keshavkhatri";

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
        darwin-custom-icons.darwinModules.default
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
