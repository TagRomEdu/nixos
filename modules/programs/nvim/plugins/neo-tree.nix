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
            added     = "✚", -- or "A"
            modified  = "", -- or "M"
            deleted   = "✖", -- or "D"
            renamed   = "", -- or "R"
            untracked = "", -- or "U"
            ignored   = "", -- or "I"
            unstaged  = "", -- or "U"
            staged    = "", -- or "S"
            conflict  = "", -- or "C"
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
