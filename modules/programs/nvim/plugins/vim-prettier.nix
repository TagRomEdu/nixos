{ pkgs }:
{
  plugin = pkgs.vimPlugins.vim-prettier;
  config = ''
    let g:prettier#autoformat = 1
    let g:prettier#autoformat_require_pragma = 0
  '';
}
