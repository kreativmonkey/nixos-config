{config, pkgs, ...}:

{
    # collection of modules that are used on every Server configuration
    imports = [
		#./home-assistant.nix
        ./portainer.nix
    ];


    virtualisation.docker = {
        enable = true;
    };

    environment.systemPackages = with pkgs; [
        docker-compose
    ];

}