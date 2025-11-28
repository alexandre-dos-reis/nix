# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  users,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../common/remap-keys.nix
    ../common/hyprland.nix
    ../common/docker.nix
    ./bluetooth.nix
    ./hosts.nix
  ];
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # https://support.system76.com/articles/system76-software/#nixos
  hardware.system76.enableAll = true;
  services.power-profiles-daemon.enable = false;

  # Cosmic system76 desktop
  services.desktopManager = {
    cosmic.enable = true;
    gnome.enable = true;
  };

  # Enable the GNOME Desktop Environment.
  # services.displayManager.gdm.enable = true;
  services.displayManager.cosmic-greeter.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "pangolin"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "fr_FR.UTF-8";
      LC_IDENTIFICATION = "fr_FR.UTF-8";
      LC_MEASUREMENT = "fr_FR.UTF-8";
      LC_MONETARY = "fr_FR.UTF-8";
      LC_NAME = "fr_FR.UTF-8";
      LC_NUMERIC = "fr_FR.UTF-8";
      LC_PAPER = "fr_FR.UTF-8";
      LC_TELEPHONE = "fr_FR.UTF-8";
      LC_TIME = "fr_FR.UTF-8";
    };
  };

  # Configure keymap in X11
  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;
    xkb = {
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
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = builtins.listToAttrs (map (u: {
      name = u.username;
      value = {
        isNormalUser = true;
        description = u.description;
        extraGroups = ["networkmanager" "wheel" "audio" "video"];
      };
    })
    users);

  nix.settings.trusted-users = ["@wheel"];

  # Install firefox.
  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    git
    google-chrome
    slack
    dig
    usbutils
    pciutils
    pavucontrol
  ];

  services.logind.settings.Login = {
    HandleLidSwitchDocked = "ignore";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
