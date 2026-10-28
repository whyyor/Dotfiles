{ pkgs, config, user, dotfiles, ... }: {
  # pure eval can't see the clone, so check at activation; Home Manager links would dangle without it
  system.activationScripts.preActivation.text = ''
    if [ ! -d "${dotfiles}" ]; then
      printf '\n\033[1;33mwarning: dotfiles not found at ${dotfiles}\033[0m\n' >&2
      printf 'config symlinks will be broken. clone the repo there, or edit `dotfiles` in nix/flake.nix\n\n' >&2
    fi
  '';

  environment.customIcons = {
    enable = true;
    icons = [
      {
        path = "/Applications/Zen.app";
        icon = ../../icons + "/zen.icns";
      }
      {
        path = "/Applications/Helium.app";
        icon = ../../icons + "/helium.icns";
      }
      {
        path = "/Applications/IINA.app";
        icon = ../../icons + "/iina.icns";
      }
      {
        path = "/Applications/Slack.app";
        icon = ../../icons + "/slack.icns";
      }
      {
        path = "/Applications/Stremio.app";
        icon = ../../icons + "/stremio.icns";
      }
      {
        path = "/Applications/Xcode.app";
        icon = ../../icons + "/xcode.icns";
      }
    ];
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
    dock.autohide-delay = 0.0;
    dock.autohide-time-modifier = 0.4;
    dock.persistent-apps = [
      "/Applications/Helium.app"
      "/Applications/Ghostty.app"
    ];
    dock.show-recents = false;
    dock.mru-spaces = false;
    finder.QuitMenuItem = true;
    finder.AppleShowAllFiles = true;
    universalaccess.reduceMotion = true;
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
    CustomUserPreferences."com.colliderli.iina" = {
      useLegacyFullScreen = true;
      currentInputConfigName = "mpv Default";
      enableAdvancedSettings = true;
      useMpvOsd = true;
      useUserDefinedConfDir = false;
    };
  };

  # Minutes before the display sleeps (battery + AC)
  power.sleep.display = 15;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # Set primary user for nix-darwin
  system.primaryUser = user;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
