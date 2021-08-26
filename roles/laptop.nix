{ ... }:
{
    # collection of modules that are used on every laptop configuration
    imports = [
        ./default.nix
        ./personal.nix
        ../config/printer.nix
        ../config/sound.nix
        ../config/desktop.nix

        # Extended
        ../modules/syncthing.nix
    ];

    environment.systemPackages = with pkgs; [
   
    ];

}