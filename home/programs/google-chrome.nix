{ pkgs, ... }:
{
  home.packages = [
    pkgs.google-chrome
  ];

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
