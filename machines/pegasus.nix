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
    ../location/de.nix

    # machine specific modules
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
    interfaces.ens3 = {
      useDHCP = false;
      ipv4.addresses = [{address = "5.9.61.183"; prefixLength = 32; }];
    };
    nameservers = [ "1.1.1.1" "8.8.8.8" "9.9.9.9" ];
  };
  #hardware.cpu.intel.updateMicrocode = true;

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.devices = [ "/dev/sda" ];

  programs.vim.defaultEditor = true;
  programs.fish.enable = true;

  # System autoupgrade
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "21.05"; # Did you read the comment?
}
