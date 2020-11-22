{config, pkgs, ...}:

{

services.openssh = {
    enable = true;

    permitRootLogin = "prohibit-password";
    passwordAuthentication = false;
};

}