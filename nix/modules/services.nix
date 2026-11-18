{ pkgs, home, ... }:
let
  # manual trigger: asks launchd to run the worker, so it's safe to call from inside Ghostty
  ghosttyRefresh = pkgs.writeShellScriptBin "ghostty-refresh" ''
    # marks the run as manual so the worker skips its busy-agent guard
    /bin/mkdir -p "$HOME/.local/state/ghostty-refresh"
    /usr/bin/touch "$HOME/.local/state/ghostty-refresh/manual"
    exec /bin/launchctl kickstart -k "gui/$(/usr/bin/id -u)/org.nixos.ghostty-refresh"
  '';
in {
  environment.systemPackages = [ ghosttyRefresh ];

  # worker lives in the repo (scripts/ghostty-refresh-worker); runs under launchd so it survives Ghostty dying
  launchd.user.agents.ghostty-refresh.serviceConfig = {
    ProgramArguments = [ "${pkgs.bash}/bin/bash" "${home}/.config/scripts/ghostty-refresh-worker" ];
    StartCalendarInterval = [ { Hour = 6; Minute = 0; } ];
    StandardOutPath = "/tmp/ghostty-refresh.log";
    StandardErrorPath = "/tmp/ghostty-refresh.log";
  };

  services = {
    tailscale.enable = true;

    postgresql = {
      enable = true;
      package = pkgs.postgresql_16;  # Stable version
      dataDir = "${home}/.postgresql/data";
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
}
