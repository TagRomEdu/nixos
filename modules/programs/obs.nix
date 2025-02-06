{ pkgs, ... }:

{
  home.packages = [
    (pkgs.wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [
        obs-vkcapture
      ];
    })
  ];
}
