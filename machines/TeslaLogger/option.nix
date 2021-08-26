{pkgs, config,...}:
let
    TL_ROOT = "/var/lib/TeslaLogger";
in
{

     imports = [
        # the "default" emile user
        ../../users/sebastian.nix

        # import the collection of modules suited for servers
        ../../roles/default.nix
        ../../config/location.nix

        # machine specific modules
        ../../modules/ssh.nix
    ];

    virtualisation.docker = {
	enable = true;
	enableOnBoot = true;
    };

    users.users.sebastian.extraGroups = [ "docker" ];

    environment.systemPackages = with pkgs; [
	    docker-compose
    ];	

    # Creating the bridged network for teslalogger
    systemd.services.init-filerun-network-and-files = {
        description = "Create the network bridge teslalogger for TeslaLogger.";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        
        serviceConfig.Type = "oneshot";
        script = let dockercli = "${config.virtualisation.docker.package}/bin/docker";
                in ''
                    # Put a true at the end to prevent getting non-zero return code, which will
                    # crash the whole service.
                    check=$(${dockercli} network ls | grep "teslalogger" || true)
                    if [ -z "$check" ]; then
                    ${dockercli} network create teslalogger
                    else
                    echo "teslalogger already exists in docker"
                    fi
                '';
    };

    docker-containers = {
        "teslalogger" = {
            image= "teslalogger_teslalogger";
            #imageFile = "${TL_ROOT}/docker/teslalogger/.";
            environment = {
                "TZ" = "Europe/Berlin";
            };
            volumes = [
                "${TL_ROOT}/TeslaLogger/www:/var/www/html"
                "${TL_ROOT}/TeslaLogger/bin:/etc/teslalogger"
                "${TL_ROOT}/TeslaLogger/GrafanaDashboards/:/var/lib/grafana/dashboards/"
                "${TL_ROOT}/TeslaLogger/GrafanaPlugins/:/var/lib/grafana/plugins"
                "${TL_ROOT}/docker/teslalogger/Dockerfile:/tmp/teslalogger-DOCKER"
                "teslalogger-tmp:/tmp/"
            ];
            ports = [ "5010:5000" ];
            extraDockerOptions = [ "--network=teslalogger" ];
            dependsOn = [ "database" ];
            autoStart = true;
        }; # teslalogger

        "database" = {
            image = "mariadb:10.4.7";
            environmentFiles = [
                "${TL_ROOT}/.env"
            ];
            volumes = [
                "${TL_ROOT}/TeslaLogger/sqlschema.sql:/docker-entrypoint-initdb.d/sqlschema.sql"
                "${TL_ROOT}/TeslaLogger/mysql:/var/lib/mysql"
            ];
            ports = [ "3306:3306" ];
            environment = {
                "TZ" = "Europe/Berlin";
            };
            extraDockerOptions = [ "--network=teslalogger" ];
        }; # database

        "grafana" = {
            image = "grafana/grafana:7.2.0";
            environment = {
                "GF_SECURITY_ADMIN_PASSWORD" = "teslalogger";
                "TZ" = "Europe/Berlin";
            };
            ports = [ "3000:3000" ];
            volumes = [
                "${TL_ROOT}/TeslaLogger/bin:/etc/teslalogger"
                "${TL_ROOT}/TeslaLogger/GrafanaDashboards/:/var/lib/grafana/dashboards/"
                "${TL_ROOT}/TeslaLogger/GrafanaPlugins/:/var/lib/grafana/plugins"
                "${TL_ROOT}/TeslaLogger/GrafanaConfig/datasource.yaml:/etc/grafana/provisioning/datasources/datasource.yml"
                "${TL_ROOT}/TeslaLogger/GrafanaConfig/sample.yaml:/etc/grafana/provisioning/dashboards/dashboards.yml"
            ];
            dependsOn = [ "database" ];
            extraDockerOptions = [ "--network=teslalogger" ];
        }; # grafana

        "webserver" = {
            image = "teslalogger_webserver";
            volumes = [
                "${TL_ROOT}/docker/webserver/php.ini:/usr/local/etc/php/php.ini"
                "${TL_ROOT}/TeslaLogger/www:/var/www/html"
                "${TL_ROOT}/TeslaLogger/bin:/etc/teslalogger"
                "${TL_ROOT}/docker/teslalogger/Dockerfile:/tmp/teslalogger-DOCKER"
                "teslalogger-tmp:/tmp/"
            ];
            ports = [ "8888:80" ];
            environment = {
                "TZ" = "Europe/Berlin";
            };
            extraDockerOptions = [ "--network=teslalogger" ];
        }; # webserver
    };
}