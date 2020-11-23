{ pkgs, ... }:
{

    users.users.sebastian = {
        description = "Main user of the unit";
        isNormalUser = true;
        hashedPassword = "$1$QIShHDeF$X3o243FuBNYyEgUha9Ois.";
        shell = pkgs.fish;
        home = "/home/sebastian";
        # packages = [ ];
        extraGroups = [ 
            "wheel" 
            "docker"
            "scanner"
            "lp"
        ]; 
        openssh.authorizedKeys.keys = [
                "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDC63/pQy57BmpA3OQ+hROeavYm7Wok+7aCebUNcJo07WTg/XN0QG4vY7Z4BctYagR2xNl3U4GwoLTil2azWwvBT7dPqlnEkCNLLhXiyce6R9PbQx1ODHHsUlBkDZ0VojrhHJQIppQ5Yy1k9DU/dqx1Gu0qavbZ/snaJUwZxUSQN3hbl6iegxIxWgoXVWwQ9Cvql6cUCGTTKhs6bYrsoxkKHyk8bjY82vYsfKsK5hrWSwZg8uL30nOXRxkkEoHxxiMTHSMxorRPc170t97hVIUa9pnBs2CNuWp4n21cspgFSEauJzX9ynIokW5coBw2kktHRMmRLvExVDd2vXhSeFJ4eB0fYLU7fEy2OYN53eO8PcDdLH/xHftZ45j8OaJrUWGsvGIiH4fhQPIHrJsNb2I6GXGP+A8TxkYJbgUry9jPEmVYfy/asfZ5l9QiHf5Sen5nISZAWeB8b7WldkK3WtIMANFPzmb6nF5vcd5nhvGsLvImydKvzNgik3NEj+aMd0//miRhIJJkW6J8E0Q+UVn6n+k8XOc0l9lSLxPNb2RkQQ8UtvjNkkeaS/ztfHi8JugvdOdJy40ILewBfA094rRAP3YBnXYYUzKqv4nPLd0Qmc9BDhJJmpjYpiisFgovfOMLEkqt3crmG0/Rnmr+2arS0/1jAuk+wDPP+ws71J40FQ== sebastian@anarchy"
                "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC2bbsrZLJ2271iSb04qpoUDlbrH19aTXUlzFaQSp1KO0BjCxdNvY1x6ZjkIPUC0YeaVGePu0cBJFWYZKpPRiz5hbWeFgaVvhbAlhxAMSlgdjLiN2alc92mBX40NhrpgSV/hGB5KAqqBQr9y01g9I5GRl9jdXgzUA9hhbqxls6tvXxGN2SJC3TFbUj+2PPpn8Cw2ZJiKsKZIoQfs9ZQuv2xDi7E6voqBALlYWd217ZgBezklrpm48dDisGI/WdZyllgk0XyxXwRSSD8QINTPjWmKXk5ZNH65J0KyDlnrZsgQuQbsN3jGgJsPfR6tydVITd1IXtSwawUYZ+JU8wwp6CR sebastian@gartenzerg"
        ];
    }; # Users.users

}