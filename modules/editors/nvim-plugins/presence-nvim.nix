{ pkgs }:
{
  plugin = pkgs.vimPlugins.presence-nvim;
  config = ''
    lua << EOF
    require("presence"):setup({
      -- Auto-update the rich presence in Discord
      auto_update = true,
      
      -- Set the Neovim image text in Discord presence
      neovim_image_text = "Neovim",

      -- You can set this to "file" for the file icon or "neovim" for the Neovim icon
      main_image = "file",

      -- Set debounce time for status updates (in seconds)
      debounce_timeout = 10,

      -- Optionally, you can show the current line number and column in Discord presence
      enable_line_number = true,

      -- Show the current git commit and branch (if applicable)
      enable_git_commit = true,

      -- Show the project title in the presence (e.g., folder name)
      enable_project_title = true,
    })
    EOF
  '';
}
