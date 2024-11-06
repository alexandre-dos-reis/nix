{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../nixos-common.nix
    ./sound.nix
    ./network.nix
    ./users.nix
  ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Duplication with home-manager ?
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  system.stateVersion = "23.11"; # Did you read the comment?
}
