{ pkgs, ... }:  # Ensure `nur` is passed in

{
  programs.firefox = {
    enable = true;

    profiles = {
      default = {
        id = 0;
        extensions.force = true;
        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          bitwarden
          darkreader
          sponsorblock
          return-youtube-dislikes
        ];

        settings = {
          Extensions.autoDisableScopes = 0;
        };
      };
    };
    policies = {
      DisableTelemetry = true;
          DisableFirefoxStudies = true;
          EnableTrackingProtection = {
            Cryptomining = true;
          };
          DisablePocket = true;
          OverrideFirstRunPage = "";
          OverridePostUpdatePage = "";
          DontCheckDefaultBrowser = true;
          DisplayBookmarksToolbar = "newtab";
          DisplayMenuBar = "default-off";
          SearchBar = "unified";
    };
  };

  stylix.targets = {
    firefox = {
      colorTheme.enable = true;
      profileNames = [ "default" ];
    };
  };

}