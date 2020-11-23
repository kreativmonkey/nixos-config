{ ... }:
{
    imports = [

        # device specific hardware configuration
        ./hardware-configuration.nix

        # the "default" emile user
        ../../users/sebastian.nix

        # import the collection of modules suited for laptops
        ../../roles/pc.nix

        # machine specific modules
        ./modules/boot.nix
        ./modules/env.nix
        ./modules/filesystem.nix
        ./modules/firewall.nix
        ./modules/hardware.nix 
        ./modules/internationalisation.nix
        ./modules/networking.nix
        ./modules/nix.nix
        ./modules/pkgs.nix
        ./modules/power.nix
        ./modules/programs.nix
        ./modules/services.nix
        ./modules/time.nix
        ./modules/wireguard.nix
        ./modules/netdata.nix
        ./modules/location.nix
    ];


    networking.hostName = "bulido"; # Define your hostname.
    networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    networking.extraHosts = ''
        192.168.5.100 core.local
        192.168.5.121 home.local
        192.168.5.126 anarchy.local
    '';

    hardware = {
        pulseaudio = {
            enable = true;
            support32Bit = true;
        };
    };

    # This value determines the NixOS release with which your system is to be
    # compatible, in order to avoid breaking some software such as database
    # servers. You should change this only after NixOS release notes say you
    # should.
    system.stateVersion = "20.09"; # Did you read the comment?
}