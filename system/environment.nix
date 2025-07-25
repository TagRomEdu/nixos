{
  config,
  pkgs,
  inputs,
  ...
}:

{
  environment.variables = {
    XCURSOR_SIZE = "24";
    QT_QPA_PLATFORM = "wayland";

    # For NVIDOA
    NVD_BACKEND = "direct";
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";
  };
}
