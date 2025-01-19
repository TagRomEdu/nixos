{ config, pkgs, inputs, lib, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./main-user.nix

      ../../modules/greeter/greetd.nix

      ../../modules/shell/bash.nix
      ../../modules/shell/fish.nix

      ../../modules/programs/xdg.nix
      ../../modules/programs/steam.nix
      inputs.home-manager.nixosModules.default
    ];

  main-user.enable = true;
  main-user.userName = "lysec";

  # Fonts
  #fonts.packages = with pkgs; [ nerdfonts ];
  fonts.packages = [
    pkgs.fira-sans
    pkgs.roboto
    pkgs.nerd-fonts._0xproto
    pkgs.nerd-fonts.droid-sans-mono
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

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

  # Enable the GNOME Desktop Environment.
  #services.xserver.displayManager.sddm.enable = true;

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
  #hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lysec = {
    isNormalUser = true;
    description = "lysec";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users = {
      "lysec" = import ./home.nix;
    };
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Install Thunar.
  programs.thunar.enable = true;
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [

    wget
    git
    pavucontrol
    pulseaudio
    waypaper
    pywal16
    pywalfox-native
    arrpc
    swww
    adwaita-icon-theme
  ];

  environment.variables.XCURSOR_SIZE = "24";

  boot.kernelPackages = pkgs.linuxPackages_cachyos;
  system.stateVersion = "25.05";
}
