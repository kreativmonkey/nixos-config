{ ... }:
{
  imports = [

    # device specific hardware configuration
    #./hardware-configuration.nix

    # the "default" emile user
    ./users/sebastian.nix

    # import the collection of modules suited for laptops
    ./roles/server.nix

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

  networking.hostName = "pegasus"; # Define your hostname.
  networking.wireless.enable = false;  # Enables wireless support via wpa_supplicant.
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

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.09"; # Did you read the comment?
}