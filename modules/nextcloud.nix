{config, pkgs, ...}:
let
  version = "20";
  hostname = "nx.butlr.org";

  dbName = "nextcloud";
  dbUser = "nextcloud";
  dbpassFile = "/var/src/secrets/nextcloud-db-pass";
  adminpassFile = "/var/src/secrets/nextcloud-db-pass";
  adminuser = "admin";
in
{

services.nginx = {
  enable = true;

  # Use recommended settings
  recommendedGzipSettings = true;
  recommendedOptimisation = true;
  recommendedProxySettings = true;
  recommendedTlsSettings = true;

  # Only allow PFS-enabled ciphers with AES256
  sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";

  # Setup Nextcloud virtual host to listen on ports
  virtualHosts."${hostname}" = {
    ## Force HTTP redirect to HTTPS
    forceSSL = true;
    ## LetsEncrypt
    enableACME = true;
  };
};

services.nextcloud = {
  enable = true;
  package = pkgs.nextcloud${version};

  hostName = hostname;

  # Settungs
  caching.apcu = true;
  maxUploadSize = "1GB";


  # Use HTTPS for links
  https = true;
  
  # Auto-update Nextcloud Apps
  autoUpdateApps.enable = true;
  # Set what time makes sense for you
  autoUpdateApps.startAt = "05:00:00";

  config = {
    # Further forces Nextcloud to use HTTPS
    overwriteProtocol = "https";

    # Nextcloud PostegreSQL database configuration, recommended over using SQLite
    #dbtype = "pgsql";
    #dbuser = "nextcloud";
    #dbhost = "/run/postgresql"; # nextcloud will add /.s.PGSQL.5432 by itself
    #dbname = "nextcloud";
    #dbpassFile = "/var/nextcloud-db-pass";

    dbtype = "mysql";
    dbuser = dbUser;
    #dbhost = "/run/postgresql"; # nextcloud will add /.s.PGSQL.5432 by itself
    dbname = dbName;
    dbpassFile = dbpassFile;


    adminpassFile = adminpassFile;
    adminuser = adminuser;
  };
};

services.mysql = {
  enable = true;

  # Ensure the database, user, and permissions always exist
  ensureDatabases = [ dbName ];
  ensureUsers = [
    { name = dbUser;
      ensurePermissions = { "${dbName}.*" = "ALL PRIVILEGES"; };
    }
  ];
  # Deprecated
  # settings = ''
  #      innodb_large_prefix=true
  #      innodb_file_format=barracuda
  #      innodb_file_per_table=1
  #'';
};


}