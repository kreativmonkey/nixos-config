{pkgs, config, ...}:
{
  services.bookstack = {
    enable = true;
    user = "bookstack";
    group = "bookstack";
    appURL = "https://wiki.oc4.de";
    appKeyFile = /var/src/secrets/bookstack_appkey;
    extraConfig = ''
      AUTH_METHOD=saml2
      SAML2_NAME=SSO
      SAML2_EMAIL_ATTRIBUTE=email
      SAML2_EXTERNAL_ID_ATTRIBUTE=uid
      SAML2_DISPLAY_NAME_ATTRIBUTES=Name
      SAML2_IDP_ENTITYID=https://login.oc4.de/api/v3/providers/saml/8/metadata/?download
      SAML2_AUTOLOAD_METADATA=true
      SAML2_USER_TO_GROUPS=true
      SAML2_GROUP_ATTRIBUTE=groups
      SAML2_REMOVE_FROM_GROUPS=true
    '';

    nginx = {
      serverName = "wiki.oc4.de";
      forceSSL = true;
      enableACME = true;
    };

    database = {
      user = config.services.bookstack.user;
      name = "bookstack";
      host = "localhost";
      #passwordFile = /var/src/secrets/bookstack_db_pass;
      createLocally = true;
    };
  };
}
