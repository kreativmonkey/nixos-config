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
	folders = {
		"/home/${username}/Sync" = {
				id = "default";
				label = "Default";
				enable = true;
				path = "/home/${username}/Sync";
				type = "sendreceive"; # one of "sendreceive", "sendonly", "receiveonly"
				watch = true;
				devices = [ "DataCore" "AnarchyBig"];
	   };
	   "/home/${username}/Dokumente" = {
				id = "Dokumente";
				label = "Dokumente ${username}";
				enable = true;
				path = "/home/${username}/Dokumente";
				type = "sendreceive"; # one of "sendreceive", "sendonly", "receiveonly"
				watch = true;
				devices = [ "DataCore" "AnarchyBig" ];
	   }; 
	}; # declarative.folder
	devices = {
			"DataCore" = {
				name = "DataCore";
				id = "Q67GOCQ-Z5FXLOR-CZQKFTW-SAQMJ3G-4OUFV3B-4KYX3HU-GJGEEQE-5ZAHJQU";
				addresses = [];
				introducer = true;
			};
			"AnarchyBig" = {
				name = "AnarchyBig";
				id = "XTTR4AX-XFVEO64-GCMHZSD-R7TSK7N-3I3ORXG-2ZX7CJP-35TLSH2-6G6GBA7";
				addresses = [];
			};
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
