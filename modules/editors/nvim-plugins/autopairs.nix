{ pkgs }:
{
  plugin = pkgs.vimPlugins.nvim-autopairs;
  config = ''
    lua << EOF
    -- Set up nvim-autopairs
    require('nvim-autopairs').setup()
    EOF
  '';
}
