{pkgs, lib, ...}:
let
    hostname = "wiki.butlr.org";

    dbUser = "bookstack";
    dbName = "boockstackapp";
    #dbpassFile = "/var/src/secrets/bookstack-db-pass";
    home = "/home/podmanager/bookstack";
in
{
  # Setup reverse proxy with nginx
  #services.nginx = {
  #    enable = true;

      # Use recommended settings
  #    recommendedGzipSettings = true;
  #    recommendedOptimisation = true;
  #    recommendedProxySettings = true;
  #    recommendedTlsSettings = true;

      # Only allow PFS-enabled ciphers with AES256
  #    sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";

      # Setup Nextcloud virtual host to listen on ports
  #    virtualHosts."${hostname}" = {
          ## Force HTTP redirect to HTTPS
  #        forceSSL = true;
          ## LetsEncrypt
  #        enableACME = true;

  #        locations."/" = {
  #            proxyPass = "http://localhost:6875";
  #        };
  #    };
  #};

  virtualisation.oci-containers = {
        backend = "podman";
        containers = {
            bookstack = {
                image = "linuxserver/bookstack";
                ports = ["6875:80"];
                volumes = [
                  "/etc/localtime:/etc/localtime:ro"
                  "${home}/data:/config"
                ];
                environment = {
                  PUID = "1000";
                  PGID = "1000";
                  DB_HOST = "bookstack_db";
                  DB_USER = "bookstack";
                  DB_DATABASE = "bookstackapp";
                  DB_PASSWORD="book_pass=word";
                };
                dependsOn = [ "bookstack_db" ];
            };
            bookstack_db = {
                image = "linuxserver/mariadb";
                environment = {
                  PUID = "1000";
                  PGID = "1000";
                  MYSQL_ROOT_PASSWORD = "passwordsecure";
                  TZ = "Europe/Berlin";
                  MYSQL_DATABASE= "bookstackapp";
                  MYSQL_USER= "bookstack";
                  MYSQL_PASSWORD="book_pass=word";
                };
                volumes = [
                  "${home}/db:/config"
                ];
            };
        };
    };
  
  systemd.services = {

    #bookstack-setup = {
    #  wantedBy = [ "default.target" ];
    #  before = [ "podman-bookstack_db" ];
    #  script = ''
    #        # create directories.
    #        # if the directories exist already with wrong permissions, we fix that
    #        for dir in ${home} ${home}/db ${home}/data; do
    #          if [ ! -e $dir ]; then
     #           mkdir -p $dir
     #         fi
    #        done
    #        exit 0
    #      '';
    #  serviceConfig = {
    #    Type = "oneshot";
    #    User = "podmanager";
    #  };
    #};

    podman-bookstack = {
      description = "Starting Bookstackapp on podman";
      serviceConfig.User = "podmanager";
      wantedBy = [ "default.target" ];
      after = ["network.target"];
    };

    podman-bookstack_db = {
      serviceConfig.User = "podmanager";
      wantedBy = [ "default.target" ];
      after = ["network.target"];
    };
  };

}