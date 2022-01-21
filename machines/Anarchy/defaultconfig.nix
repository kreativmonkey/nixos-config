{ pkgs, ... }:
{
  imports = [
    # device specific hardware configuration
    "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; }}/lenovo/thinkpad/t460s"
    ../../hardware-configuration.nix

    # the "default" emile user
    ../../users/sebastian.nix

    # import the collection of modules suited for laptops
    ../../roles/laptop.nix

    # TODO: Variablen nutzen für besseres handling
    #     (import <mobile-nixos/lib/configuration.nix> { device = "xxx-yyy"; })

    # machine specific modules
    ../../modules/podman.nix
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
    #../modules/ssh.nix
    #./modules/time.nix
    #./modules/wireguard.nix
    #./modules/netdata.nix
    #./modules/location.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use the GRUB 2 boot loader.
  boot.loader.grub = {
    enable = true;
    version = 2;
    efiSupport = true;
    enableCryptodisk = true;
    device = "nodev";
    # Use to reduce boot size like described under https://serverfault.com/posts/997143/revisions
    configurationLimit = 10;
  };

  # luks
  boot.initrd.luks.devices = {
	crypted = {
		device = "/dev/disk/by-uuid/d129b2f1-7b7d-48b5-97a2-efcf3896f6c4";
		preLVM = true;
	};
  };

  boot.kernelParams = [ "processor.max_cstate=4" "amd_iomu=soft" "idle=nomwait" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  # boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only


  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  
  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  
  
  networking.extraHosts = ''
      192.168.5.100 core.local
      192.168.5.121 home.local
      192.168.5.126 anarchy.local
  '';

  networking = {
    hostName = "anarchy"; # Define your hostname.
    #nameservers = [ "127.0.0.1" "::1" ];
    #networkmanager.dns = "none";
 
    useDHCP = false;
    #interfaces.enp0s31f6.useDHCP = true;
    #interfaces.wlp4s0.useDHCP = true;
    #interfaces.wwp0s20f0u2c2.useDHCP = true;
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

  # Enable CUPS to print documents.
  # services.printing.enable = true;
  
  # System autoupgrade
  system.autoUpgrade.enable = true;
  #system.autoUpgrade.allowReboot = true;
 
  
  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "21.11"; # Did you read the comment?
}
