{pkgs, ...}:
let
	SERVER_IP = "0.0.0.0";
	LYCHEE_MYSQL_PASSWORD = "xdlrendxlgen";
	LYCHEE_ROOT = "/var/lib/lychee";
in
{
	virtualisation.docker = {
		enable = true;
	};
	
	enviroment.systempackages = with pkgs; [
		docker-compose
	];
	
	virtualisation.oci-containers = {
		containers = {
			lychee = {
				image = "lycheeorg/lychee:latest";
				volumes = [
					"/etc/localtime:/etc/localtime:ro"
					"${LYCHEE_ROOT}/conf:/conf"
					"${LYCHEE_ROOT}/uploads:/uploads"
					"${LYCHEE_ROOT}/sym:/sym"
				];
				environment = {
					PUID=1000;
					PIGD=1000;
					PHP_TZ="Europe/Berlin";
					DB_CONNECTION="mysql";
					DB_HOST="mariadb";
					DB_PORT=3306;
					DB_DATABASE="lychee";
					DB_USERNAME="lychee";
					DB_PASSWORD="${LYCHEE_MYSQL_PASSWORD}";
				};
				dependsOn = [
					"mariadb"
				];
				ports = [ "8240:80" ];
			};
			
			mariadb = {
				image = "mariadb/server:10.3";
				enviroment = {
					MYSQL_ROOT_PASSWORD = "${MYSQL_ROOT_PASSWORD}";
					MYSQL_DATABASE = "lychee";
					MYSQL_USER = "lychee";
					MYSQL_PASSWORD = "${LYCHEE_MYSQL_PASSWORD}";
				};
				ports = [ "3306:3306" ];
				volumes = [
					"/etc/localtime:/etc/localtime:ro"
					"${LYCHEE_ROOT}/mysql:/var/lib/mysql"
				];
			};
		};
	};

}
