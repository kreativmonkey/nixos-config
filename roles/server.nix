{ config, pkgs, ... }:
{
    # collection of modules that are used on every Server configuration
    imports = [
        ./default.nix
        ../modules/podman.nix
        ../modules/ssh.nix
        ../modules/mosh.nix
        #../modules/firewall.nix
    ];

    # Installing Fish Shell - Smart and user-friendly command line shell
    programs.fish.enable = true;
    users.extraUsers.root.shell = pkgs.fish;

    # Headless settings like https://nixos.org/manual/nixos/stable/#sec-profile-headless
    sound.enable = false;
    systemd.enableEmergencyMode = false;
     
    
    # Initial empty root password for easy login:
    users.users.root.initialHashedPassword = "";

    environment.systemPackages = with pkgs; [
   
    ];

}
