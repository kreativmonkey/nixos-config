{ ... }:
{
    # collection of modules that are used on every Server configuration
    imports = [
        ../modules/podman.nix
        #../modules/firewall.nix
    ];

    # Installing Fish Shell - Smart and user-friendly command line shell
    programs.fish.enable = true;

    # Initial empty root password for easy login:
    users.users.root.initialHashedPassword = "";

    # Secure SSH Settings
    services.openssh = {
        enable = true;

        permitRootLogin = "no";
        passwordAuthentication = false;
    };

    # Installing mosh
    programs.mosh.enable = true;
    networking.firewall.allowedTCPPorts = [ 5901 ];

    environment.systemPackages = with pkgs; [
        nmap
        tcpdump
        smartmontools
        tree
        htop
        wget
        git
        gnupg
        curl
        tmux
        unzip
    ] ++ basePackages;

}/1d5a79fb8149a9478e200c95da626184/raw/c0862b2c7faad630b83ea7b9180a5bdda1197321/Nixos-Install-Github-Configuration