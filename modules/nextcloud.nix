{config, pkgs, ...}:
let
  version = "22";
  nextcloud_host = "www.oc4.de";

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
    virtualHosts.${nextcloud_host} = {
      ## Force HTTP redirect to HTTPS
      forceSSL = true;
      ## LetsEncrypt
      enableACME = true;
    };
  };

  # letsencrypt settings
  security.acme.email = "kreativmonkey@calyrium.org";
  security.acme.acceptTerms = true;

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud21; # TODO: adding version on this place

    hostName = nextcloud_host;

    # Settungs
    caching = {
	apcu = true;
	memcached = true;
	redis = false;
    };
    #maxUploadSize = "1024MB";


    # Use HTTPS for links
    https = true;
    
    # Auto-update Nextcloud Apps
    autoUpdateApps.enable = true;
    # Set what time makes sense for you
    autoUpdateApps.startAt = "05:00:00";

    config = {
      # Further forces Nextcloud to use HTTPS
      overwriteProtocol = "https";

      dbtype = "mysql";
      dbuser = dbUser;
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

  services.mysqlBackup.databases = 
	if config.services.mysqlBackup.enable then
		[ dbName ]
	else
		[];
  

  # Firewall settings for that module
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
