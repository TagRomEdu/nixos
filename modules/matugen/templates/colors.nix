{ config, lib, ... }:

let
  matugenConfigDir = "${config.home.homeDirectory}/.config/matugen";
  colorsOutput = "${config.home.homeDirectory}/nixos/modules/quickshell/qml/Data/colors.css";
in
{
  xdg.configFile = {
    "matugen/templates/quickshell.css".text = ''
      /*
       * Css Colors
       * Generated with Matugen
       */
      <* for name, value in colors *>
      @define-color {{name}} {{value.default.hex}};
      <* endfor *>
    '';

    "matugen/config.toml".text = ''
      [config]

      [templates.colors]
      input_path = "${matugenConfigDir}/templates/quickshell.css"
      output_path = "${colorsOutput}"
      post_hook = ""
    '';
  };
}
