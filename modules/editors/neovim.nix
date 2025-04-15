{ pkgs, config, ... }:
let
  plugins = {
    neo-tree = import ./nvim-plugins/neo-tree.nix { inherit pkgs; };
    alpha-nvim = import ./nvim-plugins/alpha-nvim.nix { inherit pkgs; };
    plenary-nvim = import ./nvim-plugins/plenary-nvim.nix { inherit pkgs; };
    telescope-nvim = import ./nvim-plugins/telescope-nvim.nix { inherit pkgs; };
    vim-fugitive = import ./nvim-plugins/vim-fugitive.nix { inherit pkgs; };
    #null-ls = import ./nvim-plugins/null-ls.nix { inherit pkgs; };
    treesitter-nvim = import ./nvim-plugins/treesitter-nvim.nix { inherit pkgs; };
    autopairs = import ./nvim-plugins/autopairs.nix { inherit pkgs; };
    presence-nvim = import ./nvim-plugins/presence-nvim.nix { inherit pkgs; };
  };
in
{
  programs.neovim = {
    enable = true;
    extraConfig = ''
      let mapleader="\<Space>"
      set notermguicolors
      colorscheme default
      set number
      set fillchars=vert:\|,eob:\ 
      autocmd BufWritePre *.nix,*.rs,*.js,*.json,*.ts,*.tsx,*.css,*.html,*.lua,*.py,*.go,*.md lua vim.lsp.buf.format()
      
      nnoremap <leader>ga :Git add .<CR>
      nnoremap <leader>gc :Git commit<CR>
      nnoremap <leader>gp :Git push<CR>
      nnoremap <leader>gs :Git status<CR> 
      nnoremap <C-n> :Neotree toggle<CR>

      lua << EOF
      vim.keymap.set("n", "<leader>gg", function()
        vim.cmd("terminal")
        vim.fn.chansend(vim.b.terminal_job_id, "git add . && git commit -m \"\" && git push\\n")
        vim.api.nvim_feedkeys("i<Left>", "n", true)
      end)
      EOF
    '';


    plugins = [
      plugins.neo-tree
      plugins.alpha-nvim
      plugins.plenary-nvim
      plugins.telescope-nvim
      plugins.vim-fugitive
     # plugins.null-ls
      plugins.autopairs
      plugins.presence-nvim
      plugins.treesitter-nvim
    ];
  };
}
