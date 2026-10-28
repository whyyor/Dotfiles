{ ... }: {
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
      "redis"
      "resterm"
      "homebrew-ffmpeg/ffmpeg/ffmpeg"
      "tree-sitter-cli"
      "yazi"
      "bitwarden-cli"
      "mole"
      "tlrc"
      "noodle"
      "bluekeys"
      "terminal-notifier"
      "sevenzip"
      "tuicr"
      "gh"
    ];
    taps = [
      { name = "dart-lang/dart"; trusted = true; }
      { name = "sst/tap"; trusted = true; }
      { name = "nikitabobko/tap"; trusted = true; }
      { name = "oven-sh/bun"; trusted = true; }
      { name = "homebrew-ffmpeg/ffmpeg"; trusted = true; }
      { name = "wilfredinni/noodle"; trusted = true; }
      { name = "floatpane/matcha"; trusted = true; }
      { name = "anirban12d/bluekeys"; trusted = true; }
    ];
    casks = [
      "claude-code@latest"
      "chatgpt"
      "aerospace"
      "android-platform-tools"
      "aldente"
      "ghostty"
      "appcleaner"
      "mac-mouse-fix"
      "flux-app"
      "keyboardcleantool"
      "slack"
      "iina"
      "zen"
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
      "yt-music"
      "raspberry-pi-imager"
      "onyx"
      "mactex-no-gui"
      "scoot"
      "helium-browser"
      "steam"
      "floatpane/matcha/matcha"
      "terminal-browser"
      "vorssaint"
      "hopper-disassembler"
    ];
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = false;
    };
  };
}
