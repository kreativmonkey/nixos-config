{ ... }:
{
  imports = [

    # device specific hardware configuration
    ../hardware-configuration.nix

    # the "default" emile user
    ../users/sebastian.nix

    # import the collection of modules suited for laptops
    ../roles/server.nix
    ../modules/keymap_neo.nix
    ../config/location.nix

    # machine specific modules
    ../modules/nextcloud.nix
    ../modules/letsencrypt.nix
    ../modules/mysql.nix
    ../modules/postgresql.nix
    ../modules/gitea.nix
    ../modules/fail2ban.nix
    ## Wait for stable
    ../modules/vikunja.nix
    
    ../modules/container.nix
    ../modules/mealie.nix
    ../modules/prometheus.nix
    ../modules/netdata.nix
    ../modules/authentik.nix
    ../modules/keycloak.nix
    ../modules/teslamate.nix
    ../modules/wireguard.nix
    ../modules/bookstack.nix
#../modules/firewall.nix
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
    #./modules/time.nix
    #./modules/wireguard.nix
    #./modules/netdata.nix
    #./modules/location.nix
  ];

  networking = {
    hostName = "pegasus"; # Define your hostname.
    wireless.enable = false;  # Enables wireless support via wpa_supplicant.

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;


    defaultGateway = {
      address = "10.0.1.1";
      interface = "ens3";
    };
    defaultGateway6 = {
      address = "2a01:4f8:161:62a7:1::1";
      interface = "ens3";
    };
    interfaces.ens3 = {
      useDHCP = false;
      ipv4.addresses = [{address = "5.9.61.183"; prefixLength = 32; }];
      ipv6.addresses = [{address = "2a01:4f8:161:62a7:183::1"; prefixLength = 80; }];
    };
    nameservers = [ "1.1.1.1" "8.8.8.8" "9.9.9.9" "2001:4860:4860::8888" "2001:4860:4860::8844" ];
  };
  
  networking.wireguard.interfaces.wg0.peers = [
        # List of allowed peers.
        # Feel free to give a meaning full name
        # Public key of the peer (not a file path).
        # publicKey = "";
        # allowedIPs = [ "10.100.0.2/32" "fdc9:281f:04d7:9ee9::2/128" ];
        {   # OnePlus
            publicKey = "GbwR+pmZHsYVC/XSqomLrGlfeLpGv3uytZu9kEfwikI=";
            allowedIPs = [ "10.100.0.3/32" "fdc9:281f:04d7:9ee9::3/128" ];
          }
        { # Home
          publicKey = "/Ra34AvvbJCBqb0CsPym3loimL48K6XU6UimXgSz63A=";
          allowedIPs = [ "10.100.0.2/32" ];
        }
        #{   # Anarchy
        #    publicKey = "";
        #    allowedIPs = [ "10.100.0.5/32" "fdc9:281f:04d7:9ee9::5/128"];
        #}
        #{   # Server
        #    publicKey = "";
        #    allowedIPs = [ "10.100.0.10/32" "fdc9:281f:04d7:9ee9::10/128"];
        #}
  ];

  #hardware.cpu.intel.updateMicrocode = true;

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.devices = [ "/dev/sda" ];

  # System autoupgrade
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "21.05"; # Did you read the comment?
}
