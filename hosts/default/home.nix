{
  config,
  pkgs,
  inputs,
  self,
  ...
}:

let
  allPackages = import ./packages.nix { inherit pkgs; };
in
{
  home.username = "tre";
  home.homeDirectory = "/home/tre";

  imports = [
    ../../home/niri/default.nix
    ../../home/quickshell/quickshell.nix

    ../../home/editors/vscode.nix
    ../../home/editors/nixvim.nix

    ../../home/programs/ghostty.nix
    ../../home/programs/yazi.nix
    ../../home/programs/fastfetch.nix
    ../../home/programs/spicetify.nix
    ../../home/programs/obs.nix
    ../../home/programs/vesktop/default.nix
    ../../home/programs/firefox.nix
    ../../home/programs/google-chrome.nix

    ../../system/shell/zsh.nix
    ../../system/shell/nushell.nix

    inputs.spicetify-nix.homeManagerModules.default
    inputs.nixvim.homeManagerModules.nixvim
  ];

  home.packages = allPackages;

  xdg.portal.enable = true;
  home.stateVersion = "24.11";

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  services.cliphist = {
    enable = true;
    allowImages = true;
  };

  programs.home-manager.enable = true;
   
  programs.carapace.enable = true;
  programs.carapace.enableNushellIntegration = true;

  programs.starship = { enable = true;
      settings = {
        add_newline = true;
        username = {
          show_always = true;
          style_user = "bold yellow";
        };
        hostname = {
          style = "bold dimmed blue";
          ssh_only = false;
        };
        time = {
          disabled = false;
          time_format = "%Y-%m-%d %H:%M";
          style = "bold blue";
        };
        character = { 
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };
      };
  };
}
