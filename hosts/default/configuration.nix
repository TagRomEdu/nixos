{ config, pkgs, inputs, lib, self, ... }:

{
  imports = [
    ./hardware-configuration.nix
    "${self}/system/greeter/greetd.nix"
    "${self}/system/programs/steam.nix"
    "${self}/system/programs/lact.nix"
    "${self}/system/programs/stylix.nix"
    "${self}/system/xdg.nix"
    "${self}/system/environment.nix"
    "${self}/system/packages.nix"
    "${self}/system/filesystems.nix"
    inputs.home-manager.nixosModules.default
  ];

  nixpkgs.overlays = [
    (final: prev: {
      nur = import inputs.nur {
        nurpkgs = prev;
        pkgs = prev;
      };
    })
  ];
  
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = "nodev";
      theme = /home/tre/nixos/hosts/default/grub/grub-themes/hollow-knight-grub-theme/hollow-grub/theme.txt;
      configurationName = "🌑 Hollow NixOS";
      numberOfEntries = 5;
      showAllEntries = false;
    };
  };


  security.sudo.extraConfig = ''
    tre ALL=(ALL) NOPASSWD: /run/current-system/sw/bin/tee /sys/class/backlight/intel_backlight/brightness
    tre ALL=(ALL) NOPASSWD: /run/current-system/sw/bin/cat /sys/class/power_supply/BAT0/capacity
  '';

  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  users.groups.i2c = {};

  users.users.tre = {
    isNormalUser = true;
    description = "tre";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "input"
      "plugdev"
      "i2c"
      "bluetooth"
      "docker"
    ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users = {
      "tre" = import ./home.nix;
    };
  };

  fonts.packages = with pkgs; [
    fira-sans
    roboto
    nerd-fonts._0xproto
    nerd-fonts.droid-sans-mono
    jetbrains-mono
    noto-fonts
    noto-fonts-emoji
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    material-symbols
    material-icons
  ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_cachyos;
#    kernelParams = [
#      "video=DP-1:2560x1440@360"
#    ];
    kernelModules = [ "v4l2loopback" "i2c-dev" ];
    initrd.availableKernelModules = [ "i2c-dev" ];
    extraModprobeConfig = ''
      options v4l2loopback video_nr=0 card_label="DroidCam" exclusive_caps=1
    '';
    extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback
    ];
  };

  services.udev.packages = [ pkgs.rwedid ];

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 5d";
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    wireless = {
      enable = false;
      userControlled.enable = false;
    };

    networkmanager = {
      plugins = with pkgs; [ networkmanager-l2tp ];
      wifi.backend = "wpa_supplicant";
      wifi.powersave = false;
    };
  };

  services.strongswan.enable = true;
  environment.etc."strongswan.conf".text = "";

  hardware.enableRedistributableFirmware = true;

  time.timeZone = "Asia/Yekaterinburg";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  programs.zsh.enable = true;

  services = {
    xserver = {
      enable = true;
      videoDrivers = [ "modesetting" "nvidia" ];
      xkb = {
        layout = "us,ru";
        variant = "";
      };
    };

    dbus.enable = true;
    dbus.packages = with pkgs; [ bluez ];

    power-profiles-daemon.enable = true;
    printing.enable = true;
    gvfs.enable = true;
    tumbler.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    sunshine = {
      enable = true;
      autoStart = false;
      capSysAdmin = true;
      openFirewall = true;
    };
  };

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    prime = {
      sync.enable = true;

      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.opengl.extraPackages = with pkgs; [
    nvidia-vaapi-driver
  ];

  console.keyMap = "en";

  xdg.portal.enable = true;

  hardware.bluetooth.enable = true;

  environment.systemPackages = with pkgs; [
    bluez
    strongswan
    networkmanager-l2tp
  ];

  nixpkgs.config.allowUnfree = true;

  home-manager.backupFileExtension = "backup";

  system.stateVersion = "25.05";

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
