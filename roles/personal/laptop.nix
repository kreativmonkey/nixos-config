{ pkgs, ... }:
{
    # collection of modules that are used on every laptop configuration
    imports = [
        ./default.nix
        ./modules/desktop.nix
        ./modules/firewall.nix
        
        # Extended
        ../../modules/syncthing.nix
    ];

    environment.systemPackages = with pkgs; [
   
    ];

}
