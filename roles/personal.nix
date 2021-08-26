{pkgs, ... }:
let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in
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
        # Broken packages
        #haskellPackages.pandoc-citeproc
        #haskellPackages.pandoc-crossref
        texlive.combined.scheme-full
        typora
	    firefox
        google-chrome
        kile
        masterpdfeditor
        zotero
        bitwarden	

        # Media
        vlc
        audacity
        ffmpeg
        unstable.obs-studio
        linuxPackages.v4l2loopback
        obs-v4l2sink
        
    ];

}