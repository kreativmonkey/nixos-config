{...}:
let 
    ROOT = "/var/lib/portainer";
in
{
    virtualisation.oci-containers = {
        containers = {
            portainer = {
                image = "portainer/portainer-ce";
                volumes = [
                    "${ROOT}/data:/data"
                    "/var/run/docker.sock:/var/run/docker.sock"
                ];
                ports = [ "8000:8000" "9000:9000" ];
            };
        };
    };
}
