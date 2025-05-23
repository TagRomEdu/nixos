{
  pkgs,
  ...
}:

with pkgs;
[
  # Applications
  protonplus
  lutris
  dolphin-emu
  prismlauncher
  heroic
  peazip

  # Desktop
  hyprshot
  hyprlock
  nwg-look
  walker

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
  ironbar
  qt6Packages.qt5compat
  kdePackages.syntax-highlighting
]
