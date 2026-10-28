{ config, lib, pkgs, dotfiles, ... }:
let
  # live symlink into the repo (not a read-only store copy), so apps can write and edits apply without rebuild
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
in {
  home.stateVersion = "25.11";

  xdg.configFile = {
    "aerospace".source = link "aerospace";
    "alacritty".source = link "alacritty";
    "sioyek".source = link "sioyek";
    "scripts".source = link "scripts";
    "nvim".source = link "nvim";
    "ghostty".source = link "ghostty";
    "opencode".source = link "opencode";
    "nix".source = link "nix";
    "yazi".source = link "yazi";
    "tuicr".source = link "tuicr";
    "herdr/config.toml".source = link "herdr/config.toml";
    "herdr-automatic-rename/config.sh".source = link "herdr/automatic-rename.sh";
  };

  home.file = {
    ".tmux.conf".source = link "tmux/tmux.conf";
    "poshthemes".source = link "poshthemes";
    # lazygit on macOS reads Application Support; only the file, so state.yml stays out of the repo
    "Library/Application Support/lazygit/config.yml".source = link "lazygit/config.yml";
    ".local/bin/t".source = link "scripts/t";
    ".local/bin/h".source = link "scripts/h";
    ".local/bin/hw".source = link "scripts/hw";
    ".local/bin/ha".source = link "scripts/ha";
    ".local/bin/hgo".source = link "scripts/hgo";
    ".local/bin/hnew".source = link "scripts/hnew";
    ".local/bin/msg".source = link "scripts/msg";
  };

  # imperative steps; each is guarded so repeat rebuilds are no-ops
  home.activation = {
    # compiled binary, so build instead of symlink; only when the source changed
    fileclip = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      src="${dotfiles}/scripts/fileclip.swift"
      bin="$HOME/.local/bin/fileclip"
      if [ -f "$src" ] && [ -x /usr/bin/swiftc ] && [ "$src" -nt "$bin" -o ! -e "$bin" ]; then
        run mkdir -p "$HOME/.local/bin"
        run /usr/bin/swiftc -O "$src" -o "$bin"
      fi
    '';

    # noodle rewrites its config at runtime, so seed once instead of linking
    noodleConfig = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      if [ ! -f "$HOME/.config/noodle/config.yml" ]; then
        run mkdir -p "$HOME/.config/noodle"
        run cp "${dotfiles}/noodle/config.yml" "$HOME/.config/noodle/config.yml"
      fi
    '';

    # restore flavors/plugins from yazi/package.toml; ya comes from brew, may be absent on first run
    yaziPackages = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      if [ -x /opt/homebrew/bin/ya ]; then
        # activation runs with a minimal PATH; ya shells out to git
        run env PATH="${lib.makeBinPath [ pkgs.git ]}:$PATH" /opt/homebrew/bin/ya pkg install
      fi
    '';
  };
}
