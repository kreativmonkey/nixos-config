{ pkgs, ... }:

{

    imports = [
        ../../hardware-configuration.nix   
        ./option.nix     
    ];

    # Use the GRUB 2 boot loader.
    boot.loader.grub = {
        enable = true;
        version = 2;
        device = "/dev/sda";
        # Use to reduce boot size like described under https://serverfault.com/posts/997143/revisions
        configurationLimit = 3;
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

    # System autoupgrade
    system.autoUpgrade.enable = true;
    system.autoUpgrade.allowReboot = true;

    # Auto garbade collection
    nix.gc.automatic = true;

    # This value determines the NixOS release with which your system is to be
    # compatible, in order to avoid breaking some software such as database
    # servers. You should change this only after NixOS release notes say you
    # should.
    system.stateVersion = "21.05"; # Did you read the comment?
}