{ ... }:

{
    # Scanner settings
    hardware.sane.enable = true;
    
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