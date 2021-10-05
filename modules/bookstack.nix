{pkgs, ...}:
{

  services.nginx.virtualHosts."wiki.oc4.de" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://localhost:6875";
    };
  };
}
