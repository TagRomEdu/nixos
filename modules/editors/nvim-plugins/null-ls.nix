{ pkgs }:
{
  plugin = pkgs.vimPlugins.null-ls-nvim;
  config = ''
    lua << EOF
    local null_ls = require("null-ls")

    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.nixpkgs_fmt.with({
          command = "/etc/profiles/per-user/lysec/bin/nixpkgs-fmt", -- Adjusted path
        }),
        null_ls.builtins.formatting.rustfmt.with({
          command = "/etc/profiles/per-user/lysec/bin/rustfmt", -- Adjusted path
        }),
        null_ls.builtins.formatting.prettier.with({
          command = "/run/current-system/sw/bin/prettier", -- Prettier path
        }),
        null_ls.builtins.formatting.black.with({
          command = "/etc/profiles/per-user/lysec/bin/black", -- Adjusted path
        }),
      },
      on_attach = function(client, bufnr)
        local bufname = vim.fn.bufname(bufnr)
        if bufname:match("neo-tree") then
          print("Skipping null-ls for Neo-tree buffer")
          return
        end
      end,
    })
    EOF
  '';
}
