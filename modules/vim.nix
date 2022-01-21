{config, pkgs, ...}:

{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    defaultEditor = true;
    configure = {
      customRC = ''
        set nocompatible
        set path+=**
        set wildmenu
        set ignorecase
        set mouse=a
        set nowrap
        set scrolloff=5
        set encoding=utf-8
        set complete+=kspell
        set completeopt=menuone,longest
        set showcmd
        set showmode
        set smartcase
        set tabstop=4
        set softtabstop=4
        set expandtab
        set autoindent
        set number
        set relativenumber
        set hlsearch
        syntax on
        filetype plugin indent on
        filetype plugin on
        set cursorline
        "set backupdir=~/.cache/vim
        colorscheme dracula
      '';
      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [
          # Languages
          vim-nix

          # LSB
          nvim-lspconfig
          nvim-compe

          # eyecandy
          bufferline-nvim
          feline-nvim

          # Themes
          dracula-vim
        ];
      };
    };
  };
}
