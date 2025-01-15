{ config, pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    inputs.hyprpolkitagent.packages."${pkgs.system}".hyprpolkitagent
    xdg-desktop-portal-hyprland
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    xwayland.enable = true;

    settings = {
      # Default Apps
      "$mainMod" = "SUPER";
      "$terminal" = "ghostty";
      "$browser" = "firefox";
      "$menu" = "walker";
      "$fileManager" = "thunar";

      # Keybinds Start
      bind = [
        "CTRL SHIFT, 1, exec, hyprshot -m region --clipboard-only"
        "CTRL SHIFT, 2, exec, hyprshot -m window --clipboard-only"
        "CTRL SHIFT, 3, exec, hyprshot -m output --clipboard-only"

        "$mainMod, RETURN, exec, $terminal"
        "$mainMod, B, exec, $browser"
        "$mainMod CTRL, RETURN, exec, $menu"
        "$mainMod CTRL, W, exec, waypaper"
        "$mainMod, E, exec, $fileManager"
        "$mainMod, T, togglefloating"
        "$mainMod, F, fullscreen"
        "$mainMod, J, togglesplit"
        "$mainMod, Q, killactive"

        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      bindel = [
        ", xf86audioraisevolume, exec, pactl set-sink-volume '@DEFAULT_SINK@' +5% && pactl get-sink-volume '@DEFAULT_SINK@' | grep -oP '\\d+(?=%)' | awk '{if($1>100) system(\"pactl set-sink-volume '@DEFAULT_SINK@' 100%\")}'"
        ", xf86audiolowervolume, exec, pactl set-sink-volume '@DEFAULT_SINK@' -5%"
      ];

      input = {
        kb_layout = "de";
        follow_mouse = 1;
        sensitivity = -0.2;
      };

      binds = {
        "workspace_back_and_forth" = "true";
        "allow_workspace_cycles" = "true";
        "pass_mouse_when_bound" = "false";
      };
      # Keybinds End

      general = {
        gaps_in = 5;
        gaps_out = 14;
        border_size = 3;
        "col.active_border" = "rgb(E09A25)";
      };

      decoration = {
        active_opacity = 1.0;
        inactive_opacity = 0.8;

        blur = {
          enabled = true;
          size = 6;
          passes = 2;
          new_optimizations = "on";
          ignore_opacity = true;
          xray = true;
        };
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_status = "master";
      };

      # Startup starts
      exec-once = [
        "hyprctl setcursor theme_NotwaitaBlack 24"
        "systemctl --user start hyprpolkitagent"
        "[workspace 2] vesktop"
        "arrpc"
        "waypaper --restore"
        "swaync"
        "waybar -c ~/.config/waybar/config -s ~/.config/waybar/style.css"
      ];
      # Startup ends

      # Env starts
      env = [
        "XDG_SESSION_TYPE                    ,  wayland  "
        "XDG_CURRENT_DESKTOP                 ,  Hyprland "
        "XDG_SESSION_DESKTOP                 ,  Hyprland "

        "DISABLE_QT5_COMPAT                  , 1         "
        "QT_QPA_PLATFORM                     ,  wayland  "
        "QT_AUTO_SCREEN_SCALE_FACTOR         , 1         "
        "QT_WAYLAND_DISABLE_WINDOWDECORATION , 1         "

        "MOZ_ENABLE_WAYLAND                  , 1         "
        "NIXOS_OZONE_WL                      , 1         "
        "ELECTRON_OZONE_PLATFORM_HINT        , auto      "

        "GTK_WAYLAND_DISABLE_WINDOWDECORATION, 1         "

        "GDK_SCALE							 						 , 1.25		 	 "

        "XCURSOR_THEME						 					 ,Adwaita    "
        "XCURSOR_SIZE						 			 ,24			   "
      ];
      # Env ends

      # Monitor starts
      monitor = [
        "DP-1, 3440x1440@144, auto, auto"
      ];
      # Monitor ends

      xwayland = {
        force_zero_scaling = true;
      };

    };
  };
}

