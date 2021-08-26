{ pkgs, ... }:
{
    # collection of modules that are used on every system configuration
    imports = [

    ];

    # Installing Fish Shell - Smart and user-friendly command line shell
    programs.fish.enable = true;

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
	    vim
        hunspell
        hunspellDicts.de_DE
        hunspellDicts.en_US
    ];

}
