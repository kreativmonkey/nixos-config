{ pkgs, ... }:
{
    users.users.podmanager = {   
        isNormalUser = true;
    };
    
    virtualisation.oci-containers.backend = "podman";

    virtualisation.podman = {
        enable = true;
        #dockerCompat = true;
    };

    virtualisation.docker = {
      enable = true;
    };

    environment.systemPackages = with pkgs; [
      podman-compose
      docker-compose
    ];

}
