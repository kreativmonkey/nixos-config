{...}:

{
    # Installing mosh
    programs.mosh.enable = true;
    networking.firewall.allowedTCPPorts = [ 6001 ];
}