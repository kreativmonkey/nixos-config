{ config, ...}:
## inspired by https://www.wouterbulten.nl/blog/tech/home-automation-setup-docker-compose/#mariadb
let

    SERVER_IP= "0.0.0.0";
    HA_APPDEAMON_KEY= "some long accces token";
    VSCODE_PASSWORD= "password";
    LOCAL_USER= "1000";
    VNC_PASSWORD= "password";
    MYSQL_ROOT_PASSWORD= "mySecretPassword";
    HA_MYSQL_PASSWORD= "password";
    HA_ROOT = "/var/lib/homeassistant";

in
{
     
    virtualisation.oci-containers = {
        containers = {
            hass = {
                image = "homeassistant/home-assistant:0.117.5";
                volumes = [
                "/etc/localtime:/etc/localtime:ro"
                "${HA_ROOT}/config/:/config"
                ];
                extraOptions = [
                    "--network=host"
                    # To add USB-devices:
                    # "--device=/dev/serial/by-id/usb-0658_0200-if00"
                ];
                #user = "${LOCAL_USER}:${LOCAL_USER}";
                dependsOn = [
                    "mariadb"
                    #"deconz"
                ];
            };

            mariadb = {
                image = "mariadb/server:10.3";
                environment = {
                    MYSQL_ROOT_PASSWORD = "${MYSQL_ROOT_PASSWORD}";
                    MYSQL_DATABASE = "ha_db";
                    MYSQL_USER = "homeassistant";
                    MYSQL_PASSWORD = "${HA_MYSQL_PASSWORD}";
                };
                #user = "${LOCAL_USER}:${LOCAL_USER}";
                ports = [ "3306:3306" ];
                volumes = [
                    "/etc/localtime:/etc/localtime:ro"
                    "${HA_ROOT}/mysql/:/var/lib/mysql"
                ];
            };

            #deconz = {
            #    image = "marthoc/deconz:stable";
            #    environment = {
            #        # You can access Deconz at this port
            #        DECONZ_WEB_PORT = "8080";
            #        DECONZ_WS_PORT = "8088";
            #        # Set VNC_MODE to 0 to disable it completely
            #        DECONZ_VNC_MODE = "0";
            #        DECONZ_VNC_PORT = "5900";
            #        DECONZ_VNC_PASSWORD = "${VNC_PASSWORD}";
            #    };
            #    extraOptions = [
            #        "--network=host"
            #        "--device=/dev/ttypUSB0:/dev/ttypUSB0"
            #    ];
            #    volumes = [
            #        "/etc/localtime:/etc/localtime:ro"
            #        "/etc/timezone:/etc/timezone:ro"
            #        # Replace <local path> with a path where all deconz config will be stored.
            #        "${HA_ROOT}/deconz/:/root/.local/share/dresden-elektronik/deCONZ"
            #    ];
            #};
            
            #nodered = {
            #    image = "nodered/node-red";
            #    ports = [ "1880:1880" ];
            #    volumes = [
            #        "/var/lib/homeassistant/nodered:/data"
            #    ];
            #    #dependsOn = [ "hass" ];
            #    environment = {
            #        TZ = "Europe/Berlin";
            #    };
            #    #user = "${LOCAL_USER}:${LOCAL_USER}";
            #};
            
            #app_daemon = {
            #    image = "acockburn/appdeamon:latest";
            #    environment = {
            #      HA_URL = "http://${SERVER_IP}:8123";
            #      TOKEN = HA_APPDAEMON_KEY;
            #      DASH_URL = "http://${SERVER_IP}:5050";
            #  };
            #  ports = [ "5050:5050" ];
            #  volumes = [
            #      "${HA_ROOT}/appdaemon/:/conf"
            #  ];
            #    dependsOn = [ "hass" ];
            #    #user = "${LOCAL_USER}:${LOCAL_USER}";
            #};
            
            #vscode = {
            #    image = "codercom/code-server";
            #    volumes = [
            #      # Set <project dir> to the directory you want to open in VS Code.
            #      "${HA_ROOT}/config/:/home/coder/porject"
            #      # <vs code config> should point to a local dir where vs code stores its data.
            #      "${HA_ROOT}/vscode/:/home/coder/.local/share/code-server"
            #  ];
            #  ports = [ "8443:8080" ];
            #  environment = {
            #      PASSWORD = "${VSCODE_PASSWORD}";
            #  };
            #  #extraOptions = {
            #  #    "command code-server --auth password --disable-telemetry /home/coder/project";
            #    #};
            #    #user = "${LOCAL_USER}:${LOCAL_USER}";
            #};

        }; # containers
    }; # virtualisation


    services.mosquitto = {  
      enable = true;
      host = "0.0.0.0";
      users = { 
          hass = {
              acl = [ "topic readwrite #" ]; 
              password = "notmypassword"; };
            };
      extraConf = "log_type debug";
    };
}
