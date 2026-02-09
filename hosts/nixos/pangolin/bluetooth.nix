{pkgs, ...}: {
  # WARN: Bluetooth config is apart because I had many problem with kernel firmware
  #
  # https://nixos.wiki/wiki/Bluetooth
  boot.kernelModules = ["kvm-amd" "btusb"];

  # Be carefull with the linux kernel version
  # as it can make bluetooth not working anymore.
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_18;

  hardware.enableAllFirmware = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        # Shows battery charge of connected devices on supported
        # Bluetooth adapters. Defaults to 'false'.
        Experimental = true;
        # When enabled other devices can connect faster to us, however
        # the tradeoff is increased power consumption. Defaults to
        # 'false'.
        FastConnectable = true;
      };
      Policy = {
        # Enable all controllers when they are found. This includes
        # adapters present on start as well as adapters that are plugged
        # in later on. Defaults to 'true'.
        AutoEnable = true;
      };
    };
  };

  environment.systemPackages = [
    pkgs.blueman
  ];

  services.blueman.enable = true;
  # Fix for bluetooth on the pangolin
  hardware.firmware = with pkgs; [
    linux-firmware
  ];
}
