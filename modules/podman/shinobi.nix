{ config, ...}:
let

    poduser = "podmanager";

in
{
    # TODO:
    # environment:
    #     - 'APP_BRANCH=dev'
    # restart: always
    # https://hub.docker.com/r/shinobicctv/shinobi/dockerfile
    virtualisation.oci-containers = {
        backend = "podman";
        containers = {
            shinobi = {
                image = "shinobisystems/shinobi";
                user = poduser;
                workdir = "/home/${poduser}";
                ports = ["8088:8080"];
                volumes = [
                    "/dev/shm/shinobiStreams:/dev/shm/streams"
                    "/home/${poduser}/shinobi/config:/config"
                    "/home/${poduser}/shinobi/customautoload:/customAutoLoad"
                    "/home/${poduser}/shinobi/database:/var/lib/mysql"
                    "/home/${poduser}/shinobi/videos:/opt/shinobi/videos"
                ];
            }; # hass
        }; # containers
    }; # virtualisation.oci-containers

    #systemd.services.podman-hass.serviceConfig.User = "podmanager";

}