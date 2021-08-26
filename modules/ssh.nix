{...}:

{
    # Enable the OpenSSH daemon.
    services.openssh = {
        enable = true;
        permitRootLogin = "no";
        passwordAuthentication = false;
    };

    # Installing mosh
    programs.mosh.enable = true;

    # Setup firewall ports
    networking.firewall.allowedTCPPorts = [ 22 6001 ];
}