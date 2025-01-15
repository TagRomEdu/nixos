{ config, ... }:

{
  home.file.".config/swaync/config.json".text = ''
    {
    "$schema": "/etc/xdg/swaync/configSchema.json",
    "positionX": "right",
    "positionY": "top",
    "layer": "overlay",
    "control-center-layer": "top",
    "layer-shell": true,
    "cssPriority": "application",
    "control-center-margin-top": 14,
    "control-center-margin-bottom": 0,
    "control-center-margin-right": 14,
    "control-center-margin-left": 0,
    "notification-margin-top": 0,
    "notification-margin-right": 0,
    "notification-margin-bottom": 0,
    "notification-margin-left": 0,
    "notification-2fa-action": true,
    "notification-inline-replies": false,
    "notification-icon-size": 64,
    "notification-body-image-height": 100,
    "notification-body-image-width": 200,
    "timeout": 10,
    "timeout-low": 5,
    "timeout-critical": 0,
    "fit-to-screen": true,
    "relative-timestamps": true,
    "control-center-width": 500,
    "control-center-height": 600,
    "notification-window-width": 500,
    "keyboard-shortcuts": true,
    "image-visibility": "when-available",
    "transition-time": 200,
    "hide-on-clear": false,
    "hide-on-action": true,
    "script-fail-notify": true,
    "scripts": {
        "example-script": {
        "exec": "echo 'Do something...'",
        "urgency": "Normal"
        },
        "example-action-script": {
        "exec": "echo 'Do something actionable!'",
        "urgency": "Normal",
        "run-on": "action"
        }
    },
    "notification-visibility": {
        "example-name": {
        "state": "muted",
        "urgency": "Low",
        "app-name": "Spotify"
        }
    },
    "widgets": [
        "inhibitors",
        "title",
        "notifications",
        "buttons-grid"
    ],
    "widget-config": {
        "inhibitors": {
        "text": "Inhibitors",
        "button-text": "Clear All",
        "clear-all-button": true
        },
        "title": {
        "text": "Notifications",
        "clear-all-button": true,
        "button-text": "Clear All"
        },
        "dnd": {
        "text": "Do Not Disturb"
        },
        "label": {
        "max-lines": 5,
        "text": "Label Text"
        },
        "mpris": {
        "image-size": 96,
        "image-radius": 12
        },
        "buttons-grid": {
        "actions": [
        {
            "label": "",
            "type": "button",
            "command": "sh -c 'hyprctl dispatch exit'"
        },
        {
            "label": "",
            "type": "button",
            "command": "sh -c 'systemctl reboot'"
        },
        {
            "label": "⏻",
            "type": "button",
            "command": "sh -c 'systemctl poweroff'"
        },
        {
            "label": "",
            "type": "button",
            "command": "sh -c 'hyprlock'"
        }
        ],
        "container": {
        "orientation": "horizontal",
        "spacing": 10
        }
    }
    }
    }
  '';
  home.file.".config/swaync/style.css".text = ''
    @define-color cc-bg #242036; /* Background color */
    @define-color cc-light-bg #332e4d;
    @define-color noti-border-color #E09A25; /* Gruvbox green from Waybar */
    @define-color noti-bg #242036; /* Same background color as #282828 */
    @define-color noti-bg-focus #2c3e50; /* Focused background color */
    @define-color noti-close-bg #E09A25; /* Close button background color same as border */
    @define-color noti-bg-hover #333333; /* Hover color for background */
    @define-color text-color #c3c6cd;
    @define-color bg-selected #c3c6cd;

    .control-center {
    border: 3px solid @noti-border-color;
    border-radius: 0px;
    padding: 8px;
    background: @cc-bg;
    margin-bottom: 14px;

    }

    .widget-title {
    border: 3px solid @noti-border-color;
    border-radius: 0px;
    padding: 8px;
    margin: 8px;
    background: @cc-light-bg;
    margin-bottom: 14px;

    }

    .widget-title > button {
    background: @cc-light-bg;
    color: @text-color;
    border: 3px solid @noti-border-color;
    border-radius: 0px;
    }

    .widget-title > button:hover {
    background: @noti-border-color;
    color: @cc-bg;
    border: 3px solid @noti-border-color;
    border-radius: 0px;
    }

    .widget-dnd {
    border: 3px solid @noti-border-color;
    border-radius: 0px;
    padding: 8px;
    margin: 8px;
    background: @cc-light-bg;
    margin-bottom: 14px;

    }

    .widget-dnd > switch {
    border-radius: 5px;
    background: @cc-light-bg;
    border: 3px solid @noti-border-color;
    }

    .widget-dnd > switch:checked {
    background: @noti-border-color;
    border: 3px solid @noti-border-color;
    }

    .widget-dnd > switch slider {
    background: @cc-bg;
    border-radius: 0px;
    }

    .widget-dnd > switch:checked slider {
    background: @cc-bg;
    border-radius: 0px;
    }

    .widget-buttons-grid {
    border: 3px solid @noti-border-color;
    border-radius: 0px;
    padding: 8px;
    margin: 8px;
    background: @cc-light-bg;
    margin-bottom: 14px;
    }

    .widget-buttons-grid > flowbox > flowboxchild > button {
    background: @cc-light-bg;
    border: 3px solid @noti-border-color;
    border-radius: 0px;
    min-width: 110px;
    }

    .widget-buttons-grid > flowbox > flowboxchild > button:hover {
    background: @noti-border-color;
    color: @cc-bg;
    }

    .notification-row:focus,
    .notification-row:hover {
    background: @noti-bg-hover;
    }

    .notification-row .notification-background {
    padding: 0px 0px;
    margin: 0px;
    }

    .notification-row .notification-background .close-button {
    background: @noti-close-bg;
    color: @text-color;
    padding: 0;
    margin-top: 3px;
    margin-right: 3px;
    border-radius: 0px;
    min-width: 24px;
    min-height: 24px;
    }

    .notification-row .notification-background .close-button:hover {
    background: @noti-border-color;
    }

    .notification-row .notification-background .notification {
    margin: 4px;
    border: 3px solid @noti-border-color;
    padding: 8px;
    background: @cc-bg;
    border-radius: 0px;

    }

    .notification-row .notification-background .notification .notification-action,
    .notification-row .notification-background .notification .notification-default-action {
    background: @cc-light-bg;
    color: @text-color;
    border-radius: 0px;

    }

    .notification-row .notification-background .notification .notification-action:hover,
    .notification-row .notification-background .notification .notification-default-action:hover {
    background: @noti-border-color;
    }

    .notification-row .notification-background .notification .notification-default-action {
    border-radius: 0px;
    }

    .notification-row .notification-background .notification .notification-default-action:not(:only-child) {
    border-bottom-left-radius: 0px;
    border-bottom-right-radius: 0px;
    }

    .notification-row .notification-background .notification .notification-default-action .notification-content {
    border-radius: 0px;
    padding: 8px;
    }

    .notification-row .notification-background .notification .notification-default-action .notification-content .image {
    border-radius: 0px;
    margin: 6px;
    }

    .notification-row .notification-background .notification .notification-default-action .notification-content .app-icon {
    border-radius: 0px;
    margin: 6px;
    }

    .notification-row .notification-background .notification .notification-default-action .notification-content .text-box .summary {
    font-size: 16px;
    font-weight: bold;
    color: @text-color;
    }

    .notification-row .notification-background .notification .notification-default-action .notification-content .text-box .time {
    font-size: 16px;
    font-weight: bold;
    color: @text-color;
    margin-right: 30px;
    }

    .notification-row .notification-background .notification .notification-default-action .notification-content .text-box .body {
    font-size: 15px;
    font-weight: normal;
    color: @text-color;
    }

    .notification-row .notification-background .notification .notification-default-action .notification-content progressbar {
    background: #00FFFF;
    }

    .notification-row .notification-background .notification .notification-default-action .notification-content .body-image {
    background-color: white;
    border-radius: 0px;
    }

    .notification-row .notification-background .notification .notification-default-action .notification-content .inline-reply {
    background: #00FFFF;
    }

    .notification-row .notification-background .notification .notification-default-action .notification-content .inline-reply .inline-reply-entry {
    background: @noti-bg;
    color: @text-color;
    caret-color: @text-color;
    border: 3px solid @noti-border-color;
    background: #00FFFF;
    }

    .notification-row .notification-background .notification .notification-default-action .notification-content .inline-reply .inline-reply-button {
    background: @noti-bg;
    border: 1px solid @noti-border-color;
    border-radius: 0px;
    color: @text-color;
    }

    .notification-row .notification-background .notification .notification-default-action .notification-content .inline-reply .inline-reply-button:hover {
    background: @noti-bg-hover;
    }

    .notification-row .notification-background .notification:hover {
    background: @noti-bg-hover;
    }

    .notification-row .notification-background .notification .notification-action {
    border-top: 1px solid @noti-border-color;
    border-right: 1px solid @noti-border-color;
    background: #00FFFF;
    }

    .notification-row .notification-background .notification .notification-action:first-child {
    background: #00FFFF;
    }

    .notification-row .notification-background .notification .notification-action:last-child {
    background: #00FFFF;
    }
  '';
}
