{...}:
{
    # collection of modules that are used on every laptop configuration
    imports = [
        ./personal.nix
        ./default.nix
        ../config/printer.nix
        ../config/sound.nix
        ../config/desktop.nix

        # Extended
        ../modules/syncthing.nix
    ];

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