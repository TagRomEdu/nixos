{ pkgs }:
{
  plugin = pkgs.vimPlugins.null-ls-nvim;
  config = ''
    lua << EOF
    local null_ls = require("null-ls")

    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.nixpkgs_fmt.with({
          command = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt",
        }),
        null_ls.builtins.formatting.rustfmt.with({
          command = "${pkgs.rustfmt}/bin/rustfmt",
        }),
        null_ls.builtins.formatting.prettier.with({
          command = "${pkgs.nodePackages.prettier}/bin/prettier",
        }),
                null_ls.builtins.formatting.black.with({
          command = "${pkgs.black}/bin/black",
        }),
      },
    })
    EOF
  '';
}
