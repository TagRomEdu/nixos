{ config, ... }:

{
  home.file.".config/hypr/hyprlock.conf".text = ''
    # BACKGROUND
    background {
        monitor =
        path = ${config.home.homeDirectory}/nixos/assets/wallpapers/frieren.png
        #color = $background"
        blur_passes = 2
        contrast = 1
        brightness = 0.5
        vibrancy = 0.2
        vibrancy_darkness = 0.2
    }

    # GENERAL
    general {
        no_fade_in = true
        no_fade_out = true
        hide_cursor = false
        grace = 0
        disable_loading_bar = true
    }

    # INPUT FIELD
    input-field {
        monitor =
        size = 250, 60
        outline_thickness = 3                # changed from 2 to 3
        outline_color = rgb(235, 111, 146)  # #eb6f92 pinkish rose pine accent
        dots_size = 0.2
        dots_spacing = 0.35
        dots_center = true
        outer_color = rgb(235, 111, 146)  # rose pine surface (dark grayish)
        inner_color = rgba(68, 71, 90, 0.6)  # rose pine base variant (darker)
        font_color = rgb(242, 234, 218)       # rose pine text (light cream)
        fade_on_empty = false
        rounding = -1
        check_color = rgb(235, 111, 146)     # same rose pine pink accent
        placeholder_text = Input Password...
        hide_input = false
        position = 0, -200
        halign = center
        valign = center
    }

    # DATE
    label {
      monitor =
      text = cmd[update:1000] LC_TIME=en_US.UTF-8 date +"%A, %B %d"
      color = rgba(242, 234, 218, 0.75)     # rose pine text with transparency
      font_size = 22
      font_family = JetBrains Mono
      position = 0, 300
      halign = center
      valign = center
    }

    # TIME
    label {
      monitor = 
      text = cmd[update:1000] echo "$(date +"%-I:%M")"
      color = rgba(242, 234, 218, 0.75)     # rose pine text with transparency
      font_size = 95
      font_family = JetBrains Mono Extrabold
      position = 0, 200
      halign = center
      valign = center
    }

  '';
}
