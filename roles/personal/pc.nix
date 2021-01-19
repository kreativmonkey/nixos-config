{...}:
{
    # collection of modules that are used on every laptop configuration
    imports = [
        ./default.nix # Personal default
        ../modules/desktop.nix
    ];

    service.paperless= {
        enable = true;
        ocrLanguages = [ "eng" "deu" ];
    };

    environment.systemPackages = with pkgs; [
        # Console
        unpaper
        tesseract4
        imagemagick
        parallel

        # Soicial

        # Grafik
        digikam

        # Entwicklung
    
        # Office
        
        # Media
        
        # Games
        steam
    ];

}
