{config, pkgs, ...}:

{
    virtualisation.oci-containers = {
        backend = "docker";
        containers = {
            shinobi = {
                image = "shinobisystems/shinobi:dev";
                volumes = [
                    "/dev/shm/Shinobi/streams:/dev/shm/streams:rw" 
                    "/var/lib/Shinobi/config:/config:rw" 
                    "/var/lib/Shinobi/customAutoLoad:/home/Shinobi/libs/customAutoLoad:rw"
                    "/var/lib/Shinobi/database:/var/lib/mysql:rw"
                    "/var/lib/Shinobi/videos:/home/Shinobi/videos:rw" 
                    "/var/lib/Shinobi/plugins:/home/Shinobi/plugins:rw"
                    "/etc/localtime:/etc/localtime:ro" 
                ];
                ports = [ "8080:8080/tcp" ];
            };
        };
    };
}