{
  config,
  pkgs,
  inputs,
  ...
}:

{

  environment.systemPackages = with pkgs; [
    wget
    unzip
    git
    pavucontrol
    pulseaudio
    waypaper
    pywal16
    pywalfox-native
    arrpc
    swww
    adwaita-icon-theme
    gnome-themes-extra
    nodePackages.prettier
    xwayland
    spicetify-cli
    alvr
    ffmpeg
    mesa
    libva
    libva-utils
    playerctl
    libayatana-appindicator
  ];

  environment.variables = {
    GTK_THEME = "Gruvbox-Dark";
    GTK_ICON_THEME = "Papirus-Dark";
    XCURSOR_SIZE = "24";
    QT_QPA_PLATFORM = "wayland";
  };
}
