{ pkgs, ... }:

{
    # collection of modules that are used on every system configuration
    imports = [
        ../default.nix # All System default
        
        # Default Modules
        #./modules/printer.nix
        ./modules/sound.nix
    ];

    # Scanner settings
    hardware.sane.enable = true;

    nixpkgs.config.allowUnfree = true;

    
    environment.systemPackages = with pkgs; [
        # Console
	guake        

        # Soicial
        discord
        tdesktop
        signal-desktop

        # Grafik
        krita
        gimp
        inkscape
        darktable

        # Entwicklung
        vscode
	geany
        openjdk
        go
	#gitahead
	filezilla

        # Office
        portfolio
        libreoffice-fresh
        pandoc
        haskellPackages.pandoc-citeproc
        haskellPackages.pandoc-crossref
        texlive.combined.scheme-basic
        typora
	firefox
        google-chrome
        kile

	syncthing-gtk
	bitwarden		

        # Media
        vlc
        obs-studio
        audacity
    ];

}
