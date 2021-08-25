{config, pkgs, ...}:
let
    hostname = "git.calyrium.org";

    dbUser = "gitea";
    dbName = "gitea";
    dbpassFile = "/var/src/secrets/gitea-db-pass";
in
{

    # Setup reverse proxy with nginx
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
	    serverAliases = [ "git.oc4.de" ];

            locations."/" = {
                proxyPass = "http://localhost:3000";
            };
        };
    };

    services.gitea={
        enable = true;

        appName = "Private Git Base";
        rootUrl = "https://${hostname}";
        user = "gitea";
        httpPort = 3000;
        log.level = "Warn";
        disableRegistration = false;

        #stateDir = "var/lib/gitea";
        useWizard = false;
        domain = "https://${hostname}";

        database = {
            host = "localhost";
            name = dbName;
            user = dbUser;
            #path = "/whatever";
            port = 3306;
            type = "mysql";
            passwordFile = dbpassFile;
        };

        # Enable a timer that runs gitea dump to generate backup-files of the current database and repositorys.
        dump = {
            enable = true;
            backupDir = "/var/src/backup/gitea";
            # Run a gitea dump at this interval. Runs by default at 04:31 every day. The format is described in systemd.time 7.
            interval = "05:31";
        };
        ssh = {
            enable = true;
            # SSH port displayed in clone URL. The option is required to configure a service when the external 
            # visible port differs from the local listening port i.e. if port forwarding is used. 
            clonePort = 22;
        };
    };
    
    services.mysql = {
	enable = true;
	ensureDatabases = [ dbName ];
	ensureUsers = [{
		name = dbUser;
		ensurePermissions = { "${dbName}.*" = "ALL PRIVILEGES"; };
	}];
    };

    systemd.services."gitea-dump" = {
        requires = ["mysql.service"];
        after = ["mysql.service"];
    };

}
