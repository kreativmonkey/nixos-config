{pkgs, ...}:

{

     imports = [
        # the "default" emile user
        ../../users/sebastian.nix

        # import the collection of modules suited for servers
        ../../roles/default.nix
        ../../config/location.nix

        # machine specific modules
        ../../modules/ssh.nix
        ../../modules/wireguard.nix
    ];

    # Changing SSH Port
    services.openssh = {
        ports = [ 2258 ];
    };

    networking.wireguard.interfaces.wg0.peers = [
        # List of allowed peers.
        # Feel free to give a meaning full name
        # Public key of the peer (not a file path).
        # publicKey = "";
        # allowedIPs = [ "10.100.0.2/32" "fdc9:281f:04d7:9ee9::2/128" ];
        {   # OnePlus 7T Sebastian
            publicKey = "GbwR+pmZHsYVC/XSqomLrGlfeLpGv3uytZu9kEfwikI=";
            allowedIPs = [ "10.100.0.3/32" "fdc9:281f:04d7:9ee9::3/128" ];
        }
        {   # Julia
            publicKey = "z3JkgIFaT9sBWZMzCEH9+CLc/Z7aauDN1JX6ZpKzKxY=";
            allowedIPs = [ "10.100.0.4/32" "fdc9:281f:04d7:9ee9::4/128" ];
        }
        {   # Homecentral
            publicKey = "EvpQbaR17Pal1AIo7pIZe1mVPMZqYohNdJVq9O2WJwg=";
            allowedIPs = [ "10.100.0.100/32" "fdc9:281f:04d7:9ee9::100/128" ];
        }
        #{   # Anarchy
        #    publicKey = "";
        #    allowedIPs = [ "10.100.0.5/32" "fdc9:281f:04d7:9ee9::5/128"];
        #}
        #{   # Server
        #    publicKey = "";
        #    allowedIPs = [ "10.100.0.10/32" "fdc9:281f:04d7:9ee9::10/128"];
        #}
      ];
}