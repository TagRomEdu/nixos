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
      "                                                                     ",
      "       ████ ██████           █████      ██                     ",
      "      ███████████             █████                             ",
      "      █████████ ███████████████████ ███   ███████████   ",
      "     █████████  ███    █████████████ █████ ██████████████   ",
      "    █████████ ██████████ █████████ █████ █████ ████ █████   ",
      "  ███████████ ███    ███ █████████ █████ █████ ████ █████  ",
      " ██████  █████████████████████ ████ █████ █████ ████ ██████ ",
      "                                                                   ",
    }

    dashboard.section.buttons.val = {
      dashboard.button("n", "  New File", ":enew<CR>"),
      dashboard.button("r", "  Recent Files", ":Telescope oldfiles<CR>"),
      dashboard.button("s", "  Restore Session", ":SessionRestore<CR>"),
      dashboard.button("q", "  Quit", ":qall<CR>"),
    }

    local function get_time_date()
      return os.date("%H:%M:%S %d.%m.%Y")
    end

    dashboard.section.footer.val = get_time_date()

    alpha.setup(dashboard.config)

    local timer = vim.loop.new_timer()
    timer:start(0, 1000, vim.schedule_wrap(function()
      dashboard.section.footer.val = get_time_date()
      pcall(vim.cmd, "AlphaRedraw")  -- Ensure that Alpha updates
    end))
    EOF
  '';
}
