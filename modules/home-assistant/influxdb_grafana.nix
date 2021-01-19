{config, pkgs, ...}:
let
  grafanaPort = 3000;
  influxApiPort = 2003;
  ipAddress = "127.0.0.1";
  mkGrafanaInfluxSource = db: {
    name = "My Graphit-${db} DB";
    type = "graphite";
    database = db;
    editable = false; # Force editing in this file.
    access = "proxy";
    # user = "grafana"; # fill in Grafana InfluxDB user, if enabled
    # password = "grafana";
    url = ("http://${ipAddress}:${toString influxApiPort}");
  };
in
{
  services.graphite = {
    web.enable = true;
    #group = "hass";
    dataDir = "/var/lib/homeassistant/graphite";
  };

  services.grafana = {
    addr = ""; # listen (bind) to all network interfaces (i.e. 127.0.0.1, and ipAddress)
    enable = true;
    port = grafanaPort;
    domain = "localhost";
    protocol = "http";
    dataDir = "/var/lib/homeassistant/grafana";
  };

  systemd.services.grafana = {
    # wait until all network interfaces initialize before starting Grafana
    after = [ "network-interfaces.target" ];
    wants = [ "network-interfaces.target" ];
  };  

  services.grafana.provision = {
    enable = true;
    datasources = map mkGrafanaInfluxSource
      ["home-assistant"];
  };

  networking.firewall.allowedTCPPorts = [ grafanaPort ];	# ports for influx API, grafana, resp.
}