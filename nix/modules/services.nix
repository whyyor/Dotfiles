{ pkgs, home, ... }:
let
  # does the actual kill + relaunch; runs under launchd so it survives Ghostty dying
  ghosttyRefreshWorker = pkgs.writeShellScript "ghostty-refresh-worker" ''
    /usr/bin/pgrep -xq ghostty || exit 0
    /usr/bin/pkill -9 -x ghostty
    for _ in {1..40}; do /usr/bin/pgrep -xq ghostty || break; /bin/sleep 0.05; done
    /usr/bin/open -a Ghostty
  '';
  # manual trigger: asks launchd to run the worker, so it's safe to call from inside Ghostty
  ghosttyRefresh = pkgs.writeShellScriptBin "ghostty-refresh" ''
    exec /bin/launchctl kickstart -k "gui/$(/usr/bin/id -u)/org.nixos.ghostty-refresh"
  '';
in {
  environment.systemPackages = [ ghosttyRefresh ];

  launchd.user.agents.ghostty-refresh.serviceConfig = {
    ProgramArguments = [ "${ghosttyRefreshWorker}" ];
    StartCalendarInterval = [ { Hour = 6; Minute = 0; } ];
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
