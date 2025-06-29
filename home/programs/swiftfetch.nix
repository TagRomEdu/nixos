{ config, ... }:

{
  home.file.".config/swiftfetch/ascii.txt".text = ''
          ▗▄▄▄       ▗▄▄▄▄    ▄▄▄▖
          ▜███▙       ▜███▙  ▟███▛
           ▜███▙       ▜███▙▟███▛
            ▜███▙       ▜██████▛
     ▟█████████████████▙ ▜████▛     ▟▙
    ▟███████████████████▙ ▜███▙    ▟██▙
           ▄▄▄▄▖           ▜███▙  ▟███▛
          ▟███▛             ▜██▛ ▟███▛
         ▟███▛               ▜▛ ▟███▛
▟███████████▛                  ▟██████████▙
▜██████████▛                  ▟███████████▛
      ▟███▛ ▟▙               ▟███▛
     ▟███▛ ▟██▙             ▟███▛
    ▟███▛  ▜███▙           ▝▀▀▀▀
    ▜██▛    ▜███▙ ▜██████████████████▛
     ▜▛     ▟████▙ ▜████████████████▛
           ▟██████▙       ▜███▙
          ▟███▛▜███▙       ▜███▙
         ▟███▛  ▜███▙       ▜███▙
         ▝▀▀▀    ▀▀▀▀▘       ▀▀▀▘
  '';

  home.file.".config/swiftfetch/config.toml".text = ''
    [display]
    separator = ": "
    ascii_path = "~/.config/swiftfetch/ascii.txt"
    ascii_color = "blue"

    [colors]
    green = "#A6CC70"
    blue = "#39BAE6"
    magenta = "#D2A6FF"
    yellow = "#39BAE6"  # replaced with blue
    red = "#F07178"
    cyan = "#95E6CB"
    white = "#C7C7C7"

    [[display.items]]
    key = ""
    type = "text"
    value = ""

    [[display.items]]
    key = "user_info"
    type = "default"
    value = "user_info"
    value_color = "white"

    [[display.items]]
    key = ""
    type = "text"
    value = "┌────────────────── System Information ───────────────────┐"
    color = "blue"

    [[display.items]]
    key = "           󰣇 ‣ os"
    type = "default"
    value = "os"
    color = "blue"
    value_color = "white"

    [[display.items]]
    key = "           󰍛 ‣ kernel"
    type = "default"
    value = "kernel"
    color = "blue"
    value_color = "white"

    [[display.items]]
    key = "            ‣ wm"
    type = "default"
    value = "wm"
    color = "blue"
    value_color = "white"

    [[display.items]]
    key = "            ‣ editor"
    type = "default"
    value = "editor"
    color = "blue"
    value_color = "white"

    [[display.items]]
    key = "            ‣ shell"
    type = "default"
    value = "shell"
    color = "blue"
    value_color = "white"

    [[display.items]]
    key = "            ‣ term"
    type = "default"
    value = "terminal"
    color = "blue"
    value_color = "white"

    [[display.items]]
    key = "            ‣ pkgs"
    type = "default"
    value = "pkg_count"
    color = "blue"
    value_color = "white"

    [[display.items]]
    key = "            ‣ flat"
    type = "default"
    value = "flatpak_pkg_count"
    color = "blue"
    value_color = "white"

    [[display.items]]
    key = ""
    type = "text"
    value = "├───────────────── Hardware Information ─────────────────┤"
    color = "blue"

    [[display.items]]
    key = "           󰍛 ‣ cpu"
    type = "default"
    value = "cpu"
    color = "blue"
    value_color = "white"

    [[display.items]]
    key = "           󰓅 ‣ ram"
    type = "default"
    value = "memory"
    color = "blue"
    value_color = "white"

    [[display.items]]
    key = ""
    type = "text"
    value = "├───────────────── Uptime Information ───────────────────┤"
    color = "blue"

    [[display.items]]
    key = "            ‣ uptime"
    type = "default"
    value = "uptime_seconds"
    color = "blue"
    value_color = "white"

    [[display.items]]
    key = "            ‣ age"
    type = "default"
    value = "os_age"
    color = "blue"
    value_color = "white"

    [[display.items]]
    key = ""
    type = "text"
    value = "└────────────────────────────────────────────────────────┘"
    color = "blue"
  '';
}
