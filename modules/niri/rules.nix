{ lib, pkgs, ... }:

let
  windowRules = [

  ];
in {
  programs.niri = {
    settings = {
      window-rules = windowRules;
    };
  };
}
