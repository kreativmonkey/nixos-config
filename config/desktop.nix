{ pkgs, ...}:

{

  # Configure keymap in X11
  services.xserver.layout = "de,de";
  services.xserver.xkbVariant = "neo,";
  services.xserver.xkbOptions = "eurosign:e,terminate:ctrl_alt_bksp,caps:ctrl_modifier,grp:shifts_toggle,grp:shifts_toggle";

  # Enable the GNOME 3 Desktop Environment.
  services.xserver = {
    enable = true;
    
    displayManager = {
      gdm.enable = true;
      gdm.wayland = true;
    };
    
    desktopManager = {
      gnome.enable = true;
    };
  }; # services.xserver
  
  
  # Settings
  security.pam.services.gdm.enableGnomeKeyring = true;
  
  # Gnome 3
  services.gnome = {
          gnome-user-share.enable= true;
          gnome-settings-daemon.enable=true;
          gnome-keyring.enable = true;
	  sushi.enable = true; # quick previewer for nautilus
	  games.enable = false;
	  chrome-gnome-shell.enable = true; # installing extensions from browser
	  gnome-online-accounts.enable = false; # TODO: check the sso service
  };
  
  environment.gnome.excludePackages = [ pkgs.gnome.geary pkgs.gnome.cheese ];

  environment.systemPackages = with pkgs; [
    gnome.gnome-tweaks
    gnome-network-displays
    gnomeExtensions.gsconnect
  ];
}
