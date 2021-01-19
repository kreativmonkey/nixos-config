{ pkgs, ... }:
{
    users.users."podmanager" = {
        description = "User for managing Containers";
        isNormalUser = true;
        createHome = true;
    };

    virtualisation.podman = {
        enable = true;
        dockerCompat = true;
    };

    environment.systemPackages = with pkgs; [
        podman-compose # to map docker to podman commands
    ];

}