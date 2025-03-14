{pkgs, ...}: {
  # This command fixes the problem where plugging headphone doesn't automatically switch profiles, see pavucontrol:
  # `wpctl set-profile @DEFAULT_AUDIO_SINK@ 0`

  # Pulseaudio is the old audio server.
  services.pulseaudio.enable = false;

  security.rtkit.enable = true;

  environment.systemPackages = with pkgs; [
    pavucontrol # Graphical Controls Audio through pulseaudio protocols
  ];

  # Pipewire is the new audio server.
  services.pipewire = {
    enable = true;
    audio.enable = true; # Define as primary sound server
    # Enable alsa support.
    alsa.enable = true;
    alsa.support32Bit = true;
    # Enable pipewire-pulse to help apps that uses pulseaudio protocol
    pulse.enable = true;
    # Wireplumber is some sort of pipewire client, use it with `wpctl`
    wireplumber = {
      enable = true;
      configPackages = [
        # disable HDMI sinks.
        (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/alsa.conf" ''
          monitor.alsa.rules = [
            {
              matches = [
                {
                  node.name = "alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__HDMI1__sink"
                }
                {
                  node.name = "alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__HDMI2__sink"
                }
                {
                  node.name = "alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__HDMI3__sink"
                }
              ]
              actions = {
                update-props = {
                   node.disabled = true
                }
              }
            }
          ]
        '')
      ];
    };
  };
}
