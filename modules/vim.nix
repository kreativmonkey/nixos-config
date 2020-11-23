{config, pkgs, ...}:

{
    packageOverrides = pkgs: with pkgs; {
        myVim = name = "vim-with-plugins";
        # add custom .vimrc lines like this:
        vimrcConfig.customRC = ''
            set hidden
            set colorcolumn=80 
            set mouse=
        '';
    };
}
