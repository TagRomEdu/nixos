{ config, pkgs, inputs, lib, self, ... }:

{
  imports = [
    ./hardware-configuration.nix

    "${self}/system/greeter/greetd.nix"
    "${self}/system/shell/bash.nix"
    "${self}/system/shell/fish.nix"
    "${self}/system/programs/steam.nix"
    "${self}/system/programs/lact.nix"
    "${self}/system/xdg.nix"
    "${self}/system/environment.nix"
    #"${self}/system/8bitdo.nix"
    inputs.home-manager.nixosModules.default
  ];

  # Add NUR overlay
  nixpkgs.overlays = [
    (final: prev: {
      nur = import inputs.nur {
        nurpkgs = prev;
        pkgs = prev;
      };
    })
  ];

  # Define the lysec user
  users.users.lysec = {
    isNormalUser = true;
    description = "lysec";
    shell = pkgs.fish;
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "input"
      "plugdev"
    ];
  };

  # Home Manager configuration
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users = {
      "lysec" = import ./home.nix;
    };
  };

  # Fonts
  fonts.packages = [
    pkgs.fira-sans
    pkgs.roboto
    pkgs.nerd-fonts._0xproto
    pkgs.nerd-fonts.droid-sans-mono
    pkgs.jetbrains-mono
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  networking.hostName = "nixos"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];

  services.dbus.enable = true;
  xdg.portal.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "de";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # DroidCam / v4l2loopback config
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];

  boot.kernelModules = [
    "v4l2loopback"
  ];

  boot.extraModprobeConfig = ''
    options v4l2loopback video_nr=0 card_label="DroidCam" exclusive_caps=1
  '';

  fileSystems."/home/lysec/storage" = {
    device = "UUID=74697b82-1266-4372-96cc-aac599abfb72";
    fsType = "ext4";
  };

  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 5d"; # Deletes generations older than 5 days
  };

  programs.thunar.enable = true;
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  stylix.enable = true;
  #stylix.image = "${self}/assets/wallpapers/space_bw.jpg";
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/ayu-dark.yaml";

  boot.kernelPackages = pkgs.linuxPackages_cachyos;

  home-manager.backupFileExtension = "backups";

  system.stateVersion = "25.05";


  # Log rebuild time & date for fabric panel (modules/fabric/config.py)
  system.activationScripts.logRebuildTime = {
    text = ''
      LOG_FILE="/var/log/nixos-rebuild-log.json"
      TIMESTAMP=$(date "+%d/%m")
      GENERATION=$(readlink /nix/var/nix/profiles/system | grep -o '[0-9]\+')

      echo "{\"last_rebuild\": \"$TIMESTAMP\", \"generation\": $GENERATION}" > "$LOG_FILE"
      chmod 644 "$LOG_FILE"
    '';
  };
}