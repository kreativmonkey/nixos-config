{ pkgs, ... }:
{
    users.users.podmanager = {   
        isNormalUser = true;
    };

    virtualisation.podman = {
        enable = true;
        dockerCompat = true;
    };

    environment.systemPackages = with pkgs; [
        podman-compose
    ];

}