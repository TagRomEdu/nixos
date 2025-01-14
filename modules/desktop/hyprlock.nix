{ config, ... }:

{

  home.file.".config/hypr/hyprlock.conf".text = ''
    {
        # BACKGROUND
background {
    monitor =
    #path = screenshot
    path = /home/lysec/Pictures/DSOGBqd.png
    #color = $background
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
    outline_thickness = 2
    dots_size = 0.2 # Scale of input-field height, 0.2 - 0.8
    dots_spacing = 0.35 # Scale of dots' absolute size, 0.0 - 1.0
    dots_center = true
    outer_color = rgba(0, 0, 0, 0)
    inner_color = rgba(0, 0, 0, 0.2)
    font_color = rgb(255, 255, 255)  # Set font color to white
    fade_on_empty = false
    rounding = -1
    check_color = rgb(204, 136, 34)
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
  color = rgba(242, 243, 244, 0.75)
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
  color = rgba(242, 243, 244, 0.75)
  font_size = 95
  font_family = JetBrains Mono Extrabold
  position = 0, 200
  halign = center
  valign = center
}



# Profile Picture
image {
    monitor =
    path = /home/lysec/Pictures/profile_pictures/lysec_square.png
    size = 100
    border_size = 2
    border_color = $foreground
    position = 0, -100
    halign = center
    valign = center
}

# Desktop Environment
image {
    monitor =
    path = /home/lysec/Pictures/profile_pictures/hypr.png
    size = 75
    border_size = 2
    border_color = $foreground
    position = -50, 50
    halign = right
    valign = bottom
}

    }
  '';
}
