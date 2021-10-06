{pkgs, config, lib, ...}:
let

in {
  services = {
    postgresql = {
      enable = true;
      settings = {
        log_connections = true;
        log_statement = "all";
        logging_collector = true;
        log_disconnections = true;
        log_destination = lib.mkForce "syslog";
      };
    };
    pgmanage = {
      enable = true;
      connections = {
        "localhost" = "hostaddr=127.0.0.1 port=5432 dbname=postgres";
      };
      port = 8432;
    };
    nginx.virtualHosts."pg.oc4.de" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://localhost:${toString config.services.pgmanage.port }";
      };
    };
  };
}
