{ pkgs, ... }:
{
  home.packages = [
    pkgs.google-chrome
  ];

  # Если используешь stylix для стилизации браузеров
  stylix.targets.chromium.enable = true;  # работает и для chrome, и для chromium

  # Можно также добавить desktop entries, если нужно явно
  xdg.desktopEntries.chrome = {
    name = "Google Chrome";
    exec = "google-chrome-stable --ozone-platform=wayland";
    icon = "google-chrome";
    comment = "Browse the web";
    categories = [ "Network" "WebBrowser" ];
    type = "Application";
    terminal = false;
  };
}
