{
  config,
  pkgs,
  ...
}: {
  # GPU
  # https://nixos.wiki/wiki/Nvidia
  hardware.graphics.enable = true;
  hardware.graphics.extraPackages = with pkgs; [
    # https://discourse.nixos.org/t/nvidia-open-breaks-hardware-acceleration/58770/2
    nvidia-vaapi-driver
    vaapiVdpau
    libvdpau
    libvdpau-va-gl
    vdpauinfo
    libva
    libva-utils

    vpl-gpu-rt
  ];
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    open = false;

    modesetting.enable = true;
    powerManagement = {
      enable = true;
      finegrained = true;
    };
    nvidiaSettings = true;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      # Bus ID of the Intel GPU.
      intelBusId = "PCI:0:2:0";
      # Bus ID of the NVIDIA GPU.
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  environment.variables = {
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  # Taken from here : https://wiki.hyprland.org/Nvidia/
  # CLI debug to check if nvidia drivers are running:
  #
  # `nvidia-settings`
  # `glxinfo | egrep "OpenGL"`
  # `nvidia-smi`
}
