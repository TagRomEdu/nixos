{ config, pkgs, ... }:

let
  brightnessScript = pkgs.writeShellScriptBin "brightness" ''
    STEP=5
    MIN=0
    BACKLIGHT_PATH="/sys/class/backlight/intel_backlight"
    OSD_FILE="/tmp/brightness_osd_level"

    current=$(cat "$BACKLIGHT_PATH/brightness")
    max=$(cat "$BACKLIGHT_PATH/max_brightness")
    new=$current

    if [[ "$1" == "up" ]]; then
      new=$((current + STEP))
      (( new > max )) && new=$max
    elif [[ "$1" == "down" ]]; then
      new=$((current - STEP))
      (( new < MIN )) && new=$MIN
    else
      exit 1
    fi

    echo "$new" | sudo tee "$BACKLIGHT_PATH/brightness" > /dev/null
    echo "$new" > "$OSD_FILE"
  '';
in
{
  home.packages = [
    brightnessScript
  ];
}
