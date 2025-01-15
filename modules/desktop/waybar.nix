{ config, ... }:

{
  home.file.".config/waybar/config".text = ''
    {
        "layer": "top",
        "margin-top": 14,
        "margin-bottom": 0,
        "margin-left": 14,
        "margin-right": 14,
        "spacing": 0,

        "include": [
            "~/.config/waybar/modules.json"
        ],

        "modules-left": [
            "custom/appmenu",
            "wlr/taskbar",
            "hyprland/window"
        ],

        "modules-center": [
            "hyprland/workspaces"
        ],

        "modules-right": [
            "tray",
            "pulseaudio",
            "custom/updates",
            "custom/notification",
            /*"custom/exit",*/
            "clock"
        ]
    }

  '';

  home.file.".config/waybar/style.css".text = ''
    * {
    font-family: "Fira Sans Semibold", "Font Awesome 6 Free", FontAwesome, Roboto, Helvetica, Arial, sans-serif;
    }

    window#waybar {
        background-color: #242036;
        border: 3px solid #E09A25;
        box-shadow: 0px 2px 4px rgba(0, 0, 0, 0.2);
        padding: 0;
        margin: 0;
        transition: background-color 0.3s;
    }

    #window {
        font-size: 16px;
        font-weight: 800;
        color: #F1E7D3;
        border-radius: 0px;
        padding: 4px 8px;
        margin: 2px;
        opacity: 1;
    }

    #hyprland-workspaces {
        background: #332e4d;
        margin: 1px 0;
        padding: 4px 8px;
        border-radius: 0px;
        font-weight: bold;
        font-size: 14px;
        color: #F1E7D3;
    }

    #workspaces button {
        padding: 4px 4px;
        margin: 3px 0px;
        border-radius: 0px;
        color: #ebdbb2;
        background-color: #332e4d;
        transition: all 0.3s ease-in-out;
        font-size: 14px;
    }

    #workspaces button.active {
        color: #242036;
        background: #E09A25;
    }

    #workspaces button:hover {
        background: #3c3836;
    }

    #custom-exit {
        font-size: 16px;
        background-color: #332e4d;
        color: #ebdbb2;
        border-radius: 0px;
        padding: 4px 4px;
        margin: 3px 0px;
    }

    #clock, #custom-appmenu {
        background-color: #E09A25;
        font-size: 16px;
        font-weight: 800;
        color: #242036;
        border-radius: 0px;
        padding: 4px 8px;
        margin: 2px;
    }

    tooltip {
        border-radius: 0px;
        background-color: #242036;
        color: #ebdbb2;
        padding: 4px 8px;
    }

    #taskbar {
        background-color: #332e4d;
        padding: 4px 4px;
        margin: 3px 0px;
        border-radius: 0px;
        font-weight: normal;
    }

    #idle_inhibitor {
        font-size: 18px;
        color: #ebdbb2;
        margin-right: 10px;
    }

    #idle_inhibitor.activated {
        color: #E09A25;
    }

    #backlight, #pulseaudio, #network, #bluetooth, #battery, #tray, #custom-updates, #custom-notification {
        background-color: #332e4d;
        font-size: 14px;
        font-weight: 800;
        color: #ebdbb2;
        border-radius: 0px;
        padding: 4px 10px;
        margin: 4px 0px;
    }

    #battery.critical:not(.charging) {
        background-color: #E09A25;
        color: #ebdbb2;
        animation: blink 0.5s linear infinite alternate;
    }

    @keyframes blink {
        to {
            background-color: #242036;
            color: #ebdbb2;
        }
    }

  '';

  home.file.".config/waybar/modules.json".text = ''
    {
    // Workspaces
    "hyprland/workspaces": {
        "on-scroll-up": "hyprctl dispatch workspace r-1",
        "on-scroll-down": "hyprctl dispatch workspace r+1",
        "on-click": "activate",
        "active-only": false,
        "all-outputs": true,
        "format":" {icon} ",
        "format-icons": {
        "1": " 󰈹 ",
        "2": " ",
        "3": "  ",
        "4": "  ",
        "5": " "
        },
        "persistent-workspaces": {
        "*": 5
        }
    },

    // Taskbar
    "wlr/taskbar": {
        "format": "{icon}",
        "icon-size": 18,
        "tooltip-format": "{title}",
        "on-click": "activate",
        "on-click-middle": "close",
        "ignore-list": ["Alacritty", "kitty", "ghostty"],
        "app_ids-mapping": {
        "firefoxdeveloperedition": "firefox-developer-edition"
        },
        "rewrite": {
        "Firefox Web Browser": "Firefox",
        "Foot Server": "Terminal"
        }
    },

    // Hyprland Window
    "hyprland/window": {
        "format": "{}",
        "rewrite": {
        "(.*) - Brave": "$1",
        "(.*) - Chromium": "$1",
        "(.*) - Brave Search": "$1",
        "(.*) - Outlook": "$1",
        "(.*) Microsoft Teams": "$1"
        },
        "separate-outputs": true
    },

    // Empty
    "custom/empty": {
        "format": ""
    },

        // Tools
    "custom/tools": {
        "format": "",
        "tooltip-format": "Tools"
    },

    // Updates Count
    "custom/updates": {
        "format": "{} {icon}",
        "return-type": "json",
        "format-icons": {
            "has-updates": "󱍷",
            "updated": "󰂪"
        },
        "exec-if": "which waybar-module-pacman-updates",
        "exec": "waybar-module-pacman-updates --interval-seconds 5 --network-interval-seconds 300"
    },

    // Rofi Application Launcher
    "custom/appmenu": {
        // START APPS LABEL
        "format": " 󰣇  ",
        // END APPS LABEL
        "on-click": "sleep 0.2;rofi -show drun -replace",
        "tooltip-format": "Left: Open the application launcher\nRight: Show all keybindings"
    },

    // Rofi Application Launcher
    "custom/appmenuicon": {
        "format": "",
        "on-click": "sleep 0.2;rofi -show drun -replace",
        "tooltip-format": "Left: Open the application launcher\nRight: Show all keybindings"
    },

    // Power Menu
    "custom/exit": {
        "format": " 󰐥 ",
        "on-click": "~/.config/waybar/scripts/power-menu.sh",
        "tooltip-format": "Power Menu"
    },

    // Keyboard State
    "keyboard-state": {
        "numlock": true,
        "capslock": true,
        "format": "{name} {icon}",
        "format-icons": {
        "locked": "",
        "unlocked": ""
        }
    },

    // System tray
    "tray": {
        "icon-size": 21,
        "spacing": 10
    },

    // Clock
    "clock": {
        "format": "{:%H:%M %a}",
        "on-click": "ags -t calendar",
        "tooltip": false
    },

    "hyprland/language": {
        "format": "/ K {short}"
    },

    // Network
    "network": {
        "format": "{ifname}",
        "format-wifi": "   {signalStrength}%",
        "format-ethernet": "  {ifname}",
        "format-disconnected": "Disconnected",
        "tooltip-format": " {ifname} via {gwaddri}",
        "tooltip-format-wifi": "  {ifname} @ {essid}\nIP: {ipaddr}\nStrength: {signalStrength}%\nFreq: {frequency}MHz\nUp: {bandwidthUpBits} Down: {bandwidthDownBits}",
        "tooltip-format-ethernet": " {ifname}\nIP: {ipaddr}\n up: {bandwidthUpBits} down: {bandwidthDownBits}",
        "tooltip-format-disconnected": "Disconnected",
        "max-length": 50,
        "on-click": "~/.config/ml4w/settings/networkmanager.sh",
        "on-click-right": "~/.config/ml4w/scripts/nm-applet.sh toggle",
    },

    // Battery
    "battery": {
        "states": {
        // "good": 95,
        "warning": 30,
        "critical": 15
        },
        "format": "{icon} {capacity}%",
        "format-charging": "  {capacity}%",
        "format-plugged": "  {capacity}%",
        "format-alt": "{icon}  {time}",
        // "format-good": "", // An empty format will hide the module
        // "format-full": "",
        "format-icons": [" ", " ", " ", " ", " "]
    },

    // Pulseaudio
    "pulseaudio": {
        // "scroll-step": 1, // %, can be a float
        "format": "  {icon}  {volume}%",
        "format-bluetooth": "{volume}% {icon} {format_source}",
        "format-bluetooth-muted": " {icon} {format_source}",
        "format-muted": " {format_source}",
        "format-source": "{volume}%",
        "format-source-muted": "",
        "format-icons": {
        },
        "on-click": "pavucontrol"
    },

    // Bluetooth
    "bluetooth": {
        "format": " {status}",
        "format-disabled": "",
        "format-off": "",
        "interval": 30,
        "on-click": "blueman-manager",
        "format-no-controller": ""
    },

    // Other
    "user": {
        "format": "{user}",
        "interval": 60,
        "icon": false
    },

    // Swaync

    "custom/notification": {
        "tooltip": false,
        "format": "{icon}",
        "format-icons": {
        "notification": "",
        "none": "",
        "dnd-notification": "",
        "dnd-none": "",
        "inhibited-notification": "",
        "inhibited-none": "",
        "dnd-inhibited-notification": "",
        "dnd-inhibited-none": ""
        },
        "return-type": "json",
        "exec-if": "which swaync-client",
        "exec": "swaync-client -swb",
        "on-click": "swaync-client -t -sw",
        "on-click-right": "swaync-client -d -sw",
        "escape": true
    },

    // backlight:
    "backlight": {
        "format": "{icon} {percent}%",
        "format-icons": [
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        ""
        ],
        "scroll-step": 1
    }
    }
  '';
}
