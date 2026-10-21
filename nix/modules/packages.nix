{ pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
    pkgs.git
    pkgs.neovim
    pkgs.lazygit
    pkgs.delta
    pkgs.mkalias
    pkgs.tmux
    pkgs.localsend
    pkgs.fzf
    pkgs.less # newer than macOS's 581: gomuks' Ctrl+L wrap-around search
    pkgs.ripgrep
    pkgs.xclip
    pkgs.pngpaste
    pkgs.cocoapods
    pkgs.openjdk17
    pkgs.wget
    pkgs.jira-cli-go
    pkgs.termusic
    pkgs.jellyfin-tui
    pkgs.btop
    pkgs.herdr
    pkgs.ghidra
  ];

  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
  ];
}
