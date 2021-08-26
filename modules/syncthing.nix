{ pkgs, ... }:
let
	username = "sebastian";

in
{
  services.syncthing = {
	enable = true;
	user = username;
	systemService = true;
	dataDir = "/home/${username}";
	configDir = "/home/${username}/.config/syncthing";
	declarative.folders = {
		"/home/${username}/Sync" = {
				id = "default";
				label = "Default";
				enable = true;
				path = "/home/${username}/Sync";
				type = "sendreceive"; # one of "sendreceive", "sendonly", "receiveonly"
				watch = true;
				devices = [ "DataCore" ];
	   };
	   "/home/${username}/Dokumente" = {
				id = "Dokumente";
				label = "Dokumente ${username}";
				enable = true;
				path = "/home/${username}/Dokumente";
				type = "sendreceive"; # one of "sendreceive", "sendonly", "receiveonly"
				watch = true;
				devices = [ "DataCore" ];
	   }; 
	}; # declarative.folder
	declarative.devices = {
			"DataCore" = {
				name = "DataCore";
				id = "NE6FUNT-S24QVT4-4SNAYDM-SXMJIPM-M7IRLLC-6XNBT7S-VZMTLSN-SQETCQE";
				addresses = [];
				introducer = true;
			};
			#"AnarchyBig" = {
			#	name = "AnarchyBig";
			#	id = "XTTR4AX-XFVEO64-GCMHZSD-R7TSK7N-3I3ORXG-2ZX7CJP-35TLSH2-6G6GBA7";
			#	addresses = [];
			#};
	}; # declarative.devices
  };

  networking.firewall = {
    allowedTCPPorts = [ 
      22000 # Open for Syncthing share
      21027 # Open for Syncthing discovery
    ];
    # allowedUDPPorts = [ ]
};
}
