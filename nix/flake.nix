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

      # nix-darwin defaults EDITOR to nano; yazi/git/crontab all follow $EDITOR
      environment.variables.EDITOR = "nvim";

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
          pkgs.wget
          pkgs.jira-cli-go
          pkgs.typioca
          pkgs.termusic
          pkgs.jellyfin-tui
          pkgs.btop
          pkgs.herdr
        ];

      homebrew = {
        enable = true;
        brews = [
          "oh-my-posh"
          "yt-dlp"
          "python@3.11"
          "pyenv"
          "n"
          "mas"
          "dart-sdk"
          "imagemagick"
          "openai-whisper"
          "jq"
          "md2pdf"
          "opencode"
          "go"
          "yarn"
          "maven"
          "colima"
          "docker"
          "docker-compose"
          "pango"
          "pkgconf"
          "scipy"
          "py3cairo"
          "w3m"
          "pandoc"
          "poppler"
          "azure-cli"
          "bun"
          "typtea"
          "redis"
          "resterm"
          "homebrew-ffmpeg/ffmpeg/ffmpeg"
          "tree-sitter-cli"
          "yazi"
          "bitwarden-cli"
          "mole"
          "terminal-notifier"
          "tlrc"
          "noodle"
        ];
        taps = [
          { name = "dart-lang/dart"; trusted = true; }
          { name = "sst/tap"; trusted = true; }
          { name = "nikitabobko/tap"; trusted = true; }
          { name = "oven-sh/bun"; trusted = true; }
          { name = "homebrew-ffmpeg/ffmpeg"; trusted = true; }
          { name = "wilfredinni/noodle"; trusted = true; }
          { name = "floatpane/matcha"; trusted = true; }
        ];
        casks = [
          "claude-code"
          "chatgpt"
          "aerospace"
          "android-platform-tools"
          "aldente"
          "caffeine"
          "ghostty"
          "appcleaner"
          "mac-mouse-fix"
          "flux-app"
          "keyboardcleantool"
          "slack"
          "iina"
          "zen"
          "figma"
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
          "yt-music"
          "beeper"
          "raspberry-pi-imager"
          "onyx"
          "mactex-no-gui"
          "scoot"
          "helium-browser"
          "floatpane/matcha/matcha"
        ];
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
        tailscale.enable = true;

        postgresql = {
          enable = true;
          package = pkgs.postgresql_16;  # Stable version
          dataDir = "/Users/whyyor/.postgresql/data";
          authentication = pkgs.lib.mkOverride 10 ''
            local all all trust
            host all all 127.0.0.1/32 trust
            host all all ::1/128 trust
          '';
          extraPlugins = with pkgs.postgresql_16.pkgs; [
            pgvector
          ];
        };
      };

      launchd.daemons.tailscaled.serviceConfig.KeepAlive = true;

      # gomuks matrix backend; frontends (web/tui) attach to it over RPC
      launchd.user.agents.gomuks = {
        serviceConfig = {
          ProgramArguments = [ "/Users/whyyor/.local/opt/gomuks/gomuks" ];
          RunAtLoad = true;
          KeepAlive = true;
          StandardOutPath = "/Users/whyyor/Library/Logs/gomuks.out.log";
          StandardErrorPath = "/Users/whyyor/Library/Logs/gomuks.err.log";
          EnvironmentVariables = {
            HOME = "/Users/whyyor";
            # terminal-notifier + ffmpeg live here; launchd agents get a minimal PATH
            PATH = "/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin";
          };
        };
      };

      environment.customIcons = {
        enable = true;
          icons = [
            {
              path = "/Applications/Zen.app";
              icon = "/Users/whyyor/Configration/icons/zen.icns";
            }
            {
              path = "/Applications/Helium.app";
              icon = "/Users/whyyor/Configration/icons/helium.icns";
            }
            {
              path = "/Applications/Slack.app";
              icon = "/Users/whyyor/Configration/icons/slack.icns";
            }
            {
              path = "/Applications/Stremio.app";
              icon = "/Users/whyyor/Configration/icons/stremio.icns";
            }
            {
              path = "/Applications/Xcode.app";
              icon = "/Users/whyyor/Configration/icons/xcode.icns";
            }
            {
              path = "/Applications/Beeper Desktop.app";
              icon = "/Users/whyyor/Configration/icons/beeper.icns";
            }];
      };

      system.activationScripts.applications.text = let
        env = pkgs.buildEnv {
          name = "system-applications";
          paths = config.environment.systemPackages;
          pathsToLink = [ "/Applications" ];
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
          "/Applications/Helium.app"
          "/Applications/Ghostty.app"
        ];
        dock.show-recents = false;
        dock.mru-spaces = false;
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
      system.primaryUser = "whyyor";

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."whyyor" = nix-darwin.lib.darwinSystem {
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
            user = "whyyor";
            # Automatically migrate existing Homebrew installations, remove when installing fresh(maybe idk)
            autoMigrate = true;
          };
        }
      ];
    };
  };
}
