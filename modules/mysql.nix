{config, pkgs, ...}:

{
    services.mysql = {
	enable = true;
	package = pkgs.mariadb;
    };

    services.mysqlBackup = {
        enable = true;
    };
}
