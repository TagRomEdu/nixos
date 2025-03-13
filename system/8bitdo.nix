{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Load hid-xpadneo for better 8BitDo support
  #boot.extraModulePackages = with config.boot.kernelPackages; [ hid_xpadneo ];

  # Udev rules for 8BitDo Ultimate C
  services.udev.extraRules = ''SUBSYSTEM=="usb", ATTR{idVendor}=="2dc8", ATTR{idProduct}=="310a", ATTR{manufacturer}=="8BitDo", RUN+="${pkgs.systemd}/bin/systemctl start 8bitdo-ultimate-xinput@2dc8:310a" # This device (2dc8:3016) is "connected" when the above device disconnects SUBSYSTEM=="usb", ATTR{idVendor}=="2dc8", ATTR{idProduct}=="301a", ATTR{manufacturer}=="8BitDo", RUN+="${pkgs.systemd}/bin/systemctl stop 8bitdo-ultimate-xinput@2dc8:310a" '';

  # Ensure the user has joystick support
  users.groups.input.members = [ "lysec" ];

  environment.systemPackages = with pkgs; [
    #joyutils # For testing the controller
    evtest # Event testing tool
  ];
}
