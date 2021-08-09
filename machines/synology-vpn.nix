{ pkgs, ... }:

{

    imports = [
        ../hardware-configuration.nix        

        # the "default" emile user
        ../users/sebastian.nix

        # import the collection of modules suited for servers
        ../roles/server/wireguardvpn.nix
        ../roles/default.nix

        # TODO: Variablen nutzen für besseres handling
        #     (import <mobile-nixos/lib/configuration.nix> { device = "xxx-yyy"; })

        # machine specific modules
        #../modules/podman/podman.nix
        #../modules/podman/bookstack.nix
        #../modules/home-assistant/default.nix
        #../modules/shinobi.nix
        #./modules/desktop.nix
        #./modules/boot.nix
        #./modules/env.nix
        #./modules/filesystem.nix
        #./modules/firewall.nix
        #./modules/hardware.nix 
        #./modules/internationalisation.nix
        #./modules/networking.nix
        #./modules/nix.nix
        #./modules/pkgs.nix
        #./modules/power.nix
        #./modules/programs.nix
        #./modules/services.nix
        ../modules/ssh.nix
        #./modules/time.nix
        #./modules/wireguard.nix
        #./modules/netdata.nix
        #./modules/location.nix
    ];

    # Use the GRUB 2 boot loader.
    boot.loader.grub = {
        enable = true;
        version = 2;
        device = "/dev/sda";
    };
    
    networking = {
        hostName = "wireguardvpn"; # Define your hostname.
        useDHCP = false; # deprecated and will be mandatory in the future
        interfaces.ens3.useDHCP = true;
    };

    # Select internationalisation properties.
    i18n.defaultLocale = "de_DE.UTF-8";
    console = {
    #   font = "Lat2-Terminus16";
        keyMap = "neo";
    };

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    programs.gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
    };

    # Changing SSH Port
    services.openssh = {
        ports = [ 2258 ];
    };

    # System autoupgrade
    system.autoUpgrade.enable = true;
    system.autoUpgrade.allowReboot = true;

    # This value determines the NixOS release with which your system is to be
    # compatible, in order to avoid breaking some software such as database
    # servers. You should change this only after NixOS release notes say you
    # should.
    system.stateVersion = "21.05"; # Did you read the comment?
}