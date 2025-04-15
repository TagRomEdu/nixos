{ pkgs }:
{
  plugin = pkgs.vimPlugins.nvim-autopairs;
  config = ''
    lua << EOF
    require('nvim-autopairs').setup()
    EOF
  '';
}
