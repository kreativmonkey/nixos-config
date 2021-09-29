{config, pkgs, ...}:

{
  services.netdata = {
    enable = true;
    config = {
      global = {
        "debug log" = "syslog";
        "access log" = "syslog";
        "error log" = "syslog";
      };
    };
  };

  services.nginx.virtualHosts."netdata.oc4.de" = {
    forceSSL = true;
    enableACME = true;
    extraConfig = ''
      proxy_buffers 8 16k;    
      proxy_buffer_size 32k;    
      fastcgi_buffers 16 16k;    
      fastcgi_buffer_size 32k;
      '';
    locations = {
      "/" = {
        extraConfig = ''
          proxy_pass          http://localhost:19999;

          # authentik-specific config        
          auth_request        /akprox/auth;        
          error_page          401 = @akprox_signin;        
          # For domain level, use the below error_page to redirect to your Authentik server with the full redirect path        
          # error_page          401 =302 https://authentik.company/akprox/start?rd=$scheme://$http_host$request_uri;
        
          # translate headers from the outposts back to the actual upstream        
          auth_request_set    $username    $upstream_http_x_auth_username;        
          auth_request_set    $email       $upstream_http_X_Forwarded_Email;        
          proxy_set_header    X-Auth-Username   $username;        
          proxy_set_header    X-Forwarded-Email $email;
        '';
      };
      "/akprox" = {
        extraConfig = ''
          proxy_pass        http://localhost:9009/akprox;
          proxy_set_header  Host $host;
          add_header        Set-Cookie $auth_cookie;
          auth_request_set  $auth_cookie $upstream_http_set_cookie;
          '';
        };
      "@akprox_signin" = {
        extraConfig = ''
          internal;
          add_header Set-Cookie $auth_cookie;
          return 302 /akprox/start?rd=$request_uri;
          '';
        };
    };
  };
}
