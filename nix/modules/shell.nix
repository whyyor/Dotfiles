{ pkgs, ... }: {
  # nix-darwin defaults EDITOR to nano; yazi/git/crontab all follow $EDITOR
  environment.variables.EDITOR = "nvim";

  # REA MCP: stable paths to Ghidra + JDK21, independent of shell env
  environment.etc."rea/ghidra".source = "${pkgs.ghidra}/lib/ghidra";
  environment.etc."rea/jdk21".source = "${pkgs.openjdk21.home}";

  # bun global installs land in ~/.bun/bin, absent from PATH by default
  environment.systemPath = pkgs.lib.mkOrder 1100 [ "$HOME/.bun/bin" ];

  # yt helpers land in /etc/zshrc; ~/.zshrc definitions would override these
  programs.zsh.enable = true;
  programs.zsh.interactiveShellInit = builtins.readFile ./zsh/yt.zsh;
}
