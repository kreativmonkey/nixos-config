{config, pkgs, lib,...}:
let
  unstable = import <nixos-unstable> {};
in
  {
    imports = [ <nixos-unstable/nixos/modules/services/web-apps/vikunja.nix> ];

    services.vikunja = {
      enable = true;
      setupNginx = true;
      frontendScheme = "https";
      frontendHostname = "todo.oc4.de";
      package-frontend = unstable.vikunja-frontend;
      package-api = unstable.vikunja-api;

    };

    services.nginx.virtualHosts."todo.oc4.de" = {
      enableACME = true;
      forceSSL = true;
    };
  }
