{ config, pkgs, ... }: 
{
  # grafana configuration
  services.grafana = {
    enable = true;
    domain = "grafana.oc4.de";
    port = 2342;
    addr = "127.0.0.1";
  };
  
  # nginx reverse proxy
  services.nginx.virtualHosts.${config.services.grafana.domain} = {
    ## Force HTTP redirect to HTTPS
    forceSSL = true;
    ## LetsEncrypt
    enableACME = true;

    locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.grafana.port}";
        proxyWebsockets = true;
    };
  };

  services.prometheus = {
    enable = true;
    port = 9001;

    exporters = {
      node = {
        enable = true;
        enabledCollectors = ["systemd"];
        port = 9002;
      };
    };

    scrapeConfigs = [
      {
        job_name = "pegasus";
        static_configs = [{
          targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ];
        }];
      }
    ];
  };

  services.loki = {
    enable = true;
    configFile = ./loki-local-config.yaml;
  };

  systemd.services.promtail = {
    description = "Promtail service for Loki";
    wantedBy = ["multi-user.target"];

    serviceConfig = {
      ExecStart = ''
        ${pkgs.grafana-loki}/bin/promtail --config.file ${./promtail.yaml}
        '';
    };
  };
}
