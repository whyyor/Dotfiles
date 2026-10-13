{ pkgs, ... }: {
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
        # outside ~/Library/Caches, which disk cleaners (Mole) wipe under the running daemon
        GOMUKS_CACHE_HOME = "/Users/whyyor/.local/share/gomuks-cache";
      };
    };
  };

  # expire gomuks media cache: files older than 7 days (re-downloaded on demand), stale temp files after a day
  launchd.user.agents.gomuks-cache-expiry = {
    serviceConfig = {
      ProgramArguments = [ "/bin/sh" "-c" ''
        C=/Users/whyyor/.local/share/gomuks-cache
        find "$C/media" -type f -mmin +10080 -delete 2>/dev/null
        find "$C/tmp" -type f -mmin +1440 -delete 2>/dev/null
        find "$C/media" -mindepth 1 -type d -empty -delete 2>/dev/null
        true
      '' ];
      RunAtLoad = true;
      StartCalendarInterval = [ { Hour = 4; Minute = 0; } ];
    };
  };
}
