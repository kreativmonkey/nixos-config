{...}:

{
  
    # Enable automatic discovery of the printer from other Linux systems with avahi running.
    services.avahi = {
        enable = true;
        publish.enable = true;
        publish.userServices = true;
    };


    services.printing = {
        enable = true;
        #drivers = [ YOUR_DRIVER ];
        browsing = true;
        listenAddresses = [ "*:631" ]; # Not 100% sure this is needed and you might want to restrict to the local network
        defaultShared = true; # If you want
    };

    networking.firewall = {
        allowedUDPPorts = [ 631 ];
        allowedTCPPorts = [ 631 ];
    };

}