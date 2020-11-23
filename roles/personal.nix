{ ... }:

{
    # collection of modules that are used on every system configuration
    imports = [
        ./default.nix
        ../modules/printer.nix
        ../modules/sound.nix
    ];

    # Scanner settings
    hardware.sane.enable = true;
    
    environment.systemPackages = with pkgs; [
        # Console
        

        # Soicial
        discord
        telegram


        # Grafik
        krita
        gimp
        inkscape
        darktable

        # Entwicklung
        vscode
        openjdk
        go

        # Office
        portfolio
        libreoffice-fresh
        pandoc
        haskellPackages.pandoc-citeproc
        haskellPackages.pandoc-crossref
        texlive.combined.scheme-basic
        typora

        # Media
        vlc
        obs-studio
        audacity
    ];

}