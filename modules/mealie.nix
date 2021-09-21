{...}:
let
    hostname = "meal.oc4.de";
    MEALIE_ROOT = "/var/lib/mealie";
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
	    serverAliases = [ "meal.calyrium.org" ];
            locations."/" = {
                proxyPass = "http://localhost:9925";
            };
        };
    };

    virtualisation.oci-containers.containers = {
        "mealie" = {
            image= "hkotel/mealie:latest";
            environment = {
                "TZ" = "Europe/Berlin";
                #"PUID" = "1000";
                #"PGID" = "1000";

                # Default Recipe Settings
                "RECIPE_PUBLIC" = "false";
                "RECIPE_SHOW_NUTRITION" = "true";
                "RECIPE_SHOW_ASSETS" = "true";
                "RECIPE_LANDSCAPE_VIEW" = "true";
                "RECIPE_DISABLE_COMMENTS" = "false";
                "RECIPE_DISABLE_AMOUNT" = "false";

                # Gunicorn
                "WEB_CONCURRENCY" = "2";
            };
            volumes = [
                "${MEALIE_ROOT}/:/app/data"
            ];
            ports = [ "9925:80" ];
            autoStart = true;
        }; # Mielie
    };
}
