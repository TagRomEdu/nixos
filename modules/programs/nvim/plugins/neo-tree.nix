{ pkgs }:
{
  plugin = pkgs.vimPlugins.neo-tree-nvim;
  config = ''
    lua << EOF
    require("neo-tree").setup({
      close_if_last_window = true, -- Close Neo-tree if it's the last window
      enable_git_status = true,    -- Enable Git status
      enable_diagnostics = true,
      default_component_configs = {
        icon = {
          folder_closed = "",
          folder_open = "",
          folder_empty = "",
        },
        git_status = {
          symbols = {
            -- Change type to the icons you prefer
            added     = " ✚",
            modified  = " ",
            deleted   = " ✖",
            renamed   = " R",
            untracked = " ",
            ignored   = " ",
            unstaged  = " U",
            staged    = " ",
            conflict  = " ",
          }
        },
      },
      renderers = {
        file = {
          { "icon" },
          { "name" },
          { "git_status" }, -- Add Git status to file renderer
        },
        directory = {
          { "icon" },
          { "name" },
          { "git_status" }, -- Add Git status to directory renderer
        },
      },
    })
    EOF
  '';
}
