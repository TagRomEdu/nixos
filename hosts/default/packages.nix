{
  pkgs,
  ...
}:

with pkgs;
[
  #stylix.targets.firefox.profileNames = "ide8k3pu";
  # Applications
  (writeShellApplication {
    name = "vesktop";

    runtimeInputs = [ vesktop ]; # depend on the real vesktop binary

    text = ''
      if [ "$XDG_CURRENT_DESKTOP" = "niri" ]; then
        exec vesktop --ozone-platform=x11 "$@"
      else
        exec vesktop "$@"
      fi
    '';
  })
  protonplus
  lutris
  furmark
  dolphin-emu
  prismlauncher
  heroic
  peazip
  firefox

  # Desktop
  swaynotificationcenter
  #waybar
  hyprshot
  hyprlock
  walker
  nwg-look

  # Development
  nodejs
  rustup
  gcc
  gh
  nixfmt-rfc-style
  nixpkgs-fmt
  black

  # Utilities
  eww
  jq
  socat
  tree
  libnotify
  nvd
  wl-clipboard
  pywalfox-native
  imagemagick
  amdvlk
  rar
  unzip
  droidcam
  wtfutil
  gowall
  gruvbox-gtk-theme
  papirus-icon-theme
  #xwayland-satellite
  ironbar
]
