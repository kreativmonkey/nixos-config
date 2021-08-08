{...}:
let
    networks = {
        wg0 = {
            prefix = 24;
            privateKeyFile = "/root/wgprivate";
            peers = {
                sebastianOneplus = {
                    ip = "10.100.0.3";
                };
            };
        };
    };

    privatekey = config.networking.wireguard.interfaces.wg0.privateKeyFile;
    publickey = "${dirOf privatekey}/public";
in 
{
    networking.nat = {
        enable = true;
        externalInterface = "ens3";
        internalInterfaces = [ "wg0" ];
    };

    networking.firewall = {
        allowedUDPPorts = [51280];
    };

    networking.wireguard.interfaces = {
        wg0 = {
            # Determines the IP address and subnet of the Server's end of the tunnel interface.
            #ips = [ "10.100.0.1/24" ];
            ips = [ "10.100.0.1/24" "fdc9:281f:04d7:9ee9::1/64" ];

            # The port that WireGuard listens to. Must be accessible by the client.
            listenPort = 51820;

            # This allows the WireGuard server to route your traffic to the internet and hence be like a VPN
            # For this to work you have to set the dnsserver IP of your router in your clients
            postSetup = ''
                ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -j ACCEPT
                ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.0.0.1/24 -o eth0 -j MASQUERADE
                ${pkgs.iptables}/bin/ip6tables -A FORWARD -i wg0 -j ACCEPT
                ${pkgs.iptables}/bin/ip6tables -t nat -A POSTROUTING -s fdc9:281f:04d7:9ee9::1/64 -o eth0 -j MASQUERADE
            '';

            # This undoes the above command
            postShutdown = ''
                ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -j ACCEPT
                ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.0.0.1/24 -o eth0 -j MASQUERADE
                ${pkgs.iptables}/bin/ip6tables -D FORWARD -i wg0 -j ACCEPT
                ${pkgs.iptables}/bin/ip6tables -t nat -D POSTROUTING -s fdc9:281f:04d7:9ee9::1/64 -o eth0 -j MASQUERADE
            '';

            privateKeyFile = "/root/wgprivate";

            peers = [
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
                {   # Anarchy
                    publicKey = "";
                    allowedIPs = [ "10.100.0.5/32" "fdc9:281f:04d7:9ee9::5/128"];
                }
                {   # Server
                    publicKey = "";
                    allowedIPs = [ "10.100.0.10/32" "fdc9:281f:04d7:9ee9::10/128"];
                }
            ];
        };
    };
}