{ pkgs, ... }:
{
    # collection of modules that are used on every system configuration
    imports = [
      ../modules/vim.nix
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
        hunspell
        hunspellDicts.de_DE
        hunspellDicts.en_US
        mosh
        chezmoi # dotfilemanager

        # Konsole
        lsd
        fzf
        bat
        dust
        duf
        fd
        mcfly
        cheat
        bottom
        zoxide
        fishPlugins.fzf-fish
        exa
      ];

    programs.neovim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
        configure = {
            packages.myPlugins = with pkgs.vimPlugins; {
            start = [
            vim-surround # Shortcuts for setting () {} etc.
            coc-git coc-highlight coc-python coc-rls coc-vetur coc-vimtex coc-yaml coc-html coc-json # auto completion
            vim-nix # nix highlight
            vimtex # latex stuff
            fzf-vim # fuzzy finder through vim
            nerdtree # file structure inside nvim
            rainbow # Color parenthesis
            ];
            opt = [];
            };	
        };
    };

}
