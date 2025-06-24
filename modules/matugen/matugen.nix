{ config, pkgs, lib, ... }:

let
  cfg = config.programs.matugen;
  matugenPkg = pkgs.matugen;

  colorsTemplate = import ./templates/quickshell.nix { inherit config lib pkgs; };
  quickshellTemplate = import ./templates/quickshell-colors.qml { inherit config lib pkgs; };
  matugen-qsTemplate = import ./templates/matugen-qs.nix { inherit config lib pkgs; };
  genCommand =
    if cfg.wallpaper != null then
      "${matugenPkg}/bin/matugen image ${cfg.wallpaper}"
    else if cfg.source_color != null then
      "${matugenPkg}/bin/matugen color ${cfg.source_color}"
    else
      null;
in
{
  options = {
    programs.matugen = {
      enable = lib.mkEnableOption "Enable Matugen theming";

      variant = lib.mkOption {
        type = lib.types.enum [ "light" "dark" "amoled" ];
        default = "dark";
        description = "Colorscheme variant";
      };

      source_color = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Hex color to generate colorscheme from";
      };

      wallpaper = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Wallpaper path to generate colorscheme from";
      };

      generateOnLogin = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to run matugen automatically on login.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ matugenPkg ];

    xdg.configFile = lib.recursiveUpdate
      colorsTemplate.xdg.configFile
      {};
  };
}
