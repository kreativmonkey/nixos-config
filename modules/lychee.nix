{pkgs, ...}:
let
	cfg = config.webservices.lychee;

	phpPackage = pkgs.php.buildEnv {
		extensions = { enabled, all }:
		(with all;
			enabled
			++ BCMath
			++ ctype
			++ fileinfo
			++ exif
			++ mbstring
			++ gd
			++ json
			++ openssl
			++ pdo
			++ tokenizer
			++ xml
			++ zip
			++ optional cfg.enableImagemagick imagick
			++ optional cfg.enableFFmpeg ffmpeg
		)
		++ cfg.phpExtraExtensions all; # Enabled by user
		extraConfig = toKeyValue phpOptions;
	};

	phpOptions = {
		max_execution_time = "200";
		upload_max_size = cfg.maxUploadSize;
		upload_max_filesize = cfg.maxUploadFileSize;
		post_max_size = cfg.maxUploadSize;
		memory_limit = cfg.maxUploadSize;
	} // cfg.phpOptions
		// optionalAttrs cfg.caching.apcu {
		"apc.enable_cli" = "1";
    };

	pkg = hostName: cfg: pkgs.stdenv.mkDerivation rec {
    	pname = "lychee-${hostName}";
		version = src.version;
		src = fetchurl {
			url = "https://github.com/LycheeOrg/Lychee/releases/download/v${version}/Lychee.zip";
			sha256 = "sha256-6f51e8239bc38cba0ae8f0759b7eb4c87a09009cab07b3694f4666f7411b0f8d";
		};

		installPhase = ''
			mkdir -p $out
			cp -r * $out/

			# symlink the lychee storage
			ln -s ${cfg.uploads} $out/share/lychee/public/uploads
			'';
	};
in
{
	options.webservices.lychee = {
		enable = mkEnableOption "lychee";
		hostName = mkOption {
			type = types.str;
			description = "FQDN for the lychee instance.";
		};
		home = mkOption {
			type = type.str;
			default = "/var/lib/lychee";
			description = "Storage path of lychee";
		};
		https = mkOption {
			type = type.bool;
			default = false;
			description = "Force https connection";
		};

		maxUploadSize = mkOption {
			default = "512M";
			type = types.str;
			description = ''
				Defines the upload limit for files. This changes the relevant options
				in php.ini and nginx if enabled.
			'';
		};
		maxUploadFileSize = mkOption {
			default = "20M";
			type = type.str;
			description = ''
				Defines the upload file size limit. This changes the relevant options
				in php.ini and nginx if enabled.
			'';
		};

		enableImagemagick = mkEnableOption ''
			Whether to load the ImageMagick module into PHP.
			To generate better thumbnails.
			'' // {
			default = true;
		};
		enableFFmpeg = mkEnableOption ''
			Whether to load the FFMpeg module into PHP.
			To generate video thumbnails.
			'' // {
			default = false;
		};


		config = {
			dbtype = mkOption {
				type = types.enum [ "sqlite" "pgsql" "mysql" ];
				default = "sqlite";
				description = "Database type.";
			};
			dbname = mkOption {
				type = types.nullOr types.str;
				default = "lychee";
				description = "Database name.";
			};
			dbuser = mkOption {
				type = types.nullOr types.str;
				default = "lychee";
				description = "Database user.";
			};
			dbpass = mkOption {
				type = types.nullOr types.str;
				default = null;
				description = ''
				Database password.  Use <literal>dbpassFile</literal> to avoid this
				being world-readable in the <literal>/nix/store</literal>.
				'';
			};
			dbpassFile = mkOption {
				type = types.nullOr types.str;
				default = null;
				description = ''
				The full path to a file that contains the database password.
				'';
			};
			dbhost = mkOption {
				type = types.nullOr types.str;
				default = "localhost";
				description = ''
				Database host.
				Note: for using Unix authentication with PostgreSQL, this should be
				set to <literal>/run/postgresql</literal>.
				'';
			};
			dbport = mkOption {
				type = with types; nullOr (either int str);
				default = null;
				description = "Database port.";
			};
			dbtableprefix = mkOption {
				type = types.nullOr types.str;
				default = null;
				description = "Table prefix in Nextcloud database.";
			};
		};
		phpExtraExtensions = mkOption {
			type = with types; functionTo (listOf package);
			default = all: [];
			defaultText = "all: []";
			description = ''
				Additional PHP extensions to use for nextcloud.
				By default, only extensions necessary for a vanilla nextcloud installation are enabled,
				but you may choose from the list of available extensions and add further ones.
				This is sometimes necessary to be able to install a certain nextcloud app that has additional requirements.
			'';
			example = literalExample ''
				all: [ all.pdlib all.bz2 ]
			'';
		};
		phpOptions = mkOption {
			type = types.attrsOf types.str;
			default = {
				short_open_tag = "Off";
				expose_php = "Off";
				error_reporting = "E_ALL & ~E_DEPRECATED & ~E_STRICT";
				display_errors = "stderr";
				"openssl.cafile" = "/etc/ssl/certs/ca-certificates.crt";
			};
			description = ''
				Options for PHP's php.ini file for nextcloud.
			'';
		};
	};

	config = mkIf cfg.enable {	
		services.phpfpm = {
			pools.lychee = {
				user = "lychee";
				group = "lychee";
				phpPackage = phpPackage;
				phpEnv = {
					LYCHEE_CONFIG_DIR = "${cfg.home}/config";
					PATH = "/run/wrappers/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:/usr/bin:/bin";
				};
				settings = mapAttrs (name: mkDefault) {
					"listen.owner" = config.services.nginx.user;
					"listen.group" = config.services.nginx.group;
				};
			};
		};


		users.users.lychee = {
			home = "${cfg.home}";
			group = "lychee";
			createHome = true;
			isSystemUser = true;
		};
		users.groups.lychee.members = [ "lychee" config.services.nginx.user ];

		services.nginx.enable = mkDefault true;

		services.nginx.virtualHosts.${cfg.hostName} = {
			root = cfg.package;
			locations = {
				"= /index.php" = {
					extraConfig = ''
						# Mitigate https://httpoxy.org/ vulnerabilities
						fastcgi_param HTTP_PROXY "";

						include ${config.services.nginx.package}/conf/fastcgi.conf;
						fastcgi_split_path_info ^(.+?\.php)(/.*)$;
						fastcgi_index index.php;
						fastcgi_pass unix:${fpm.socket};
						fastcgi_param PHP_VALUE "post_max_size=${cfg.maxUploadSize}
							max_execution_time=200
							upload_max_filesize=${cfg.maxUploadFileSize}
							memory_limit=${cfg.maxUploadSize}";
						fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
						fastcgi_param HTTPS ${if cfg.https then "on" else "off"};
						fastcgi_param PATH /usr/local/bin:/usr/bin:/bin;
					'';
				};
				"~ [^/]\.php(/|$)" = {
					extraConfig = ''
						return 403;
					'';
				};
			};
			extraConfig = ''
				if (!-e $request_filename) {
					rewrite ^/(.*)$ /index.php?/$1 last;
					break;
				}
				# [Optional] Lychee-specific logs
				error_log  /var/log/nginx/lychee.error.log;
				access_log /var/log/nginx/lychee.access.log;

				# [Optional] Remove trailing slashes from requests (prevents SEO duplicate content issues)
				rewrite ^/(.+)/$ /$1 permanent;

				index index.php index.html /index.php$request_uri;

				add_header X-Content-Type-Options nosniff;
				add_header X-XSS-Protection "1; mode=block";
				add_header X-Robots-Tag none;
				add_header X-Download-Options noopen;
				add_header X-Permitted-Cross-Domain-Policies none;
				add_header X-Frame-Options sameorigin;
				add_header Referrer-Policy no-referrer;
				add_header Strict-Transport-Security "max-age=15552000; includeSubDomains" always;
			
				client_max_body_size ${cfg.maxUploadSize};
				fastcgi_buffers 64 4K;
				fastcgi_hide_header X-Powered-By;
				gzip on;
				gzip_vary on;
				gzip_comp_level 4;
				gzip_min_length 256;
				gzip_proxied expired no-cache no-store private no_last_modified no_etag auth;
				gzip_types application/atom+xml application/javascript application/json application/ld+json application/manifest+json application/rss+xml application/vnd.geo+json application/vnd.ms-fontobject application/x-font-ttf application/x-web-app-manifest+json application/xhtml+xml application/xml font/opentype image/bmp image/svg+xml image/x-icon text/cache-manifest text/css text/plain text/vcard text/vnd.rim.location.xloc text/vtt text/x-component text/x-cross-domain-policy;
			'';
		};	
	};
}