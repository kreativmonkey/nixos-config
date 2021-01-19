{config, pkgs, ...}:

{
    
networking.firewall = {
    allowedTCPPorts = [ 
		22000 # Open for Syncthing share
		21027 # Open for Syncthing discovery
    ];
    # allowedUDPPorts = [ ]
};

}
