{ pkgs, ... }:

let
  # Import the Neovim plugins
  neovimPlugins = pkgs.neovimPlugins;
in

{
  programs.neovim = {
    enable = true; # Enable Neovim
    package = pkgs.neovim; # Use the Neovim package from nixpkgs

    # Neovim extra configuration (this will be placed in init.vim)
    extraConfig = ''
      " Basic settings
      set number
      set relativenumber
      syntax enable
      set background=dark
      set autoindent
      set expandtab
      set tabstop=4
      set shiftwidth=4
      set smartindent
      set wildmenu
      set lazyredraw
      set showmatch
      set incsearch
      set hlsearch
      set clipboard=unnamedplus

      " Enable line wrapping
      set wrap

      " Plugin settings and other configurations can go here
    '';

    # List of Neovim plugins to install using Nixpkgs
    plugins = with neovimPlugins; [
      fzf # Fuzzy file search
      nvim-treesitter # Syntax highlighting with treesitter
      vim-airline # Status line plugin
      nvim-lspconfig # Language server protocol support
      gitsigns.nvim # Git integration
      nvim-compe # Auto-completion
      telescope.nvim # Fuzzy finder
      nvim-cmp # Autocompletion plugin
    ];

    # Optional: If you want to create your own init.vim or add custom settings
    vimrc = ''
      " Example Neovim Configuration
      set number
      set relativenumber
      set background=dark
      syntax enable
      filetype plugin indent on
    '';
  };
}
