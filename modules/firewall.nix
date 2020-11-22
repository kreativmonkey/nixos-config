{config, pkgs, ...}:

{
    
networking.firewall = {
    allowedTCPPorts = [ 80 443 22 222];
    # allowedUDPPorts = [ ]
};

}