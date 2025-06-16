{
  config,
  pkgs,
  ...
}:
{
  programs.niri.settings.window-rules = [
    {
      matches = [
        { app-id = "firefox"; }
      ];
      open-on-workspace = "browser";
    }
    {
      matches = [
        { app-id = "vesktop"; at-startup = true;}
      ];
      open-on-workspace = "vesktop";
    }
  ];
}
