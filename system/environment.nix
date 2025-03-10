{
  config,
  pkgs,
  inputs,
  ...
}:

{
  environment.variables = {
    GTK_THEME = "Adwaita-dark";
    XCURSOR_SIZE = "24";
  };

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
    libva
    libva-utils
    playerctl
  ];
}
