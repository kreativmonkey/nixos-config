{ ... }:
{
    # collection of modules that are used on every system configuration
    imports = [

    ];

    # Installing Fish Shell - Smart and user-friendly command line shell
    programs.fish.enable = true;

    # Secure SSH Settings
    services.openssh = {
        enable = true;

        permitRootLogin = "no";
        passwordAuthentication = false;
    };

    environment.systemPackages = with pkgs; [
        nmap
        tcpdump
        smartmontools
        tree
        htop
        wget
        git
        gnupg
        curl
        tmux
        unzip
        python3

    ] ++ basePackages;

}