{ pkgs }:
{
  plugin = pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
    p.bash
    p.lua
    p.vim
    p.python
    p.javascript
    p.nix
  ]);

  config = ''
    lua << EOF
    require'nvim-treesitter.configs'.setup {
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true
      },
    }
    EOF
  '';
}
