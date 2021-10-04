{config, pkgs, lib, ...}:
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
      #database = {
      #  type = "postgres";
      #  host = "localhost";
      #  database = "vikunja";
      #  user = "vikunja";
      #};
      #environmentFiles = [
      #  "/var/src/secrets/vikunja_db_pass"
      #];
      settings = {
        auth = {
          local = {
            enable = false;
          };
          openid = {
            enable = true;
            providers = [ {
              name = "vikunja";
              authurl = "https://login.oc4.de/application/o/vikunja";
              clientid = lib.removeSuffix "\n" (builtins.readFile /var/src/secrets/vikunja_clientid);
              clientsecret = lib.removeSuffix "\n" (builtins.readFile /var/src/secrets/vikunja_clientsecret);
            } ];
          };
        };
      };
    };

    services.nginx.virtualHosts."${config.services.vikunja.frontendHostname}" = {
      enableACME = true;
      forceSSL = true;
    };

    services.postgresql = {
      ensureDatabases = [ "vikunja" ];
      ensureUsers = [ { 
        name = "vikunja";
        ensurePermissions = { "DATABASE vikunja" = "ALL PRIVILEGES"; };
      } ];
    };

    systemd.services.vikunja-api = {
      serviceConfig = {
        DynamicUser = lib.mkForce false;
        User = "vikunja";
        Group = "vikunja";
      };
    };

    users.users.vikunja = {
      description = "Vikunja Service";
      createHome = false;
      group = "vikunja";
      isSystemUser = true;
    };

    users.groups.vikunja = {};
  }
