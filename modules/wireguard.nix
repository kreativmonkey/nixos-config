{ pkgs, config, ... }:

with lib;

{
  networking = let
    ipv4 = "10.100.0.1/24";
    ipv6 = "fdc9:281f:04d7:9ee9::1/64";
    privatekey = "/etc/wireguard/private";
    publickey = "${dirOf networks.wg0.privateKeyFile}/public";
  in {
    nat = {
      enable = true;
      externalInterface = "ens3";
      internalInterfaces = [ "wg0" ];
    };

    firewall = {
      allowedUDPPorts = [ 51820 ];
    };

    wireguard.interfaces.wg0 = {
      # Determines the IP address and subnet of the Server's end of the tunnel interface.
      ips = [ ipv4 ipv6 ];

      # The port that WireGuard listens to. Must be accessible by the client.
      listenPort = 51820;

      # The private Key file for the Server.
      privateKeyFile = privatekey;

      # This allows the WireGuard server to route your traffic to the internet and hence be like a VPN
      # For this to work you have to set the dnsserver IP of your router in your clients
      postSetup = ''
        ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -j ACCEPT
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s ${ipv4} -o eth0 -j MASQUERADE
        ${pkgs.iptables}/bin/ip6tables -A FORWARD -i wg0 -j ACCEPT
        ${pkgs.iptables}/bin/ip6tables -t nat -A POSTROUTING -s ${ipv6} -o eth0 -j MASQUERADE
      '';

      # This undoes the above command
      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -j ACCEPT
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s ${ipv4} -o eth0 -j MASQUERADE
        ${pkgs.iptables}/bin/ip6tables -D FORWARD -i wg0 -j ACCEPT
        ${pkgs.iptables}/bin/ip6tables -t nat -D POSTROUTING -s ${ipv6} -o eth0 -j MASQUERADE
      '';
    };    
  };

  # Generating public and private key if the key is not present
  systemd = let
        privatekey = networks.wg0.privateKeyFile;
    in {
      services.wireguard-wg0-key = {
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
    paths."wireguard-wg0" = {
      pathConfig = {
        PathExists = privatekey;
      };
    };
  };

}