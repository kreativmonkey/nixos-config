{...}:

# mostly taken from https://github.com/davidak/nixos-config/blob/master/services/fail2ban.nix 
{
	services.fail2ban = {
		enable = true;
		jails = { 
      			DEFAULT = ''
        			bantime  = 3600
        			#ignoreip = 127.0.0.1
        			logpath  = /var/log/auth.log
      			'';

      			sshd = ''
        			enabled = true
        			filter = sshd
				findtime = 1d
				bandtime = 2w
				backend = systemd
        			maxretry = 4
        			action = iptables[name=SSH, port=ssh, protocol=tcp]
      			'';

      			sshd-ddos = ''
        			enabled  = true
        			filter = sshd-ddos
        			maxretry = 2
        			action   = iptables[name=ssh, port=ssh, protocol=tcp]
      			'';

			      nginx-req-limit = ''
        enabled = true
        filter = nginx-req-limit
        maxretry = 10
        action = iptables-multiport[name=ReqLimit, port="http,https", protocol=tcp]
        findtime = 600
        bantime = 7200
      '';			
		};
	};

  environment.etc."fail2ban/filter.d/nginx-req-limit.conf".text = ''
    [Definition]
    failregex = limiting requests, excess:.* by zone.*client: <HOST>
  '';

  # Limit stack size to reduce memory usage
  systemd.services.fail2ban.serviceConfig.LimitSTACK = 256 * 1024;	
}
