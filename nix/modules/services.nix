{ pkgs, home, ... }: {
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
