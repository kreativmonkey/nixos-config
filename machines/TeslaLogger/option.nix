{pkgs, ...}:

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
}
