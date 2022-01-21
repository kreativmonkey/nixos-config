{pkgs, ... }:
let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in
{
    # Scanner settings
    hardware.sane.enable = true;
    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
        # Console
	    guake        
	    mosh
        nerdfonts

        # Soicial
        discord
        tdesktop
        signal-desktop

        # Grafik
        krita
        gimp
        inkscape
        darktable
        flameshot

        # Entwicklung
        vscode
    	geany
        openjdk
        go
        filezilla
        jupyter

        # Office
        unstable.portfolio
        libreoffice-fresh
        pandoc
        # Broken packages
        #haskellPackages.pandoc-citeproc
        #haskellPackages.pandoc-crossref
        texlive.combined.scheme-full
        #typora # removed by 21.11
        firefox
        google-chrome
        kile
        masterpdfeditor
        zotero
        bitwarden	

        # Productivity
        barrier

        # Media
        vlc
        audacity
        ffmpeg
        unstable.obs-studio
        linuxPackages.v4l2loopback
      ];

}
