{pkgs, ...}: {
  # Bootloader.
  # See https://nixos.wiki/wiki/Bootloader
  boot.loader = {
    systemd-boot = {
      enable = false;
      configurationLimit = 5; # Prevent generations from filling `/boot`
    };
    # https://discourse.nixos.org/t/newbee-switching-to-grub-and-dual-boot/31678
    grub = {
      enable = true;
      device = "nodev";
      useOSProber = true;
      efiSupport = true;
      configurationLimit = 5; # Prevent generations from filling `/boot`
      fontSize = 40;
      font = "${pkgs.maple-mono.NF}/share/fonts/truetype/MapleMono-NF-Regular.ttf";
    };
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
  };
}
