{pkgs, config, ...}:

{
  services.nginx.virtualHosts."login.oc4.de" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      extraConfig = ''
        proxy_pass https://localhost:9443;        
        proxy_http_version 1.1;       
        proxy_set_header X-Forwarded-Proto https;        
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;        
        # This needs to be set inside the location block, very important.        
        proxy_set_header Host $host;       
        proxy_set_header Upgrade $http_upgrade;        
        proxy_set_header Connection $connection_upgrade;
        '';
    };
  };
}
