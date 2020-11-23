{config, pkgs, lib, ...}:

with lib;

let
    commonUserAttrs = {
        isNormalUser = true;
        extraGroups = [ "wheel" "docker" "libvirtd" ];
    };
    cfg = config.default.users;

    users = {
        sebastian = {
            uid = 1000;
            description = "Sebastian Preisner";
            openssh.authorizedKeys.keys = [ 
                "" 
            ];
        } // commonUserAttrs;
    };

in {
    options.default.users = {
        enable = mkOption {
            default = true;
            type = types.bool;
            description = ''
                Add all known users to the machine and assign them sudo permissions.
            '';
        };
        all = mkOption {
            default = users;
            type = types.attrs;
            internal = true;
        };
    };
  config = mkIf cfg.enable {
    users.users = cfg.all;
  };
}