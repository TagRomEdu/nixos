{ config, pkgs, ... }:

let
  brightnessScript = pkgs.writeShellScriptBin "brightness" ''
    STEP_PERCENT=5
    MIN=0
    BACKLIGHT_PATH="/sys/class/backlight/intel_backlight"
    OSD_FILE="/tmp/brightness_osd_level"

    current=$(cat "$BACKLIGHT_PATH/brightness")
    max=$(cat "$BACKLIGHT_PATH/max_brightness")
    new=$current

    step=$(( max * STEP_PERCENT / 100 ))

    if [[ "$1" == "up" ]]; then
      new=$((current + step))
      (( new > max )) && new=$max
    elif [[ "$1" == "down" ]]; then
      new=$((current - step))
      (( new < MIN )) && new=$MIN
    else
      exit 1
    fi

    echo "$new" | sudo tee "$BACKLIGHT_PATH/brightness" > /dev/null
    percent=$(( new * 100 / max ))
    echo "$percent" > "$OSD_FILE"
  '';
in
{
  home.packages = [
    brightnessScript
  ];
}
