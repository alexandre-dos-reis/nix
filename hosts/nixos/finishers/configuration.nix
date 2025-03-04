# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  host,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.dell-xps-15-9530
    ../common
    ./boot.nix
    ./gpu.nix
    ./hyprland.nix
    ./kavval-core.nix
  ];

  networking.hostName = host.hostname; # Define your hostname.

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Paris";

  i18n = let
    lang = "en_US";
    locale = "fr_FR";
  in {
    defaultLocale = "${lang}.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "${locale}.UTF-8";
      LC_IDENTIFICATION = "${locale}.UTF-8";
      LC_MEASUREMENT = "${locale}.UTF-8";
      LC_MONETARY = "${locale}.UTF-8";
      LC_NAME = "${locale}.UTF-8";
      LC_NUMERIC = "${locale}.UTF-8";
      LC_PAPER = "${locale}.UTF-8";
      LC_TELEPHONE = "${locale}.UTF-8";
      LC_TIME = "${locale}.UTF-8";
    };
  };

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    xkb = {
      # Configure keymap in X11
      layout = "us";
      variant = "";
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # jack.enable = true;
  };

  # TODO: map over user...
  users.users.alex = {
    isNormalUser = true;
    description = "Alexandre Dos Reis";
    extraGroups = ["networkmanager" "wheel" "audio" "video"];
    # packages = [] Managed by home-manager
  };

  # `root` is already included
  nix.settings.trusted-users = ["@wheel"];

  # Install firefox.
  programs.firefox.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nix.settings.experimental-features = ["nix-command" "flakes"];
  environment.systemPackages = with pkgs; [
    vim
    git
    google-chrome
    slack
    gparted # Managed disks
    nvitop # NVIDIA-GPU process viewer
    mesa-demos # glxgears
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
