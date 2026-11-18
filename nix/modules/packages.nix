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
    pkgs.pngpaste
    pkgs.cocoapods
    pkgs.openjdk17
    pkgs.wget
    pkgs.jellyfin-tui
    pkgs.btop
    pkgs.herdr
    pkgs.ghidra
    pkgs.matcha
  ];

  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
  ];
}
