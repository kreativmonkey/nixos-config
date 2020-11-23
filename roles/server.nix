{ ... }:
{
    # collection of modules that are used on every Server configuration
    imports = [
        ./default.nix
        ../modules/podman.nix
        ../modules/firewall.nix
    ];

    environment.systemPackages = with pkgs; [
        # Console
        

    ];
}