{pkgs, ...}:
let
    networks = {
        wg0 = {
            IPv4 = "10.100.0.1/24";
            IPv6 = "fdc9:281f:04d7:9ee9::1/64";
            prefix = 24;
            port = 51280;
            privateKeyFile = "/etc/wireguard/private";
            peers = {
                sebastianOneplus = {
                    ip = "10.100.0.3";
                };
            };
        };
    };

    privatekey = networks.wg0.privateKeyFile;
    publickey = "${dirOf networks.wg0.privateKeyFile}/public";
in 
{
    networking.nat = {
        enable = true;
        externalInterface = "ens3";
        internalInterfaces = [ "wg0" ];
    };

    networking.firewall = {
        allowedUDPPorts = [ networks.wg0.port ];
    };

    networking.wireguard.interfaces.wg0 = {
        # Determines the IP address and subnet of the Server's end of the tunnel interface.
        ips = [ networks.wg0.IPv4 networks.wg0.IPv6 ];

        # The port that WireGuard listens to. Must be accessible by the client.
        listenPort = networks.wg0.port;

        # The private Key file for the Server.
        privateKeyFile = networks.wg0.privateKeyFile;

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


        # This allows the WireGuard server to route your traffic to the internet and hence be like a VPN
        # For this to work you have to set the dnsserver IP of your router in your clients
        postSetup = ''
            ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -j ACCEPT
            ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s ${networks.wg0.IPv4} -o eth0 -j MASQUERADE
            ${pkgs.iptables}/bin/ip6tables -A FORWARD -i wg0 -j ACCEPT
            ${pkgs.iptables}/bin/ip6tables -t nat -A POSTROUTING -s ${networks.wg0.IPv6} -o eth0 -j MASQUERADE
        '';

        # This undoes the above command
        postShutdown = ''
            ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -j ACCEPT
            ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s ${networks.wg0.IPv4} -o eth0 -j MASQUERADE
            ${pkgs.iptables}/bin/ip6tables -D FORWARD -i wg0 -j ACCEPT
            ${pkgs.iptables}/bin/ip6tables -t nat -D POSTROUTING -s ${networks.wg0.IPv6} -o eth0 -j MASQUERADE
        '';

    };

    # Generating public and private key if the key is not present
    systemd.services.wireguard-wg0-key = {
        enable = true;
        wantedBy = [ "wireguard-wg0.service" ];
        path = with pkgs; [ wireguard ];
        serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
        };

        script = ''
        mkdir --mode 0644 -p "${dirOf privatekey}"
        if [ ! -f "${privatekey}" ]; then
            touch "${privatekey}"
            chmod 0600 "${privatekey}"
            wg genkey > "${privatekey}"
            chmod 0400 "${privatekey}"

            touch "${publickey}"
            chmod 0600 "${publickey}"
            wg pubkey < "${privatekey}" > "${publickey}"
            chmod 0444 "${publickey}"
        fi
        '';
    };

    # Starting wireguard only if the privatekey exists!
    systemd.paths."wireguard-wg0" = {
        pathConfig = {
        PathExists = privatekey;
        };
    };
}