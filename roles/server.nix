    { ... }:
    {
        # collection of modules that are used in every laptop configuration
        imports = [
            ../modules/docker.nix
            ../modules/u2f.nix
            ../modules/pulseaudio.nix
            ../modules/bluetooth.nix
            ../modules/opengl.nix
            ../modules/trackpoint.nix
            ../modules/sound.nix
            ../modules/virtualbox.nix
        ];
    }