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
		gnome3.enable = true;
	};
  }; # services.xserver
  
  
  # Settings
  security.pam.services.gdm.enableGnomeKeyring = true;
  
  # Gnome 3
  services.gnome3 = {
	gnome-keyring.enable = true;
	sushi.enable = true; # quick previewer for nautilus
	games.enable = false;
	chrome-gnome-shell.enable = true; # installing extensions from browser
	gnome-online-accounts.enable = false; # TODO: check the sso service
  };
  
  environment.gnome3.excludePackages = [ pkgs.gnome3.geary pkgs.gnome3.cheese ];

}
