{ pkgs }:
{
  plugin = pkgs.vimPlugins.alpha-nvim;
  config = ''
    lua << EOF
    -- Set up alpha-nvim
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- Custom header (ASCII art)
    dashboard.section.header.val = {
      "                                                                   ",
      " ███▄▄▄▄      ▄████████  ▄██████▄   ▄█    █▄   ▄█    ▄▄▄▄███▄▄▄▄   ",
      " ███▀▀▀██▄   ███    ███ ███    ███ ███    ███ ███  ▄██▀▀▀███▀▀▀██▄ ",
      " ███   ███   ███    █▀  ███    ███ ███    ███ ███▌ ███   ███   ███ ",
      " ███   ███  ▄███▄▄▄     ███    ███ ███    ███ ███▌ ███   ███   ███ ",
      " ███   ███ ▀▀███▀▀▀     ███    ███ ███    ███ ███▌ ███   ███   ███ ",
      " ███   ███   ███    █▄  ███    ███ ███    ███ ███  ███   ███   ███ ",
      " ███   ███   ███    ███ ███    ███ ███    ███ ███  ███   ███   ███ ",
      "  ▀█   █▀    ██████████  ▀██████▀   ▀██████▀  █▀    ▀█   ███   █▀  ",
      "                                                                   ",
    }

    -- Custom buttons
    dashboard.section.buttons.val = {
      dashboard.button("n", "  New File", ":enew<CR>"),
      dashboard.button("r", "  Recent Files", ":Telescope oldfiles<CR>"),
      dashboard.button("s", "  Restore Session", ":SessionRestore<CR>"),
      dashboard.button("q", "  Quit", ":qall<CR>"),
    }

    -- Footer (optional)
    dashboard.section.footer.val = "Neovim x NixOS"

    -- Set up alpha
    alpha.setup(dashboard.config)

    -- Apply green color to the header
    vim.cmd("highlight DashboardHeader guifg=#00ff00")
    EOF
  '';
}
