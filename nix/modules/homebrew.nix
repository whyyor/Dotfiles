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
      "docker"
      "docker-compose"
      "pango"
      "pkgconf"
      "scipy"
      "py3cairo"
      "pandoc"
      "poppler"
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
      "sevenzip"
      "tuicr"
      "gh"
      "cloaky233/tap/siltop"
      "dungngminh/simutil/simutil"
      "whyyor/tap/tuimessenger"
      "circumflex"
      # shadows /usr/bin/trash; reads native ~/.Trash for macos-trash.yazi
      "walavave/tap/trash-cli"
      "melqtx/tap/tork"
    ];
    taps = [
      { name = "dart-lang/dart"; trusted = true; }
      { name = "sst/tap"; trusted = true; }
      { name = "nikitabobko/tap"; trusted = true; }
      { name = "oven-sh/bun"; trusted = true; }
      { name = "homebrew-ffmpeg/ffmpeg"; trusted = true; }
      { name = "wilfredinni/noodle"; trusted = true; }
      { name = "anirban12d/bluekeys"; trusted = true; }
      { name = "cloaky233/tap"; trusted = true; }
      { name = "dungngminh/simutil"; trusted = true; }
      { name = "whyyor/tap"; trusted = true; }
      { name = "walavave/tap"; trusted = true; }
      { name = "melqtx/tap"; trusted = true; }
    ];
    casks = [
      "claude-code@latest"
      "aerospace"
      "android-platform-tools"
      "aldente"
      "ghostty"
      "flux-app"
      "slack"
      "iina"
      "android-studio"
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
      "mactex-no-gui"
      "scoot"
      "helium-browser"
      "steam"
      "vorssaint"
      "hopper-disassembler"
      "sst/tap/hex"
    ];
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
  };
}
